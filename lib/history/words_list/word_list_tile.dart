import 'package:flutter/material.dart';

class WordListTile extends StatelessWidget {
  const WordListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.media,
    required this.onPressed,
    required this.onActionsMenuTapped,
  });
  static const BorderRadius _border = BorderRadius.vertical(
    top: Radius.circular(10),
    bottom: Radius.circular(5),
  );
  static const double _horizaontalGap = 20;
  static const double _actionMenuButtonSize = 30;
  final String title;
  final String subtitle;
  final Widget media;
  final void Function() onPressed;
  final void Function() onActionsMenuTapped;

  Widget _cardBuilder({required Widget child}) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: _border,
      ),
      color: Colors.white,
      elevation: 0,
      child: ClipRRect(
        borderRadius: _border,
        child: child,
      ),
    );
  }

  IconButton _actionMenuButton() {
    return IconButton(
      onPressed: onActionsMenuTapped,
      icon: const Icon(Icons.more_vert_sharp, size: _actionMenuButtonSize),
      splashRadius: _horizaontalGap,
    );
  }

  Widget _titleBuilder() {
    return Builder(builder: (context) {
      return Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      );
    });
  }

  Widget _subtitleBuilder() {
    return Builder(builder: (context) {
      return Text(
        subtitle,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.titleSmall?.color?.withOpacity(0.6),
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawMaterialButton(
          onPressed: onPressed,
          child: _cardBuilder(
            child: Row(
              children: [
                media,
                const SizedBox(width: _horizaontalGap),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.1),
                    _titleBuilder(),
                    SizedBox(height: constraints.maxHeight * 0.1),
                    _subtitleBuilder(),
                    SizedBox(height: constraints.maxHeight * 0.2),
                  ],
                ),
                const Expanded(child: SizedBox()),
                _actionMenuButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
