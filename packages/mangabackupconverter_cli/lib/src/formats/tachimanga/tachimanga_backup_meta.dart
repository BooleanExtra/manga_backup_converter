import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'tachimanga_backup_meta.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class TachimangaBackupMeta with TachimangaBackupMetaMappable {
  final String name;
  final bool remoteBackup;
  final bool downloaded;
  final int backupId;
  final int updateAt;
  final int type;
  final int size;
  final String checksum;
  final int createAt;
  final bool cloudBackup;
  final int version;
  final double downloadProgress;
  final int state;
  final Object? extInfo;

  TachimangaBackupMeta({
    required this.name,
    required this.remoteBackup,
    required this.downloaded,
    required this.backupId,
    required this.updateAt,
    required this.type,
    required this.size,
    required this.checksum,
    required this.createAt,
    required this.cloudBackup,
    required this.version,
    required this.downloadProgress,
    required this.state,
    required this.extInfo,
  });

  static const TachimangaBackupMeta Function(Map<String, dynamic> map) fromMap = TachimangaBackupMetaMapper.fromMap;
  static const TachimangaBackupMeta Function(String json) fromJson = TachimangaBackupMetaMapper.fromJson;
}
