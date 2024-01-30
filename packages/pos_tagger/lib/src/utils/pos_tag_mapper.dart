import '../models/pos_tag.dart';

extension PosTagMapper on PosTag {
  static PosTag fromRawTag(String tag) {
    switch (tag) {
      case "PRP":
        return PosTag.personalPronoun;
      case "IN":
        return PosTag.preposition;
      case "VBG":
        return PosTag.verbGerund;
      case "NN":
        return PosTag.noun;
      case "VB":
        return PosTag.verbBaseForm;
      case "VBD":
        return PosTag.verbPastTense;
      case "VBP":
        return PosTag.verbNonThirdPersonSingularPresent;
      case "VBZ":
        return PosTag.verbThirdPersonSingularPresent;
      case "VBN":
        return PosTag.verbPastParticiple;
      case "JJ":
        return PosTag.adjective;
      case "RB":
        return PosTag.adverb;
      case "CC":
        return PosTag.conjunction;
      case "UH":
        return PosTag.interjection;
      case "DT":
        return PosTag.determiner;
      case "NNS":
        return PosTag.pluralNoun;
      default:
        throw UnimplementedError(tag);
    }
  }
}
