import 'dart:typed_data';

import 'package:aidoku_plugin_loader/src/codec/postcard_reader.dart';
import 'package:aidoku_plugin_loader/src/models/setting_item.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('SettingItem.fromJson', () {
    test('switch/toggle type produces SwitchSetting with default=true', () {
      final item = SettingItem.fromJson(<String, dynamic>{
        'type': 'switch',
        'key': 'showNsfw',
        'default': true,
      });
      check(item).isA<SwitchSetting>()
        ..has((SwitchSetting s) => s.key, 'key').equals('showNsfw')
        ..has((SwitchSetting s) => s.defaultValue, 'defaultValue').isTrue();
    });

    test('toggle type is alias for switch', () {
      final item = SettingItem.fromJson(<String, dynamic>{
        'type': 'toggle',
        'key': 'adult',
        'default': false,
      });
      check(item).isA<SwitchSetting>().has((SwitchSetting s) => s.defaultValue, 'defaultValue').isFalse();
    });

    test('select type produces SelectSetting', () {
      final item = SettingItem.fromJson(<String, dynamic>{
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
      final item = SettingItem.fromJson(<String, dynamic>{
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
      final item = SettingItem.fromJson(<String, dynamic>{
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
      final item = SettingItem.fromJson(<String, dynamic>{
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
      final item = SettingItem.fromJson(<String, dynamic>{
        'type': 'text',
        'key': 'apiKey',
        'default': 'abc',
      });
      check(item).isA<TextSetting>()
        ..has((TextSetting s) => s.key, 'key').equals('apiKey')
        ..has((TextSetting s) => s.defaultValue, 'defaultValue').equals('abc');
    });

    test('group type produces GroupSetting with nested items', () {
      final item = SettingItem.fromJson(<String, dynamic>{
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
      final item = SettingItem.fromJson(<String, dynamic>{
        'type': 'button',
        'key': 'reset',
        'title': 'Reset',
      });
      check(item).isA<UnknownSetting>().has((UnknownSetting s) => s.type, 'type').equals('button');
    });

    test('missing type produces UnknownSetting with empty type', () {
      final item = SettingItem.fromJson(<String, dynamic>{'key': 'x'});
      check(item).isA<UnknownSetting>();
    });
  });

  group('SettingItem.defaultEntry', () {
    test('SwitchSetting true → postcard bool true', () {
      const item = SwitchSetting(defaultValue: true, key: 'nsfw');
      final ({String key, Object value})? entry = item.defaultEntry;
      check(entry).isNotNull();
      if (entry == null) throw Exception('entry is null');
      check(entry.key).equals('nsfw');
      check(entry.value).isA<Uint8List>();
      check(PostcardReader(entry.value as Uint8List).readBool()).isTrue();
    });

    test('SwitchSetting false → postcard bool false', () {
      const item = SwitchSetting(defaultValue: false, key: 'safe');
      final Object? value = item.defaultEntry?.value;
      check(value).isA<Uint8List>();
      check(PostcardReader(value! as Uint8List).readBool()).isFalse();
    });

    test('SwitchSetting without key → null', () {
      const item = SwitchSetting(defaultValue: true);
      check(item.defaultEntry).isNull();
    });

    test('SelectSetting → postcard zigzag index of defaultValue', () {
      const item = SelectSetting(
        values: <String>['en', 'ja', 'ko'],
        titles: <String>[],
        key: 'lang',
        defaultValue: 'ja',
      );
      final Object? value = item.defaultEntry?.value;
      check(value).isA<Uint8List>();
      check(PostcardReader(value! as Uint8List).readSignedVarInt()).equals(1);
    });

    test('SelectSetting with unknown default → postcard zigzag 0', () {
      const item = SelectSetting(
        values: <String>['en', 'ja'],
        titles: <String>[],
        key: 'lang',
        defaultValue: 'fr',
      );
      final Object? value = item.defaultEntry?.value;
      check(value).isA<Uint8List>();
      check(PostcardReader(value! as Uint8List).readSignedVarInt()).equals(0);
    });

    test('SegmentSetting → postcard zigzag defaultValue', () {
      const item = SegmentSetting(values: <String>[], titles: <String>[], defaultValue: 2, key: 'r');
      final Object? value = item.defaultEntry?.value;
      check(value).isA<Uint8List>();
      check(PostcardReader(value! as Uint8List).readSignedVarInt()).equals(2);
    });

    test('StepperSetting → postcard zigzag rounded int', () {
      const item = StepperSetting(min: 0, max: 100, step: 1, defaultValue: 20.7, key: 'n');
      final Object? value = item.defaultEntry?.value;
      check(value).isA<Uint8List>();
      check(PostcardReader(value! as Uint8List).readSignedVarInt()).equals(21);
    });

    test('TextSetting → postcard string', () {
      const item = TextSetting(defaultValue: 'hello', key: 'api');
      final ({String key, Object value})? entry = item.defaultEntry;
      check(entry).isNotNull();
      if (entry == null) throw Exception('entry is null');
      check(entry.value).isA<Uint8List>();
      check(PostcardReader(entry.value as Uint8List).readString()).equals('hello');
    });

    test('GroupSetting itself → null (children flattened separately)', () {
      const item = GroupSetting(
        items: <SettingItem>[SwitchSetting(defaultValue: true, key: 'x')],
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
      check(flattenSettingDefaults(<SettingItem>[])).isEmpty();
    });

    test('flattens top-level settings', () {
      final items = <SwitchSetting>[
        const SwitchSetting(defaultValue: true, key: 'a'),
        const SwitchSetting(defaultValue: false, key: 'b'),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result).length.equals(2);
      check(PostcardReader(result['a']! as Uint8List).readBool()).isTrue();
      check(PostcardReader(result['b']! as Uint8List).readBool()).isFalse();
    });

    test('recurses into GroupSetting', () {
      const items = <GroupSetting>[
        GroupSetting(
          title: 'Content',
          items: <SettingItem>[
            SwitchSetting(defaultValue: true, key: 'nsfw'),
            SelectSetting(values: <String>['en', 'ja'], titles: <String>[], key: 'lang', defaultValue: 'ja'),
          ],
        ),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(PostcardReader(result['nsfw']! as Uint8List).readBool()).isTrue();
      check(PostcardReader(result['lang']! as Uint8List).readSignedVarInt()).equals(1);
    });

    test('recurses into PageSetting', () {
      const items = <PageSetting>[
        PageSetting(
          title: 'Advanced',
          items: <SettingItem>[TextSetting(defaultValue: 'abc', key: 'token')],
        ),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result['token']).isA<Uint8List>();
      check(PostcardReader(result['token']! as Uint8List).readString()).equals('abc');
    });

    test('skips items without keys', () {
      const items = <SettingItem>[
        GroupSetting(title: 'G', items: <SettingItem>[]),
        UnknownSetting(type: 'button'),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result).isEmpty();
    });

    test('prefixes keys with sourceId when provided', () {
      const items = <GroupSetting>[
        GroupSetting(
          title: 'Content',
          items: <SettingItem>[SwitchSetting(defaultValue: false, key: 'nsfw')],
        ),
      ];
      final Map<String, Object> result = flattenSettingDefaults(items, sourceId: 'en.test');
      check(result.containsKey('en.test.nsfw')).isTrue();
      check(result.containsKey('nsfw')).isFalse();
      check(PostcardReader(result['en.test.nsfw']! as Uint8List).readBool()).isFalse();
    });

    test('no prefix when sourceId is null', () {
      const items = <SwitchSetting>[SwitchSetting(defaultValue: true, key: 'x')];
      final Map<String, Object> result = flattenSettingDefaults(items);
      check(result.containsKey('x')).isTrue();
    });
  });
}
