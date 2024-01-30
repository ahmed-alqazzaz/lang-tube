// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:collection';
import 'package:pos_tagger/src/models/pos_tag_entry.dart';

import 'pos_tagger_impl.dart';

abstract class PosTagger {
  static final Map<String, PosTagger> _models = HashMap();

  static FutureOr<PosTagger> acquireEnglishModel() async {
    const modelPath = "en";
    if (!_models.containsKey(modelPath)) {
      _models[modelPath] = await PosTaggerImpl.loadModel(modelPath);
    }
    return _models[modelPath]!;
  }

  Future<List<PosTagEntry>> posTag(String text);
}
