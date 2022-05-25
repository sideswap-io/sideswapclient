import 'package:flutter/material.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';

class DUrlLink extends StatelessWidget {
  const DUrlLink({
    super.key,
    required this.text,
    this.url,
  });

  final String text;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            text,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        );
      },
      onPressed: () => openUrl(url ?? text),
    );
  }
}
