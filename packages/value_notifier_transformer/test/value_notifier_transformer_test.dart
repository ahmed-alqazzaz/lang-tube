import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:value_notifier_transformer/src/transformer.dart';

void main() {
  test('Async Map Value Notifier Extension Test', () async {
    // Create a ValueNotifier with an initial value of 5
    final valueNotifier = ValueNotifier<int>(5);

    // Create an async-mapped ValueNotifier
    final mappedNotifier = await valueNotifier.asyncMap((event) async {
      // Simulate an asynchronous operation
      await Future.delayed(const Duration(milliseconds: 500));
      return event * 2; // Double the input value
    });

    // Define a callback function for when the mappedNotifier changes
    void onMappedValueChange() {
      if (kDebugMode) {
        print('Mapped Value Changed: ${mappedNotifier.value}');
      }
    }

    // Add the listener to the mappedNotifier
    mappedNotifier.addListener(onMappedValueChange);

    // Wait for the async update to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // The mappedNotifier should now have the updated value (5 * 2 = 10)
    expect(mappedNotifier.value, equals(10));

    // Change the source ValueNotifier's value to trigger a new update
    valueNotifier.value = 8;

    // Wait for the async update to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // The mappedNotifier should now have the updated value (8 * 2 = 16)
    expect(mappedNotifier.value, equals(16));

    // Change the source ValueNotifier's value to trigger a new update
    valueNotifier.value = 16;

    // Wait for the async update to complete
    await Future.delayed(const Duration(milliseconds: 500));

    // The mappedNotifier should now have the updated value (8 * 2 = 16)
    expect(mappedNotifier.value, equals(32));
    // Remove the listener to avoid memory leaks in the test
    mappedNotifier.removeListener(onMappedValueChange);
  });
}
