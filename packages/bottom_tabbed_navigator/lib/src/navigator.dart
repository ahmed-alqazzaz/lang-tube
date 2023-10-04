import 'package:bottom_tabbed_navigator/src/keep_alive_wrapper.dart';
import 'package:flutter/material.dart';

import 'tab_navigation_item.dart';

class TabbedNavigator extends StatefulWidget {
  const TabbedNavigator(
      {super.key, required this.items, this.keepAlive = false})
      : assert(items.length >= 2 && items.length <= 5);
  final List<TabNavigationItem> items;
  final bool keepAlive;
  @override
  State<TabbedNavigator> createState() => _TabbedNavigatorState();
}

class _TabbedNavigatorState extends State<TabbedNavigator> {
  late final ValueNotifier<int> _indexNotifier;
  late final PageController _controller;
  bool _isUserScrolling = false;

  @override
  void initState() {
    _controller = PageController();
    _indexNotifier = ValueNotifier<int>(0)
      ..addListener(
        () {
          _isUserScrolling = false;
          _controller.jumpToPage(_indexNotifier.value);
        },
      );
    super.initState();
  }

  @override
  void dispose() {
    _indexNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabbedNavigatorPageController._(
      pageController: _controller,
      child: Scaffold(
        body: GestureDetector(
          onHorizontalDragUpdate: (details) => _isUserScrolling = true,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            onPageChanged: (index) {
              if (_isUserScrolling) _indexNotifier.value = index;
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) => KeepAliveWrapper(
              wantToKeepAlive: widget.keepAlive,
              child: widget.items[index].page,
            ),
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<int>(
          valueListenable: _indexNotifier,
          builder: (context, index, _) {
            return BottomNavigationBar(
              onTap: (value) => _indexNotifier.value = value,
              currentIndex: index,
              items:
                  widget.items.map((e) => e.bottomNavigationBarItem).toList(),
            );
          },
        ),
      ),
    );
  }
}

class TabbedNavigatorPageController extends InheritedWidget {
  final PageController _pageController;

  const TabbedNavigatorPageController._({
    Key? key,
    required PageController pageController,
    required Widget child,
  })  : _pageController = pageController,
        super(key: key, child: child);

  static PageController? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<TabbedNavigatorPageController>()
      ?._pageController;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
