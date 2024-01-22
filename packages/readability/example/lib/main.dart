import 'package:flutter/material.dart';
import 'package:readability/readability.dart';

void main() {
  runApp(const ReadabilityExample());
}

class ReadabilityExample extends StatefulWidget {
  const ReadabilityExample({super.key});

  @override
  State<ReadabilityExample> createState() => _ReadabilityExampleState();
}

class _ReadabilityExampleState extends State<ReadabilityExample> {
  String sylablesCount = '';
  String? score;
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

                // score =
                //     (await calculateTextReadability(text: value)).toString();
                setState(() {});
              },
            ),
            SizedBox(height: 100),
            Text(score ?? '0'),
            Text(sylablesCount.toString()),
          ],
        ),
      ),
    );
  }
}
