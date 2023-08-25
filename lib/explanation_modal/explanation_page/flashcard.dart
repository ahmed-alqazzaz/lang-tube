import 'dart:developer';

import 'package:circular_inkwell/circular_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:lang_tube/explanation_modal/explanation_page/data/lexicon_entry.dart';
import 'package:lang_tube/main.dart';
import 'package:sized_button/sized_button.dart';

class ExplanationFlashcard extends StatelessWidget {
  const ExplanationFlashcard({
    super.key,
    required this.entry,
    required this.flipController,
    required this.wordHighlightColor,
    required this.bakgroundColor,
    this.side = CardSide.FRONT,
  });

  final LexiconEntry entry;
  final CardSide side;
  final Color wordHighlightColor;
  final Color bakgroundColor;
  final FlipCardController? flipController;

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      flipOnTouch: true,
      controller: flipController,
      front: _meaningCardBuilder(context: context),
      back: _detailsCardBuilder(context: context),
      side: side,
    );
  }

  Card _meaningCardBuilder({required BuildContext context}) {
    final size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: bakgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
            ),
            child: AspectRatio(
              aspectRatio: 5 / 3,
              child: entry.media,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.015,
            ),
            child: Text(
              entry.definition,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: LangTube.tmp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _examplesBuilder(),
          ),
          SizedBox(height: size.height * 0.025),
        ],
      ),
    );
  }

  Widget _detailsCardBuilder({required BuildContext context}) {
    final size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      log(size.toString());
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.08),
            Text(
              entry.term,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                color: LangTube.tmp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              entry.linguisticElement,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                color: LangTube.tmp,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: size.height * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularInkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.volume_up_rounded,
                    size: size.height * 0.06,
                  ),
                ),
                SizedBox(width: size.height * 0.03),
                CircularInkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.mic,
                    size: size.height * 0.06,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.07),
            SizedButton.large(
              color: LangTube.tmp,
              textColor: Colors.white,
              onPressed: () {},
              size: const Size(320, 40),
              child: const Text("Save"),
            ),
            SizedBox(height: size.height * 0.04),
            Container(
              width: size.width * 0.1,
              height: size.height * 0.045,
              decoration: BoxDecoration(
                color: LangTube.tmp,
                borderRadius: BorderRadius.circular(7),
              ),
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(1.5, 0),
                child: Text(
                  entry.cefr,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _exampleBuilder({required List<String> words}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '❝  ',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Flexible(
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: LangTube.tmp,
              ),
              children: [
                for (int index = 0; index < words.length; index++)
                  TextSpan(
                    text: (index == 0 ? '' : ' ') + words[index],
                    style: TextStyle(
                      color: words[index].contains(entry.term)
                          ? wordHighlightColor
                          : null,
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _examplesBuilder() {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (var index = 0; index < entry.examples.length; index++)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.007,
                ),
                child: _exampleBuilder(
                  words: entry.examples[index].split(" "),
                ),
              )
          ],
        );
      },
    );
  }

  Widget _posBuilder() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
        ),
        color: Colors.black,
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Text(
        entry.linguisticElement,
        style: const TextStyle(
          color: Color.fromARGB(255, 50, 189, 210),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
