library search_app_bar;

import 'dart:async';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';

class SearchAppbar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppbar({
    super.key,
    required this.searchFieldHint,
    this.leading,
    required this.title,
    this.toolbarHeight,
    this.actions,
    this.bottom,
    this.cursorColor,
    this.onChange,
  });

  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  final List<Widget>? actions;
  final String searchFieldHint;
  final String title;
  final Color? cursorColor;
  final void Function(String)? onChange;

  @override
  State<SearchAppbar> createState() => SearchAppbarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class SearchAppbarState extends State<SearchAppbar> {
  late String title = widget.title;
  late String searchFieldHint = widget.searchFieldHint;
  set setTitle(String newTitle) => setState(() => title = newTitle);
  set setSearchFieldHint(String newHint) =>
      setState(() => searchFieldHint = newHint);

  late final FocusNode _focusNode;
  late final TextEditingController _textEditingController;

  bool _isSearching = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          _isSearching = _focusNode.hasFocus;
          _textEditingController.clear();
        });
      });

    super.initState();
  }

  void disableSearch() => setState(() => _focusNode.unfocus());

  bool get isSearching => _isSearching;

  Widget? leading() {
    return _isSearching ? null : widget.leading;
  }

  List<Widget> get actions {
    final items = <Widget>[];
    if (!_isSearching && widget.actions != null) items.addAll(widget.actions!);
    items.add(
      _isSearching
          ? CircularInkWell(
              child: const Icon(Icons.clear_sharp),
              onTap: () => Timer(
                const Duration(milliseconds: 350),
                () => _textEditingController.text.isEmpty
                    ? _focusNode.unfocus()
                    : _textEditingController.clear(),
              ),
            )
          : CircularInkWell(
              onTap: () => setState(() {
                _focusNode.requestFocus();
                _isSearching = true;
              }),
              child: const Icon(Icons.search_outlined),
            ),
    );
    return items
        .map((item) => AspectRatio(aspectRatio: 1, child: item))
        .toList();
  }

  Widget searchField() {
    return TextField(
      focusNode: _focusNode,
      controller: _textEditingController,
      onChanged: widget.onChange,
      autofocus: true,
      autocorrect: false,
      textAlign: TextAlign.start,
      textAlignVertical: const TextAlignVertical(y: 1),
      cursorColor: widget.cursorColor,
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        hintText: searchFieldHint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: AppBar(
        automaticallyImplyLeading: !_isSearching,
        leading: leading(),
        title: _isSearching
            ? searchField()
            : Text(
                title,
              ),
        toolbarHeight: widget.toolbarHeight,
        bottom: widget.bottom,
        actions: actions,
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
