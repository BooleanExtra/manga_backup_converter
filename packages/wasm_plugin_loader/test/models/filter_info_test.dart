import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/models/filter.dart';
import 'package:wasm_plugin_loader/src/models/filter_info.dart';

void main() {
  group('FilterInfo.fromJson', () {
    test('check type', () {
      final fi = FilterInfo.fromJson({'type': 'check', 'name': 'Has chapters', 'default': true});
      check(fi.type).equals('check');
      check(fi.name).equals('Has chapters');
      check(fi.defaultValue).equals(true);
    });

    test('check type default false when omitted', () {
      final fi = FilterInfo.fromJson({'type': 'check', 'name': 'Foo'});
      check(fi.defaultValue).equals(false);
    });

    test('select type with options', () {
      final fi = FilterInfo.fromJson({
        'type': 'select',
        'name': 'Sort by',
        'values': ['relevance', 'latest', 'rating'],
        'default': 1,
      });
      check(fi.type).equals('select');
      check(fi.options).deepEquals(['relevance', 'latest', 'rating']);
      check(fi.defaultValue).equals(1);
    });

    test('sort type', () {
      final fi = FilterInfo.fromJson({'type': 'sort', 'name': 'Order', 'default': 2});
      check(fi.type).equals('sort');
      check(fi.defaultValue).equals(2);
    });

    test('group type with nested items', () {
      final fi = FilterInfo.fromJson({
        'type': 'group',
        'name': 'Content',
        'filters': [
          {'type': 'check', 'name': 'Safe', 'default': true},
        ],
      });
      check(fi.type).equals('group');
      check(fi.items).length.equals(1);
      check(fi.items[0].type).equals('check');
    });

    test('text type has no default', () {
      final fi = FilterInfo.fromJson({'type': 'text', 'name': 'Search'});
      check(fi.type).equals('text');
      check(fi.defaultValue).isNull();
    });

    test('canExclude and canAscend parsed', () {
      final fi = FilterInfo.fromJson({'type': 'sort', 'name': 'S', 'canExclude': true, 'canAscend': true});
      check(fi.canExclude).isTrue();
      check(fi.canAscend).isTrue();
    });
  });

  group('FilterInfo.toDefaultFilterValue', () {
    test('check → FilterValue with bool value', () {
      final fi = FilterInfo.fromJson({'type': 'check', 'name': 'NSFW', 'default': true});
      final fv = fi.toDefaultFilterValue();
      check(fv).isNotNull();
      check(fv!.type).equals(FilterType.check);
      check(fv.name).equals('NSFW');
      check(fv.value).equals(true);
    });

    test('check false → FilterValue false', () {
      final fi = FilterInfo.fromJson({'type': 'check', 'name': 'X', 'default': false});
      check(fi.toDefaultFilterValue()!.value).equals(false);
    });

    test('select → FilterValue with int index', () {
      final fi = FilterInfo.fromJson({'type': 'select', 'name': 'Sort', 'default': 2});
      final fv = fi.toDefaultFilterValue();
      check(fv).isNotNull();
      check(fv!.type).equals(FilterType.select);
      check(fv.value).equals(2);
    });

    test('sort → FilterValue with int index', () {
      final fi = FilterInfo.fromJson({'type': 'sort', 'name': 'Order', 'default': 1});
      final fv = fi.toDefaultFilterValue();
      check(fv).isNotNull();
      check(fv!.type).equals(FilterType.sort);
      check(fv.value).equals(1);
    });

    test('text → null (no meaningful default)', () {
      final fi = FilterInfo.fromJson({'type': 'text', 'name': 'Q'});
      check(fi.toDefaultFilterValue()).isNull();
    });

    test('group → null', () {
      final fi = FilterInfo.fromJson({'type': 'group', 'name': 'G'});
      check(fi.toDefaultFilterValue()).isNull();
    });

    test('check without name → null', () {
      const fi = FilterInfo(type: 'check', defaultValue: true);
      check(fi.toDefaultFilterValue()).isNull();
    });
  });
}
