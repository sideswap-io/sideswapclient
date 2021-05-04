import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';

class UrlLinkButton extends StatelessWidget {
  const UrlLinkButton({
    Key key,
    @required this.text,
    this.url,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final String url;
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 56.h,
      child: TextButton(
        onPressed: () async {
          if (url != null) {
            await openUrl(url);
            return;
          }

          onPressed();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Container(
                width: 24.w,
                height: 24.w,
                child: icon,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17.w),
              child: Text(
                text ?? '',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF00C5FF),
                  textStyle: TextStyle(
                    decoration: url != null
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Color(0xFF135579),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.w),
            ),
          ),
          side: BorderSide(
            color: Color(0xFF135579),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
