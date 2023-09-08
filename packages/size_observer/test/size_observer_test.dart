import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/size_observer.dart';

void main() {
  testWidgets('SizeObserver notifies on size change',
      (WidgetTester tester) async {
    Size? notifiedSize;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SizeObserver(
                onChange: (size) {
                  notifiedSize = size;
                },
                child: Container(
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Initial pump
    await tester.pump();

    // The SizeObserver should have been laid out once.
    expect(notifiedSize, isNotNull);
    expect(notifiedSize!.width, 100.0);
    expect(notifiedSize!.height, 100.0);

    // Change the child widget size
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SizeObserver(
                onChange: (size) {
                  notifiedSize = size;
                },
                child: Container(
                  width: 150,
                  height: 200,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Trigger a new layout
    await tester.pump();

    // The SizeObserver should have been laid out again with the new size.
    expect(notifiedSize!.width, 150.0);
    expect(notifiedSize!.height, 200.0);
  });
}
