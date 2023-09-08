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

  bool _areCookiesInjected = false;
  // executes only when the viewer is created
  // update cookie and reload webview
  Future<void> synchronizeCookies() async {
    await _retrieveCookies().then((value) async {
      // in case the app is not starting for the first time
      if (value != null) {
        await _injectCookiesIntoWebView(value);
        await Future.delayed(cookieInjectionDelay);
        _onCookiesInjected();
      }
      _areCookiesInjected = true;
      await _saveCookies();
    });
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

  Future<void> _saveCookies() async =>
      await CookieManager.instance().getCookies(url: _youtubeUrl).then(
        (cookies) async {
          if (_areCookiesInjected) {
            final oldCookies = await _retrieveCookies();
            if (oldCookies != null && oldCookies.length > cookies.length) {
              printRed("syncronizing cookies");
              return synchronizeCookies();
            }
            await _storageManager.saveCookies(
              cookies: jsonEncode(
                cookies.map((cookie) => cookie.toJson()).toList(),
              ),
            );
          }
        },
      );
  Future<List<dynamic>?> _retrieveCookies() async {
    final cookies = await _storageManager.retrieveCookies();
    if (cookies?.isNotEmpty == true) {
      return jsonDecode(cookies!);
    }
    return null;
  }

  @mustCallSuper
  Future<void> close() async => await _saveCookies();

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