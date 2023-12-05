import 'dart:async';
import 'package:flutter/foundation.dart';

extension ValueNotifierTransformer<T> on ValueListenable<T> {
  /// Creates a new ValueNotifier with each data event of this ValueNotifier
  /// asynchronously mapped to a new event.
  ///
  /// This acts like [map], except that [convert] may return a [Future],
  /// and in that case, this method waits for that future to complete before
  /// updating the result ValueNotifier.

  Future<ValueListenable<R>> asyncMap<R>(
      FutureOr<R> Function(T event) mapper) async {
    final resultNotifier = ValueNotifier<R>(await mapper(value));

    void updateResult(T value) async {
      final mappedValue = await mapper(value);
      resultNotifier.value = mappedValue;
    }

    // Initial update
    updateResult(value);

    // Listen to changes in the source ValueNotifier
    addListener(() => updateResult(value));
    return resultNotifier;
  }

  ValueListenable<R> syncMap<R>(R Function(T event) mapper) {
    final resultNotifier = ValueNotifier<R>(mapper(value));
    Stream.fromIterable([]).asyncMap((event) => null);
    void updateResult(T value) {
      final mappedValue = mapper(value);
      resultNotifier.value = mappedValue;
    }

    // Initial update
    updateResult(value);

    // Listen to changes in the source ValueNotifier
    addListener(() => updateResult(value));
    return resultNotifier;
  }

  ValueNotifier<T> where(bool Function(T event) predicate) {
    final resultNotifier = ValueNotifier<T>(value);

    void updateResult(T value) {
      if (predicate(value)) {
        resultNotifier.value = value;
      }
    }

    // Initial update
    updateResult(value);

    // Listen to changes in the source ValueNotifier
    addListener(() => updateResult(value));
    return resultNotifier;
  }

  ValueListenable<T> get unique {
    final resultNotifier = ValueNotifier<T>(value);
    T previousValue = value;

    void updateResult(T value) {
      if (value != previousValue) {
        resultNotifier.value = value;
        previousValue = value;
      }
    }

    // Initial update
    updateResult(value);

    // Listen to changes in the source ValueNotifier
    addListener(() => updateResult(value));
    return resultNotifier;
  }

  ValueListenable<T> delayWhen(
      Duration delayDuration, bool Function(T event) shouldDelay) {
    final resultNotifier = ValueNotifier<T>(value);

    void updateResult(T value) async {
      if (shouldDelay(value)) {
        await Future.delayed(delayDuration);
      }
      resultNotifier.value = value;
    }

    // Initial update
    updateResult(value);

    // Listen to changes in the source ValueNotifier
    addListener(() => updateResult(value));
    return resultNotifier;
  }

  ValueListenable<T> delayFirst(Duration duration) {
    assert(duration >= Duration.zero, 'Duration must be non-negative.');

    final resultNotifier = ValueNotifier<T>(value);
    final timer = Stopwatch()..start();

    void updateResult(T value) {
      if (timer.elapsed < duration) {
        Timer(duration - timer.elapsed, () {
          resultNotifier.value = value;
        });
      } else {
        resultNotifier.value = value;
      }
    }

    // Initial update
    updateResult(value);

    // Listen to changes in the source ValueNotifier
    addListener(() => updateResult(value));
    return resultNotifier;
  }
}
