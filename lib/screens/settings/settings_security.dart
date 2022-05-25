import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class SettingsSecurity extends StatelessWidget {
  const SettingsSecurity({
    super.key,
    this.value = false,
    this.onTap,
    this.icon = Icons.fingerprint,
    this.description = '',
  });

  final bool value;
  final VoidCallback? onTap;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: InkWell(
        onTap: onTap,
        child: AbsorbPointer(
          child: SizedBox(
            height: 60.w,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: const Color(0xFF135579),
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
                    padding: EdgeInsets.only(left: 16.w),
                    child: Icon(
                      icon,
                      size: 24.h,
                      color: const Color(0xFF00C5FF),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      description,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 19.w),
                    child: FlutterSwitch(
                      value: value,
                      onToggle: (val) {},
                      width: 51.h,
                      height: 31.h,
                      toggleSize: 27.h,
                      padding: 2.h,
                      activeColor: const Color(0xFF00C5FF),
                      inactiveColor: const Color(0xFF164D6A),
                      toggleColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
