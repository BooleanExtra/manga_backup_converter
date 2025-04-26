import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';

part 'mangayomi_backup_db.mapper.dart';

@MappableClass(includeCustomMappers: [SecondsEpochDateTimeMapper()])
class MangayomiBackupDb with MangayomiBackupDbMappable {
  final String? version;

  const MangayomiBackupDb({
    this.version = '2',
  });

  static const fromMap = MangayomiBackupDbMapper.fromMap;
  static const fromJson = MangayomiBackupDbMapper.fromJson;
}
