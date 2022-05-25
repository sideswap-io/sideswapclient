import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/screens/onboarding/import_avatar_resizer.dart';
import 'package:sideswap/screens/onboarding/widgets/image_source_chooser.dart';

class ChooseAvatarImage extends StatelessWidget {
  const ChooseAvatarImage({
    super.key,
    this.resizerData,
  });

  final ImportAvatarResizerData? resizerData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          ImageSourceChooser(
            resizerData: resizerData,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: CustomBigButton(
              width: double.maxFinite,
              height: 57.h,
              text: 'CANCEL'.tr(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(14.w),
                ),
              ),
              backgroundColor: Colors.white.withOpacity(0.92),
              textColor: const Color(0xFF007AFF),
              onPressed: () async {
                Navigator.pop(context);
              },
              textStyle: GoogleFonts.sourceSansPro(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
