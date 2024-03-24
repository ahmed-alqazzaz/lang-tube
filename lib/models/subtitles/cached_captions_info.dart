import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';

import '../../crud/subtitles_cache_manager/entity/subtitles_info.dart';
import 'captions_type.dart';

final class CachedCaptionsInfo extends CaptionsInfo {
  final CaptionsType type;
  const CachedCaptionsInfo({
    required super.videoId,
    required this.type,
    required super.language,
  }) : super(isAutoGenerated: type == CaptionsType.youTubeAutoGenerated);

  const CachedCaptionsInfo.userUploaded({
    required super.videoId,
    required super.language,
  })  : type = CaptionsType.userUploaded,
        super(isAutoGenerated: false);

  CachedCaptionsInfo.fromDatabaseSourceInfo(DatabaseSubtitlesInfo info)
      : type = info.captionsType,
        super(
          videoId: info.videoId,
          language: Language.fromName(info.language),
          isAutoGenerated:
              info.captionsType == CaptionsType.youTubeAutoGenerated,
        );
}
