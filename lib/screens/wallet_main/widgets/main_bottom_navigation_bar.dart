import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

class MainBottomNavigationBar extends StatefulWidget {
  MainBottomNavigationBar({Key key, this.onTap, this.currentIndex})
      : super(key: key);

  final ValueChanged<int> onTap;
  final int currentIndex;

  @override
  _MainBottomNavigationBarState createState() =>
      _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF021C36),
        selectedItemColor: Color(0xFF00C5FF),
        unselectedItemColor: Color(0xFF68839E),
        selectedLabelStyle: GoogleFonts.roboto(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        items: [
          BottomNavigationBarItem(
            label: 'Home'.tr(),
            icon: widget.currentIndex == 0
                ? SvgPicture.asset('assets/home_active.svg', height: 24.h)
                : SvgPicture.asset('assets/home.svg', height: 24.h),
          ),
          BottomNavigationBarItem(
            label: 'Accounts'.tr(),
            icon: widget.currentIndex == 1
                ? SvgPicture.asset('assets/accounts_active.svg', height: 24.h)
                : SvgPicture.asset('assets/accounts.svg', height: 24.h),
          ),
          // TODO: uncomment when request will be ready
          // BottomNavigationBarItem(
          //   label: 'Requests'.tr(),
          //   icon: widget.currentIndex == 2
          //       ? SvgPicture.asset('assets/requests_active.svg', height: 24.h)
          //       : SvgPicture.asset('assets/requests.svg', height: 24.h),
          // ),
          BottomNavigationBarItem(
            label: 'Swap'.tr(),
            icon: widget.currentIndex == 2
                ? SvgPicture.asset('assets/swap_active.svg', height: 24.h)
                : SvgPicture.asset('assets/swap.svg', height: 24.h),
          ),
        ],
        onTap: widget.onTap,
      ),
    );
  }
}
