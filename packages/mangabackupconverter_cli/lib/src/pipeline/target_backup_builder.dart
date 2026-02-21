import 'package:mangabackupconverter_cli/src/common/convertable.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_chapter.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_history.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_library_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_manga.dart';
import 'package:mangabackupconverter_cli/src/formats/aidoku/aidoku_backup_track_item.dart';
import 'package:mangabackupconverter_cli/src/pipeline/migration_pipeline.dart';
import 'package:mangabackupconverter_cli/src/pipeline/plugin_source.dart';
import 'package:mangabackupconverter_cli/src/pipeline/source_manga_data.dart';

sealed class TargetBackupBuilder {
  const TargetBackupBuilder();
  ConvertableBackup build(List<MangaMatchConfirmation> confirmations);
}

class AidokuBackupBuilder extends TargetBackupBuilder {
  const AidokuBackupBuilder();

  @override
  ConvertableBackup build(List<MangaMatchConfirmation> confirmations) {
    final Iterable<MangaMatchConfirmation> confirmed = confirmations.where(
      (MangaMatchConfirmation c) => c.confirmedMatch != null,
    );

    final mangaSet = <AidokuBackupManga>{};
    final librarySet = <AidokuBackupLibraryManga>{};
    final chapterSet = <AidokuBackupChapter>{};
    final historySet = <AidokuBackupHistory>{};
    final trackItemSet = <AidokuBackupTrackItem>{};
    final sources = <String>{};
    final allCategories = <String>{};

    for (final confirmation in confirmed) {
      final PluginSearchResult match = confirmation.confirmedMatch!;
      final SourceMangaData sourceManga = confirmation.sourceManga;

      mangaSet.add(
        AidokuBackupManga(
          sourceId: match.pluginSourceId,
          id: match.mangaKey,
          title: match.title,
          cover: match.coverUrl,
          author: match.authors.firstOrNull,
          artist: sourceManga.details.artists.firstOrNull,
          desc: sourceManga.details.description,
          tags: sourceManga.details.tagNames.isEmpty ? null : sourceManga.details.tagNames,
        ),
      );

      librarySet.add(
        AidokuBackupLibraryManga(
          mangaId: match.mangaKey,
          sourceId: match.pluginSourceId,
          dateAdded: sourceManga.dateAdded ?? DateTime.now(),
          lastOpened: DateTime.now(),
          lastUpdated: DateTime.now(),
          lastRead: sourceManga.lastRead,
          categories: sourceManga.categories,
        ),
      );

      allCategories.addAll(sourceManga.categories);

      for (final (int i, SourceChapter ch) in sourceManga.chapters.indexed) {
        final chapterId = 'ch_$i';
        chapterSet.add(
          AidokuBackupChapter(
            sourceId: match.pluginSourceId,
            mangaId: match.mangaKey,
            id: chapterId,
            title: ch.title,
            scanlator: ch.scanlator,
            lang: ch.language ?? 'en',
            chapter: ch.chapterNumber,
            volume: ch.volumeNumber,
            dateUploaded: ch.dateUploaded,
            sourceOrder: ch.sourceOrder,
          ),
        );

        if (ch.isRead) {
          historySet.add(
            AidokuBackupHistory(
              dateRead: sourceManga.lastRead ?? DateTime.now(),
              sourceId: match.pluginSourceId,
              chapterId: chapterId,
              mangaId: match.mangaKey,
              progress: null,
              total: null,
              completed: true,
            ),
          );
        }
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

      for (final (int i, SourceTrackingEntry t) in sourceManga.tracking.indexed) {
        trackItemSet.add(
          AidokuBackupTrackItem(
            id: 'track_${match.mangaKey}_$i',
            trackerId: t.syncId.toString(),
            mangaId: match.mangaKey,
            sourceId: match.pluginSourceId,
            title: t.title,
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
      trackItems: trackItemSet.isEmpty ? null : trackItemSet,
      categories: allCategories.isEmpty ? null : allCategories,
      sources: sources,
      date: DateTime.now(),
      name: null,
      version: null,
    );
  }
}

class UnimplementedBackupBuilder extends TargetBackupBuilder {
  const UnimplementedBackupBuilder();

  @override
  ConvertableBackup build(List<MangaMatchConfirmation> confirmations) {
    throw UnimplementedError('Target backup construction not yet implemented for this format');
  }
}
