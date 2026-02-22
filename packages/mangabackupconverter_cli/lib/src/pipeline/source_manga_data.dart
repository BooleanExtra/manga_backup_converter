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
  const SourceChapter({
    required this.title,
    this.chapterNumber,
    this.volumeNumber,
    this.scanlator,
    this.language,
    this.isRead = false,
    this.isBookmarked = false,
    this.lastPageRead = 0,
    this.dateUploaded,
    this.sourceOrder = 0,
  });

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
  const SourceHistoryEntry({
    required this.chapterTitle,
    this.chapterNumber,
    this.dateRead,
    this.completed = false,
    this.progress,
    this.total,
  });

  final String chapterTitle;
  final double? chapterNumber;
  final DateTime? dateRead;
  final bool completed;
  final int? progress;
  final int? total;
}

class SourceTrackingEntry {
  const SourceTrackingEntry({
    required this.syncId,
    this.libraryId,
    this.mediaId,
    this.trackingUrl,
    this.title,
    this.lastChapterRead,
    this.totalChapters,
    this.score,
    this.status,
    this.startedReadingDate,
    this.finishedReadingDate,
  });

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
