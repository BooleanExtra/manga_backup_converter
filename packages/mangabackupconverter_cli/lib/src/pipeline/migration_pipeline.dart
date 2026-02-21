import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/exceptions/migration_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/pipeline/conversion_strategy.dart';
import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_loader.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';

class MigrationPipeline {
  const MigrationPipeline({
    required this.repoUrls,
    required this.onSelectExtensions,
    required this.onConfirmMatch,
    required this.onProgress,
  });

  final List<String> repoUrls;
  final Future<List<ExtensionEntry>> Function(List<ExtensionEntry> extensions) onSelectExtensions;
  final Future<MangaMatchConfirmation> Function(MangaMatchProposal proposal) onConfirmMatch;
  final void Function(int current, int total, String message) onProgress;

  Future<ConvertableBackup> run({
    required ConvertableBackup sourceBackup,
    required BackupFormat sourceFormat,
    required BackupFormat targetFormat,
  }) async {
    final ConversionStrategy strategy = determineStrategy(sourceFormat, targetFormat);
    return switch (strategy) {
      Skip() => sourceBackup,
      DirectConversion() => (sourceBackup as TachimangaBackup).toTachiBackup(),
      Migration() => _runMigration(sourceBackup, sourceFormat, targetFormat),
    };
  }

  Future<ConvertableBackup> _runMigration(
    ConvertableBackup sourceBackup,
    BackupFormat sourceFormat,
    BackupFormat targetFormat,
  ) async {
    final PluginLoader loader = targetFormat.pluginLoader;

    final List<ExtensionEntry> availableExtensions = await loader.fetchExtensionLists(
      repoUrls,
      onWarning: (String msg) => onProgress(0, 0, 'Warning: $msg'),
    );
    if (availableExtensions.isEmpty && repoUrls.isNotEmpty) {
      throw const MigrationException('No extensions found from provided repos');
    }

    final List<ExtensionEntry> selectedExtensions = await onSelectExtensions(availableExtensions);
    if (selectedExtensions.isEmpty) throw const MigrationException('No extensions selected');

    onProgress(0, selectedExtensions.length, 'Loading plugins...');
    final List<PluginSource> plugins = await loader.loadPlugins(
      selectedExtensions,
      onProgress: onProgress,
    );

    try {
      final List<SourceMangaData> mangaList = _extractManga(sourceBackup);
      final List<MangaMatchConfirmation> confirmations = [];
      for (final (int i, SourceMangaData manga) in mangaList.indexed) {
        onProgress(i + 1, mangaList.length, 'Searching for: ${manga.details.title}');
        final MangaMatchProposal proposal = await _searchForManga(manga.details, plugins);
        final MangaMatchConfirmation confirmation = await onConfirmMatch(proposal);

        PluginMangaDetails? targetDetails;
        var targetChapters = const <PluginChapter>[];

        final PluginSearchResult? match = confirmation.confirmedMatch;
        if (match != null) {
          final PluginSource? source = plugins
              .where((PluginSource p) => p.sourceId == match.pluginSourceId)
              .firstOrNull;
          if (source != null) {
            onProgress(i + 1, mangaList.length, 'Fetching details for: ${match.title}');
            final (PluginMangaDetails, List<PluginChapter>)? result = await source.getMangaWithChapters(match.mangaKey);
            if (result != null) {
              (targetDetails, targetChapters) = result;
            }
          }
        }

        confirmations.add(
          MangaMatchConfirmation(
            sourceManga: manga,
            confirmedMatch: match,
            targetMangaDetails: targetDetails,
            targetChapters: targetChapters,
          ),
        );
      }

      return _buildTargetBackup(sourceBackup, sourceFormat, targetFormat, confirmations);
    } finally {
      for (final plugin in plugins) {
        plugin.dispose();
      }
    }
  }

  List<SourceMangaData> _extractManga(ConvertableBackup backup) {
    return backup.sourceMangaDataEntries;
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

  ConvertableBackup _buildTargetBackup(
    ConvertableBackup sourceBackup,
    BackupFormat sourceFormat,
    BackupFormat targetFormat,
    List<MangaMatchConfirmation> confirmations,
  ) {
    return targetFormat.backupBuilder.build(confirmations, sourceFormatAlias: sourceFormat.alias);
  }
}

class MangaMatchConfirmation {
  const MangaMatchConfirmation({
    required this.sourceManga,
    this.confirmedMatch,
    this.targetMangaDetails,
    this.targetChapters = const <PluginChapter>[],
  });

  final SourceMangaData sourceManga;
  final PluginSearchResult? confirmedMatch;
  final PluginMangaDetails? targetMangaDetails;
  final List<PluginChapter> targetChapters;
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
