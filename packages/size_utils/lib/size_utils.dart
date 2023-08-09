library size_utils;

import 'package:flutter/widgets.dart';

final screen = WidgetsBinding.instance.platformDispatcher.views.first;
Size getScreenSize() => Size(
      getScreenPhysicalSize().width / screen.devicePixelRatio,
      getScreenPhysicalSize().height / screen.devicePixelRatio,
    );

Size getScreenPhysicalSize() => screen.physicalSize;
