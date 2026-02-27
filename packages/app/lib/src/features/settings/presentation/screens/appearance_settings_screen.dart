import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mangabackupconverter/src/features/settings/application/settings_service.dart';
import 'package:mangabackupconverter/src/features/settings/application/themes.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/settings.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/theme_type.dart';
import 'package:mangabackupconverter/src/features/settings/presentation/widgets/segmented_button_tile.dart';
import 'package:mangabackupconverter/src/features/settings/presentation/widgets/theme_selector_tile.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Settings settings = ref.watch(settingsServiceProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final List<FlexSchemeData> themes = ref.watch(themesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: Material(
        child: ListView(
          children: <Widget>[
            SegmentedButtonTile<ThemeType>(
              initial: settings.themeType,
              segments: const <ThemeType>[
                ThemeType.system,
                ThemeType.dark,
                ThemeType.light,
              ],
              onTap: (ThemeType themeType) {
                ref
                    .read(settingsServiceProvider.notifier)
                    .setThemeType(themeType);
              },
            ),
            ThemeSelectorTile(
              selected: isLight ? settings.lightTheme : settings.darkTheme,
              schemes: themes,
              colorProvider: (FlexSchemeData data) =>
                  isLight ? data.light : data.dark,
              onTap: (FlexSchemeData scheme) {
                isLight
                    ? ref
                          .read(settingsServiceProvider.notifier)
                          .setLightTheme(scheme)
                    : ref
                          .read(settingsServiceProvider.notifier)
                          .setDarkTheme(scheme);
              },
            ),
          ],
        ),
      ),
    );
  }
}
