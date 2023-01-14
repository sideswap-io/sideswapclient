import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
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
          width: 22,
          height: 22,
          color: const Color(0xFFFF7878),
        );
        borderColor = const Color(0xFFFF7878);
        break;
      case SettingsDialogIcon.restart:
        iconWidget = SvgPicture.asset(
          'assets/restart.svg',
          width: 22,
          height: 22,
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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Color(0xFF1C6086),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
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
                      backgroundColor: const Color(0xFF00C5FF),
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

    if (errorDescription.contains('User declined to sign transaction')) {
      errorDescription = 'Transaction sign declined'.tr();
    }

    if (errorDescription.contains('jade response timeout')) {
      errorDescription = 'Please make sure Jade is turned on'.tr();
    }

    if (errorDescription.contains('jade is not connected')) {
      errorDescription = 'Please make sure Jade is connected'.tr();
    }

    await showDialog<void>(
      context: context,
      barrierDismissible:
          FlavorConfig.isDesktop, // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 343,
            height: 378,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              color: Color(0xFF1C6086),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: const Color(0xFFFF7878),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/error.svg',
                          width: 23,
                          height: 23,
                          color: const Color(0xFFFF7878),
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 343,
        height: 378,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color(0xFF1C6086),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: const Color(0xFFFF7878),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/error.svg',
                    width: 23,
                    height: 23,
                    color: const Color(0xFFFF7878),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
                      Text(
                        'Insufficient funds'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          const SizedBox(width: 12),
                          Text(availableStr),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                          const SizedBox(width: 12),
                          Text(requiredStr),
                          const SizedBox(width: 8),
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
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomBigButton(
                    width: 279,
                    height: 54,
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

class _AmpId extends StatelessWidget {
  const _AmpId({
    required this.ampId,
  });

  final String ampId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        const Text(
          'AMP ID:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            ampId,
            style: const TextStyle(
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await copyToClipboard(
              context,
              ampId,
            );
          },
          icon: SvgPicture.asset(
            'assets/copy2.svg',
            width: 20,
            height: 20,
          ),
        )
      ],
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 390,
        height: 378,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: Color(0xFF1C6086),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: const Color(0xFFFF7878),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/error.svg',
                      width: 23,
                      height: 23,
                      color: const Color(0xFFFF7878),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
                      Text(
                        'Please register your AMP ID at'.tr(),
                      ),
                      const SizedBox(height: 8),
                      DUrlLink(
                        text: 'https://${msg.domainAgent}',
                      ),
                      const SizedBox(height: 20),
                      if (ampId != null) _AmpId(ampId: ampId),
                    ],
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
