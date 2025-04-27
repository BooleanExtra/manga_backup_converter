import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_j2k.proto/proto/schema_j2k.pb.dart' as j2k;
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart' as neko;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;
import 'package:mangabackupconverter_cli/src/proto/schema_yokai.proto/proto/schema_yokai.pb.dart' as yokai;

part 'tachi_backup_chapter.mapper.dart';

@MappableClass()
class TachiBackupChapter with TachiBackupChapterMappable {
  final String url;
  final String name;
  final String scanlator;
  final bool read;
  final bool bookmark;
  final int lastPageRead;
  final int dateFetch;
  final int dateUpload;
  final double chapterNumber;
  final int sourceOrder;
  final int? lastModifiedAt;
  final int? version;

  /// J2K and Yokai only
  final int? pagesLeft;

  const TachiBackupChapter({
    required this.url,
    required this.name,
    required this.scanlator,
    required this.read,
    required this.bookmark,
    required this.lastPageRead,
    required this.dateFetch,
    required this.dateUpload,
    required this.chapterNumber,
    required this.sourceOrder,
    this.lastModifiedAt,
    this.version,
    this.pagesLeft,
  });

  factory TachiBackupChapter.fromMihon(mihon.BackupChapter backupChapter) {
    return TachiBackupChapter(
      url: backupChapter.url,
      name: backupChapter.name,
      scanlator: backupChapter.scanlator,
      read: backupChapter.read,
      bookmark: backupChapter.bookmark,
      lastPageRead: backupChapter.lastPageRead.toInt(),
      dateFetch: backupChapter.dateFetch.toInt(),
      dateUpload: backupChapter.dateUpload.toInt(),
      chapterNumber: backupChapter.chapterNumber,
      sourceOrder: backupChapter.sourceOrder.toInt(),
      lastModifiedAt: backupChapter.lastModifiedAt.toInt(),
      version: backupChapter.version.toInt(),
    );
  }

  factory TachiBackupChapter.fromSy(sy.BackupChapter backupChapter) {
    return TachiBackupChapter(
      url: backupChapter.url,
      name: backupChapter.name,
      scanlator: backupChapter.scanlator,
      read: backupChapter.read,
      bookmark: backupChapter.bookmark,
      lastPageRead: backupChapter.lastPageRead.toInt(),
      dateFetch: backupChapter.dateFetch.toInt(),
      dateUpload: backupChapter.dateUpload.toInt(),
      chapterNumber: backupChapter.chapterNumber,
      sourceOrder: backupChapter.sourceOrder.toInt(),
      lastModifiedAt: backupChapter.lastModifiedAt.toInt(),
      version: backupChapter.version.toInt(),
    );
  }

  factory TachiBackupChapter.fromJ2k(j2k.BackupChapter backupChapter) {
    return TachiBackupChapter(
      url: backupChapter.url,
      name: backupChapter.name,
      scanlator: backupChapter.scanlator,
      read: backupChapter.read,
      bookmark: backupChapter.bookmark,
      lastPageRead: backupChapter.lastPageRead,
      dateFetch: backupChapter.dateFetch.toInt(),
      dateUpload: backupChapter.dateUpload.toInt(),
      chapterNumber: backupChapter.chapterNumber,
      sourceOrder: backupChapter.sourceOrder,
      pagesLeft: backupChapter.pagesLeft,
    );
  }

  factory TachiBackupChapter.fromNeko(neko.BackupChapter backupChapter) {
    return TachiBackupChapter(
      url: backupChapter.url,
      name: backupChapter.name,
      scanlator: backupChapter.scanlator,
      read: backupChapter.read,
      bookmark: backupChapter.bookmark,
      lastPageRead: backupChapter.lastPageRead,
      dateFetch: backupChapter.dateFetch.toInt(),
      dateUpload: backupChapter.dateUpload.toInt(),
      chapterNumber: backupChapter.chapterNumber,
      sourceOrder: backupChapter.sourceOrder,
    );
  }

  factory TachiBackupChapter.fromYokai(yokai.BackupChapter backupChapter) {
    return TachiBackupChapter(
      url: backupChapter.url,
      name: backupChapter.name,
      scanlator: backupChapter.scanlator,
      read: backupChapter.read,
      bookmark: backupChapter.bookmark,
      lastPageRead: backupChapter.lastPageRead,
      dateFetch: backupChapter.dateFetch.toInt(),
      dateUpload: backupChapter.dateUpload.toInt(),
      chapterNumber: backupChapter.chapterNumber,
      sourceOrder: backupChapter.sourceOrder,
      pagesLeft: backupChapter.pagesLeft,
    );
  }

  static const fromMap = TachiBackupChapterMapper.fromMap;
  static const fromJson = TachiBackupChapterMapper.fromJson;
}
