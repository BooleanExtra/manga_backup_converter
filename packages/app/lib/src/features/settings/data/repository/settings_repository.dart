import 'package:mangabackupconverter/src/features/settings/application/prefs.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

@riverpod
class SettingsRepository extends _$SettingsRepository {
  late final SharedPreferences _prefs;
  @override
  Settings build() {
    _prefs = ref.read(prefsProvider).requireValue;
    return getSettings();
  }

  Settings resetSettings() {
    return saveSettings(const Settings());
  }

  Settings saveSettings(Settings settings) {
    _prefs.setString('settings', settings.toJson());
    return settings;
  }

  Settings getSettings() {
    return Settings.fromJson(_prefs.getString('settings') ?? '{}');
  }
}
