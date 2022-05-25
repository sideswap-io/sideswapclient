import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

enum SettingsButtonType {
  recovery,
  shield,
  about,
  delete,
  userDetails,
  network,
}

class SettingsButton extends StatefulWidget {
  const SettingsButton({
    super.key,
    this.transparent = false,
    this.type = SettingsButtonType.recovery,
    required this.text,
    this.onPressed,
  });

  final bool transparent;
  final SettingsButtonType type;
  final String text;
  final VoidCallback? onPressed;

  @override
  SettingsButtonState createState() => SettingsButtonState();
}

class SettingsButtonState extends State<SettingsButton> {
  late Widget _icon;

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case SettingsButtonType.recovery:
        _icon = SvgPicture.asset(
          'assets/recovery.svg',
          width: 24.w,
          height: 24.w,
        );
        break;
      case SettingsButtonType.shield:
        _icon = SvgPicture.asset(
          'assets/shield.svg',
          width: 24.w,
          height: 24.w,
        );
        break;
      case SettingsButtonType.about:
        _icon = SvgPicture.asset(
          'assets/about.svg',
          width: 24.w,
          height: 24.w,
        );
        break;
      case SettingsButtonType.delete:
        _icon = SvgPicture.asset(
          'assets/delete.svg',
          width: 24.w,
          height: 24.w,
        );
        break;
      case SettingsButtonType.userDetails:
        _icon = SvgPicture.asset(
          'assets/user_details.svg',
          width: 24.w,
          height: 24.w,
        );
        break;
      case SettingsButtonType.network:
        _icon = SvgPicture.asset(
          'assets/network.svg',
          width: 24.w,
          height: 24.w,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.w,
      width: double.infinity,
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor:
              widget.transparent ? Colors.transparent : const Color(0xFF135579),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.w),
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
              padding: EdgeInsets.only(left: 17.w),
              child: _icon,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Text(
                widget.text,
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
