import 'package:flutter/foundation.dart';

abstract class SubtitlesScraperApiClient {
  // must not be used within this package
  Future<T> fetchUrl<T>(Uri url, {void Function(int, int)? onReceiveProgress});

  // onPrgressUpdated is between 0.0 and 1.0
  @mustCallSuper
  Future<String> fetchSubtitles(
      {required Uri url, void Function(double)? onProgressUpdated}) async {
    int receivedPulses = 0;
    onProgressUpdated?.call(0.0);
    return await fetchUrl<String>(
      url,
      onReceiveProgress: (count, total) {
        receivedPulses++;
        onProgressUpdated?.call(receivedPulses / (receivedPulses + 2));
      },
    ).whenComplete(
      () => onProgressUpdated?.call(1.0),
    );
  }
}
