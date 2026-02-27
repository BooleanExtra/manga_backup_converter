import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/settings.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/theme_type.dart';
import 'package:mangabackupconverter/src/features/settings/data/repository/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_service.g.dart';

const String settingsBoxName = 'settingsBox';

@riverpod
class SettingsService extends _$SettingsService {
  late SettingsRepository _settingsRepository;

  @override
  Settings build() {
    _settingsRepository = ref.watch(settingsRepositoryProvider.notifier);
    return _settingsRepository.getSettings();
  }

  Future<void> resetSettings() async {
    state = _settingsRepository.resetSettings();
  }

  bool toggleBanner() {
    final bool bannerEnabled = !state.bannerEnabled;
    final Settings newSettings = state.copyWith(bannerEnabled: bannerEnabled);
    state = newSettings;
    _settingsRepository.saveSettings(newSettings);
    return bannerEnabled;
  }

  void setThemeType(ThemeType themeType) {
    final Settings newSettings = state.copyWith(themeType: themeType);
    state = newSettings;
    _settingsRepository.saveSettings(newSettings);
  }

  void setLightTheme(FlexSchemeData lightTheme) {
    final Settings newSettings = state.copyWith(lightTheme: lightTheme);
    state = newSettings;
    _settingsRepository.saveSettings(newSettings);
  }

  void setDarkTheme(FlexSchemeData darkTheme) {
    final Settings newSettings = state.copyWith(darkTheme: darkTheme);
    state = newSettings;
    _settingsRepository.saveSettings(newSettings);
  }

  void setCustomThemes(List<FlexSchemeData> customThemes) {
    final Settings newSettings = state.copyWith(customThemes: customThemes);
    state = newSettings;
    _settingsRepository.saveSettings(newSettings);
  }
}
