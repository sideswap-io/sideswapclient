import 'package:flutter/material.dart';

import 'package:sideswap/common/helpers.dart';

class UrlLinkButton extends StatelessWidget {
  const UrlLinkButton({
    super.key,
    required this.text,
    this.url = '',
    this.icon,
    this.onPressed,
  });

  final String url;
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: double.maxFinite,
      height: 56,
      child: TextButton(
        onPressed: () async {
          if (url.isNotEmpty) {
            await openUrl(url);
            return;
          }
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: const Color(0xFF135579),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          side: const BorderSide(
            color: Color(0xFF135579),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: icon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFF00C5FF),
                  decoration: url.isNotEmpty
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
