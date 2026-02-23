import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/pipeline/conversion_strategy.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('determineStrategy', () {
    test('same non-Tachi format returns Migration', () {
      check(determineStrategy(const Aidoku(), const Aidoku())).isA<Migration>();
      check(determineStrategy(const Paperback(), const Paperback()))
          .isA<Migration>();
      check(determineStrategy(const Tachimanga(), const Tachimanga()))
          .isA<Migration>();
      check(determineStrategy(const Mangayomi(), const Mangayomi()))
          .isA<Migration>();
    });

    test('same or cross Tachi fork returns Migration', () {
      check(determineStrategy(const Mihon(), const Mihon())).isA<Migration>();
      check(determineStrategy(const TachiSy(), const TachiSy()))
          .isA<Migration>();
      check(determineStrategy(const Mihon(), const TachiSy())).isA<Migration>();
      check(determineStrategy(const TachiJ2k(), const TachiYokai()))
          .isA<Migration>();
      check(determineStrategy(const TachiNeko(), const Mihon()))
          .isA<Migration>();
      check(determineStrategy(const TachiSy(), const TachiJ2k()))
          .isA<Migration>();
    });

    test('Tachi fork to Tachimanga returns DirectConversion', () {
      check(determineStrategy(const Mihon(), const Tachimanga()))
          .isA<DirectConversion>();
      check(determineStrategy(const TachiSy(), const Tachimanga()))
          .isA<DirectConversion>();
      check(determineStrategy(const TachiJ2k(), const Tachimanga()))
          .isA<DirectConversion>();
    });

    test('Tachimanga to Tachi fork returns DirectConversion', () {
      check(determineStrategy(const Tachimanga(), const Mihon()))
          .isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiSy()))
          .isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiJ2k()))
          .isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiYokai()))
          .isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiNeko()))
          .isA<DirectConversion>();
    });

    test('cross-format returns Migration', () {
      check(determineStrategy(const Aidoku(), const Mihon())).isA<Migration>();
      check(determineStrategy(const Paperback(), const Aidoku()))
          .isA<Migration>();
      check(determineStrategy(const Mihon(), const Aidoku())).isA<Migration>();
      check(determineStrategy(const Mangayomi(), const Paperback()))
          .isA<Migration>();
      check(determineStrategy(const Paperback(), const Mangayomi()))
          .isA<Migration>();
      check(determineStrategy(const Aidoku(), const Tachimanga()))
          .isA<Migration>();
      check(determineStrategy(const Mangayomi(), const Mihon()))
          .isA<Migration>();
    });
  });
}
