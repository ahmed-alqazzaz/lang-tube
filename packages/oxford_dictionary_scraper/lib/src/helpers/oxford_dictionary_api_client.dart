import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../exceptions.dart';

@immutable
class OxfordDictionaryApiClient {
  OxfordDictionaryApiClient({
    required String userAgent,
  }) : client = HttpClient()
          ..connectionTimeout = _connectionTimeout
          ..maxConnectionsPerHost = _maxConnectionsPerHost
          ..userAgent = userAgent;

  final HttpClient client;

  static const Duration _connectionTimeout = Duration(seconds: 5);
  static const int _maxConnectionsPerHost = 10;
  // Base URL for the Oxford Dictionary API
  static const String _oxfordDictionaryUrl =
      "https://www.oxfordlearnersdictionaries.com/definition/english/";

  Future<String?> fetchUrl(final String url) async {
    try {
      final uri = Uri.parse(url);

      // Use client.getUrl() to create a GET request with the constructed URL
      final request = await client.openUrl("GET", uri);
      final response = await request.close();

      // If response has a 200 status code, return the response body
      if (response.statusCode == 200) {
        return await response.transform(utf8.decoder).join();
      }
      return null;
    } on HttpException {
      throw const OxfordDictionaryBlockedRequestException();
    } on SocketException {
      throw const WordLoadingException();
    } catch (_) {
      throw const OxfordDictionaryScraperUnknownException();
    }
  }

  Future<String?> fetchWord(final String word) async =>
      fetchUrl(_oxfordDictionaryUrl + word);
}
