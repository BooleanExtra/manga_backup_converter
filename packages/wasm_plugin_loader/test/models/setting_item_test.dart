import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/models/setting_item.dart';

void main() {
  group('SettingItem.fromJson', () {
    test('switch/toggle type produces SwitchSetting with default=true', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'switch',
        'key': 'showNsfw',
        'default': true,
      });
      check(item).isA<SwitchSetting>()
        ..has((SwitchSetting s) => s.key, 'key').equals('showNsfw')
        ..has((SwitchSetting s) => s.defaultValue, 'defaultValue').isTrue();
    });

    test('toggle type is alias for switch', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'toggle',
        'key': 'adult',
        'default': false,
      });
      check(item).isA<SwitchSetting>().has((SwitchSetting s) => s.defaultValue, 'defaultValue').isFalse();
    });

    test('select type produces SelectSetting', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'select',
        'key': 'lang',
        'values': <String>['en', 'ja', 'ko'],
        'titles': <String>['English', 'Japanese', 'Korean'],
        'default': 'ja',
      });
      check(item).isA<SelectSetting>()
        ..has((SelectSetting s) => s.key, 'key').equals('lang')
        ..has((SelectSetting s) => s.values, 'values').deepEquals(<Object?>['en', 'ja', 'ko'])
        ..has((SelectSetting s) => s.defaultValue, 'defaultValue').equals('ja');
    });

    test('segment type produces SegmentSetting', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'segment',
        'key': 'rating',
        'values': <String>['safe', 'suggestive', 'erotica'],
        'titles': <String>['Safe', 'Suggestive', 'Erotica'],
        'default': 1,
      });
      check(item).isA<SegmentSetting>()
        ..has((SegmentSetting s) => s.key, 'key').equals('rating')
        ..has((SegmentSetting s) => s.defaultValue, 'defaultValue').equals(1);
    });

    test('multi-select type produces MultiSelectSetting', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'multi-select',
        'key': 'langs',
        'values': <String>['en', 'ja'],
        'default': <String>['en'],
      });
      check(item).isA<MultiSelectSetting>()
        ..has((MultiSelectSetting s) => s.key, 'key').equals('langs')
        ..has((MultiSelectSetting s) => s.defaultValue, 'defaultValue').deepEquals(<Object?>['en']);
    });

    test('stepper type produces StepperSetting', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'stepper',
        'key': 'limit',
        'minimumValue': 5,
        'maximumValue': 50,
        'stepValue': 5,
        'default': 20,
      });
      check(item).isA<StepperSetting>()
        ..has((StepperSetting s) => s.key, 'key').equals('limit')
        ..has((StepperSetting s) => s.defaultValue, 'defaultValue').equals(20.0);
    });

    test('text type produces TextSetting', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'text',
        'key': 'apiKey',
        'default': 'abc',
      });
      check(item).isA<TextSetting>()
        ..has((TextSetting s) => s.key, 'key').equals('apiKey')
        ..has((TextSetting s) => s.defaultValue, 'defaultValue').equals('abc');
    });

    test('group type produces GroupSetting with nested items', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'group',
        'title': 'Content',
        'items': <Map<String, Object>>[
          <String, Object>{'type': 'switch', 'key': 'nsfw', 'default': false},
        ],
      });
      check(item).isA<GroupSetting>()
        ..has((GroupSetting s) => s.title, 'title').equals('Content')
        ..has((GroupSetting s) => s.items, 'items').length.equals(1);
      check((item as GroupSetting).items[0]).isA<SwitchSetting>();
    });

    test('unknown type produces UnknownSetting', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{
        'type': 'button',
        'key': 'reset',
        'title': 'Reset',
      });
      check(item).isA<UnknownSetting>().has((UnknownSetting s) => s.type, 'type').equals('button');
    });

    test('missing type produces UnknownSetting with empty type', () {
      final SettingItem item = SettingItem.fromJson(<String, dynamic>{'key': 'x'});
      check(item).isA<UnknownSetting>();
    });
  });

  group('SettingItem.defaultEntry', () {
    test('SwitchSetting true → 1', () {
      const SwitchSetting item = SwitchSetting(defaultValue: true, key: 'nsfw');
      final ({String key, Object value})? entry = item.defaultEntry;
      check(entry).isNotNull();
      check(entry!.key).equals('nsfw');
      check(entry.value).equals(1);
    });

    test('SwitchSetting false → 0', () {
      const SwitchSetting item = SwitchSetting(defaultValue: false, key: 'safe');
      check(item.defaultEntry!.value).equals(0);
    });

    test('SwitchSetting without key → null', () {
      const SwitchSetting item = SwitchSetting(defaultValue: true);
      check(item.defaultEntry).isNull();
    });

    test('SelectSetting → index of defaultValue', () {
      const SelectSetting item = SelectSetting(
        values: <String>['en', 'ja', 'ko'],
        titles: <String>[],
        key: 'lang',
        defaultValue: 'ja',
      );
      check(item.defaultEntry!.value).equals(1);
    });

    test('SelectSetting with unknown default → 0', () {
      const SelectSetting item = SelectSetting(
        values: <String>['en', 'ja'],
        titles: <String>[],
        key: 'lang',
        defaultValue: 'fr',
      );
      check(item.defaultEntry!.value).equals(0);
    });

    test('SegmentSetting → defaultValue int', () {
      const SegmentSetting item = SegmentSetting(values: <String>[], titles: <String>[], defaultValue: 2, key: 'r');
      check(item.defaultEntry!.value).equals(2);
    });

    test('StepperSetting → rounded int', () {
      const StepperSetting item = StepperSetting(min: 0, max: 100, step: 1, defaultValue: 20.7, key: 'n');
      check(item.defaultEntry!.value).equals(21);
    });

    test('TextSetting → UTF-8 Uint8List', () {
      const TextSetting item = TextSetting(defaultValue: 'hello', key: 'api');
      final ({String key, Object value})? entry = item.defaultEntry;
      check(entry).isNotNull();
      check(entry!.value).isA<Uint8List>();
      check(utf8.decode(entry.value as Uint8List)).equals('hello');
    });

    test('GroupSetting itself → null (children flattened separately)', () {
      const GroupSetting item = GroupSetting(
        items: <SettingItem>[SwitchSetting(defaultValue: true, key: 'x')],
      );
      check(item.defaultEntry).isNull();
    });

    test('UnknownSetting → null', () {
      const UnknownSetting item = UnknownSetting(type: 'button', key: 'x');
      check(item.defaultEntry).isNull();
    });
  });

  group('flattenSettingDefaults', () {
    test('empty list → empty map', () {
      check(flattenSettingDefaults(<SettingItem>[])).isEmpty();
    });

    test('flattens top-level settings', () {
      final List<SwitchSetting> items = <SwitchSetting>[
        const SwitchSetting(defaultValue: true, key: 'a'),
        const SwitchSetting(defaultValue: false, key: 'b'),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result).deepEquals(<Object?, Object?>{'a': 1, 'b': 0});
    });

    test('recurses into GroupSetting', () {
      const List<GroupSetting> items = <GroupSetting>[
        GroupSetting(
          title: 'Content',
          items: <SettingItem>[
            SwitchSetting(defaultValue: true, key: 'nsfw'),
            SelectSetting(values: <String>['en', 'ja'], titles: <String>[], key: 'lang', defaultValue: 'ja'),
          ],
        ),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result['nsfw']).equals(1);
      check(result['lang']).equals(1);
    });

    test('recurses into PageSetting', () {
      const List<PageSetting> items = <PageSetting>[
        PageSetting(
          title: 'Advanced',
          items: <SettingItem>[TextSetting(defaultValue: 'abc', key: 'token')],
        ),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result['token']).isA<Uint8List>();
      check(utf8.decode(result['token']! as Uint8List)).equals('abc');
    });

    test('skips items without keys', () {
      const List<SettingItem> items = <SettingItem>[
        GroupSetting(title: 'G', items: <SettingItem>[]),
        UnknownSetting(type: 'button'),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result).isEmpty();
    });

    test('prefixes keys with sourceId when provided', () {
      const List<GroupSetting> items = <GroupSetting>[
        GroupSetting(
          title: 'Content',
          items: <SettingItem>[SwitchSetting(defaultValue: false, key: 'nsfw')],
        ),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items, sourceId: 'en.test');
      check(result.containsKey('en.test.nsfw')).isTrue();
      check(result.containsKey('nsfw')).isFalse();
      check(result['en.test.nsfw']).equals(0);
    });

    test('no prefix when sourceId is null', () {
      const List<SwitchSetting> items = <SwitchSetting>[SwitchSetting(defaultValue: true, key: 'x')];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result.containsKey('x')).isTrue();
    });
  });
}
