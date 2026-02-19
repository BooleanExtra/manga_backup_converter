import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/models/setting_item.dart';

void main() {
  group('SettingItem.fromJson', () {
    test('switch/toggle type produces SwitchSetting with default=true', () {
      final item = SettingItem.fromJson({'type': 'switch', 'key': 'showNsfw', 'default': true});
      check(item).isA<SwitchSetting>()
        ..has((s) => s.key, 'key').equals('showNsfw')
        ..has((s) => s.defaultValue, 'defaultValue').isTrue();
    });

    test('toggle type is alias for switch', () {
      final item = SettingItem.fromJson({'type': 'toggle', 'key': 'adult', 'default': false});
      check(item).isA<SwitchSetting>().has((s) => s.defaultValue, 'defaultValue').isFalse();
    });

    test('select type produces SelectSetting', () {
      final item = SettingItem.fromJson({
        'type': 'select',
        'key': 'lang',
        'values': ['en', 'ja', 'ko'],
        'titles': ['English', 'Japanese', 'Korean'],
        'default': 'ja',
      });
      check(item).isA<SelectSetting>()
        ..has((s) => s.key, 'key').equals('lang')
        ..has((s) => s.values, 'values').deepEquals(['en', 'ja', 'ko'])
        ..has((s) => s.defaultValue, 'defaultValue').equals('ja');
    });

    test('segment type produces SegmentSetting', () {
      final item = SettingItem.fromJson({
        'type': 'segment',
        'key': 'rating',
        'values': ['safe', 'suggestive', 'erotica'],
        'titles': ['Safe', 'Suggestive', 'Erotica'],
        'default': 1,
      });
      check(item).isA<SegmentSetting>()
        ..has((s) => s.key, 'key').equals('rating')
        ..has((s) => s.defaultValue, 'defaultValue').equals(1);
    });

    test('multi-select type produces MultiSelectSetting', () {
      final item = SettingItem.fromJson({
        'type': 'multi-select',
        'key': 'langs',
        'values': ['en', 'ja'],
        'default': ['en'],
      });
      check(item).isA<MultiSelectSetting>()
        ..has((s) => s.key, 'key').equals('langs')
        ..has((s) => s.defaultValue, 'defaultValue').deepEquals(['en']);
    });

    test('stepper type produces StepperSetting', () {
      final item = SettingItem.fromJson({
        'type': 'stepper',
        'key': 'limit',
        'minimumValue': 5,
        'maximumValue': 50,
        'stepValue': 5,
        'default': 20,
      });
      check(item).isA<StepperSetting>()
        ..has((s) => s.key, 'key').equals('limit')
        ..has((s) => s.defaultValue, 'defaultValue').equals(20.0);
    });

    test('text type produces TextSetting', () {
      final item = SettingItem.fromJson({'type': 'text', 'key': 'apiKey', 'default': 'abc'});
      check(item).isA<TextSetting>()
        ..has((s) => s.key, 'key').equals('apiKey')
        ..has((s) => s.defaultValue, 'defaultValue').equals('abc');
    });

    test('group type produces GroupSetting with nested items', () {
      final item = SettingItem.fromJson({
        'type': 'group',
        'title': 'Content',
        'items': [
          {'type': 'switch', 'key': 'nsfw', 'default': false},
        ],
      });
      check(item).isA<GroupSetting>()
        ..has((s) => s.title, 'title').equals('Content')
        ..has((s) => s.items, 'items').length.equals(1);
      check((item as GroupSetting).items[0]).isA<SwitchSetting>();
    });

    test('unknown type produces UnknownSetting', () {
      final item = SettingItem.fromJson({'type': 'button', 'key': 'reset', 'title': 'Reset'});
      check(item).isA<UnknownSetting>().has((s) => s.type, 'type').equals('button');
    });

    test('missing type produces UnknownSetting with empty type', () {
      final item = SettingItem.fromJson({'key': 'x'});
      check(item).isA<UnknownSetting>();
    });
  });

  group('SettingItem.defaultEntry', () {
    test('SwitchSetting true → 1', () {
      const item = SwitchSetting(defaultValue: true, key: 'nsfw');
      final entry = item.defaultEntry;
      check(entry).isNotNull();
      check(entry!.key).equals('nsfw');
      check(entry.value).equals(1);
    });

    test('SwitchSetting false → 0', () {
      const item = SwitchSetting(defaultValue: false, key: 'safe');
      check(item.defaultEntry!.value).equals(0);
    });

    test('SwitchSetting without key → null', () {
      const item = SwitchSetting(defaultValue: true);
      check(item.defaultEntry).isNull();
    });

    test('SelectSetting → index of defaultValue', () {
      const item = SelectSetting(
        values: ['en', 'ja', 'ko'],
        titles: [],
        key: 'lang',
        defaultValue: 'ja',
      );
      check(item.defaultEntry!.value).equals(1);
    });

    test('SelectSetting with unknown default → 0', () {
      const item = SelectSetting(values: ['en', 'ja'], titles: [], key: 'lang', defaultValue: 'fr');
      check(item.defaultEntry!.value).equals(0);
    });

    test('SegmentSetting → defaultValue int', () {
      const item = SegmentSetting(values: [], titles: [], defaultValue: 2, key: 'r');
      check(item.defaultEntry!.value).equals(2);
    });

    test('StepperSetting → rounded int', () {
      const item = StepperSetting(min: 0, max: 100, step: 1, defaultValue: 20.7, key: 'n');
      check(item.defaultEntry!.value).equals(21);
    });

    test('TextSetting → UTF-8 Uint8List', () {
      const item = TextSetting(defaultValue: 'hello', key: 'api');
      final entry = item.defaultEntry;
      check(entry).isNotNull();
      check(entry!.value).isA<Uint8List>();
      check(utf8.decode(entry.value as Uint8List)).equals('hello');
    });

    test('GroupSetting itself → null (children flattened separately)', () {
      const item = GroupSetting(
        items: [SwitchSetting(defaultValue: true, key: 'x')],
      );
      check(item.defaultEntry).isNull();
    });

    test('UnknownSetting → null', () {
      const item = UnknownSetting(type: 'button', key: 'x');
      check(item.defaultEntry).isNull();
    });
  });

  group('flattenSettingDefaults', () {
    test('empty list → empty map', () {
      check(flattenSettingDefaults([])).isEmpty();
    });

    test('flattens top-level settings', () {
      final items = [
        const SwitchSetting(defaultValue: true, key: 'a'),
        const SwitchSetting(defaultValue: false, key: 'b'),
      ];
      final result = flattenSettingDefaults(items);
      check(result).deepEquals({'a': 1, 'b': 0});
    });

    test('recurses into GroupSetting', () {
      const items = [
        GroupSetting(
          title: 'Content',
          items: [
            SwitchSetting(defaultValue: true, key: 'nsfw'),
            SelectSetting(values: ['en', 'ja'], titles: [], key: 'lang', defaultValue: 'ja'),
          ],
        ),
      ];
      final result = flattenSettingDefaults(items);
      check(result['nsfw']).equals(1);
      check(result['lang']).equals(1);
    });

    test('recurses into PageSetting', () {
      const items = [
        PageSetting(
          title: 'Advanced',
          items: [TextSetting(defaultValue: 'abc', key: 'token')],
        ),
      ];
      final result = flattenSettingDefaults(items);
      check(result['token']).isA<Uint8List>();
      check(utf8.decode(result['token']! as Uint8List)).equals('abc');
    });

    test('skips items without keys', () {
      const items = [
        GroupSetting(title: 'G', items: []),
        UnknownSetting(type: 'button'),
      ];
      final result = flattenSettingDefaults(items);
      check(result).isEmpty();
    });

    test('prefixes keys with sourceId when provided', () {
      const items = [
        GroupSetting(
          title: 'Content',
          items: [SwitchSetting(defaultValue: false, key: 'nsfw')],
        ),
      ];
      final result = flattenSettingDefaults(items, sourceId: 'en.test');
      check(result.containsKey('en.test.nsfw')).isTrue();
      check(result.containsKey('nsfw')).isFalse();
      check(result['en.test.nsfw']).equals(0);
    });

    test('no prefix when sourceId is null', () {
      const items = [SwitchSetting(defaultValue: true, key: 'x')];
      final result = flattenSettingDefaults(items);
      check(result.containsKey('x')).isTrue();
    });
  });
}
