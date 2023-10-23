import 'dart:convert';
import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'cookies_storage_manager.dart';

class YoutubeCookiesManager {
  YoutubeCookiesManager({
    required CookiesStorageManager storageManager,
    required Uri youtubeUrl,
    required VoidCallback onCookiesInjected,
  })  : _storageManager = storageManager,
        _youtubeUrl = youtubeUrl,
        _onCookiesInjected = onCookiesInjected {
    synchronizeCookies();
  }

  final CookiesStorageManager _storageManager;
  final Uri _youtubeUrl;
  final VoidCallback _onCookiesInjected;

  // update cookie and reload webview in case stored cookies exists, and save browser cookie
  Future<void> synchronizeCookies() async {
    final storedCookies = await _retrieveCookiesStorage();
    // in case the app is not starting for the first time, and cookies are not inject
    if (storedCookies != null) {
      await _injectCookiesIntoWebView(storedCookies);
      await Future.delayed(cookieInjectionDelay);
      _onCookiesInjected();
    }
    await _saveCookiesIntoStorage();
  }

  Future<void> _saveCookiesIntoStorage() async {
    final storedCookies = await _retrieveCookiesStorage();
    final currentCookies = await _retrieveCookiesFromWebView();
    if (currentCookies.length < (storedCookies?.length ?? 0)) {
      printPurple("""cookies length is less than stored cookies""");
      return synchronizeCookies();
    }
    await _storageManager.saveCookies(
      cookies: jsonEncode(
        currentCookies.map((cookie) => cookie.toJson()).toList(),
      ),
    );
  }

  Future<List<Cookie>> _retrieveCookiesFromWebView() async =>
      await CookieManager.instance().getCookies(url: _youtubeUrl);
  Future<List<dynamic>?> _retrieveCookiesStorage() async {
    final cookies = await _storageManager.retrieveCookies();
    return cookies?.isNotEmpty == true ? jsonDecode(cookies!) : null;
  }

  Future<void> _injectCookiesIntoWebView(List<dynamic> cookies) async {
    for (final cookie in cookies) {
      await CookieManager.instance().setCookie(
        url: _youtubeUrl,
        name: cookie['name'],
        value: cookie['value'],
        expiresDate: cookie['expiresDate'],
        domain: cookie['domain'],
        path: cookie['path'] ?? '/',
        isSecure: cookie['isSecure'],
        isHttpOnly: cookie['isHttpOnly'],
      );
    }
  }

  @mustCallSuper
  Future<void> close() async => await _saveCookiesIntoStorage();

  static const Duration cookieInjectionDelay = Duration(seconds: 10);
}


// IMPORTANT:
// on hot reload, teh inappwebview loses its cookies for few seconds

// STORED COOKIES:

/*
  [{name: GPS, value: 1, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
  {name: YSC, value: cW_5c_eMWLU, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
  {name: VISITOR_INFO1_LIVE, value: ItMi1UD1Rew, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
  {name: VISITOR_PRIVACY_METADATA, value: CgJJURICGgA%3D, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
  {name: PREF, value: tz=Asia.Baghdad, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null}, 
  {name: ST-qhmp3k, value: csn=MC44MDg5ODU3MTY3NTQyNTg1&itct=CAYQ_FoiEwiJ4qT7xeaAAxVOEfEFHT1DAaoyCmctaGlnaC1yZWNaD0ZFd2hhdF90b193YXRjaJoBBhCOHhieAQ%3D%3D, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null
*/

// NEW COOKIES
/* 
[
{name: GPS, value: 1, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
{name: YSC, value: cW_5c_eMWLU, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
{name: VISITOR_INFO1_LIVE, value: ItMi1UD1Rew, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
{name: VISITOR_PRIVACY_METADATA, value: CgJJURICGgA%3D, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null},
{name: PREF, value: tz=Asia.Baghdad, expiresDate: null, isSessionOnly: null, domain: null, sameSite: null, isSecure: null, isHttpOnly: null, path: null}
]
*/