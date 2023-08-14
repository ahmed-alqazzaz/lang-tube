import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

const Duration cookieReloadDuration = Duration(seconds: 3);
bool x = false;

@immutable
class YoutubeCookiesManager {
  YoutubeCookiesManager({
    required this.uri,
    required this.cookiesUpdateCallBack,
  }) {
    synchronizeCookies();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (x) {
        _saveCookiesIntoStorage();
      }
    });
  }
  final Uri uri;
  final Future<void> Function() cookiesUpdateCallBack;

  // executes only when the viewer is created
  // update cookie and reload webview
  Future<void> synchronizeCookies() async {
    await _readCookiesFromStorage().then((value) async {
      // in case the app is not starting for the first time
      if (value != null) {
        await _injectCookiesIntoWebView(jsonDecode(value));
      }
      await Future.delayed(const Duration(seconds: 2));
      await _saveCookiesIntoStorage();
    });
    await cookiesUpdateCallBack();
  }

  Future<void> close() async {
    await _saveCookiesIntoStorage();
  }

  Future<String?> _readCookiesFromStorage() async {
    final documentDirectory = await _cookiesDirectory;
    final file = File('${documentDirectory.path}/cookies.json');
    if (file.existsSync()) {
      return file.readAsString();
    }
    return null;
  }

  Future<void> _injectCookiesIntoWebView(List<dynamic> cookies) async {
    for (final cookie in cookies) {
      // injected cookies into webview
      await CookieManager.instance().setCookie(
        url: uri,
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

  Future<void> _saveCookiesIntoStorage() async {
    final cookies = await CookieManager.instance().getCookies(url: uri);
    final documentDirectory = await _cookiesDirectory;
    await File('${documentDirectory.path}/cookies.json').writeAsString(
      jsonEncode(cookies.map((cookie) => cookie.toJson()).toList()),
    );
  }

  Future<Directory> get _cookiesDirectory async =>
      await getApplicationDocumentsDirectory();
}
