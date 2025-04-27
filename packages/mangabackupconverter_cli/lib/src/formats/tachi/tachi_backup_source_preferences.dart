import 'package:dart_mappable/dart_mappable.dart';
import 'package:mangabackupconverter_cli/mangabackupconverter_lib.dart';
import 'package:mangabackupconverter_cli/src/proto/schema_mihon.proto/proto/schema_mihon.pb.dart' as mihon;
import 'package:mangabackupconverter_cli/src/proto/schema_sy.proto/proto/schema_sy.pb.dart' as sy;

part 'tachi_backup_source_preferences.mapper.dart';

@MappableClass()
class TachiBackupSourcePreferences with TachiBackupSourcePreferencesMappable {
  final String sourceKey;
  final List<TachiBackupPreference> prefs;

  const TachiBackupSourcePreferences({required this.sourceKey, required this.prefs});

  factory TachiBackupSourcePreferences.fromMihon(mihon.BackupSourcePreferences backupSourcePreferences) {
    return TachiBackupSourcePreferences(
      sourceKey: backupSourcePreferences.sourceKey,
      prefs: backupSourcePreferences.prefs.map(TachiBackupPreference.fromMihon).toList(),
    );
  }

  factory TachiBackupSourcePreferences.fromSy(sy.BackupSourcePreferences backupSourcePreferences) {
    return TachiBackupSourcePreferences(
      sourceKey: backupSourcePreferences.sourceKey,
      prefs: backupSourcePreferences.prefs.map(TachiBackupPreference.fromSy).toList(),
    );
  }

  static const fromMap = TachiBackupSourcePreferencesMapper.fromMap;
  static const fromJson = TachiBackupSourcePreferencesMapper.fromJson;
}
