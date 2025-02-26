import 'package:flutter/material.dart';

import 'package:sideswap/common/helpers.dart';

class UrlLink extends StatelessWidget {
  final String url;
  const UrlLink({super.key, this.url = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          if (url.isNotEmpty) {
            openUrl(url);
          }
        },
        child: Text(
          url,
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
