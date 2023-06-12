// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lang_tube/youtube_video_player/generic_actions/actions_provider.dart';

// class FullScreenToggleButton extends ConsumerWidget {
//   const FullScreenToggleButton({super.key});

//   static const color = Colors.white;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isFullScreen =
//         ref.watch(actionsProvider.select((model) => model.isFullScreen));
//     return IconButton(
//       onPressed: () {
//         ref.read(actionsProvider).toggleFullScreen();
//       },
//       icon: Icon(
//         isFullScreen ? Icons.fullscreen_exit_outlined : Icons.fullscreen,
//         color: color,
//       ),
//     );
//   }
// }
