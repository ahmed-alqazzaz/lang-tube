import 'package:flutter/material.dart';

import '../../../main.dart';

class BrowserSuggestionsList extends StatelessWidget {
  const BrowserSuggestionsList({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  final List<String> suggestions;
  final void Function(String suggestion) onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: LangTube.backgroundColor,
      child: ListView.separated(
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 2),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                suggestions[index],
                style: const TextStyle(color: LangTube.tmp),
              ),
              leading: const Icon(
                Icons.search,
                size: 30,
                color: LangTube.tmp,
              ),
              trailing: const Icon(
                Icons.arrow_outward_rounded,
                size: 30,
                color: LangTube.tmp,
              ),
            ),
          );
        },
      ),
    );
  }
}
