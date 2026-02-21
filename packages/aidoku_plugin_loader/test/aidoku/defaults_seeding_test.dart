import 'dart:convert';
import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/models/setting_item.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('flattenSettingDefaults', () {
    test('switch true seeds 1', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        SwitchSetting(defaultValue: true, key: 'nsfw'),
      ]);
      check(result['nsfw']).equals(1);
    });

    test('switch false seeds 0', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        SwitchSetting(defaultValue: false, key: 'nsfw'),
      ]);
      check(result['nsfw']).equals(0);
    });

    test('select seeds index of default', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        SelectSetting(
          values: <String>['safe', 'suggestive', 'erotica'],
          titles: <String>['Safe', 'Suggestive', 'Erotica'],
          key: 'content',
          defaultValue: 'suggestive',
        ),
      ]);
      check(result['content']).equals(1);
    });

    test('stepper seeds rounded int', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        StepperSetting(min: 0, max: 100, step: 5, defaultValue: 25.0, key: 'limit'),
      ]);
      check(result['limit']).equals(25);
    });

    test('text seeds utf8 bytes', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        TextSetting(defaultValue: 'secret', key: 'token'),
      ]);
      final Object? bytes = result['token'];
      check(bytes).isA<Uint8List>();
      check(utf8.decode(bytes! as Uint8List)).equals('secret');
    });

    test('multi-select seeds postcard-encoded string list', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        MultiSelectSetting(values: <String>['en', 'ja', 'ko'], defaultValue: <String>['en', 'ja'], key: 'langs'),
      ]);
      final Object? bytes = result['langs'];
      check(bytes).isA<Uint8List>();
      // Postcard encodes as varint count + per-string bytes
      check((bytes! as Uint8List).length).isGreaterThan(0);
    });

    test('group children are flattened', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        GroupSetting(
          title: 'Advanced',
          items: <SettingItem>[
            SwitchSetting(defaultValue: true, key: 'advanced'),
            SwitchSetting(defaultValue: false, key: 'debug'),
          ],
        ),
      ]);
      check(result['advanced']).equals(1);
      check(result['debug']).equals(0);
    });

    test('nested groups are fully flattened', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        GroupSetting(
          title: 'Outer',
          items: <SettingItem>[
            GroupSetting(
              title: 'Inner',
              items: <SettingItem>[SwitchSetting(defaultValue: true, key: 'deep')],
            ),
          ],
        ),
      ]);
      check(result['deep']).equals(1);
    });

    test('settings without keys are skipped', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        SwitchSetting(defaultValue: true), // no key
        UnknownSetting(type: 'button', title: 'Reset'),
      ]);
      check(result).isEmpty();
    });

    test('multiple settings produce all entries', () {
      final Map<String, Object> result = flattenSettingDefaults(const <SettingItem>[
        SwitchSetting(defaultValue: true, key: 'a'),
        SwitchSetting(defaultValue: false, key: 'b'),
        SegmentSetting(values: <String>[], titles: <String>[], defaultValue: 2, key: 'c'),
      ]);
      check(result).length.equals(3);
      check(result['a']).equals(1);
      check(result['b']).equals(0);
      check(result['c']).equals(2);
    });
  });
}
