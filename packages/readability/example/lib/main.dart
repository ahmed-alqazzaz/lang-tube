import 'package:flutter/material.dart';
import 'package:readability/readability.dart';
import 'package:readability/rust_bridge/readability_score.dart';

void main() {
  runApp(const ReadabilityExample());
}

class ReadabilityExample extends StatefulWidget {
  const ReadabilityExample({super.key});

  @override
  State<ReadabilityExample> createState() => _ReadabilityExampleState();
}

class _ReadabilityExampleState extends State<ReadabilityExample> {
  int sylablesCount = 0;
  ReadbilityScore? score;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 200),
            TextField(
              onChanged: (value) async {
                sylablesCount = await countSyllables(text: value);
                score = await calculateTextReadability(text: value);
                setState(() {});
              },
            ),
            SizedBox(height: 100),
            Text(score.toString()),
            Text(sylablesCount.toString()),
          ],
        ),
      ),
    );
  }
}
