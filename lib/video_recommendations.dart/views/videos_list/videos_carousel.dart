import 'package:flashcard/generics/circular_inkwell.dart';
import 'package:flashcard/main.dart';
import 'package:flashcard/videos_list/video_item_view/view.dart';
import 'package:flutter/material.dart';

class VideosCarousel extends StatelessWidget {
  const VideosCarousel({super.key, this.useLargeLoadMoreButton = true});

  final bool useLargeLoadMoreButton;
  Widget _actionMenuBuilder({required void Function() onTap}) {
    return CircularInkWell(
      onTap: onTap,
      child: const Icon(
        Icons.more_vert_sharp,
        size: 20,
      ),
    );
  }

  Widget _topicBuilder() {
    return Builder(builder: (context) {
      return Text(
        "For you",
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      );
    });
  }

  Widget _smallLoadMoreButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: const Alignment(0, -0.3),
          child: Container(
            padding: EdgeInsets.all(constraints.maxHeight * 0.03),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 226, 228, 233),
              boxShadow: [
                BoxShadow(
                  color: FlashCardsView.mainColor.withOpacity(0.2),
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
        );
      },
    );
  }

  Widget _largeLoadMoreButton() {
    return GenericButton.large(
      color: FlashCardsView.mainColor,
      textColor: Colors.white,
      onPressed: () {},
      child: const Text("More"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth * 0.03;
        return Column(
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: horizontalPadding),
                _topicBuilder(),
                const Expanded(child: SizedBox()),
                _actionMenuBuilder(onTap: () {}),
              ],
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Expanded(
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(width: horizontalPadding),
                  ),
                  SliverList.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 300,
                        height: 200,
                        child: VideoItemView(
                          title:
                              "Here's what Kushner's testimony reveals about special counsel investigation",
                          badges: const [
                            "CNN",
                            "220k views",
                            "•",
                            "1 year ago"
                          ],
                          thumbnailUrl: "lib/maxresdefault.jpg",
                          actionsMenu: _actionMenuBuilder(onTap: () {}),
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
            SizedBox(height: constraints.maxHeight * 0.05),
            if (useLargeLoadMoreButton)
              SizedBox(
                width: constraints.maxWidth * 0.9,
                height: constraints.maxHeight * 0.11,
                child: _largeLoadMoreButton(),
              ),
          ],
        );
      },
    );
  }
}

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CircularButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: const Alignment(0, -0.3),
          child: Container(
            padding: EdgeInsets.all(constraints.maxHeight * 0.03),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 226, 228, 233),
              boxShadow: [
                BoxShadow(
                  color: FlashCardsView.mainColor.withOpacity(0.2),
                  blurRadius: 4.0,
                  offset: const Offset(0.0, 2.0),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_forward_outlined,
              size: constraints.maxHeight * 0.13,
            ),
          ),
        );
      },
    );
  }
}

enum _LoadMoreButtonSize {
  large,
  small,
}
