import 'dart:developer';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lang_tube/browser/enums/popup_menu_items.dart';
import 'package:value_notifier_transformer/value_notifier_transformer.dart';

import '../main.dart';
import 'providers/suggestions_List_provider/provider.dart';
import 'providers/suggestions_overlay_provider/provider.dart';

class BrowserAppbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const BrowserAppbar({
    super.key,
    required this.currentUrl,
    required this.onSubmit,
    required this.onHomeTabbed,
    this.bottom,
  });

  final String currentUrl;
  final VoidCallback onHomeTabbed;
  final PreferredSizeWidget? bottom;
  final void Function(String query) onSubmit;
  @override
  ConsumerState<BrowserAppbar> createState() => BrowserAppbarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class BrowserAppbarState extends ConsumerState<BrowserAppbar>
    with SingleTickerProviderStateMixin {
  static const double _actionsWidth = 50;
  static const Duration _searchAnimationDuration = Duration(milliseconds: 250);

  late final AnimationController _animationController;
  late final TextEditingController _textEditingController;
  late final CurvedAnimation _animation;

  late final _suggestionsListNotifier =
      ref.read(browserSugesstionsListProvider.notifier);
  late final _suggestionsOverlayNotifier =
      ref.read(browserSuggestionsOverlayProvider.notifier);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _searchAnimationDuration,
      value: 1,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    )..addListener(() {
        if (_animation.value == 0) {
          _suggestionsOverlayNotifier.show(context);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _textEditingController.value = TextEditingValue(
              text: widget.currentUrl,
              selection: TextSelection(
                baseOffset: 0,
                extentOffset: widget.currentUrl.length,
              ),
            );
          });
        } else {
          _suggestionsOverlayNotifier.hide();
        }
      });
    _textEditingController = TextEditingController(text: widget.currentUrl)
      ..addListener(
        () => _suggestionsListNotifier.updateQuery(
          _textEditingController.text == widget.currentUrl
              ? ''
              : _textEditingController.text,
        ),
      );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.dispose();
    _textEditingController.dispose();

    super.dispose();
  }

  void toggleSearch() => _animationController.isCompleted
      ? _animationController.reverse()
      : _animationController.forward();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (_animation.value == 0) {
            toggleSearch();
            return false;
          }
          return true;
        },
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // HOME ACTION
                    _actionBuilder(
                      animation: _animation.value,
                      child: const Icon(Icons.home_outlined, size: 30),
                      onTap: widget.onHomeTabbed,
                    ),

                    // SEARCH FIELD/ BAR
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _animation.value == 1 ? toggleSearch() : null,
                        child: Container(
                          height: (widget.preferredSize.height * 0.9) -
                              _animation.value * 10,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: _animation.value == 0
                              ? _searchFieldBuilder()
                              : _searchBarBuilder(),
                        ),
                      ),
                    ),

                    // SHARE ACTION
                    _actionBuilder(
                      child: const Icon(Icons.share_sharp, size: 23),
                      animation: _animation.value,
                      onTap: () {},
                    ),
                    // TAB ACTION
                    _actionBuilder(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: _tabIconBuilder(tabNumber: 1),
                      ),
                      animation: _animation.value,
                      onTap: () {},
                    ),
                    // SETTINGS ACTION
                    _actionBuilder(
                      child: _popupMenuBuilder(),
                      animation: _animation.value,
                      onTap: () {},
                    ),
                  ],
                );
              },
            ),
            if (widget.bottom != null) widget.bottom!,
          ],
        ),
      ),
    );
  }

  Widget _searchFieldBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder<bool>(
          valueListenable: _textEditingController
              .syncMap((event) => event.text != widget.currentUrl)
              .unique,
          builder: (context, isTextModified, _) {
            return ValueListenableBuilder<bool>(
                valueListenable: _textEditingController
                    .syncMap((event) => event.text == '')
                    .unique,
                builder: (context, isTextEmpty, _) {
                  return TextField(
                    controller: _textEditingController,
                    autofocus: true,
                    onSubmitted: (query) {
                      toggleSearch();
                      widget.onSubmit(query);
                    },
                    autocorrect: false,
                    keyboardType: TextInputType.url,
                    textAlign: TextAlign.start,
                    textAlignVertical: const TextAlignVertical(y: 0.5),
                    cursorOpacityAnimates: true,
                    onChanged: (value) {
                      // the controller is not sensetive to empty strings
                      // so we must notify it directly
                      if (value == "") {
                        _textEditingController.value =
                            _textEditingController.value.copyWith(text: "");
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Search or type web address',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        suffixIconColor: LangTube.tmp,
                        prefixIconColor: LangTube.tmp,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isTextModified
                                ? Image.asset(
                                    'assets/google_icon.png',
                                    width: 20,
                                  )
                                : const FaIcon(
                                    FontAwesomeIcons.globe,
                                    size: 20,
                                  ),
                          ],
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isTextEmpty
                                ? _actionBuilder(
                                    child: const Icon(Icons.mic, size: 23),
                                    animation: (1 - _animation.value).abs(),
                                    onTap: () {},
                                  )
                                : _actionBuilder(
                                    child: const Icon(Icons.close, size: 23),
                                    animation: (1 - _animation.value).abs(),
                                    onTap: () {
                                      _textEditingController.clear();
                                    },
                                  )
                          ],
                        )),
                  );
                });
          }),
    );
  }

  Widget _popupMenuBuilder() {
    return PopupMenuButton<BrowserPopUpMenuItems>(
      iconSize: 25,
      onSelected: print,
      itemBuilder: (context) => [
        for (var item in BrowserPopUpMenuItems.values)
          PopupMenuItem(
            value: item,
            child: Text(item.name()),
          )
      ],
    );
  }

  Widget _tabIconBuilder({required int tabNumber}) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: LangTube.tmp,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            tabNumber.toString(),
            style: const TextStyle(
              color: LangTube.tmp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBuilder({
    required Widget child,
    required double animation,
    required VoidCallback onTap,
  }) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: animation,
          child: SizedBox(
            width: animation * _actionsWidth,
            child: IconButton(
              splashRadius: 20,
              icon: child,
              onPressed: onTap,
            ),
          ),
        ),
      ),
    );
  }

  Container _searchBarBuilder() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.lock_sharp,
                    size: 18,
                  ),
                ),
              ),
              TextSpan(
                text: widget.currentUrl,
                style: const TextStyle(
                  color: LangTube.tmp,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
