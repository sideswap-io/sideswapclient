import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          ImageSourceChooser(
            resizerData: resizerData,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CustomBigButton(
              width: double.maxFinite,
              height: 57,
              text: 'CANCEL'.tr(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
              backgroundColor: Colors.white.withOpacity(0.92),
              textColor: const Color(0xFF007AFF),
              onPressed: () async {
                Navigator.pop(context);
              },
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
