import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_agent/user_agent.dart';

final userAgentProvider = FutureProvider<UserAgent>(
  (ref) async => await UserAgent.initlize(),
);
