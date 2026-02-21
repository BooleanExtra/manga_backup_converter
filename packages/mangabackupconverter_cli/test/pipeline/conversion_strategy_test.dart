import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/pipeline/backup_format.dart';
import 'package:mangabackupconverter_cli/src/pipeline/conversion_strategy.dart';
import 'package:test/scaffolding.dart' hide Skip;

void main() {
  group('determineStrategy', () {
    test('same format returns Skip', () {
      check(determineStrategy(const Aidoku(), const Aidoku())).isA<Skip>();
      check(determineStrategy(const Paperback(), const Paperback())).isA<Skip>();
      check(determineStrategy(const Tachimanga(), const Tachimanga())).isA<Skip>();
      check(determineStrategy(const Mangayomi(), const Mangayomi())).isA<Skip>();
    });

    test('Tachi fork to Tachi fork returns Skip', () {
      check(determineStrategy(const Mihon(), const TachiSy())).isA<Skip>();
      check(determineStrategy(const TachiJ2k(), const TachiYokai())).isA<Skip>();
      check(determineStrategy(const TachiNeko(), const Mihon())).isA<Skip>();
      check(determineStrategy(const TachiSy(), const TachiJ2k())).isA<Skip>();
    });

    test('Tachi fork to Tachimanga returns Skip', () {
      check(determineStrategy(const Mihon(), const Tachimanga())).isA<Skip>();
      check(determineStrategy(const TachiSy(), const Tachimanga())).isA<Skip>();
      check(determineStrategy(const TachiJ2k(), const Tachimanga())).isA<Skip>();
    });

    test('Tachimanga to Tachi fork returns DirectConversion', () {
      check(determineStrategy(const Tachimanga(), const Mihon())).isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiSy())).isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiJ2k())).isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiYokai())).isA<DirectConversion>();
      check(determineStrategy(const Tachimanga(), const TachiNeko())).isA<DirectConversion>();
    });

    test('cross-format returns Migration', () {
      check(determineStrategy(const Aidoku(), const Mihon())).isA<Migration>();
      check(determineStrategy(const Paperback(), const Aidoku())).isA<Migration>();
      check(determineStrategy(const Mihon(), const Aidoku())).isA<Migration>();
      check(determineStrategy(const Mangayomi(), const Paperback())).isA<Migration>();
      check(determineStrategy(const Paperback(), const Mangayomi())).isA<Migration>();
      check(determineStrategy(const Aidoku(), const Tachimanga())).isA<Migration>();
      check(determineStrategy(const Mangayomi(), const Mihon())).isA<Migration>();
    });
  });
}
