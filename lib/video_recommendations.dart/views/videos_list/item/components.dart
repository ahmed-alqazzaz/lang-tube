import 'package:flutter/material.dart';

import '../../generics/circular_inkwell.dart';

mixin VideoItemComponents {
  Widget thumbnailBuilder(String thumbnailUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.asset(
        thumbnailUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget channelIconBuilder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        "https://yt3.ggpht.com/qWTXkB8Y-a7sAr8eZ8v_jpaBk4NXYZ3jd6GuSFOGHqTNZY6bZ275gfFrmw9UF3Rkzs9XICtFeXs=s68-c-k-c0x00ffffff-no-rj",
        fit: BoxFit.cover,
        width: 36,
        height: 36,
      ),
    );
  }

  Widget titleBuilder({required String title, required int maxLines}) {
    return Builder(
      builder: (context) {
        return Text(
          title,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 15,
              ),
        );
      },
    );
  }

  Widget badgeBuilder({required String badge}) {
    return Builder(
      builder: (context) {
        return Text(
          badge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium,
        );
      },
    );
  }

  //  Widget _itemLarge() {
  //   return Column(
  //     children: [
  //       _thumbnailBuilder(),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         child: Row(
  //           children: [
  //             _channelIconBuilder(),
  //             Expanded(
  //               child: _titleBuilder(
  //                 text:
  //                     "Here's what Kushner's testimony reveals about special counsel investigation",
  //                 maxLines: 2,
  //               ),
  //             ),
  //             const SizedBox(width: 30),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
