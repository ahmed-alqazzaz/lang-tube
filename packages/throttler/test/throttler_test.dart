import 'package:flutter_test/flutter_test.dart';
import 'package:throttler/throttler.dart';

void main() {
  group('Throttler', () {
    test('should execute only the last call', () async {
      final throttler = Throttler();
      final durations = <Duration>[
        const Duration(milliseconds: 200),
        const Duration(milliseconds: 100),
        const Duration(milliseconds: 300),
      ];
      final calls = <int>[];

      void callback(int callIndex) {
        calls.add(callIndex);
      }

      for (var i = 0; i < durations.length; i++) {
        throttler.throttle(durations[i], () => callback(i));
      }

      // Wait for the maximum duration to ensure all timer callbacks have been executed.
      await Future.delayed(durations.reduce((a, b) => a + b), () {
        // The last call (index 2) should be the only one executed.
        expect(calls, [2]);
      });
    });

    test('should cancel throttling', () {
      final throttler = Throttler();
      final durations = <Duration>[
        const Duration(milliseconds: 200),
        const Duration(milliseconds: 100),
        const Duration(milliseconds: 300),
      ];
      final calls = <int>[];

      void callback(int callIndex) {
        calls.add(callIndex);
      }

      for (var i = 0; i < durations.length; i++) {
        throttler.throttle(durations[i], () => callback(i));
      }

      // Cancel the throttler before any callbacks are executed.
      throttler.cancel();

      // Wait for a short duration to ensure that no timer callbacks have executed.
      Future.delayed(const Duration(milliseconds: 500), () {
        // No callbacks should have been executed.
        expect(calls, isEmpty);
      });
    });
    test('should reset count after rate limit duration', () async {
      const rateLimit = CallbackRateLimit(
        maxCount: 3,
        duration: Duration(seconds: 1),
        breakDuration: Duration(seconds: 1),
      );

      final throttler = Throttler(rateLimit: rateLimit);
      final calls = <int>[];

      void callback(int callIndex) {
        calls.add(callIndex);
      }

      for (var i = 0; i < 5; i++) {
        throttler.throttle(
            const Duration(milliseconds: 100), () => callback(i));
      }

      // Wait for the rate limit duration to ensure all timer callbacks have been executed.
      await Future.delayed(rateLimit.duration, () async {
        expect(calls, []);
      });

      // Call throttle again after the rate limit duration has passed.
      for (var i = 5; i < 16; i++) {
        throttler.throttle(
            const Duration(milliseconds: 100), () => callback(i));
        await Future.delayed(const Duration(milliseconds: 110));
      }

      // Wait for another rate limit duration to ensure all timer callbacks have been executed.
      await Future.delayed(rateLimit.duration, () async {
        // The next maxCount calls should have been executed.
        expect(calls, [5, 6, 7, 8]);
      });
      calls.clear();
      for (var i = 5; i < 15; i++) {
        throttler.throttle(
            const Duration(milliseconds: 400), () => callback(i));
        await Future.delayed(const Duration(milliseconds: 400));
      }

      await Future.delayed(rateLimit.duration, () async {
        // The next maxCount calls should have been executed.
        expect(calls, [5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
      });
    });
  });
}
