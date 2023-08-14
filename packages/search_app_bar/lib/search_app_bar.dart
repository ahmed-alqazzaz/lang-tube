library search_app_bar;

import 'dart:async';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppbar({
    super.key,
    required this.onQueryUpdated,
    required this.searchFieldHint,
    required this.leading,
    required this.title,
    this.cursorColor,
  });

  final Widget leading;
  final String searchFieldHint;
  final String title;
  final void Function(String) onQueryUpdated;
  final Color? cursorColor;

  @override
  State<SearchAppbar> createState() => SearchAppbarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class SearchAppbarState extends State<SearchAppbar> {
  late final FocusNode _focusNode;
  late final StreamSubscription<bool> _keyboardSubscription;
  late final TextEditingController _textEditingController;

  bool _isSearching = false;
  @override
  void dispose() {
    _keyboardSubscription.cancel();
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _isSearching = _focusNode.hasFocus);
      });
    _textEditingController = TextEditingController()
      ..addListener(() => widget.onQueryUpdated(_textEditingController.text));
    _keyboardSubscription = KeyboardVisibilityController().onChange.listen(
          (event) => event ? null : _focusNode.unfocus(),
        );

    super.initState();
  }

  void disableSearch() => setState(() => _focusNode.unfocus());

  bool get isSearching => _isSearching;

  Widget? leading() {
    return _isSearching ? null : widget.leading;
  }

  Widget title() {
    return _isSearching
        ? searchField()
        : Text(
            widget.title,
          );
  }

  Widget action() {
    return AspectRatio(
      aspectRatio: 1,
      child: _isSearching
          ? CircularInkWell(
              child: const Icon(Icons.clear_sharp),
              onTap: () => _textEditingController.text.isEmpty
                  ? _focusNode.unfocus()
                  : _textEditingController.clear(),
            )
          : CircularInkWell(
              onTap: () => setState(() {
                _focusNode.requestFocus();
                _isSearching = true;
              }),
              child: const Icon(Icons.search_outlined),
            ),
    );
  }

  Widget searchField() {
    return TextField(
      focusNode: _focusNode,
      controller: _textEditingController,
      autofocus: true,
      autocorrect: false,
      textAlign: TextAlign.start,
      textAlignVertical: const TextAlignVertical(y: 1),
      cursorColor: widget.cursorColor,
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        hintText: widget.searchFieldHint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: AppBar(
        automaticallyImplyLeading: !_isSearching,
        leading: leading(),
        title: title(),
        actions: [action()],
      ),
      onWillPop: () async {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          return false;
        }
        return true;
      },
    );
  }
}
