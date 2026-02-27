import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/codec/postcard_reader.dart';
import 'package:aidoku_plugin_loader/src/models/setting_item.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('flattenSettingDefaults', () {
    test('switch true seeds postcard bool true', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const SwitchSetting(defaultValue: true, key: 'nsfw'),
      ]);
      final Object? bytes = result['nsfw'];
      check(bytes).isA<Uint8List>();
      check(PostcardReader(bytes! as Uint8List).readBool()).isTrue();
    });

    test('switch false seeds postcard bool false', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const SwitchSetting(defaultValue: false, key: 'nsfw'),
      ]);
      final Object? bytes = result['nsfw'];
      check(bytes).isA<Uint8List>();
      check(PostcardReader(bytes! as Uint8List).readBool()).isFalse();
    });

    test('select seeds postcard zigzag int of index', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const SelectSetting(
          values: <String>['safe', 'suggestive', 'erotica'],
          titles: <String>['Safe', 'Suggestive', 'Erotica'],
          key: 'content',
          defaultValue: 'suggestive',
        ),
      ]);
      final Object? bytes = result['content'];
      check(bytes).isA<Uint8List>();
      check(PostcardReader(bytes! as Uint8List).readSignedVarInt()).equals(1);
    });

    test('segment seeds postcard zigzag int', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const SegmentSetting(values: <String>[], titles: <String>[], defaultValue: 2, key: 'c'),
      ]);
      final Object? bytes = result['c'];
      check(bytes).isA<Uint8List>();
      check(PostcardReader(bytes! as Uint8List).readSignedVarInt()).equals(2);
    });

    test('stepper seeds postcard zigzag int (rounded)', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const StepperSetting(min: 0, max: 100, step: 5, defaultValue: 25.0, key: 'limit'),
      ]);
      final Object? bytes = result['limit'];
      check(bytes).isA<Uint8List>();
      check(PostcardReader(bytes! as Uint8List).readSignedVarInt()).equals(25);
    });

    test('text seeds postcard string', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const TextSetting(defaultValue: 'secret', key: 'token'),
      ]);
      final Object? bytes = result['token'];
      check(bytes).isA<Uint8List>();
      check(PostcardReader(bytes! as Uint8List).readString()).equals('secret');
    });

    test('multi-select seeds postcard-encoded string list', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const MultiSelectSetting(values: <String>['en', 'ja', 'ko'], defaultValue: <String>['en', 'ja'], key: 'langs'),
      ]);
      final Object? bytes = result['langs'];
      check(bytes).isA<Uint8List>();
      // Postcard encodes as varint count + per-string bytes
      check((bytes! as Uint8List).length).isGreaterThan(0);
    });

    test('group children are flattened', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const GroupSetting(
          title: 'Advanced',
          items: <SettingItem>[
            SwitchSetting(defaultValue: true, key: 'advanced'),
            SwitchSetting(defaultValue: false, key: 'debug'),
          ],
        ),
      ]);
      check(PostcardReader(result['advanced']! as Uint8List).readBool()).isTrue();
      check(PostcardReader(result['debug']! as Uint8List).readBool()).isFalse();
    });

    test('nested groups are fully flattened', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const GroupSetting(
          title: 'Outer',
          items: <SettingItem>[
            GroupSetting(
              title: 'Inner',
              items: <SettingItem>[SwitchSetting(defaultValue: true, key: 'deep')],
            ),
          ],
        ),
      ]);
      check(PostcardReader(result['deep']! as Uint8List).readBool()).isTrue();
    });

    test('settings without keys are skipped', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const SwitchSetting(defaultValue: true), // no key
        const UnknownSetting(type: 'button', title: 'Reset'),
      ]);
      check(result).isEmpty();
    });

    test('multiple settings produce all entries', () {
      final Map<String, Object> result = flattenSettingDefaults(<SettingItem>[
        const SwitchSetting(defaultValue: true, key: 'a'),
        const SwitchSetting(defaultValue: false, key: 'b'),
        const SegmentSetting(values: <String>[], titles: <String>[], defaultValue: 2, key: 'c'),
      ]);
      check(result).length.equals(3);
      check(PostcardReader(result['a']! as Uint8List).readBool()).isTrue();
      check(PostcardReader(result['b']! as Uint8List).readBool()).isFalse();
      check(PostcardReader(result['c']! as Uint8List).readSignedVarInt()).equals(2);
    });
  });
}
