import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pos_tagger/pos_tagger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () async {
                  final timer = Stopwatch()..start();
                  log((await (await PosTagger.acquireEnglishModel())
                              .posTag("I like playing football"))
                          .toString() ??
                      "null");
                  log("lasted ${timer.elapsedMilliseconds}");
                },
                child: const Text("data"))
          ],
        ),
      ),
    );
  }
}
