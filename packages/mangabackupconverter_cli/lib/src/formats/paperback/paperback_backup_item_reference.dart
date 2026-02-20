import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_type.dart';

part 'paperback_backup_item_reference.mapper.dart';

@MappableClass(includeCustomMappers: <MapperBase<Object>>[SecondsEpochDateTimeMapper()])
class PaperbackBackupItemReference with PaperbackBackupItemReferenceMappable {
  final PaperbackBackupItemType type;
  final String id;

  PaperbackBackupItemReference({required this.type, required this.id});

  static const PaperbackBackupItemReference Function(Map<String, dynamic> map) fromMap =
      PaperbackBackupItemReferenceMapper.fromMap;
  static const PaperbackBackupItemReference Function(String json) fromJson =
      PaperbackBackupItemReferenceMapper.fromJson;
}
