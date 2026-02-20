import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:mangabackupconverter/src/features/initialization/application/info_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSettingsScreen extends ConsumerStatefulWidget {
  const AboutSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AboutSettingsScreenState();
}

class _AboutSettingsScreenState extends ConsumerState<AboutSettingsScreen> {
  static final Logger _log = Logger('AboutSettingsScreen');

  late SystemClipboard? clipboard;

  @override
  void initState() {
    super.initState();
    clipboard = SystemClipboard.instance;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PackageInfo> packageInfo = ref.watch(packageInfoProvider);
    final String version = packageInfo.requireValue.version;
    final String buildNumber = packageInfo.requireValue.buildNumber;
    final versionId =
        'v$version${((!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && version == buildNumber) || buildNumber.isEmpty) ? '' : '+$buildNumber'}';
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Material(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Version'),
              leading: const Icon(Icons.info),
              subtitle: Text(versionId),
              onTap: clipboard == null
                  ? null
                  : () async {
                      final item = DataWriterItem();
                      item.add(Formats.plainText(versionId));
                      await clipboard?.write(<DataWriterItem>[item]);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Version copied to clipboard'),
                          ),
                        );
                      }
                    },
            ),
            ListTile(
              title: const Text('Open Source Licenses'),
              leading: const Icon(Icons.description),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: packageInfo.requireValue.appName,
                  useRootNavigator: true,
                );
              },
            ),
            ListTile(
              title: const Text('GitHub'),
              leading: const Icon(Icons.code),
              subtitle: const Text('getBoolean/manga_backup_converter'),
              onTap: () async {
                final Uri url = Uri.parse(
                  'https://www.github.com/getBoolean/manga_backup_converter',
                );
                try {
                  final bool success = await launchUrl(url);
                  if (!success) {
                    _log.fine('Could not launch url: ${url.path}');
                  }
                } on PlatformException catch (e, st) {
                  _log.severe('Could not launch url: ${e.message}', e, st);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
