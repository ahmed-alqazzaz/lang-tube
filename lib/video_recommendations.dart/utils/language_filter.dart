import 'package:languages/languages.dart';
import 'package:youtube_scraper/youtube_scraper.dart';

extension LanguageFilter on List<ObservedVideo> {
  List<ObservedVideo> get filteredByTargetLanguage =>
      filteredByLanguage(Language.english());

  List<ObservedVideo> filteredByLanguage(Language language) =>
      where((item) => RegExp(language.pattern).hasMatch(item.title)).toList();
}
