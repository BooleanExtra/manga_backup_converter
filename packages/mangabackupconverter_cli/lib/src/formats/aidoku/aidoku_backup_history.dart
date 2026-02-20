import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/aidoku_date_time_mapper.dart';

part 'aidoku_backup_history.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[AidokuDateTimeMapper()], ignoreNull: true)
class AidokuBackupHistory with AidokuBackupHistoryMappable {
  final DateTime dateRead;
  final String sourceId;
  final String chapterId;
  final String mangaId;
  final int? progress;
  final int? total;
  final bool completed;

  AidokuBackupHistory({
    required this.dateRead,
    required this.sourceId,
    required this.chapterId,
    required this.mangaId,
    required this.progress,
    required this.total,
    required this.completed,
  });

  static const AidokuBackupHistory Function(Map<String, dynamic> map) fromMap = AidokuBackupHistoryMapper.fromMap;
  static const AidokuBackupHistory Function(String json) fromJson = AidokuBackupHistoryMapper.fromJson;
}
