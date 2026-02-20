import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_j2k.proto/proto/schema_j2k.pb.dart' as j2k;
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_neko.proto/proto/schema_neko.pb.dart' as neko;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;
import 'package:mangabackupconverter_cli/src/proto/schema_yokai.proto/proto/schema_yokai.pb.dart' as yokai;

part 'tachi_backup_history.mapper.dart';

@MappableClass()
class TachiBackupHistory with TachiBackupHistoryMappable {
  final String url;
  final int lastRead;
  final int readDuration;

  const TachiBackupHistory({required this.url, required this.lastRead, required this.readDuration});

  factory TachiBackupHistory.fromMihon(mihon.BackupHistory backupHistory) {
    return TachiBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  factory TachiBackupHistory.fromSy(sy.BackupHistory backupHistory) {
    return TachiBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  factory TachiBackupHistory.fromJ2k(j2k.BackupHistory backupHistory) {
    return TachiBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  factory TachiBackupHistory.fromNeko(neko.BackupHistory backupHistory) {
    return TachiBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  factory TachiBackupHistory.fromYokai(yokai.BackupHistory backupHistory) {
    return TachiBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  static const TachiBackupHistory Function(Map<String, dynamic> map) fromMap = TachiBackupHistoryMapper.fromMap;
  static const TachiBackupHistory Function(String json) fromJson = TachiBackupHistoryMapper.fromJson;
}

@MappableClass()
class TachiBrokenBackupHistory extends TachiBackupHistory with TachiBrokenBackupHistoryMappable {
  const TachiBrokenBackupHistory({required super.url, required super.lastRead, required super.readDuration});

  factory TachiBrokenBackupHistory.fromJ2k(j2k.BrokenBackupHistory backupHistory) {
    return TachiBrokenBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  factory TachiBrokenBackupHistory.fromNeko(neko.BrokenBackupHistory backupHistory) {
    return TachiBrokenBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  factory TachiBrokenBackupHistory.fromYokai(yokai.BrokenBackupHistory backupHistory) {
    return TachiBrokenBackupHistory(
      url: backupHistory.url,
      lastRead: backupHistory.lastRead.toInt(),
      readDuration: backupHistory.readDuration.toInt(),
    );
  }

  static const TachiBrokenBackupHistory Function(Map<String, dynamic> map) fromMap =
      TachiBrokenBackupHistoryMapper.fromMap;
  static const TachiBrokenBackupHistory Function(String json) fromJson = TachiBrokenBackupHistoryMapper.fromJson;
}
