import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/wallet.dart';

class AssetSearchTextField extends StatelessWidget {
  AssetSearchTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      child: TextField(
        onChanged: (value) =>
            context.read(walletProvider).setToggleAssetFilter(value),
        style: GoogleFonts.roboto(
          fontSize: 17.sp,
          fontWeight: FontWeight.normal,
          color: Color(0xFF055271),
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Container(
            width: 41.w,
            child: Center(
              child: SvgPicture.asset(
                'assets/search.svg',
                width: 19.w,
                height: 19.w,
                color: Color(0xFF055271),
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: 'Search'.tr(),
          hintStyle: GoogleFonts.roboto(
            fontSize: 17.sp,
            fontWeight: FontWeight.normal,
            color: Color(0xFF84ADC6),
          ),
        ),
      ),
    );
  }
}
