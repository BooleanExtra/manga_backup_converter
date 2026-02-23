import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/pipeline/migration_pipeline.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';

sealed class TargetBackupBuilder {
  const TargetBackupBuilder();
  ConvertableBackup build(
    List<MangaMatchConfirmation> confirmations, {
    String? sourceFormatAlias,
  });
}

class AidokuBackupBuilder extends TargetBackupBuilder {
  const AidokuBackupBuilder();

  @override
  ConvertableBackup build(
    List<MangaMatchConfirmation> confirmations, {
    String? sourceFormatAlias,
  }) {
    final Iterable<MangaMatchConfirmation> confirmed = confirmations.where(
      (MangaMatchConfirmation c) => c.confirmedMatch != null,
    );

    final mangaSet = <AidokuBackupManga>{};
    final librarySet = <AidokuBackupLibraryManga>{};
    final chapterSet = <AidokuBackupChapter>{};
    final historySet = <AidokuBackupHistory>{};
    final sources = <String>{};
    final allCategories = <String>{};

    for (final confirmation in confirmed) {
      final PluginSearchResult match = confirmation.confirmedMatch!;
      final SourceMangaData sourceManga = confirmation.sourceManga;
      final PluginMangaDetails? details = confirmation.targetMangaDetails;
      final List<PluginChapter> targetChapters = confirmation.targetChapters;

      mangaSet.add(
        AidokuBackupManga(
          sourceId: match.pluginSourceId,
          id: match.mangaKey,
          title: details?.title ?? match.title,
          cover: details?.coverUrl ?? match.coverUrl,
          author: details?.authors.firstOrNull ?? match.authors.firstOrNull,
          artist: details?.artists.firstOrNull ?? sourceManga.details.artists.firstOrNull,
          desc: details?.description ?? sourceManga.details.description,
          tags: details != null && details.tags.isNotEmpty
              ? details.tags
              : sourceManga.details.tagNames.isEmpty
              ? null
              : sourceManga.details.tagNames,
        ),
      );

      librarySet.add(
        AidokuBackupLibraryManga(
          mangaId: match.mangaKey,
          sourceId: match.pluginSourceId,
          dateAdded: sourceManga.dateAdded ?? DateTime.now(),
          lastOpened: sourceManga.lastOpened ?? sourceManga.lastRead ?? DateTime.now(),
          lastUpdated: sourceManga.lastUpdated ?? sourceManga.dateAdded ?? DateTime.now(),
          lastRead: sourceManga.lastRead,
          categories: sourceManga.categories,
        ),
      );

      allCategories.addAll(sourceManga.categories);

      if (targetChapters.isNotEmpty) {
        _addTargetChapters(
          targetChapters,
          sourceManga,
          match,
          chapterSet,
          historySet,
        );
      }

      for (final SourceHistoryEntry h in sourceManga.history) {
        historySet.add(
          AidokuBackupHistory(
            dateRead: h.dateRead ?? DateTime.now(),
            sourceId: match.pluginSourceId,
            chapterId: h.chapterTitle,
            mangaId: match.mangaKey,
            progress: h.progress,
            total: h.total,
            completed: h.completed,
          ),
        );
      }

      sources.add(match.pluginSourceId);
    }

    return AidokuBackup(
      library: librarySet,
      history: historySet.isEmpty ? null : historySet,
      manga: mangaSet,
      chapters: chapterSet.isEmpty ? null : chapterSet,
      trackItems: null,
      categories: allCategories.isEmpty ? null : allCategories,
      sources: sources,
      date: DateTime.now(),
      name: sourceFormatAlias != null ? 'Migrated from $sourceFormatAlias' : null,
      version: '0.6.10',
    );
  }

  void _addTargetChapters(
    List<PluginChapter> targetChapters,
    SourceMangaData sourceManga,
    PluginSearchResult match,
    Set<AidokuBackupChapter> chapterSet,
    Set<AidokuBackupHistory> historySet,
  ) {
    final readSourceChapters = <double, SourceChapter>{
      for (final SourceChapter ch in sourceManga.chapters)
        if (ch.isRead && ch.chapterNumber != null) ch.chapterNumber!: ch,
    };

    for (final (int i, PluginChapter ch) in targetChapters.indexed) {
      chapterSet.add(
        AidokuBackupChapter(
          sourceId: match.pluginSourceId,
          mangaId: match.mangaKey,
          id: ch.chapterId,
          title: ch.title,
          scanlator: ch.scanlator,
          lang: ch.language ?? 'en',
          chapter: ch.chapterNumber,
          volume: ch.volumeNumber,
          dateUploaded: ch.dateUploaded,
          sourceOrder: i,
        ),
      );

      final SourceChapter? sourceCh = ch.chapterNumber != null ? readSourceChapters[ch.chapterNumber] : null;
      if (sourceCh != null) {
        historySet.add(
          AidokuBackupHistory(
            dateRead: sourceManga.lastRead ?? DateTime.now(),
            sourceId: match.pluginSourceId,
            chapterId: ch.chapterId,
            mangaId: match.mangaKey,
            progress: sourceCh.lastPageRead > 0 ? sourceCh.lastPageRead : null,
            total: null,
            completed: true,
          ),
        );
      }
    }
  }
}

class UnimplementedBackupBuilder extends TargetBackupBuilder {
  const UnimplementedBackupBuilder();

  @override
  ConvertableBackup build(
    List<MangaMatchConfirmation> confirmations, {
    String? sourceFormatAlias,
  }) {
    // TODO: Implement backup builders for other formats
    throw UnimplementedError('Target backup construction not yet implemented for this format');
  }
}
