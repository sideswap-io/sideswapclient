import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/insufficient_funds.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

abstract class DialogPresenter {
  Future<void> showSettingsErrorDialog(
    BuildContext context, {
    required String title,
    String description,
    required String buttonText,
    required void Function(BuildContext context) onPressed,
    String secondButtonText,
    void Function(BuildContext context)? onSecondPressed,
    SettingsDialogIcon icon,
    double? width,
  });

  Future<void> showErrorDialog(
    BuildContext context,
    String errorDescription, {
    String? buttonText,
  });

  Future<void> showInsufficientFundsDialog(
    BuildContext context,
    From_ShowInsufficientFunds msg,
  );
}

class FlutterDialogPresenter implements DialogPresenter {
  @override
  Future<void> showSettingsErrorDialog(
    BuildContext context, {
    required String title,
    String description = '',
    required String buttonText,
    required void Function(BuildContext context) onPressed,
    String secondButtonText = '',
    void Function(BuildContext context)? onSecondPressed,
    SettingsDialogIcon icon = SettingsDialogIcon.error,
    double? width,
  }) async {
    final Widget? iconWidget;
    final Color? borderColor;

    switch (icon) {
      case SettingsDialogIcon.error:
        iconWidget = SvgPicture.asset(
          'assets/error.svg',
          width: 23,
          height: 23,
          colorFilter: const ColorFilter.mode(
            SideSwapColors.bitterSweet,
            BlendMode.srcIn,
          ),
        );
        borderColor = SideSwapColors.bitterSweet;
        break;
      case SettingsDialogIcon.restart:
        iconWidget = SvgPicture.asset(
          'assets/restart.svg',
          width: 23,
          height: 23,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        );
        borderColor = SideSwapColors.brightTurquoise;
        break;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
            child: SizedBox(
              width: width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: borderColor!,
                          width: 4,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(child: iconWidget),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: CustomBigButton(
                        width: double.maxFinite,
                        height: 54,
                        text: buttonText,
                        backgroundColor: SideSwapColors.brightTurquoise,
                        onPressed: () {
                          onPressed(context);
                        },
                      ),
                    ),
                    if (secondButtonText.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: CustomBigButton(
                          width: double.maxFinite,
                          height: 54,
                          text: secondButtonText,
                          backgroundColor: Colors.transparent,
                          textColor: SideSwapColors.brightTurquoise,
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
          ),
        );
      },
    );
  }

  @override
  Future<void> showErrorDialog(
    BuildContext context,
    String errorDescription, {
    String? buttonText,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible:
          FlavorConfig.isDesktop, // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return KeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKeyEvent: (value) {
            if (FlavorConfig.isDesktop &&
                value is KeyDownEvent &&
                value.logicalKey == LogicalKeyboardKey.enter) {
              Navigator.of(context).pop();
            }
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: 343,
              height: 378,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: SideSwapColors.blumine,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: SideSwapColors.bitterSweet,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/error.svg',
                          width: 23,
                          height: 23,
                          colorFilter: const ColorFilter.mode(
                            SideSwapColors.bitterSweet,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: SizedBox(
                          height: 75,
                          child: SingleChildScrollView(
                            child: Text(
                              errorDescription,
                              style: const TextStyle(
                                fontSize: 20,
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
                        padding: const EdgeInsets.only(top: 16),
                        child: CustomBigButton(
                          width: 279,
                          height: 54,
                          text: buttonText ?? 'TRY AGAIN'.tr(),
                          backgroundColor: SideSwapColors.brightTurquoise,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> showInsufficientFundsDialog(
    BuildContext context,
    From_ShowInsufficientFunds msg,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: FlavorConfig.isDesktop,
      builder: (BuildContext context) {
        return KeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKeyEvent: (KeyEvent event) {
            if (FlavorConfig.isDesktop &&
                event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              Navigator.of(context).pop();
            }
          },
          child: InsufficientFunds(msg: msg),
        );
      },
    );
  }
}
