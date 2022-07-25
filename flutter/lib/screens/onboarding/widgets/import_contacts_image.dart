import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sideswap/screens/onboarding/widgets/contact_mockup_container.dart';

class ImportContactsImage extends StatelessWidget {
  const ImportContactsImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 192,
      height: 202,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 43),
            child: SvgPicture.asset(
              'assets/device_frame.svg',
              width: 106,
              height: 202,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 21),
            child: ContactMockupContainer(
              icon: ContactMockupIcon.male1,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 77, left: 76),
            child: ContactMockupContainer(
              icon: ContactMockupIcon.female1,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 133),
            child: ContactMockupContainer(
              icon: ContactMockupIcon.male2,
            ),
          ),
        ],
      ),
    );
  }
}
