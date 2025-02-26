import 'package:flutter/material.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';

class DUrlLink extends StatelessWidget {
  const DUrlLink({super.key, required this.text, this.url, this.style});

  final String text;
  final String? url;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            text,
            overflow: TextOverflow.clip,
            maxLines: 1,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ).merge(style),
          ),
        );
      },
      onPressed: () => openUrl(url ?? text),
    );
  }
}
