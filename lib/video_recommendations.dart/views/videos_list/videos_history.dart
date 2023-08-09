import 'package:flashcard/generics/circular_inkwell.dart';
import 'package:flashcard/videos_list/video_item_view/view.dart';
import 'package:flashcard/videos_list/videos_carousel.dart';
import 'package:flutter/material.dart';

class VideosHistoryView extends StatelessWidget {
  const VideosHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_outlined),
        title: const Text("History"),
        actions: const [
          CircularInkWell(child: Icon(Icons.search_outlined)),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            children: const [
              SizedBox(
                height: 380,
                child: VideosCarousel(),
              ),
              SizedBox(
                height: 380,
                child: VideosCarousel(),
              ),
              SizedBox(
                height: 380,
                child: VideosCarousel(),
              ),
              SizedBox(
                height: 380,
                child: VideosCarousel(),
              ),
            ],
          );

          return SizedBox(
            width: 300,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: 5,
              separatorBuilder: (context, index) =>
                  SizedBox(height: constraints.maxHeight * 0.016),
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 290,
                  child: VideoItemView(
                    title: "",
                    badges: const [],
                    thumbnailUrl: "lib/maxresdefault.jpg",
                    actionsMenu: Container(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
