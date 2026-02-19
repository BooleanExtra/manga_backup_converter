import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/models/language_info.dart';

void main() {
  group('LanguageInfo.fromJson', () {
    test('from String: code == value, isDefault == null', () {
      final lang = LanguageInfo.fromJson('en');
      check(lang.code).equals('en');
      check(lang.value).equals('en');
      check(lang.isDefault).isNull();
    });

    test('from Map with all fields', () {
      final lang = LanguageInfo.fromJson({
        'code': 'ja',
        'value': 'japanese',
        'default': true,
      });
      check(lang.code).equals('ja');
      check(lang.value).equals('japanese');
      check(lang.isDefault).equals(true);
    });

    test('from Map with only code', () {
      final lang = LanguageInfo.fromJson({'code': 'zh'});
      check(lang.code).equals('zh');
      check(lang.value).isNull();
      check(lang.isDefault).isNull();
    });

    test('from Map with default: false', () {
      final lang = LanguageInfo.fromJson({'code': 'ko', 'default': false});
      check(lang.isDefault).equals(false);
    });
  });

  group('LanguageInfo.effectiveValue', () {
    test('prefers value when set', () {
      const lang = LanguageInfo(code: 'zh', value: 'zh-hans');
      check(lang.effectiveValue).equals('zh-hans');
    });

    test('falls back to code when value is null', () {
      const lang = LanguageInfo(code: 'en');
      check(lang.effectiveValue).equals('en');
    });
  });
}
