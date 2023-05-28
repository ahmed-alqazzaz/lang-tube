// Widget _buildPlayer({required Widget errorWidget}) {
//     final size = MediaQuery.of(context).size;
//     final double fullScreenScale = controller.value.isFullScreen
//         ? (1 / _aspectRatio * size.width) / size.height
//         : 1;

//     final double widthScale = (size.aspectRatio > _aspectRatio
//             ? (_aspectRatio / size.aspectRatio)
//             : 1) /
//         RawYoutubePlayer.widthScalingFactor;
        
//     final double remainingWidth = size.aspectRatio > _aspectRatio
//         ? size.width - (_aspectRatio * size.height)
//         : 0;
//     return ClipRRect(
//       clipBehavior: Clip.hardEdge,
//       child: OverflowBox(
//         alignment: Alignment.center,
//         maxHeight: size.width / _aspectRatio,
//         child: AspectRatio(
//           aspectRatio: _aspectRatio,
//           child: Stack(
//             fit: StackFit.expand,
//             clipBehavior: Clip.hardEdge,
//             children: [
//               SizedBox(
//                 width: size.width,
//                 height: size.width / _aspectRatio,
//               ),
//               Positioned(
//                 bottom: 0,
//                 top: 0,
//                 right: -remainingWidth / 2,
//                 left: remainingWidth / 2,
//                 child: Transform(
//                   alignment: Alignment.centerLeft,
//                   transform: Matrix4.identity()
//                     ..scale(fullScreenScale)
//                     ..scale(widthScale),
//                   child: RawYoutubePlayer(
//                     key: widget.key,
//                     onEnded: (YoutubeMetaData metaData) {
//                       if (controller.flags.loop) {
//                         controller.load(controller.metadata.videoId,
//                             startAt: controller.flags.startAt,
//                             endAt: controller.flags.endAt);
//                       }

//                       widget.onEnded?.call(metaData);
//                     },
//                   ),
//                 ),
//               ),
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   return Stack(
//                     fit: StackFit.expand,
//                     clipBehavior: Clip.hardEdge,
//                     children: [
//                       SizedBox(
//                         width: constraints.maxWidth,
//                         height: constraints.maxHeight,
//                       ),
//                       if (!controller.flags.hideThumbnail)
//                         AnimatedOpacity(
//                           opacity: controller.value.isPlaying ? 0 : 1,
//                           duration: const Duration(milliseconds: 300),
//                           child: widget.thumbnail ?? _thumbnail,
//                         ),
//                       if (!controller.value.isFullScreen &&
//                           !controller.flags.hideControls &&
//                           controller.value.position >
//                               const Duration(milliseconds: 100) &&
//                           !controller.value.isControlsVisible &&
//                           widget.showVideoProgressIndicator &&
//                           !controller.flags.isLive)
//                         Positioned(
//                           bottom: -7.0,
//                           left: -7.0,
//                           right: -7.0,
//                           child: IgnorePointer(
//                             ignoring: true,
//                             child: ProgressBar(
//                               colors: widget.progressColors.copyWith(
//                                 handleColor: Colors.transparent,
//                               ),
//                             ),
//                           ),
//                         ),
//                       if (!controller.flags.hideControls) ...[
//                         TouchShutter(
//                           disableDragSeek: controller.flags.disableDragSeek,
//                           timeOut: widget.controlsTimeOut,
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           left: 0,
//                           right: 0,
//                           child: AnimatedOpacity(
//                             opacity: !controller.flags.hideControls &&
//                                     controller.value.isControlsVisible
//                                 ? 1
//                                 : 0,
//                             duration: const Duration(milliseconds: 300),
//                             child: controller.flags.isLive
//                                 ? LiveBottomBar(
//                                     liveUIColor: widget.liveUIColor,
//                                     showLiveFullscreenButton: widget.controller
//                                         .flags.showLiveFullscreenButton,
//                                   )
//                                 : Padding(
//                                     padding: widget.bottomActions == null
//                                         ? const EdgeInsets.all(0.0)
//                                         : widget.actionsPadding,
//                                     child: Row(
//                                       children: widget.bottomActions ??
//                                           [
//                                             const SizedBox(width: 14.0),
//                                             CurrentPosition(),
//                                             const SizedBox(width: 8.0),
//                                             ProgressBar(
//                                               isExpanded: true,
//                                               colors: widget.progressColors,
//                                             ),
//                                             RemainingDuration(),
//                                             const PlaybackSpeedButton(),
//                                             FullScreenButton(),
//                                           ],
//                                     ),
//                                   ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           child: AnimatedOpacity(
//                             opacity: !controller.flags.hideControls &&
//                                     controller.value.isControlsVisible
//                                 ? 1
//                                 : 0,
//                             duration: const Duration(milliseconds: 300),
//                             child: Padding(
//                               padding: widget.actionsPadding,
//                               child: Row(
//                                 children: widget.topActions ?? [Container()],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                       if (!controller.flags.hideControls)
//                         Center(
//                           child: PlayPauseButton(),
//                         ),
//                       if (controller.value.hasError) errorWidget,
//                     ],
//                   );
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget get _thumbnail => Image.network(
//         YoutubePlayer.getThumbnail(
//           videoId: controller.metadata.videoId.isEmpty
//               ? controller.initialVideoId
//               : controller.metadata.videoId,
//         ),
//         fit: BoxFit.cover,
//         loadingBuilder: (_, child, progress) =>
//             progress == null ? child : Container(color: Colors.black),
//         errorBuilder: (context, _, __) => Image.network(
//           YoutubePlayer.getThumbnail(
//             videoId: controller.metadata.videoId.isEmpty
//                 ? controller.initialVideoId
//                 : controller.metadata.videoId,
//             webp: false,
//           ),
//           fit: BoxFit.cover,
//           loadingBuilder: (_, child, progress) =>
//               progress == null ? child : Container(color: Colors.black),
//           errorBuilder: (context, _, __) => Container(),
//         ),
//       );