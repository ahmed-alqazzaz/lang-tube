part of '../languages.dart';

@immutable
class English extends Language {
  static const String _pattern = r'^[a-zA-Z0-9\s!@#$%^&*(),.?":{}|<>`~_-]+$';
  static const String _flagUrl =
      "https://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/800px-Flag_of_the_United_States.svg.png";

  const English()
      : super(
          name: "English",
          code: 'en',
          pattern: _pattern,
          flagUrl: _flagUrl,
        );

  const English._variant(String code, String name)
      : super(
          code: code,
          name: name,
          pattern: _pattern,
          flagUrl: _flagUrl,
        );

  @override
  List<Language> get variants => const [
        English._variant('en-US', 'English (United States)'),
        English._variant('en-GB', 'English (United Kingdom)'),
        English._variant('en-AU', 'English (Australia)'),
        English._variant('en-CA', 'English (Canada)'),
        English._variant('en-NZ', 'English (New Zealand)'),
        English._variant('en-IE', 'English (Ireland)'),
        English._variant('en-ZA', 'English (South Africa)'),
        English._variant('en-IN', 'English (India)'),
      ];
}
