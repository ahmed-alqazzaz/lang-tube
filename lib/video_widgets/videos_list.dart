import 'package:flutter/material.dart';
import 'package:lang_tube/video_widgets/display_video_item.dart';

import 'video_item.dart';

class VideosListView extends StatelessWidget {
  const VideosListView({
    super.key,
    required this.videos,
    required this.itemHeight,
    required this.verticalPadding,
    required this.trailingBuilder,
    required this.onTap,
  });
  final List<DisplayVideoItem> videos;
  final double itemHeight;
  final double verticalPadding;
  final Widget Function(DisplayVideoItem) trailingBuilder;
  final Function(DisplayVideoItem) onTap;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final item = videos[index];
        return SizedBox(
          height: itemHeight,
          child: RawMaterialButton(
            onPressed: () => onTap(item),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
              ),
              child: VideoItemView.small(
                title: item.title,
                badges: const [],
                thumbnailUrl: item.thumbnailUrl,
                trailing: trailingBuilder(item),
                duration: item.duration,
              ),
            ),
          ),
        );
      },
    );
  }
}
