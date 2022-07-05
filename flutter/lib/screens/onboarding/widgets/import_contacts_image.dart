import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/onboarding/widgets/contact_mockup_container.dart';

class ImportContactsImage extends StatelessWidget {
  const ImportContactsImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192.w,
      height: 202.h,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 43.w),
            child: SvgPicture.asset(
              'assets/device_frame.svg',
              width: 106.w,
              height: 202.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 21.h),
            child: const ContactMockupContainer(
              icon: ContactMockupIcon.male1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 77.h, left: 76.w),
            child: const ContactMockupContainer(
              icon: ContactMockupIcon.female1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 133.h),
            child: const ContactMockupContainer(
              icon: ContactMockupIcon.male2,
            ),
          ),
        ],
      ),
    );
  }
}
