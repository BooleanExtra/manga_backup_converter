import 'package:checks/checks.dart';
import 'package:mangabackupconverter_cli/src/common/aidoku_date_time_mapper.dart';
import 'package:mangabackupconverter_cli/src/common/seconds_epoc_date_time_mapper.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('AidokuDateTimeMapper', () {
    const mapper = AidokuDateTimeMapper();

    test('decode from num treats value as seconds since epoch', () {
      // 1700000000 seconds = 2023-11-14T22:13:20.000Z
      final DateTime result = mapper.decode(1700000000);
      check(result).equals(
        DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000),
      );
    });

    test('decode from num 0 returns Unix epoch', () {
      final DateTime result = mapper.decode(0);
      check(result).equals(DateTime.fromMillisecondsSinceEpoch(0));
    });

    test('decode from String parses ISO 8601', () {
      final DateTime result = mapper.decode('2023-11-14T22:13:20.000Z');
      check(result).equals(DateTime.utc(2023, 11, 14, 22, 13, 20));
    });

    test('decode from DateTime returns the same DateTime', () {
      final dt = DateTime.utc(2024, 6, 15, 12, 30);
      final DateTime result = mapper.decode(dt);
      check(result).equals(dt);
    });

    test('encode returns the DateTime itself', () {
      final dt = DateTime.utc(2024);
      final dynamic result = mapper.encode(dt);
      check(result).isA<DateTime>().equals(dt);
    });
  });

  group('SecondsEpochDateTimeMapper', () {
    const mapper = SecondsEpochDateTimeMapper();

    test('decode converts seconds to DateTime', () {
      final DateTime result = mapper.decode(1700000000);
      check(result).equals(
        DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000),
      );
    });

    test('encode converts DateTime to seconds', () {
      final dt = DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000);
      final dynamic result = mapper.encode(dt);
      check(result).isA<double>().isCloseTo(1700000000, 0.001);
    });

    test('round-trip preserves DateTime to second precision', () {
      final original = DateTime.fromMillisecondsSinceEpoch(1700000000 * 1000);
      final dynamic encoded = mapper.encode(original);
      final DateTime decoded = mapper.decode(encoded as num);
      check(decoded).equals(original);
    });
  });
}
