// import 'dart:developer';

// import 'package:circular_inkwell/circular_inkwell.dart';
// import 'package:circular_menu/circular_menu.dart';
// import 'package:clipped_icon/clipped_icon.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lang_tube/youtube_video_player/actions/views/portrait_screen_actions/bottom_actions_bar.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// import '../../../custom/icons/custom_icons.dart';
// import '../../youtube_video_player.dart';
// import '../action_providers/full_screen_provider/provider.dart';
// import '../action_providers/loop_providers/custom_loop_provider/loop_provider.dart';
// import '../action_providers/loop_providers/custom_loop_provider/setup_provider.dart';
// import '../action_providers/loop_providers/raw_loop_notifier/loop.dart';
// import '../action_providers/loop_providers/subtitle_loop_provider.dart/notifier.dart';
// import '../action_providers/loop_providers/subtitle_loop_provider.dart/provider.dart';
// import '../action_providers/youtube_hd_provider/provider.dart';
// import '../action_providers/youtube_playback_speed_provider/provider.dart';


// abstract class YoutubePlayerActions extends StatelessWidget {
//   YoutubePlayerActions({
//     super.key,
//     required YoutubePlayerController youtubePlayerController,
//     required CurrentSubtitleGetter currentSubtitleGetter,
//   })  : _youtubePlayerController = youtubePlayerController,
//         _customLoopProvider = customLoopProviderFamily(youtubePlayerController),
//         _youtubeHdProvider = youtubeHdProviderFamily(youtubePlayerController),
//         _youtubePlaybackSpeedProvider =
//             youtubePlaybackSpeedProviderFamily(youtubePlayerController),
//         _subtitleLoopProvider = subtitleLoopProviderFamily((
//           youtubePlayerController: youtubePlayerController,
//           currentSubtitleGetter: currentSubtitleGetter,
//           loopCount: 1
//         ));
//   final YoutubePlayerController _youtubePlayerController;
//   final CustomLoopProvider _customLoopProvider;
//   final SubtitleLoopProvider _subtitleLoopProvider;
//   final YoutubeHdProvider _youtubeHdProvider;
//   final YoutubePlaybackSpeedProvider _youtubePlaybackSpeedProvider;
  
  
 
//   Widget positionIndicator() => CurrentPosition(
//         controller: _youtubePlayerController,
//       );

//   Widget backButton() {
//     return CircularInkWell(
//       child: const Icon(
//         Icons.keyboard_arrow_down_outlined,
//         color: Colors.white,
//       ),
//       onTap: () {},
//     );
//   }

//   Widget toggleFullScreenButton() {
//     return Consumer(
//       builder: (context, ref, _) {
//         final isFullScreen = ref.read(youtubePlayerFullScreenProvider);
//         return CircularInkWell(
//           child: Icon(
//             isFullScreen
//                 ? Icons.fullscreen_exit_outlined
//                 : Icons.fullscreen_sharp,
//             color: Colors.white,
//           ),
//           onTap: () {
//             final fullScreenNotifier =
//                 ref.read(youtubePlayerFullScreenProvider.notifier);
//             final isFullScreen = ref.read(youtubePlayerFullScreenProvider);
//             isFullScreen
//                 ? fullScreenNotifier.enableFullScreen()
//                 : fullScreenNotifier.exitFullScreen();
//           },
//         );
//       },
//     );
//   }

//   Widget progressBar() {
//     CustomProgress? customProgressGenerator({
//       required Loop loop,
//       required Color color,
//     }) =>
//         CustomProgress(
//           start: loop.start.inMilliseconds /
//               _youtubePlayerController.value.metaData.duration.inMilliseconds,
//           end: loop.end.inMilliseconds /
//               _youtubePlayerController.value.metaData.duration.inMilliseconds,
//           color: Colors.amber.shade600,
//         );

//     return Consumer(
//       builder: (context, ref, _) {
//         final subtitlesLoopStream =
//             ref.read(_subtitleLoopProvider.notifier).stream.startWith(null);
//         final customLoopStream =
//             ref.read(_customLoopProvider.notifier).stream.startWith(null);
//         return ProgressBar(
//           controller: _youtubePlayerController,
//           customProgress: Rx.combineLatestList([
//             subtitlesLoopStream.asyncMap(
//               (loop) => loop != null
//                   ? customProgressGenerator(
//                       loop: loop,
//                       color: progressBarSubtitleLoopColor,
//                     )
//                   : null,
//             ),
//             customLoopStream.asyncMap(
//               (loop) => loop != null
//                   ? customProgressGenerator(
//                       loop: loop,
//                       color: progressBarCustomLoopColor,
//                     )
//                   : null,
//             ),
//           ]),
//           colors: ProgressBarColors(
//             handleColor: progressBarPlayedColor,
//             playedColor: progressBarPlayedColor,
//             bufferedColor: progressBarBufferColor.withOpacity(0.7),
//             backgroundColor: progressBarBackgroungColor.withOpacity(0.5),
//           ),
//         );
//       },
//     );
//   }

