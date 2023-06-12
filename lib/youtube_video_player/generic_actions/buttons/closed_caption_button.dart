// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lang_tube/youtube_video_player/generic_actions/actions_provider.dart';

// class ClosedCaptionsButton extends ConsumerWidget {
//   const ClosedCaptionsButton({super.key});

//   static const color = Colors.white;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isEnabled = ref
//         .watch(actionsProvider.select((model) => model.isClosedCaptionEnabled));
//     return IconButton(
//       iconSize: 30,
//       onPressed: () {
//         ref.read(actionsProvider).toggleClosedCaptionsButton();
//       },
//       icon: Icon(
//         isEnabled
//             ? Icons.closed_caption_outlined
//             : Icons.closed_caption_off_outlined,
//         color: color,
//         weight: 1,
//       ),
//     );
//   }
// }
