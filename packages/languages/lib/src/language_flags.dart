import 'package:flutter/material.dart';

sealed class LangaugeFlags {
  static Image get german => Image.network(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Flag_of_Germany.svg/800px-Flag_of_Germany.svg.png",
        fit: BoxFit.cover,
      );
  static Image get french => Image.network(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/800px-Flag_of_France.svg.png",
        fit: BoxFit.cover,
      );
  static Image get arabic => Image.network(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/800px-Flag_of_France.svg.png",
        fit: BoxFit.cover,
      );
  static Image get english => Image.network(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Flag_of_France.svg/800px-Flag_of_France.svg.png",
        fit: BoxFit.cover,
      );
}
