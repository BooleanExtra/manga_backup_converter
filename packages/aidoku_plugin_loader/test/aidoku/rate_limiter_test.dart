import 'package:aidoku_plugin_loader/src/aidoku/libs/host_store.dart';
import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('RateLimitConfig.fromWasm', () {
    test('unit 0 (seconds)', () {
      final config = RateLimitConfig.fromWasm(10, 60, 0);
      check(config.permits).equals(10);
      check(config.periodMs).equals(60000);
    });

    test('unit 1 (minutes)', () {
      final config = RateLimitConfig.fromWasm(5, 2, 1);
      check(config.permits).equals(5);
      check(config.periodMs).equals(120000);
    });

    test('unit 2 (hours)', () {
      final config = RateLimitConfig.fromWasm(100, 1, 2);
      check(config.permits).equals(100);
      check(config.periodMs).equals(3600000);
    });

    test('unknown unit defaults to seconds', () {
      final config = RateLimitConfig.fromWasm(3, 10, 99);
      check(config.periodMs).equals(10000);
    });
  });

  group('RateLimiter', () {
    test('allows requests under the limit', () {
      final limiter = RateLimiter(
        const RateLimitConfig(permits: 3, periodMs: 10000),
      );
      check(limiter.waitDuration(nowMs: 1000)).equals(Duration.zero);
      limiter.recordRequest(nowMs: 1000);
      check(limiter.waitDuration(nowMs: 1001)).equals(Duration.zero);
      limiter.recordRequest(nowMs: 1001);
      check(limiter.waitDuration(nowMs: 1002)).equals(Duration.zero);
    });

    test('delays when at the limit', () {
      final limiter = RateLimiter(
        const RateLimitConfig(permits: 2, periodMs: 10000),
      );
      limiter.recordRequest(nowMs: 1000);
      limiter.recordRequest(nowMs: 2000);
      // At limit — next request should wait until oldest (1000) + period (10000) = 11000
      final Duration wait = limiter.waitDuration(nowMs: 3000);
      check(wait).equals(const Duration(milliseconds: 8000));
    });

    test('allows after window expires', () {
      final limiter = RateLimiter(
        const RateLimitConfig(permits: 2, periodMs: 5000),
      );
      limiter.recordRequest(nowMs: 1000);
      limiter.recordRequest(nowMs: 2000);
      // After the window: oldest (1000) + period (5000) = 6000, now = 6001
      check(limiter.waitDuration(nowMs: 6001)).equals(Duration.zero);
    });

    test('sliding window prunes expired entries', () {
      final limiter = RateLimiter(
        const RateLimitConfig(permits: 2, periodMs: 5000),
      );
      limiter.recordRequest(nowMs: 1000);
      limiter.recordRequest(nowMs: 2000);
      // First request expires at 6000, record new one after that
      limiter.recordRequest(nowMs: 6001);
      // Window now has [2000, 6001] — still at limit; wait until 2000+5000=7000
      check(limiter.waitDuration(nowMs: 6002)).equals(const Duration(milliseconds: 998));
      // After second entry also expires, slot opens up
      check(limiter.waitDuration(nowMs: 7001)).equals(Duration.zero);
    });

    test('returns zero delay when wait would be non-positive', () {
      final limiter = RateLimiter(
        const RateLimitConfig(permits: 1, periodMs: 1000),
      );
      limiter.recordRequest(nowMs: 1000);
      // Exactly at expiry boundary
      check(limiter.waitDuration(nowMs: 2000)).equals(Duration.zero);
    });
  });
}
