import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/common/extensions.dart';
import 'package:mangabackupconverter_cli/src/exceptions/migration_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/pipeline/conversion_strategy.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source_aidoku.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source_stub.dart';
import 'package:wasm_plugin_loader/wasm_plugin_loader.dart';

class MigrationPipeline {
  const MigrationPipeline({
    required this.onSelectRepos,
    required this.onSelectExtensions,
    required this.onConfirmMatches,
    required this.onProgress,
  });

  final Future<List<ExtensionRepo>> Function(ExtensionType targetType, List<ExtensionRepo> available) onSelectRepos;
  final Future<List<SourceEntry>> Function(List<SourceEntry> extensions) onSelectExtensions;
  final Future<List<MangaMatchConfirmation>> Function(List<MangaMatchProposal> proposals) onConfirmMatches;
  final void Function(int current, int total, String message) onProgress;

  Future<ConvertableBackup> run({
    required ConvertableBackup sourceBackup,
    required BackupFormat source,
    required BackupFormat target,
  }) async {
    final ConversionStrategy strategy = determineStrategy(source, target);
    return switch (strategy) {
      Skip() => sourceBackup,
      DirectConversion() =>
        sourceBackup is TachimangaBackup && target is Tachiyomi ? sourceBackup.toTachiBackup() : sourceBackup,
      Migration() => _runMigration(sourceBackup, source, target),
    };
  }

  Future<ConvertableBackup> _runMigration(
    ConvertableBackup sourceBackup,
    BackupFormat source,
    BackupFormat target,
  ) async {
    final repoIndex = ExtensionRepoIndex.parseExtensionRepoIndex();
    final List<ExtensionRepo> availableRepos = repoIndex.repos[target.extensionType] ?? <ExtensionRepo>[];

    final List<ExtensionRepo> selectedRepos = await onSelectRepos(target.extensionType, availableRepos);
    if (selectedRepos.isEmpty) throw const MigrationException('No repos selected');

    final List<SourceEntry> availableExtensions = await _fetchExtensionLists(target.extensionType, selectedRepos);
    final List<SourceEntry> selectedExtensions = await onSelectExtensions(availableExtensions);
    if (selectedExtensions.isEmpty) throw const MigrationException('No extensions selected');

    onProgress(0, selectedExtensions.length, 'Loading plugins...');
    final List<PluginSource> plugins = await _loadPlugins(target.extensionType, selectedExtensions, selectedRepos);

    try {
      final List<MangaSearchDetails> mangaList = _extractManga(sourceBackup);
      final proposals = <MangaMatchProposal>[];

      for (var i = 0; i < mangaList.length; i++) {
        onProgress(i + 1, mangaList.length, 'Searching for: ${mangaList[i].title}');
        final MangaMatchProposal proposal = await _searchForManga(mangaList[i], plugins);
        proposals.add(proposal);
      }

      final List<MangaMatchConfirmation> confirmations = await onConfirmMatches(proposals);
      return _buildTargetBackup(target, confirmations);
    } finally {
      for (final plugin in plugins) {
        plugin.dispose();
      }
    }
  }

  Future<List<SourceEntry>> _fetchExtensionLists(
    ExtensionType extensionType,
    List<ExtensionRepo> repos,
  ) async {
    if (extensionType == ExtensionType.aidoku) {
      final entries = <SourceEntry>[];
      for (final repo in repos) {
        final manager = SourceListManager();
        try {
          final RemoteSourceList sourceList = await manager.fetchRemoteSourceList(repo.url);
          entries.addAll(sourceList.sources);
        } on Object catch (e) {
          onProgress(0, 0, 'Warning: failed to fetch repo ${repo.url}: $e');
        }
      }
      return entries;
    }
    return <SourceEntry>[];
  }

  Future<List<PluginSource>> _loadPlugins(
    ExtensionType extensionType,
    List<SourceEntry> extensions,
    List<ExtensionRepo> repos,
  ) async {
    if (extensionType == ExtensionType.aidoku) {
      final loader = AidokuPluginMemoryStore();
      final plugins = <PluginSource>[];
      for (var i = 0; i < extensions.length; i++) {
        final entry = extensions[i];
        onProgress(i + 1, extensions.length, 'Loading plugin: ${entry.name}');
        try {
          final http.Response response = await http.get(Uri.parse(entry.downloadUrl));
          if (response.statusCode != 200) {
            onProgress(i + 1, extensions.length, 'Warning: failed to download ${entry.name}: HTTP ${response.statusCode}');
            continue;
          }
          final AidokuPlugin plugin = await loader.loadAixBytes(Uint8List.fromList(response.bodyBytes));
          plugins.add(AidokuPluginSource(plugin: plugin));
        } on Object catch (e) {
          onProgress(i + 1, extensions.length, 'Warning: failed to load ${entry.name}: $e');
        }
      }
      return plugins;
    }
    return extensions
        .map(
          (SourceEntry e) => StubPluginSource(
            sourceId: e.id,
            sourceName: e.name,
            extensionType: extensionType,
          ),
        )
        .toList();
  }

  List<MangaSearchDetails> _extractManga(ConvertableBackup backup) {
    return backup.mangaSearchEntries.map((MangaSearchEntry m) => m.toMangaSearchDetails()).toList();
  }

  Future<MangaMatchProposal> _searchForManga(MangaSearchDetails manga, List<PluginSource> plugins) async {
    final allCandidates = <PluginSearchResult>[];
    final failures = <PluginSearchFailure>[];
    for (final plugin in plugins) {
      try {
        final PluginSearchPageResult result = await plugin.search(manga.title, 1);
        allCandidates.addAll(result.results);
      } on Object catch (e) {
        failures.add(PluginSearchFailure(pluginId: plugin.sourceId, error: e));
      }
    }

    final PluginSearchResult? bestMatch = allCandidates.isEmpty
        ? null
        : allCandidates.firstWhere(
            (PluginSearchResult r) => r.title.toLowerCase() == manga.title.toLowerCase(),
            orElse: () => allCandidates.first,
          );

    return MangaMatchProposal(
      sourceManga: manga,
      candidates: allCandidates,
      bestMatch: bestMatch,
      failures: failures,
    );
  }

  ConvertableBackup _buildTargetBackup(BackupFormat target, List<MangaMatchConfirmation> confirmations) {
    // TODO: Construct the target backup from confirmed matches.
    throw UnimplementedError('Target backup construction not yet implemented');
  }
}

class MangaMatchConfirmation {
  const MangaMatchConfirmation({required this.sourceManga, this.confirmedMatch});

  final MangaSearchDetails sourceManga;
  final PluginSearchResult? confirmedMatch;
}

class MangaMatchProposal {
  const MangaMatchProposal({
    required this.sourceManga,
    required this.candidates,
    this.bestMatch,
    this.failures = const <PluginSearchFailure>[],
  });

  final MangaSearchDetails sourceManga;
  final List<PluginSearchResult> candidates;
  final PluginSearchResult? bestMatch;
  final List<PluginSearchFailure> failures;
}

class PluginSearchFailure {
  const PluginSearchFailure({required this.pluginId, required this.error});

  final String pluginId;
  final Object error;

  @override
  String toString() => 'PluginSearchFailure(pluginId: $pluginId, error: $error)';
}

class PluginLoadFailure {
  const PluginLoadFailure({required this.extensionId, required this.error});

  final String extensionId;
  final Object error;

  @override
  String toString() => 'PluginLoadFailure(extensionId: $extensionId, error: $error)';
}
