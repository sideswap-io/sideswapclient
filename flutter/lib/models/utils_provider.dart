import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/desktop/d_home.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swap/widgets/quote_expired_dialog.dart';

enum SettingsDialogIcon {
  error,
  restart,
}

const kErrorQuoteExpired = 'quote expired';

final utilsProvider = Provider<UtilsProvider>((ref) => UtilsProvider(ref));

class UtilsProvider {
  final Ref ref;

  UtilsProvider(this.ref);

  Future<void> settingsErrorDialog({
    required String title,
    String description = '',
    required String buttonText,
    required void Function(BuildContext context) onPressed,
    String secondButtonText = '',
    void Function(BuildContext context)? onSecondPressed,
    SettingsDialogIcon icon = SettingsDialogIcon.error,
  }) async {
    final context = ref.read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    final Widget? iconWidget;
    final Color? borderColor;

    switch (icon) {
      case SettingsDialogIcon.error:
        iconWidget = SvgPicture.asset(
          'assets/error.svg',
          width: 22.w,
          height: 22.w,
          color: const Color(0xFFFF7878),
        );
        borderColor = const Color(0xFFFF7878);
        break;
      case SettingsDialogIcon.restart:
        iconWidget = SvgPicture.asset(
          'assets/restart.svg',
          width: 22.w,
          height: 22.w,
          color: const Color(0xFF00C5FF),
        );
        borderColor = const Color(0xFF00C5FF);
        break;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
              color: const Color(0xFF1C6086),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 66.w,
                    height: 66.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.w),
                      border: Border.all(
                        color: borderColor!,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: iconWidget,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Text(
                        description,
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54.h,
                      text: buttonText,
                      backgroundColor: const Color(0xFF00C5FF),
                      onPressed: () {
                        onPressed(context);
                      },
                    ),
                  ),
                  if (secondButtonText.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: CustomBigButton(
                        width: double.maxFinite,
                        height: 54.h,
                        text: secondButtonText,
                        backgroundColor: Colors.transparent,
                        textColor: const Color(0xFF00C5FF),
                        onPressed: () {
                          if (onSecondPressed != null) {
                            onSecondPressed(context);
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showErrorDialog(String errorDescription,
      {String? buttonText}) async {
    final context = ref.read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    if (errorDescription == kErrorQuoteExpired) {
      showQuoteExpiredDialog(context);
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible:
          FlavorConfig.isDesktop, // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Container(
            width: 343.w,
            height: 378.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
              color: const Color(0xFF1C6086),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.w),
                        border: Border.all(
                          color: const Color(0xFFFF7878),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/error.svg',
                          width: 23.w,
                          height: 23.w,
                          color: const Color(0xFFFF7878),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsets.only(top: 32.h),
                      child: SizedBox(
                        height: 75.h,
                        child: SingleChildScrollView(
                          child: Text(
                            errorDescription,
                            style: GoogleFonts.roboto(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: CustomBigButton(
                        width: 279.w,
                        height: 54.h,
                        text: buttonText ?? 'TRY AGAIN'.tr(),
                        backgroundColor: const Color(0xFF00C5FF),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showInsufficienFunds(From_ShowInsufficientFunds msg) async {
    final context = ref.read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible:
          FlavorConfig.isDesktop, // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return _InsufficientFunds(msg: msg);
      },
    );
  }

  Future<void> showUnregisteredGaid(
      From_SubmitResult_UnregisteredGaid msg) async {
    final context = ref.read(walletProvider).navigatorKey.currentContext;
    if (context == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible:
          FlavorConfig.isDesktop, // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return _UnregisteredGaid(msg: msg);
      },
    );
  }
}

class _InsufficientFunds extends ConsumerWidget {
  const _InsufficientFunds({
    required this.msg,
  });

  final From_ShowInsufficientFunds msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final asset = wallet.assets[msg.assetId]!;
    final icon = wallet.assetImagesVerySmall[asset.assetId]!;
    final availableStr = amountStrNamed(msg.available.toInt(), asset.ticker,
        precision: asset.precision);
    final requiredStr = amountStrNamed(msg.required.toInt(), asset.ticker,
        precision: asset.precision);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Container(
        width: 343.w,
        height: 378.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.w),
          ),
          color: const Color(0xFF1C6086),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.w),
                    border: Border.all(
                      color: const Color(0xFFFF7878),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/error.svg',
                      width: 23.w,
                      height: 23.w,
                      color: const Color(0xFFFF7878),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Column(
                    children: [
                      Text(
                        'Insufficient funds'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Text(
                            'Available'.tr(),
                            style: const TextStyle(
                              color: Color(0xFF569BBA),
                            ),
                          ),
                          const Spacer(),
                          icon,
                          SizedBox(width: 12.w),
                          Text(availableStr),
                          SizedBox(width: 8.w),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            'Required'.tr(),
                            style: const TextStyle(
                              color: Color(0xFF569BBA),
                            ),
                          ),
                          const Spacer(),
                          icon,
                          SizedBox(width: 12.w),
                          Text(requiredStr),
                          SizedBox(width: 8.w),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: CustomBigButton(
                    width: 279.w,
                    height: 54.h,
                    text: 'OK'.tr(),
                    backgroundColor: const Color(0xFF00C5FF),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnregisteredGaid extends ConsumerWidget {
  const _UnregisteredGaid({
    required this.msg,
  });

  final From_SubmitResult_UnregisteredGaid msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ampId = ref.watch(walletProvider).ampId;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Container(
        width: 390.w,
        height: 378.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8.w),
          ),
          color: const Color(0xFF1C6086),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.w),
                    border: Border.all(
                      color: const Color(0xFFFF7878),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/error.svg',
                      width: 23.w,
                      height: 23.w,
                      color: const Color(0xFFFF7878),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Column(
                    children: [
                      Text(
                        'Please register your AMP ID at'.tr(),
                      ),
                      SizedBox(height: 8.h),
                      DUrlLink(
                        text: 'https://${msg.domainAgent}',
                      ),
                      SizedBox(height: 20.h),
                      if (ampId != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AmpId(ampId: ampId),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: CustomBigButton(
                    width: 279.w,
                    height: 54.h,
                    text: 'OK'.tr(),
                    backgroundColor: const Color(0xFF00C5FF),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
