import 'package:flutter/material.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';

class UrlLink extends StatelessWidget {
  final String url;
  UrlLink({this.url = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GestureDetector(
        onTap: () {
          if (url.isNotEmpty) {
            openUrl(url);
          }
        },
        child: Text(url,
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 16,
            )),
      ),
    );
  }
}
