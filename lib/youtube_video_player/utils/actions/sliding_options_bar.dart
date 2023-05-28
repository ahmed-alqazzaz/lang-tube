// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class SlidingOptionsBar extends StatefulWidget {
//   const SlidingOptionsBar({super.key, required this.youtubePlayerController});

//   final YoutubePlayerController youtubePlayerController;
//   @override
//   State<SlidingOptionsBar> createState() => _SlidingOptionsBarState();
// }

// class _SlidingOptionsBarState extends State<SlidingOptionsBar>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animationController;

//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animationController.forward();

//     widget.youtubePlayerController.addListener(slidingListener);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();

//     widget.youtubePlayerController.removeListener(slidingListener);
//     super.dispose();
//   }

//   void slidingListener() {
//     final areControlsVisible =
//         widget.youtubePlayerController.value.isControlsVisible;
//     final currentAnimationOffset = _animationController.value.toInt();

//     if (areControlsVisible && currentAnimationOffset == 1) {
//       _animationController.reverse();
//     } else if (!areControlsVisible && currentAnimationOffset == 0) {
//       _animationController.forward();
//     }
//   }

//   Widget optionsBar() {
//     final width = MediaQuery.of(context).size.width;
//     return Container(
//       color: Colors.black,
//       constraints: BoxConstraints(
//         maxHeight: 70,
//         minHeight: 70,
//         minWidth: width,
//       ),
//       child: Container(
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Color.fromARGB(
//             255,
//             30,
//             30,
//             31,
//           ), // Customize the color of the circle
//         ),
//         child: IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.pause,
//             size: 30,
//             opticalSize: 50,
//           ),
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position:
//           Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
//         CurvedAnimation(
//           parent: _animationController,
//           curve: Curves.fastOutSlowIn,
//         ),
//       ),
//       child: optionsBar(),
//     );
//   }
// }
