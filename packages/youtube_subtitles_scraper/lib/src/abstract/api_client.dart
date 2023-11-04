import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_subtitles_scraper/src/models/download_progress.dart';

abstract class SubtitlesScraperApiClient {
  // a stream of a set of the progress value of the all scraped subtitles
  final _progressController = BehaviorSubject<List<SubtitlesDownloadProgress>>()
    ..add([]);

  // must not be used within this package
  Future<T> fetchUrl<T>(Uri url, {void Function(int, int)? onReceiveProgress});

  @mustCallSuper
  Future<String> fetchSubtitles({required Uri url}) async {
    final subtitlesId = const Uuid().v4();
    final progressList = _progressController.value;
    progressList.add(SubtitlesDownloadProgress(uuid: subtitlesId, value: 0));

    return await fetchUrl<String>(
      url,
      onReceiveProgress: (count, total) {
        if (total == -1) return;
        final progress = progressList.firstWhere(
          (progress) => progress.uuid == subtitlesId,
        );

        progressList[progressList.indexOf(progress)] =
            progress.copyWith(value: count / total);
        _progressController.add(progressList);
      },
    );
  }

  // stream of the progress of the currently scraped subtitles where 0.0 < value < 1.0
  @mustCallSuper
  Stream<double> get activeProgress =>
      _progressController.stream.asyncMap((progressList) {
        final activeProgressList = progressList.where(
          (progress) => progress.isActive,
        );
        return activeProgressList.fold(0.0,
                (previousValue, progress) => previousValue + progress.value) /
            activeProgressList.length;
      });

  @mustCallSuper
  Future<void> close() async => await _progressController.close();
}
