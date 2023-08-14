import 'dart:async';

abstract class CookiesStorageManager {
  FutureOr<void> saveCookies({required String cookies});
  FutureOr<String?> retrieveCookies();
}
