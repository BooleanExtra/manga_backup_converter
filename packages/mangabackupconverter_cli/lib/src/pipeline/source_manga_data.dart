import 'package:mangabackupconverter_cli/src/common/normalize_chapter_number.dart';
import 'package:mangabackupconverter_cli/src/pipeline/manga_details.dart';

class SourceMangaData {
  const SourceMangaData({
    required this.details,
    this.sourceId,
    this.categories = const <String>[],
    this.chapters = const <SourceChapter>[],
    this.history = const <SourceHistoryEntry>[],
    this.tracking = const <SourceTrackingEntry>[],
    this.dateAdded,
    this.lastRead,
    this.lastOpened,
    this.lastUpdated,
    this.status,
  });

  final MangaSearchDetails details;
  final String? sourceId;
  final List<String> categories;
  final List<SourceChapter> chapters;
  final List<SourceHistoryEntry> history;
  final List<SourceTrackingEntry> tracking;
  final DateTime? dateAdded;
  final DateTime? lastRead;
  final DateTime? lastOpened;
  final DateTime? lastUpdated;
  final int? status;
}

class SourceChapter {
  SourceChapter({
    required this.title,
    double? chapterNumber,
    double? volumeNumber,
    this.scanlator,
    this.language,
    this.isRead = false,
    this.isBookmarked = false,
    this.lastPageRead = 0,
    this.dateUploaded,
    this.sourceOrder = 0,
  })  : chapterNumber = chapterNumber == null
            ? null
            : normalizeChapterNumber(chapterNumber),
        volumeNumber =
            volumeNumber == null ? null : normalizeChapterNumber(volumeNumber);

  final String title;
  final double? chapterNumber;
  final double? volumeNumber;
  final String? scanlator;
  final String? language;
  final bool isRead;
  final bool isBookmarked;
  final int lastPageRead;
  final DateTime? dateUploaded;
  final int sourceOrder;
}

class SourceHistoryEntry {
  SourceHistoryEntry({
    required this.chapterTitle,
    double? chapterNumber,
    this.dateRead,
    this.completed = false,
    this.progress,
    this.total,
  }) : chapterNumber = chapterNumber == null
            ? null
            : normalizeChapterNumber(chapterNumber);

  final String chapterTitle;
  final double? chapterNumber;
  final DateTime? dateRead;
  final bool completed;
  final int? progress;
  final int? total;
}

class SourceTrackingEntry {
  SourceTrackingEntry({
    required this.syncId,
    this.libraryId,
    this.mediaId,
    this.trackingUrl,
    this.title,
    double? lastChapterRead,
    this.totalChapters,
    this.score,
    this.status,
    this.startedReadingDate,
    this.finishedReadingDate,
  }) : lastChapterRead = lastChapterRead == null
            ? null
            : normalizeChapterNumber(lastChapterRead);

  final int syncId;
  final int? libraryId;
  final int? mediaId;
  final String? trackingUrl;
  final String? title;
  final double? lastChapterRead;
  final int? totalChapters;
  final double? score;
  final int? status;
  final DateTime? startedReadingDate;
  final DateTime? finishedReadingDate;
}
