import 'dart:async';

import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/exceptions/migration_exception.dart';
import 'package:mangabackupconverter_cli/src/formats/tachi/tachi_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/tachimanga/tachimanga_backup.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/pipeline/conversion_strategy.dart';
import 'package:mangabackupconverter_cli/src/pipeline/extension_entry.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_loader.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';

// ---------------------------------------------------------------------------
// Streaming search events
// ---------------------------------------------------------------------------

sealed class PluginSearchEvent {}

class PluginSearchStarted extends PluginSearchEvent {
  PluginSearchStarted({required this.pluginId});

  final String pluginId;
}

class PluginSearchResults extends PluginSearchEvent {
  PluginSearchResults({required this.pluginId, required this.results});

  final String pluginId;
  final List<PluginSearchResult> results;
}

class PluginSearchError extends PluginSearchEvent {
  PluginSearchError({required this.failure});

  final PluginSearchFailure failure;
}

// ---------------------------------------------------------------------------
// Pipeline
// ---------------------------------------------------------------------------

/// Callback signature for batch match confirmation.
///
/// Receives all source manga upfront together with a streaming search function
/// and a details-fetching function. Returns confirmed matches for each manga.
typedef OnConfirmMatches =
    Future<List<MangaMatchConfirmation>> Function(
      List<String> pluginNames,
      List<SourceMangaData> manga,
      Stream<PluginSearchEvent> Function(String query) onSearch,
      Future<(PluginMangaDetails, List<PluginChapter>)?> Function(
        String pluginSourceId,
        String mangaKey,
      )
      onFetchDetails,
    );

class MigrationPipeline {
  const MigrationPipeline({
    required this.repoUrls,
    required this.onSelectExtensions,
    required this.onConfirmMatches,
    required this.onProgress,
    this.pluginLoader,
  });

  final List<String> repoUrls;
  final Future<List<ExtensionEntry>> Function(List<ExtensionEntry> extensions) onSelectExtensions;
  final OnConfirmMatches onConfirmMatches;
  final void Function(int current, int total, String message) onProgress;
  final PluginLoader? pluginLoader;

  Future<ConvertableBackup> run({
    required ConvertableBackup sourceBackup,
    required BackupFormat sourceFormat,
    required BackupFormat targetFormat,
    bool forceMigration = false,
  }) async {
    final ConversionStrategy strategy = determineStrategy(sourceFormat, targetFormat);
    return switch (strategy) {
      DirectConversion() =>
        forceMigration ? _runMigration(sourceBackup, sourceFormat, targetFormat) : _directConvert(sourceBackup),
      Migration() => _runMigration(sourceBackup, sourceFormat, targetFormat),
    };
  }

  ConvertableBackup _directConvert(ConvertableBackup sourceBackup) {
    if (sourceBackup is TachimangaBackup) return sourceBackup.toTachiBackup();
    if (sourceBackup is TachiBackup) return sourceBackup.toTachimangaBackup();
    throw StateError('Unexpected source type for direct conversion: ${sourceBackup.runtimeType}');
  }

  Future<ConvertableBackup> _runMigration(
    ConvertableBackup sourceBackup,
    BackupFormat sourceFormat,
    BackupFormat targetFormat,
  ) async {
    final PluginLoader loader = pluginLoader ?? targetFormat.pluginLoader;

    onProgress(0, 0, 'Fetching extension lists...');
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

    if (plugins.isEmpty) {
      throw const MigrationException('No plugins loaded successfully');
    }

    try {
      final List<SourceMangaData> mangaList = _extractManga(sourceBackup);

      // Batch confirmation — UI handles searching & user interaction.
      final List<String> pluginNames = plugins.map((PluginSource p) => p.sourceName).toList();
      final List<MangaMatchConfirmation> confirmations = await onConfirmMatches(
        pluginNames,
        mangaList,
        (String query) => _streamSearch(query, plugins),
        (String pluginSourceId, String mangaKey) async {
          final PluginSource? source = plugins.where((PluginSource p) => p.sourceId == pluginSourceId).firstOrNull;
          if (source == null) return null;
          return source.getMangaWithChapters(mangaKey);
        },
      );

      // Use already-enriched details from _streamSearch (no re-fetch needed).
      final List<MangaMatchConfirmation> detailedConfirmations = confirmations.map((confirmation) {
        final PluginSearchResult? match = confirmation.confirmedMatch;
        return MangaMatchConfirmation(
          sourceManga: confirmation.sourceManga,
          confirmedMatch: match,
          targetMangaDetails: match?.details,
          targetChapters: match?.chapters ?? const <PluginChapter>[],
        );
      }).toList();

      return _buildTargetBackup(sourceBackup, sourceFormat, targetFormat, detailedConfirmations);
    } finally {
      for (final plugin in plugins) {
        plugin.dispose();
      }
    }
  }

  /// Searches all [plugins] in parallel, emitting results as they arrive.
  ///
  /// Each result is enriched with details from [PluginSource.getMangaWithChapters]
  /// before being emitted, so consumers receive URL and chapter data upfront.
  Stream<PluginSearchEvent> _streamSearch(String query, List<PluginSource> plugins) {
    final controller = StreamController<PluginSearchEvent>();
    var cancelled = false;
    controller.onCancel = () {
      cancelled = true;
    };
    int remaining = plugins.length;
    if (remaining == 0) {
      controller.close();
      return controller.stream;
    }
    for (final plugin in plugins) {
      controller.add(PluginSearchStarted(pluginId: plugin.sourceId));
      plugin
          .search(query, 1)
          .then(
            (PluginSearchPageResult result) async {
              final enriched = <PluginSearchResult>[];
              for (final PluginSearchResult r in result.results) {
                if (cancelled) break;
                try {
                  final (PluginMangaDetails, List<PluginChapter>)? detailResult = await plugin.getMangaWithChapters(
                    r.mangaKey,
                  );
                  if (detailResult != null) {
                    enriched.add(
                      PluginSearchResult(
                        pluginSourceId: r.pluginSourceId,
                        mangaKey: r.mangaKey,
                        title: r.title,
                        coverUrl: r.coverUrl,
                        authors: detailResult.$1.authors.isNotEmpty ? detailResult.$1.authors : r.authors,
                        details: detailResult.$1,
                        chapters: detailResult.$2,
                      ),
                    );
                    continue;
                  }
                } on Object {
                  // Fall through — use result without details.
                }
                enriched.add(r);
              }
              if (!cancelled && !controller.isClosed) {
                controller.add(PluginSearchResults(pluginId: plugin.sourceId, results: enriched));
                if (result.warnings.isNotEmpty) {
                  controller.add(
                    PluginSearchError(
                      failure: PluginSearchFailure(
                        pluginId: plugin.sourceId,
                        error: '${result.warnings.length} host error(s)',
                      ),
                    ),
                  );
                }
              }
            },
            onError: (Object e) {
              if (!cancelled && !controller.isClosed) {
                controller.add(
                  PluginSearchError(
                    failure: PluginSearchFailure(pluginId: plugin.sourceId, error: e),
                  ),
                );
              }
            },
          )
          .whenComplete(() {
            remaining--;
            if (remaining == 0 && !controller.isClosed) controller.close();
          });
    }
    return controller.stream;
  }

  List<SourceMangaData> _extractManga(ConvertableBackup backup) {
    return backup.sourceMangaDataEntries;
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

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------

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
