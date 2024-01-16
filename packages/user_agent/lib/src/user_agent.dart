import 'dart:math';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'popular_user_agents.dart';

final class UserAgentManager {
  static UserAgentManager get instance => _instance;
  static final _instance = UserAgentManager._sharedInstance();
  UserAgentManager._sharedInstance();

  bool isInitilized = false;

  Future<void> initilize() async {
    assert(!isInitilized, 'user agent manager is already initilized');
    isInitilized = true;
    return await FkUserAgent.init();
  }

  String get userAgent {
    assert(isInitilized, 'user agent manager is not initilized');
    return FkUserAgent.userAgent ?? _randomUserAgent;
  }

  String get webviewUserAgent {
    assert(isInitilized, 'user agent manager is not initilized');
    return FkUserAgent.webViewUserAgent ?? _randomUserAgent;
  }

  String get _randomUserAgent =>
      popularUserAgents[Random().nextInt(popularUserAgents.length)];
}
