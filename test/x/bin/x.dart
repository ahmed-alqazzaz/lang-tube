
class YoutubeRecommendationsManager {
  factory YoutubeRecommendationsManager.newInstance() => _instance;
  factory YoutubeRecommendationsManager.sharedInstance() => _sharedInstance;

  static final _sharedInstance = _instance;
  static YoutubeRecommendationsManager get _instance =>
      YoutubeRecommendationsManager._internal();
  YoutubeRecommendationsManager._internal();
  int v = 0;
  x() {
    v = 1;
  }
}

void main(List<String> arguments) {
  YoutubeRecommendationsManager.sharedInstance().x();

  print(YoutubeRecommendationsManager.sharedInstance().v);
  print((YoutubeRecommendationsManager.newInstance()..x()).v);
}
