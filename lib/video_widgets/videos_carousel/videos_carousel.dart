import 'dart:developer';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:lang_tube/main.dart';
import 'package:lang_tube/video_recommendations.dart/views/videos_list/videos_carousel/carousel_video_item.dart';
import 'package:size_utils/size_utils.dart';
import 'package:sized_button/sized_button.dart';
import '../video_item/video_item.dart';

class VideosCarousel extends StatelessWidget {
  const VideosCarousel({
    super.key,
    required this.topic,
    required this.videoItems,
    required this.onActionsMenuPressed,
    required this.onLoadMore,
    this.useLargeLoadMoreButton = false,
  });

  static const double videoItemAspectRatio = 1.5;

  final void Function() onActionsMenuPressed;
  final void Function() onLoadMore;

  final String topic;
  final bool useLargeLoadMoreButton;
  final List<CarouselVideoItem> videoItems;

  Widget _actionMenuBuilder() {
    return CircularInkWell(
      onTap: onActionsMenuPressed,
      child: const Icon(
        Icons.more_vert_sharp,
        size: 20,
      ),
    );
  }

  Widget _topicBuilder() {
    return Builder(
      builder: (context) {
        return Text(
          topic,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        );
      },
    );
  }

  Widget _smallLoadMoreButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          final screenSize = getScreenSize();
          return SizedBox(
            width: orientation == Orientation.portrait
                ? screenSize.width * 0.2
                : screenSize.height * 0.1,
            child: Align(
              alignment: const Alignment(0, -0.4),
              child: Container(
                padding: EdgeInsets.all(constraints.maxHeight * 0.03),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 226, 228, 233),
                  boxShadow: [
                    BoxShadow(
                      color: LangTube.tmp.withOpacity(0.2),
                      blurRadius: 4.0,
                      offset: const Offset(0.0, 2.0),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_forward_outlined,
                  size: constraints.maxHeight * 0.1,
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _largeLoadMoreButton() {
    return SizedButton.large(
      color: LangTube.tmp,
      textColor: Colors.white,
      onPressed: () {},
      child: const Text("More"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.03;
    final videoItemWidth = size.width > 500 ? size.width * 0.70 : 500 * 0.70;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: horizontalPadding * 1.5),
            _topicBuilder(),
            const Expanded(child: SizedBox()),
            _actionMenuBuilder(),
          ],
        ),
        SizedBox(height: size.height * 0.005),
        SizedBox(
          height: videoItemWidth / VideoItemView.largeItemMaximumAspectRatio,
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(width: horizontalPadding),
              ),
              SliverList.separated(
                itemCount: videoItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: VideoItemView.actionsMenuOffset * 2),
                itemBuilder: (context, index) {
                  final item = videoItems[index];
                  return MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: item.onPressed,
                    child: SizedBox(
                      width: videoItemWidth,
                      child: VideoItemView(
                        title: item.title,
                        badges: item.badges,
                        thumbnailUrl: item.thumbnailUrl,
                        duration: '1:12',
                        actionsMenu: _actionMenuBuilder(),
                      ),
                    ),
                  );
                },
              ),
              if (!useLargeLoadMoreButton)
                SliverToBoxAdapter(child: _smallLoadMoreButton()),
              SliverToBoxAdapter(child: SizedBox(width: horizontalPadding)),
            ],
          ),
        ),
        if (useLargeLoadMoreButton) ...[
          SizedBox(height: size.height * 0.02),
          SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.05,
            child: _largeLoadMoreButton(),
          ),
        ]
      ],
    );
  }
}
