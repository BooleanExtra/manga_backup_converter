import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mangabackupconverter/src/features/settings/application/settings_service.dart';
import 'package:mangabackupconverter/src/features/settings/data/dto/settings.dart';
import 'package:mangabackupconverter/src/routing/router/router.dart';
import 'package:mangabackupconverter/utils/utils.dart';

class SettingsScreen extends StatefulHookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final Settings settings = ref.watch(settingsServiceProvider);
    final List<AbstractSettingsTile> developerSettings =
        _buildDeveloperSettings(settings: settings);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: theme.colorScheme.surface,
          settingsSectionBackground: theme.colorScheme.surface,
          tileHighlightColor: theme.highlightColor,
        ),
        darkTheme: SettingsThemeData(
          settingsListBackground: theme.colorScheme.surface,
          settingsSectionBackground: theme.colorScheme.surface,
          tileHighlightColor: theme.highlightColor,
        ),
        brightness: theme.brightness,
        platform: DevicePlatform.android,
        sections: <AbstractSettingsSection>[
          SettingsSection(
            tiles: <AbstractSettingsTile>[
              SettingsTile.navigation(
                title: const Text('Appearance'),
                leading: const Icon(Icons.colorize),
                onPressed: (BuildContext context) {
                  context.goNamed(
                    RouteName.settingDetails.name,
                    pathParameters: <String, String>{'id': 'appearance'},
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text('About'),
                leading: const Icon(Icons.info),
                onPressed: (BuildContext context) {
                  context.goNamed(
                    RouteName.settingDetails.name,
                    pathParameters: <String, String>{'id': 'about'},
                  );
                },
              ),
            ],
          ),
          buildAdvancedSection(),
          if (developerSettings.isNotEmpty && !kReleaseMode)
            SettingsSection(
              title: const Text('Developer'),
              tiles: developerSettings,
            ),
        ],
      ),
    );
  }

  SettingsSection buildAdvancedSection() {
    return SettingsSection(
      title: const Text('Advanced'),
      tiles: <AbstractSettingsTile>[
        SettingsTile(
          title: const Text('Reset settings'),
          leading: const Icon(Icons.restore),
          onPressed: (BuildContext context) async {
            await showAdaptiveDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                final ColorScheme colorScheme = Theme.of(context).colorScheme;
                return AlertDialog.adaptive(
                  title: const Text('Reset settings'),
                  content: const Text(
                    'Are you sure you want to reset your settings to default? This action cannot be undone.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(settingsServiceProvider.notifier)
                            .resetSettings();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  List<AbstractSettingsTile> _buildDeveloperSettings({
    required Settings settings,
  }) {
    return <AbstractSettingsTile>[
      if (settings.bannerEnabled)
        CustomSettingsTile(child: _ToggleBannerButton(context: context)),
    ];
  }
}

class _ToggleBannerButton extends ConsumerWidget {
  const _ToggleBannerButton({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Settings settings = ref.watch(settingsServiceProvider);
    return ListTile(
      leading: const Icon(Icons.bug_report),
      title: const Text('Enable banner'),
      onTap: () {
        _toggleButton(ref, context);
      },
      trailing: Semantics(
        label: 'Toggle debug banner',
        child: Switch(
          value: settings.bannerEnabled,
          onChanged: (bool value) {
            _toggleButton(ref, context);
          },
        ),
      ),
    );
  }

  void _toggleButton(WidgetRef ref, BuildContext context) {
    final bool bannerEnabled = ref
        .read(settingsServiceProvider.notifier)
        .toggleBanner();
    context.showAccessibilitySnackBar(
      'Debug banner has been ${bannerEnabled ? 'enabled' : 'disabled'}',
    );
  }
}

class CustomSettingsTile extends AbstractSettingsTile {
  const CustomSettingsTile({
    required this.child,
    this.padding = EdgeInsetsDirectional.zero,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}
