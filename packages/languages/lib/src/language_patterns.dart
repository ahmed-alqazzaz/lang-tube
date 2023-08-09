sealed class LanguagePatterns {
  const LanguagePatterns._();
  static const String english = r'^[a-zA-Z0-9\s!@#$%^&*(),.?":{}|<>`~_-]+$';
  static const String german = r'^[a-zA-Z0-9äöüß\s!@#$%^&*(),.?":{}|<>`~_-]+$';
  static const String french =
      r'^[a-zA-Z0-9àâçéèêëîïôûùüÿñæœ\s!@#$%^&*(),.?":{}|<>`~_-]+$';
  static const String arabic =
      r'^[اأإءآبتثجحخدذرزسشصضطظعغفقكلمنهويىئؤة\s!@#$%^&*(),.?":{}|<>`~_-]+$';
}
