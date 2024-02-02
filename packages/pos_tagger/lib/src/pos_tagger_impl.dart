import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos_tagger/src/utils/pos_tag_mapper.dart';

import 'method_channel/pos_tagger_platform_interface.dart';
import 'models/pos_tag_entry.dart';
import 'pos_tagger_interface.dart';

@immutable
class PosTaggerImpl extends PosTagger {
  final String modelPath;
  PosTaggerImpl._({required this.modelPath});

  @override
  Future<List<PosTagEntry>> posTag(String text) async {
    final tagEntries = <PosTagEntry>[];
    final response =
        await PosTaggerPlatform.getInstance(modelPath).posTag(text);
    log(response.toString());
    if (response == null) return tagEntries;
    final rawTags = jsonDecode(response) as List<dynamic>;
    for (var entry in rawTags) {
      tagEntries.add(
        PosTagEntry(
            word: entry[0],
            tag: PosTagMapper.fromRawTag(entry[1]),
            probability: double.parse(entry[2])),
      );
    }
    return tagEntries;
  }

  static Future<PosTagger> loadModel(String langCode) async {
    assert(_models.containsKey(langCode));
    final cachePath = await _generateCachePath(langCode);
    if (!File(cachePath).existsSync()) {
      await Dio().downloadUri(_models[langCode]!, cachePath);
    }
    return PosTaggerImpl._(modelPath: cachePath);
  }

  static Future<String> _generateCachePath(String langCode) async {
    return await getApplicationDocumentsDirectory().then(
      (dir) => '${dir.path}/$langCode.bin',
    );
  }

  static final Map<String, Uri> _models = HashMap.from({
    "en": Uri.parse(
      "https://opennlp.sourceforge.net/models-1.5/en-pos-maxent.bin",
    )
  });
}
