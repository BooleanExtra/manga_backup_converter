import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:wasm_plugin_loader/src/models/language_info.dart';

void main() {
  group('LanguageInfo.fromJson', () {
    test('from String: code == value, isDefault == null', () {
      final LanguageInfo lang = LanguageInfo.fromJson('en');
      check(lang.code).equals('en');
      check(lang.value).equals('en');
      check(lang.isDefault).isNull();
    });

    test('from Map with all fields', () {
      final LanguageInfo lang = LanguageInfo.fromJson(<String, Object>{
        'code': 'ja',
        'value': 'japanese',
        'default': true,
      });
      check(lang.code).equals('ja');
      check(lang.value).equals('japanese');
      check(lang.isDefault).equals(true);
    });

    test('from Map with only code', () {
      final LanguageInfo lang = LanguageInfo.fromJson(<String, String>{'code': 'zh'});
      check(lang.code).equals('zh');
      check(lang.value).isNull();
      check(lang.isDefault).isNull();
    });

    test('from Map with default: false', () {
      final LanguageInfo lang = LanguageInfo.fromJson(<String, Object>{'code': 'ko', 'default': false});
      check(lang.isDefault).equals(false);
    });
  });

  group('LanguageInfo.effectiveValue', () {
    test('prefers value when set', () {
      const LanguageInfo lang = LanguageInfo(code: 'zh', value: 'zh-hans');
      check(lang.effectiveValue).equals('zh-hans');
    });

    test('falls back to code when value is null', () {
      const LanguageInfo lang = LanguageInfo(code: 'en');
      check(lang.effectiveValue).equals('en');
    });
  });
}
