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
        final RemoteSourceList? sourceList = await manager.fetchRemoteSourceList(repo.url);
        if (sourceList != null) entries.addAll(sourceList.sources);
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
      for (final entry in extensions) {
        final http.Response response = await http.get(Uri.parse(entry.downloadUrl));
        if (response.statusCode != 200) continue;
        final AidokuPlugin plugin = await loader.loadAixBytes(Uint8List.fromList(response.bodyBytes));
        plugins.add(AidokuPluginSource(plugin: plugin));
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
    for (final plugin in plugins) {
      try {
        final PluginSearchPageResult result = await plugin.search(manga.title, 1);
        allCandidates.addAll(result.results);
      } on Object {
        // Search failed for this plugin; continue with others.
      }
    }

    final PluginSearchResult? bestMatch = allCandidates.isEmpty
        ? null
        : allCandidates.firstWhere(
            (PluginSearchResult r) => r.title.toLowerCase() == manga.title.toLowerCase(),
            orElse: () => allCandidates.first,
          );

    return MangaMatchProposal(sourceManga: manga, candidates: allCandidates, bestMatch: bestMatch);
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
  const MangaMatchProposal({required this.sourceManga, required this.candidates, this.bestMatch});

  final MangaSearchDetails sourceManga;
  final List<PluginSearchResult> candidates;
  final PluginSearchResult? bestMatch;
}
