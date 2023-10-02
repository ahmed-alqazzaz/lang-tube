import 'package:flutter/material.dart';

class TabNavigationItem {
  final Widget page;
  final BottomNavigationBarItem bottomNavigationBarItem;
  const TabNavigationItem({
    required this.page,
    required this.bottomNavigationBarItem,
  });
}
