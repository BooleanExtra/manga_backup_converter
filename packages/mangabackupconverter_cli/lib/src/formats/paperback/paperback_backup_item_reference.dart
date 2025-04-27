import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/formats/paperback/paperback_backup_item_type.dart';

part 'paperback_backup_item_reference.mapper.dart';

@MappableClass(includeCustomMappers: [SecondsEpochDateTimeMapper()])
class PaperbackBackupItemReference with PaperbackBackupItemReferenceMappable {
  final PaperbackBackupItemType type;
  final String id;

  PaperbackBackupItemReference({required this.type, required this.id});

  static const fromMap = PaperbackBackupItemReferenceMapper.fromMap;
  static const fromJson = PaperbackBackupItemReferenceMapper.fromJson;
}
