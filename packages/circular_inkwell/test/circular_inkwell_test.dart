import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CircularInkWell calls onTap when tapped',
      (WidgetTester tester) async {
    // Create a key for the CircularInkWell widget
    final circularInkWellKey = GlobalKey();

    // Variable to track whether onTap was called
    bool onTapCalled = false;

    // Build our app with CircularInkWell and set onTap callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularInkWell(
            key: circularInkWellKey,
            onTap: () {
              onTapCalled = true;
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );

    // Ensure the InkWell's child is visible
    expect(find.byKey(circularInkWellKey), findsOneWidget);

    // Tap on the CircularInkWell
    await tester.tap(find.byKey(circularInkWellKey));
    await tester.pump();

    // Ensure onTap was called
    expect(onTapCalled, isTrue);
  });

  testWidgets('CircularInkWell does not call onTap when disabled',
      (WidgetTester tester) async {
    // Create a key for the CircularInkWell widget
    final circularInkWellKey = GlobalKey();

    // Variable to track whether onTap was called
    bool onTapCalled = false;

    // Build our app with CircularInkWell and set onTap callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularInkWell(
            key: circularInkWellKey,
            onTap: () {
              onTapCalled = true;
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );

    // Ensure the InkWell's child is visible
    expect(find.byKey(circularInkWellKey), findsOneWidget);

    // Disable the CircularInkWell by setting onTap to null
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CircularInkWell(
            key: circularInkWellKey,
            onTap: null,
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );

    // Tap on the disabled CircularInkWell
    await tester.tap(find.byKey(circularInkWellKey));
    await tester.pump();

    // Ensure onTap was not called
    expect(onTapCalled, isFalse);
  });
}
