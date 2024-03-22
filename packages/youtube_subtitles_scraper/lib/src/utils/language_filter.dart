import 'package:languages/languages.dart';

import '../models/source_captions.dart';

extension LanguageFilter on Iterable<SourceCaptions> {
  Future<List<SourceCaptions>> filteredByLanguage(
          List<Language> languages) async =>
      where((caption) => languages.contains(caption.info.language)).toList();
}
