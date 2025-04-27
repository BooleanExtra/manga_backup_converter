import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_j2k.proto/proto/schema_j2k.pb.dart' as j2k;
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart' as neko;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;
import 'package:mangabackupconverter_cli/src/proto/schema_yokai.proto/proto/schema_yokai.pb.dart' as yokai;

part 'tachi_backup_tracking.mapper.dart';

@MappableClass()
class TachiBackupTracking with TachiBackupTrackingMappable {
  final int syncId;
  final int libraryId;
  final int mediaIdInt;
  final String trackingUrl;
  final String title;
  final double lastChapterRead;
  final int totalChapters;
  final double score;
  final int status;
  final int startedReadingDate;
  final int finishedReadingDate;
  final int mediaId;

  const TachiBackupTracking({
    required this.syncId,
    required this.libraryId,
    required this.mediaIdInt,
    required this.trackingUrl,
    required this.title,
    required this.lastChapterRead,
    required this.totalChapters,
    required this.score,
    required this.status,
    required this.startedReadingDate,
    required this.finishedReadingDate,
    required this.mediaId,
  });

  factory TachiBackupTracking.fromMihon(mihon.BackupTracking backupTracking) {
    return TachiBackupTracking(
      syncId: backupTracking.syncId,
      libraryId: backupTracking.libraryId.toInt(),
      mediaIdInt: backupTracking.mediaIdInt,
      trackingUrl: backupTracking.trackingUrl,
      title: backupTracking.title,
      lastChapterRead: backupTracking.lastChapterRead,
      totalChapters: backupTracking.totalChapters,
      score: backupTracking.score,
      status: backupTracking.status,
      startedReadingDate: backupTracking.startedReadingDate.toInt(),
      finishedReadingDate: backupTracking.finishedReadingDate.toInt(),
      mediaId: backupTracking.mediaId.toInt(),
    );
  }

  factory TachiBackupTracking.fromSy(sy.BackupTracking backupTracking) {
    return TachiBackupTracking(
      syncId: backupTracking.syncId,
      libraryId: backupTracking.libraryId.toInt(),
      mediaIdInt: backupTracking.mediaIdInt,
      trackingUrl: backupTracking.trackingUrl,
      title: backupTracking.title,
      lastChapterRead: backupTracking.lastChapterRead,
      totalChapters: backupTracking.totalChapters,
      score: backupTracking.score,
      status: backupTracking.status,
      startedReadingDate: backupTracking.startedReadingDate.toInt(),
      finishedReadingDate: backupTracking.finishedReadingDate.toInt(),
      mediaId: backupTracking.mediaId.toInt(),
    );
  }

  factory TachiBackupTracking.fromJ2k(j2k.BackupTracking backupTracking) {
    return TachiBackupTracking(
      syncId: backupTracking.syncId,
      libraryId: backupTracking.libraryId.toInt(),
      mediaIdInt: backupTracking.mediaIdInt,
      trackingUrl: backupTracking.trackingUrl,
      title: backupTracking.title,
      lastChapterRead: backupTracking.lastChapterRead,
      totalChapters: backupTracking.totalChapters,
      score: backupTracking.score,
      status: backupTracking.status,
      startedReadingDate: backupTracking.startedReadingDate.toInt(),
      finishedReadingDate: backupTracking.finishedReadingDate.toInt(),
      mediaId: backupTracking.mediaId.toInt(),
    );
  }

  factory TachiBackupTracking.fromNeko(neko.BackupTracking backupTracking) {
    return TachiBackupTracking(
      syncId: backupTracking.syncId,
      libraryId: backupTracking.libraryId.toInt(),
      mediaIdInt: backupTracking.mediaIdInt,
      trackingUrl: backupTracking.trackingUrl,
      title: backupTracking.title,
      lastChapterRead: backupTracking.lastChapterRead,
      totalChapters: backupTracking.totalChapters,
      score: backupTracking.score,
      status: backupTracking.status,
      startedReadingDate: backupTracking.startedReadingDate.toInt(),
      finishedReadingDate: backupTracking.finishedReadingDate.toInt(),
      mediaId: backupTracking.mediaId.toInt(),
    );
  }

  factory TachiBackupTracking.fromYokai(yokai.BackupTracking backupTracking) {
    return TachiBackupTracking(
      syncId: backupTracking.syncId,
      libraryId: backupTracking.libraryId.toInt(),
      mediaIdInt: backupTracking.mediaIdInt,
      trackingUrl: backupTracking.trackingUrl,
      title: backupTracking.title,
      lastChapterRead: backupTracking.lastChapterRead,
      totalChapters: backupTracking.totalChapters,
      score: backupTracking.score,
      status: backupTracking.status,
      startedReadingDate: backupTracking.startedReadingDate.toInt(),
      finishedReadingDate: backupTracking.finishedReadingDate.toInt(),
      mediaId: backupTracking.mediaId.toInt(),
    );
  }

  static const fromMap = TachiBackupTrackingMapper.fromMap;
  static const fromJson = TachiBackupTrackingMapper.fromJson;
}
