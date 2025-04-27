import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;

part 'tachi_backup_preference.mapper.dart';

@MappableClass()
class TachiBackupPreference with TachiBackupPreferenceMappable {
  final String key;
  final TachiBackupPreferenceValue value;

  const TachiBackupPreference({required this.key, required this.value});

  factory TachiBackupPreference.fromMihon(mihon.BackupPreference backupPreference) {
    return TachiBackupPreference(
      key: backupPreference.key,
      value: TachiBackupPreferenceValue.fromMihon(backupPreference.value),
    );
  }

  factory TachiBackupPreference.fromSy(sy.BackupPreference backupPreference) {
    return TachiBackupPreference(
      key: backupPreference.key,
      value: TachiBackupPreferenceValue.fromSy(backupPreference.value),
    );
  }

  static const fromMap = TachiBackupPreferenceMapper.fromMap;
  static const fromJson = TachiBackupPreferenceMapper.fromJson;
}

@MappableClass()
class TachiBackupPreferenceValue with TachiBackupPreferenceValueMappable {
  final String type;
  final List<int> truevalue;

  const TachiBackupPreferenceValue({required this.type, required this.truevalue});

  factory TachiBackupPreferenceValue.fromMihon(mihon.PreferenceValue value) {
    return TachiBackupPreferenceValue(type: value.type, truevalue: value.truevalue);
  }

  factory TachiBackupPreferenceValue.fromSy(sy.PreferenceValue value) {
    return TachiBackupPreferenceValue(type: value.type, truevalue: value.truevalue);
  }

  static const fromMap = TachiBackupPreferenceValueMapper.fromMap;
  static const fromJson = TachiBackupPreferenceValueMapper.fromJson;
}
