enum VideoQuality {
  tiny144p,
  small240p,
  medium360p,
  large480p,
  hd720p,
  hd1080p,
  hd1440p,
}

const qualityToString = {
  VideoQuality.tiny144p: "144p",
  VideoQuality.small240p: "240p",
  VideoQuality.medium360p: "360p",
  VideoQuality.large480p: "480p",
  VideoQuality.hd720p: "720p",
  VideoQuality.hd1080p: "1080p",
  VideoQuality.hd1440p: "1440p",
};
final Map<String, VideoQuality> stringToQuality =
    qualityToString.map((key, value) => MapEntry(value, key));
