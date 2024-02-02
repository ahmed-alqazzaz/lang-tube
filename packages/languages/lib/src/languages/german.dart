part of '../languages.dart';

@immutable
class German extends Language {
  static const String _pattern =
      r'^[a-zA-Z0-9äöüß\s!@#$%^&*(),.?":{}|<>`~_-]+$';
  static const String _flagUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Flag_of_Germany.svg/800px-Flag_of_Germany.svg.png";

  const German()
      : super(
          code: 'de',
          name: "German",
          pattern: _pattern,
          flagUrl: _flagUrl,
        );

  const German._variant(String code, String name)
      : super(
          code: code,
          name: name,
          pattern: _pattern,
          flagUrl: _flagUrl,
        );
  @override
  List<Language> get variants => const [
        German._variant('de-DE', 'German (Germany)'),
        German._variant('de-AT', 'German (Austria)'),
        German._variant('de-CH', 'German (Switzerland)'),
        German._variant('de-LI', 'German (Liechtenstein)'),
        German._variant('de-LU', 'German (Luxembourg)'),
      ];
}
