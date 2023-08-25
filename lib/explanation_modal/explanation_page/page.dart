import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/web_example.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/youtube_example.dart';
import 'package:lang_tube/subtitles_player/views/subtitle_box.dart';
import 'package:lang_tube/youtube_video_player/settings/subtitles_settings/settings.dart';
import 'package:lang_tube/youtube_video_player/yotube_video_player_modes/iframe_youtube_player.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:size_observer/size_observer.dart';
import '../../main.dart';
import 'data/lexicon.dart';
import 'flashcard.dart';

class ExplanationPage extends StatefulWidget {
  const ExplanationPage({
    super.key,
    required this.word,
    required this.data,
  });
  final String word;
  final Lexicon data;

  @override
  State<ExplanationPage> createState() => _ExplanationPageState();
}

class _ExplanationPageState extends State<ExplanationPage> {
  late final _entries = widget.data.entries;
  late final _webExamples = widget.data.webExamples;
  late final _youtubeExamples = widget.data.youtubeExamples;
  late final PreloadPageController _pageController;
  final _flashcardContorllers = <FlipCardController>[];

  @override
  void initState() {
    _pageController = PreloadPageController(viewportFraction: 0.90)
      ..addListener(() {
        final double page = _pageController.page!;
        final double offset = page.ceil() - page;
        final double curvedOffset = Curves.easeIn.transform(offset);
        final flashcardController = _flashcardContorllers[page.ceil()];
        if (flashcardController.state?.isFront == false) {
          flashcardController.skew(curvedOffset, duration: Duration.zero);
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double? _flascardsPageViewHeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 50,
        title: Text(
          widget.word.capitalize(),
          style: const TextStyle(
            fontSize: 26,
            color: LangTube.tmp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Transform.translate(
            offset: const Offset(-15, 0),
            child: CircularInkWell(
              onTap: () {},
              child: const Icon(Icons.close),
            ),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: StatefulBuilder(
              builder: (context, setState) {
                _flashcardContorllers.clear();
                final bottomPadding = _flascardsPageViewHeight != null
                    ? _flascardsPageViewHeight! *
                        _flashcardsPageViewBottomPaddingToHeightRatio
                    : 0.0;
                final topPadding = _flascardsPageViewHeight != null
                    ? _flascardsPageViewHeight! *
                        _flashcardsPageViewTopPaddingToHeightRatio
                    : 0.0;
                return SizedBox(
                  height: _flascardsPageViewHeight != null
                      ? _flascardsPageViewHeight! + bottomPadding + topPadding
                      : 500,
                  child: _flashcardsBuilder(
                    backgroundColor: Colors.white,
                    wordHighlightColor: Colors.deepPurple,
                    padding: EdgeInsets.only(
                      bottom: bottomPadding,
                      top: topPadding,
                    ),
                    onMaxHeightChange: (height) =>
                        _flascardsPageViewHeight == null
                            ? setState(
                                () => _flascardsPageViewHeight =
                                    height - topPadding - bottomPadding,
                              )
                            : null,
                  ),
                );
              },
            ),
          ),
          SliverList.separated(
            itemCount: _webExamples.length > _youtubeExamples.length
                ? _webExamples.length
                : _youtubeExamples.length,
            separatorBuilder: (context, index) {
              return _youtubeExampleBuilder(example: _youtubeExamples.first);

              return _youtubeExampleBuilder(example: _youtubeExamples.last);

              return Container();
            },
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: _webExampleBuilder(
                  webExample: _webExamples[index],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _youtubeExampleBuilder({required YoutubeExample example}) {
    Widget subtitleBuilder(
            {required String subtitle, required Color textColor}) =>
        SubtitleBox(
          words: subtitle.split(' '),
          backgroundColor: Colors.white,
          defaultTextColor: textColor,
          textFontSize: 17,
          fontWeight: FontWeight.w500,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        var height = MediaQuery.of(context).size.height;
        return Column(
          children: [
            IframeYoutubePlayer(
              videoId: example.videoId,
              start: example.start,
              end: example.end,
            ),
            Container(
              color: Colors.white,
              width: constraints.maxWidth,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.05,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.005,
                    ),
                    subtitleBuilder(
                      subtitle: example.mainSubtitle,
                      textColor: LangTube.tmp,
                    ),
                    SizedBox(height: height * 0.01),
                    subtitleBuilder(
                      subtitle: example.translatedSubtitle,
                      textColor: Colors.deepPurple,
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _webExampleBuilder({required WebExample webExample}) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 5 / 3,
          child: AnyLinkPreview.builder(
            link: webExample.link,
            cache: const Duration(days: 7),
            placeholderWidget: _imageLoadingPlaceholder,
            errorWidget: _imageErrorPlaceholder,
            itemBuilder: (context, metaData, image) {
              return metaData.image != null
                  ? CachedNetworkImage(
                      imageUrl: metaData.image!,
                      placeholder: (context, url) => _imageLoadingPlaceholder,
                      errorWidget: (context, url, error) =>
                          _imageErrorPlaceholder,
                      fit: BoxFit.fill,
                    )
                  : _imageErrorPlaceholder;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 25,
          ),
          child: Text(
            webExample.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: LangTube.tmp,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: 16,
          ),
          child: RichText(
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                color: LangTube.tmp,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              children: [
                TextSpan(text: "You "),
                TextSpan(
                    text: "guessed ",
                    style: TextStyle(color: Colors.deepPurple)),
                TextSpan(
                  text:
                      """it, a good night's sleep. Sleep is comprised of four stages, the deepest of which is known as slow-wave sleep and rapid eye movement. EEG machines monitoring people during these stages have shown electrical impulses""",
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _flashcardsBuilder({
    required Function(double height) onMaxHeightChange,
    required Color backgroundColor,
    required Color wordHighlightColor,
    required EdgeInsets padding,
  }) {
    final entries = widget.data.entries;
    return PreloadPageView.builder(
      controller: _pageController,
      preloadPagesCount: entries.length,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _flexBuilder(
                isEnabled: _flascardsPageViewHeight != null,
                child: SizeObserver(
                  onChange: (size) =>
                      size != null ? onMaxHeightChange(size.height) : null,
                  child: ExplanationFlashcard(
                    wordHighlightColor: wordHighlightColor,
                    bakgroundColor: backgroundColor,
                    side: index < 2 ? CardSide.FRONT : CardSide.BACK,
                    flipController:
                        (_flashcardContorllers..add(FlipCardController())).last,
                    entry: entries[index],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget get _imageLoadingPlaceholder {
    return _imagePlaceholderBuilder(
      builder: (context, size) {
        return LoadingAnimationWidget.threeRotatingDots(
          color: LangTube.tmp,
          size: size.longestSide * 0.15,
        );
      },
    );
  }

  Widget get _imageErrorPlaceholder {
    return _imagePlaceholderBuilder(
      builder: (context, size) => Icon(
        Icons.broken_image_outlined,
        color: Colors.white,
        size: size.longestSide * 0.15,
      ),
    );
  }

  Widget _imagePlaceholderBuilder(
      {required Widget Function(BuildContext, Size) builder}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        assert(width.isFinite && height.isFinite);
        return Container(
          color: const Color.fromARGB(255, 219, 219, 219),
          child: Center(
            child: builder(context, Size(height, width)),
          ),
        );
      },
    );
  }

  Widget _flexBuilder({required Widget child, bool isEnabled = false}) =>
      isEnabled ? Flexible(child: child) : child;

  static const _flashcardsPageViewTopPaddingToHeightRatio = 0.05;
  static const _flashcardsPageViewBottomPaddingToHeightRatio = 0.09;
}
