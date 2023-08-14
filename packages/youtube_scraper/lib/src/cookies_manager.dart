import 'dart:convert';

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
    if (cookies != null) {
      return jsonDecode(cookies);
    }
    return null;
  }

  @mustCallSuper
  Future<void> close() async => await _saveCookies();
  static const Duration cookieInjectionDelay = Duration(seconds: 5);
}
