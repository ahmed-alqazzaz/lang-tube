import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';

final class VideoItemView extends StatelessWidget {
  const VideoItemView({
    super.key,
    required this.title,
    required this.badges,
    required this.thumbnailUrl,
    required this.actionsMenu,
    required this.duration,
  });
  static const _constraintsAspectRatioError =
      "Video item height can not exceed its width";
  static const double _thumbnailPadding = 10;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final List<String> badges;
  final Widget actionsMenu;

  static const double largeItemMaximumAspectRatio = 1.25;
  static const double smallItemMinimumAspectRatio = 3;
  static const double actionsMenuOffset = CircularInkWell.defaultSplashRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        assert(
            aspectRatio <= largeItemMaximumAspectRatio ||
                aspectRatio >= smallItemMinimumAspectRatio,
            "$aspectRatio $largeItemMaximumAspectRatio");
        return constraints.maxHeight <= constraints.maxWidth / 3
            ? _smallItemBuilder()
            : _largeItemBuilder();
      },
    );
  }

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

  Widget _durationBuilder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.65),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 4,
      ),
      child: Text(
        duration,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _largeItemBuilder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: constraints.maxWidth,
              child: Stack(
                children: [
                  thumbnailBuilder(thumbnailUrl),
                  Positioned(
                      bottom: constraints.maxHeight * 0.03,
                      right: constraints.maxWidth * 0.03,
                      child: _durationBuilder())
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.015),
            Padding(
              padding: const EdgeInsets.only(
                left: CircularInkWell.defaultSplashRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: titleBuilder(title: title, maxLines: 2)),
                      Transform.translate(
                        offset: const Offset(
                          CircularInkWell.defaultSplashRadius,
                          0,
                        ),
                        child: actionsMenu,
                      )
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

  Widget thumbnailBuilder(String thumbnailUrl) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: constraints.copyWith(minWidth: constraints.minWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl,
                fit: BoxFit.fitWidth,
                fadeInDuration: const Duration(milliseconds: 200),
                fadeOutDuration: const Duration(milliseconds: 200),
                placeholder: (context, url) =>
                    Container(color: const Color.fromARGB(255, 219, 219, 219)),
                errorWidget: (context, url, error) {
                  log("image error $error");
                  return Container(color: Colors.red);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget channelIconBuilder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        "https://yt3.ggpht.com/qWTXkB8Y-a7sAr8eZ8v_jpaBk4NXYZ3jd6GuSFOGHqTNZY6bZ275gfFrmw9UF3Rkzs9XICtFeXs=s68-c-k-c0x00ffffff-no-rj",
        fit: BoxFit.cover,
        width: 36,
        height: 36,
      ),
    );
  }

  Widget titleBuilder({required String title, required int maxLines}) {
    return Builder(
      builder: (context) {
        return Text(
          title,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 15,
              ),
        );
      },
    );
  }

  Widget badgeBuilder({required String badge}) {
    return Builder(
      builder: (context) {
        return Text(
          badge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium,
        );
      },
    );
  }

  //  Widget _itemLarge() {
  //   return Column(
  //     children: [
  //       _thumbnailBuilder(),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         child: Row(
  //           children: [
  //             _channelIconBuilder(),
  //             Expanded(
  //               child: _titleBuilder(
  //                 text:
  //                     "Here's what Kushner's testimony reveals about special counsel investigation",
  //                 maxLines: 2,
  //               ),
  //             ),
  //             const SizedBox(width: 30),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
