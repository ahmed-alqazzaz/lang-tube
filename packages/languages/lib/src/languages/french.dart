part of '../languages.dart';

@immutable
class French extends Language {
  static const String _pattern =
      r'^[a-zA-Z0-9àâçéèêëîïôûùüÿñæœ\s!@#$%^&*(),.?":{}|<>`~_-]+$';
  static const String _flagUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/800px-Flag_of_France.svg.png";
  const French()
      : super(
          name: "French",
          code: 'fr',
          pattern: _pattern,
          flagUrl: _flagUrl,
        );

  const French._variant(String code, String name)
      : super(
          code: code,
          name: name,
          pattern: _pattern,
          flagUrl: _flagUrl,
        );

  @override
  List<Language> get variants => const [
        French._variant('fr-FR', 'French (France)'),
        French._variant('fr-CA', 'French (Canada)'),
        French._variant('fr-BE', 'French (Belgium)'),
        French._variant('fr-CH', 'French (Switzerland)'),
        French._variant('fr-LU', 'French (Luxembourg)'),
        French._variant('fr-MC', 'French (Monaco)'),
      ];
}
