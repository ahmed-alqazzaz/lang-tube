import '../../../models/subtitles/captions_type.dart';
import '../entity/subtitles_info.dart';

typedef InfoFilter = bool Function(DatabaseSubtitlesInfo info);

extension DatabaseInfoMatcher on DatabaseSubtitlesInfo {
  bool matches({String? videoId, String? language, CaptionsType? type}) =>
      matchesVideoId(videoId) && matchesLanguage(language) && matchesType(type);

  bool matchesLanguage(String? language) =>
      language != null ? this.language == language : true;

  bool matchesType(CaptionsType? type) =>
      type != null ? captionsType == type : true;

  bool matchesVideoId(String? videoId) =>
      videoId != null ? this.videoId == videoId : true;
}