//   Widget playbackSpeedButton({required double splashRadius}) {
//     return Consumer(
//       builder: (context, ref, _) {
//         final playbackSpeedNotifier = ref.read(
//           _youtubePlaybackSpeedProvider.notifier,
//         );
//         final speed = ref.watch(_youtubePlaybackSpeedProvider).toString();
//         return Transform.translate(
//           offset: Offset(speed.length == 4 ? 0 : -6, 0),
//           child: CircularInkWell(
//             onTap: () => playbackSpeedNotifier.seekNext(),
//             splashRadius: splashRadius,
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   TextSpan(
//                     text: speed,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.0,
//                     ),
//                   ),
//                   const TextSpan(
//                     text: 'x',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget customLoopButton({required double splashRadius}) {
//     Duration? loopStart;
//     return Consumer(
//       builder: (context, ref, _) {
//         final loopNotifier = ref.read(_customLoopProvider.notifier);
//         final loopSetupProvider = ref.read(customLoopSettingProvider.notifier);
//         final loopState = ref.watch(customLoopSettingProvider);
//         return CircularInkWell(
//           onTap: () {
//             switch (loopState) {
//               case CustomLoopState.inactive:
//                 loopStart = _youtubePlayerController.value.position;
//                 loopSetupProvider.state = CustomLoopState.activating;
//                 break;
//               case CustomLoopState.activating:
//                 final loopEnd = _youtubePlayerController.value.position;
//                 loopNotifier.activateLoop(start: loopStart!, end: loopEnd);
//                 loopSetupProvider.state = CustomLoopState.active;
//                 break;
//               case CustomLoopState.active:
//                 loopStart = null;
//                 loopNotifier.deactivateLoop();
//                 loopSetupProvider.state = CustomLoopState.inactive;
//                 break;
//             }
//           },
//           splashRadius: splashRadius,
//           child: Stack(
//             children: [
//               const SizedBox(height: 30, width: 30),
//               Positioned(
//                 top: 0,
//                 child: ClippedIcon(
//                   clipDirection: ClipDirection.top,
//                   height: 15,
//                   icon: Icon(
//                     Icons.repeat,
//                     color: loopState == CustomLoopState.active
//                         ? Colors.amber.shade600
//                         : Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: ClippedIcon(
//                   clipDirection: ClipDirection.bottom,
//                   height: 15,
//                   icon: Icon(
//                     Icons.repeat,
//                     color: loopState == CustomLoopState.inactive
//                         ? Colors.white
//                         : Colors.amber.shade600,
//                     size: 30,
//                   ),
//                 ),
//               ),
//               Positioned.fill(
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'A',
//                           style: TextStyle(
//                             color: loopState == CustomLoopState.inactive
//                                 ? Colors.white
//                                 : Colors.amber.shade600,
//                             fontSize: 8,
//                           ),
//                         ),
//                         TextSpan(
//                           text: 'B',
//                           style: TextStyle(
//                             color: loopState == CustomLoopState.active
//                                 ? Colors.amber.shade600
//                                 : Colors.white,
//                             fontSize: 8,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   static const Color progressBarBackgroungColor =
//       Color.fromARGB(255, 156, 156, 156);
//   static const Color progressBarBufferColor = Color(0xFFCCCCCC);
//   static const Color progressBarPlayedColor = Color(0xFFFF0000);
//   static const Color progressBarSubtitleLoopColor = Colors.amber;
//   static const Color progressBarCustomLoopColor = Colors.amber;
//   static const double progressBarThickness = 2;
// }

// class CircularMenuActions extends YoutubePlayerActions {
//   CircularMenuActions({
//     super.key,
//     required super.youtubePlayerController,
//     required super.currentSubtitleGetter,
//     required this.onActionsMenuToggled,
//   });
//   final circularMenuToggleButtonColor = Colors.amber[600];
//   static const circularMenuItemBackgroundColor =
//       Color.fromARGB(255, 50, 50, 50);

//   final void Function() onActionsMenuToggled;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, _) {
//         return CircularMenu(
//           toggleButtonColor: circularMenuToggleButtonColor,
//           alignment: const Alignment(0, 0.92),
//           startingAngleInRadian: 3.8,
//           endingAngleInRadian: 5.6,
//           toggleButtonSize: 35,
//           toggleButtonOnPressed: onActionsMenuToggled,
//           toggleButtonBoxShadow: const [
//             BoxShadow(color: Colors.white, blurRadius: 0.5)
//           ],
//           items: [
//             _circularMenuHdButton(ref),
//             _circularMenuSubtitlesButton(ref),
//             circularMenuSubtitlesLoopButton(ref),
//           ],
//         );
//       },
//     );
//   }

//   CircularMenuItem _genericCircularMenuItem({
//     required IconData icon,
//     required void Function() onTap,
//     Color iconColor = Colors.white,
//   }) {
//     return CircularMenuItem(
//       icon: icon,
//       iconColor: iconColor,
//       color: circularMenuItemBackgroundColor,
//       onTap: onTap,
//     );
//   }

//   CircularMenuItem _circularMenuHdButton(WidgetRef ref) {
//     final isHd = ref.watch(_youtubeHdProvider);
//     final youtubeHdNotifier = ref.read(_youtubeHdProvider.notifier);
//     return _genericCircularMenuItem(
//       icon: Icons.hd_rounded,
//       iconColor: isHd ? Colors.white : Colors.white30,
//       onTap: () async =>
//           isHd ? youtubeHdNotifier.disableHd() : youtubeHdNotifier.forceHd(),
//     );
//   }

//   CircularMenuItem circularMenuSubtitlesLoopButton(WidgetRef ref) {
//     final isLoopActive =
//         ref.watch(_subtitleLoopProvider.select((value) => value != null));
//     final subtitleLoopNotifier = ref.read(_subtitleLoopProvider.notifier);

//     return _genericCircularMenuItem(
//       icon: Icons.repeat_one,
//       iconColor: isLoopActive ? Colors.white : Colors.white30,
//       onTap: () => isLoopActive
//           ? subtitleLoopNotifier.deactivateLoop()
//           : subtitleLoopNotifier.activateLoop(),
//     );
//   }

//   CircularMenuItem _circularMenuSubtitlesButton(WidgetRef ref) {
//     return _genericCircularMenuItem(
//       icon: Icons.closed_caption_rounded,
//       onTap: () {},
//     );
//   }
// }

// class YoutubeMiniPlayerActions extends YoutubePlayerActions {
//   YoutubeMiniPlayerActions({
//     super.key,
//     required super.youtubePlayerController,
//     required super.currentSubtitleGetter,
//   });
//   static const buttonsPadding = 15.0;

//   Widget _bottomActions() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Transform.translate(
//           offset: const Offset(buttonsPadding, 0),
//           child: positionIndicator(),
//         ),
//         Transform.translate(
//           offset: const Offset(buttonsPadding, 0),
//           child: toggleFullScreenButton(),
//         ),
//       ],
//     );
//   }

//   Widget _topActions() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Transform.translate(
//           offset: const Offset(-buttonsPadding, 0),
//           child: backButton(),
//         ),
//         Transform.translate(
//           offset: const Offset(buttonsPadding, 0),
//           child:backButton(),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Container(
//           alignment: Alignment.center,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _topActions(),
//               _bottomActions(),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class YoutubeFullScreenPlayerActions extends YoutubePlayerActions {
//   YoutubeFullScreenPlayerActions({
//     super.key,
//     required super.youtubePlayerController,
//     required super.currentSubtitleGetter,
//   });

//   Widget subtitlesSettingsButton() {
//     return CircularInkWell(
//       child: const Icon(
//         Icons.closed_caption_outlined,
//         color: Colors.white,
//       ),
//       onTap: () {},
//     );
//   }

//   Widget settingsButton() {
//     return CircularInkWell(
//       child: const Icon(
//         Icons.more_vert,
//         color: Colors.white,
//       ),
//       onTap: () {},
//     );
//   }

//   Widget youtubeButton() {
//     return RawMaterialButton(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(30.0),
//         ),
//       ),
//       highlightColor: Colors.white10,
//       child: const SizedBox(
//         width: 130,
//         height: 35,
//         child: Icon(
//           CustomIcons.youtubeIcon,
//           color: Colors.white,
//         ),
//       ),
//       onPressed: () {},
//     );
//   }

//   Widget _subtitlesLoopButton() {
//     return Consumer(
//       builder: (context, ref, _) {
//         final isHd = ref.watch(_youtubeHdProvider);
//         final youtubeHdNotifier = ref.read(_youtubeHdProvider.notifier);
//         return RawMaterialButton(
//           child: Icon(
//             Icons.hd_outlined,
//             color: isHd ? Colors.white : Colors.white30,
//           ),
//           onPressed: () => isHd
//               ? youtubeHdNotifier.disableHd()
//               : youtubeHdNotifier.forceHd(),
//         );
//       },
//     );
//   }

//   Widget midActions() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(
//             left: YoutubeVideoPlayerView.progressBarHandleRadius,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               positionIndicator(),
//               toggleFullScreenButton(),
//             ],
//           ),
//         ),
//     progressBar(),
//       ],
//     );
//   }

//   Widget bottomActions() {
//     return Row(
//       children: [
//         _subtitlesLoopButton(),
//         customLoopButton(splashRadius: 12),
//         playbackSpeedButton(splashRadius: 12),
//         Expanded(child: Container()),
//         youtubeButton(),
//       ],
//     );
//   }

//   Widget topActions() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Switch(value: true, onChanged: (h) {}),
//         subtitlesSettingsButton(),
//         settingsButton(),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final areActionsVisible = true;
//     // ref.watch(
//     //   actions._actionsProvider
//     //       .select((actionsModel) => actionsModel.areFullScreenActionsVisible),
//     // );
//     return AnimatedOpacity(
//       opacity: areActionsVisible ? 1.0 : 0,
//       duration: const Duration(milliseconds: 300),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(
//             height: 5,
//           ),
//           topActions(),
//           Expanded(
//             flex: 1,
//             child: Container(),
//           ),
//           midActions(),
//           const SizedBox(height: 4),
//           bottomActions(),
//           const SizedBox(height: 5),
//         ],
//       ),
//     );
//   }
// }

// class BottomActionsBar extends YoutubePlayerActions {
//   BottomActionsBar({
//     super.key,
//     required super.youtubePlayerController,
//     required super.currentSubtitleGetter,
//     required Widget subtitlesSettings,
//   }) : _subtitlesSettings = subtitlesSettings;

//   final splashRadius = 12.0;
//   final Widget _subtitlesSettings;
//   Widget subtitlesSettingsButton() {
//     return Consumer(
//       builder: (context, ref, _) {
//         return CircularInkWell(
//           onTap: () {
//             showModalBottomSheet(
//               context: context,
//               constraints: const BoxConstraints(minHeight: 250, maxHeight: 250),
//               builder: (context) {
//                 return StatefulBuilder(
//                   builder: (context, setState) {
//                     return _subtitlesSettings;
//                   },
//                 );
//               },
//             );
//           },
//           splashRadius: splashRadius,
//           child: const Icon(
//             Icons.closed_caption_rounded,
//             color: Colors.white,
//             size: 30,
//           ),
//         );
//       },
//     );
//   }


//   Widget settingsButton() {
//     return Consumer(
//       builder: (context, ref, _) {
//         return CircularInkWell(
//           onTap: () => throw UnimplementedError,
//           splashRadius: splashRadius,
//           child: const Icon(
//             Icons.settings_outlined,
//             color: Colors.white,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         log(constraints.toString());
//         return Stack(
//           children: [
//             CustomPaint(
//               size: Size(
//                 width,
//                 (width * 0.25).toDouble(),
//               ),
//               painter: RPSCustomPainter(
//                 backgroundColor: const Color.fromARGB(255, 15, 15, 15),
//               ),
//             ),
//             Row(
//               children: [
//                 SizedBox(width: constraints.maxWidth * 0.03),
//                 Transform.translate(
//                   offset: Offset(0, constraints.maxHeight * 0.28),
//                   child: subtitlesSettingsButton(),
//                 ),
//                 SizedBox(width: constraints.maxWidth * 0.055),
//                 Transform.translate(
//                   offset: Offset(0, constraints.maxHeight * 0.13),
//                   child: customLoopButton(splashRadius: splashRadius),
//                 ),
//                 const Expanded(child: SizedBox()),
//                 Transform.translate(
//                   offset: Offset(0, constraints.maxHeight * 0.13),
//                   child: playbackSpeedButton(splashRadius: splashRadius),
//                 ),
//                 SizedBox(width: constraints.maxWidth * 0.02),
//                 Transform.translate(
//                   offset: Offset(0, constraints.maxHeight * 0.28),
//                   child: settingsButton(),
//                 ),
//                 SizedBox(width: constraints.maxWidth * 0.05),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
// }
