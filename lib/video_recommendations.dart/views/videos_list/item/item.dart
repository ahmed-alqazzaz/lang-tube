import 'package:flashcard/generics/circular_inkwell.dart';
import 'package:flashcard/videos_list/video_item_view/components.dart';
import 'package:flutter/material.dart';

class VideoItemView extends StatelessWidget with VideoItemComponents {
  const VideoItemView({
    super.key,
    required this.title,
    required this.badges,
    required this.thumbnailUrl,
    required this.actionsMenu,
  });
  static const _constraintsAspectRatioError =
      "Video item height can not exceed its width";
  static const double _thumbnailPadding = 10;
  final String title;
  final String thumbnailUrl;
  final List<String> badges;
  final Widget actionsMenu;

  Widget _smallItemBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _thumbnailPadding),
              child: thumbnailBuilder(thumbnailUrl),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleBuilder(title: title, maxLines: 3),
                  SizedBox(height: constraints.maxHeight * 0.025),
                  badgeBuilder(badge: "CNN"),
                  badgeBuilder(badge: "220k views"),
                ],
              ),
            ),
            actionsMenu,
          ],
        );
      },
    );
  }

  Widget _largeItemBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth - CircularInkWell.padding * 1.5,
              child: thumbnailBuilder(thumbnailUrl),
            ),
            SizedBox(height: constraints.maxHeight * 0.025),
            Padding(
              padding: const EdgeInsets.only(left: CircularInkWell.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: titleBuilder(title: title, maxLines: 2)),
                      actionsMenu
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.01),
                  if (badges.isNotEmpty) ...[
                    badgeBuilder(badge: badges.first),
                    SizedBox(height: constraints.maxHeight * 0.01),
                    Row(
                      children: [
                        for (final badge in badges.sublist(1)) ...[
                          badgeBuilder(badge: badge),
                          SizedBox(width: constraints.maxHeight * 0.02),
                        ],
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        assert(constraints.maxHeight <= constraints.maxWidth,
            _constraintsAspectRatioError);
        return constraints.maxHeight <= constraints.maxWidth / 3
            ? _smallItemBuilder()
            : _largeItemBuilder();
      },
    );
  }
}
