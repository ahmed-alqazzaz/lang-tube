import 'package:languages/languages.dart';

import '../models/source_captions.dart';

extension LanguageFilter on Iterable<SourceCaptions> {
  List<SourceCaptions> filteredByLanguage(List<Language> languages) =>
      where((caption) => languages.contains(caption.language)).toList();
}
