import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/avatar_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/screens/onboarding/import_avatar_resizer.dart';

class ImageSourceChooser extends ConsumerWidget {
  const ImageSourceChooser({
    Key? key,
    this.resizerData,
  }) : super(key: key);

  final ImportAvatarResizerData? resizerData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(14.w),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.maxFinite,
          height: 115.h,
          color: const Color(0xFFF8F8F8).withOpacity(0.92),
          child: Column(
            children: [
              CustomBigButton(
                width: double.maxFinite,
                height: 56.h,
                text: 'Open camera'.tr(),
                textStyle: GoogleFonts.sourceSansPro(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
                textColor: const Color(0xFF007AFF),
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.zero,
                  ),
                ),
                onPressed: () async {
                  if (await ref.read(avatarProvider).loadCameraImage()) {
                    Navigator.pop(context);
                    await Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (context) => ImportAvatarResizer(
                          resizerData: resizerData,
                        ),
                      ),
                    );
                    return;
                  }

                  final error =
                      ref.read(avatarProvider).avatarProviderError;
                  if (error != null) {
                    await ref.read(utilsProvider).showErrorDialog(
                        'UNABLE_TO_LOAD_IMAGE'.tr(args: ['$error']));
                  }
                },
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black.withOpacity(0.2),
              ),
              CustomBigButton(
                width: double.maxFinite,
                height: 56.h,
                text: 'Choose from gallery'.tr(),
                textStyle: GoogleFonts.sourceSansPro(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                ),
                textColor: const Color(0xFF007AFF),
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.zero,
                  ),
                ),
                onPressed: () async {
                  if (await ref.read(avatarProvider).loadGalleryImage()) {
                    Navigator.pop(context);
                    await Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (context) => ImportAvatarResizer(
                          resizerData: resizerData,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
