import 'dart:async';

import 'package:flutter/foundation.dart';

extension ValueNotifierTransformer<T> on ValueNotifier<T> {
  /// Creates a new ValueNotifier with each data event of this ValueNotifier
  /// asynchronously mapped to a new event.
  ///
  /// This acts like [map], except that [convert] may return a [Future],
  /// and in that case, this method waits for that future to complete before
  /// updating the result ValueNotifier.
  Future<ValueNotifier<R>> asyncMap<R>(
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
}
