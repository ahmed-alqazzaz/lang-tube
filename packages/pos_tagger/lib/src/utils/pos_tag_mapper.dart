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
      case "TO":
        return PosTag.preposition;
      case "CD":
        return PosTag.cardinalNumber;
      case "POS":
        return PosTag.possessiveEnding;
      case "WDT":
        return PosTag.whDeterminer;
      case "WP":
        return PosTag.whPronoun;
      case "FW":
        return PosTag.foreignWord;
      case "NNP":
        return PosTag.properNounSingular;
      case "NNPS":
        return PosTag.properNounPlural;
      case "MD":
        return PosTag.modal;
      case "LS":
        return PosTag.listItemMarker;
      case "PDT":
        return PosTag.predeterminer;
      case "SYM":
        return PosTag.symbol;
      default:
        throw UnimplementedError(tag);
    }
  }
}
