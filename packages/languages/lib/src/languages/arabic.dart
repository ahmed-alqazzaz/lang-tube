// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../languages.dart';

@immutable
class Arabic extends Language {
  static const String _pattern =
      r'^[اأإءآبتثجحخدذرزسشصضطظعغفقكلمنهويىئؤة\s!@#$%^&*(),.?":{}|<>`~_-]+$';
  static const String _flagUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Flag_of_the_Arab_League.svg/800px-Flag_of_the_Arab_League.svg.png";
  const Arabic()
      : super(
          name: "Arabic",
          code: 'ar',
          pattern: _pattern,
          flagUrl: _flagUrl,
        );

  const Arabic._variant(String code, String name)
      : super(
          code: code,
          name: name,
          pattern: _pattern,
          flagUrl: _flagUrl,
        );

  @override
  List<Language> get variants => const [
        Arabic._variant('ar-SA', 'Arabic (Saudi Arabia)'),
        Arabic._variant('ar-IQ', 'Arabic (Iraq)'),
        Arabic._variant('ar-EG', 'Arabic (Egypt)'),
        Arabic._variant('ar-LY', 'Arabic (Libya)'),
        Arabic._variant('ar-DZ', 'Arabic (Algeria)'),
        Arabic._variant('ar-MA', 'Arabic (Morocco)'),
        Arabic._variant('ar-TN', 'Arabic (Tunisia)'),
        Arabic._variant('ar-OM', 'Arabic (Oman)'),
        Arabic._variant('ar-YE', 'Arabic (Yemen)'),
        Arabic._variant('ar-SY', 'Arabic (Syria)'),
        Arabic._variant('ar-JO', 'Arabic (Jordan)'),
        Arabic._variant('ar-LB', 'Arabic (Lebanon)'),
        Arabic._variant('ar-KW', 'Arabic (Kuwait)'),
        Arabic._variant('ar-AE', 'Arabic (United Arab Emirates)'),
        Arabic._variant('ar-BH', 'Arabic (Bahrain)'),
        Arabic._variant('ar-QA', 'Arabic (Qatar)'),
      ];
}
