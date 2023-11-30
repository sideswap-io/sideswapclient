import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swap/widgets/quote_expired_dialog.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

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
    final context = ref.read(navigatorKeyProvider).currentContext;

    final Widget? iconWidget;
    final Color? borderColor;

    switch (icon) {
      case SettingsDialogIcon.error:
        iconWidget = SvgPicture.asset(
          'assets/error.svg',
          width: 23,
          height: 23,
          colorFilter: const ColorFilter.mode(
              SideSwapColors.bitterSweet, BlendMode.srcIn),
        );
        borderColor = SideSwapColors.bitterSweet;
        break;
      case SettingsDialogIcon.restart:
        iconWidget = SvgPicture.asset(
          'assets/restart.svg',
          width: 23,
          height: 23,
          colorFilter: const ColorFilter.mode(
              SideSwapColors.brightTurquoise, BlendMode.srcIn),
        );
        borderColor = SideSwapColors.brightTurquoise;
        break;
    }
    await showDialog<void>(
      context: context!,
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
              color: SideSwapColors.blumine,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
        );
      },
    );
  }

  Future<void> showErrorDialog(String errorDescription,
      {String? buttonText}) async {
    final context = ref.read(navigatorKeyProvider).currentContext;

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
      errorDescription = 'Please ensure your Jade is turned on'.tr();
    }

    if (errorDescription.contains('jade is not connected')) {
      errorDescription = 'Please ensure your Jade device is connected'.tr();
    }
    await showDialog<void>(
      context: context,
      barrierDismissible:
          FlavorConfig.isDesktop, // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (RawKeyEvent event) {
            if (FlavorConfig.isDesktop &&
                event is RawKeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              Navigator.of(context).pop(); // Dismiss the dialog
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
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: SideSwapColors.blumine,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
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
                              SideSwapColors.bitterSweet, BlendMode.srcIn),
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

  Future<void> showInsufficienFunds(From_ShowInsufficientFunds msg) async {
    final context = ref.read(navigatorKeyProvider).currentContext;

    if (context == null) {
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible: FlavorConfig.isDesktop,
      // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (RawKeyEvent event) {
            if (FlavorConfig.isDesktop &&
                event is RawKeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              Navigator.of(context).pop(); // Dismiss the dialog
            }
          },
          child: InsufficientFunds(msg: msg),
        );
      },
    );
  }

  Future<void> showUnregisteredGaid(
      From_SubmitResult_UnregisteredGaid msg) async {
    final context = ref.read(navigatorKeyProvider).currentContext;

    if (context == null) {
      return;
    }
    await showDialog<void>(
      context: context,
      barrierDismissible:
          FlavorConfig.isDesktop, // Allow close popups with Esc on desktop
      builder: (BuildContext context) {
        return RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (RawKeyEvent event) {
            if (FlavorConfig.isDesktop &&
                event is RawKeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              Navigator.of(context).pop(); // Dismiss the dialog
            }
          },
          child: UnregisteredGaid(msg: msg),
        );
      },
    );
  }
}

class InsufficientFunds extends ConsumerWidget {
  const InsufficientFunds({
    super.key,
    required this.msg,
  });

  final From_ShowInsufficientFunds msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[msg.assetId]));
    final icon =
        ref.watch(assetImageProvider).getVerySmallImage(asset?.assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);

    final availableStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: msg.available.toInt(),
            ticker: asset?.ticker ?? '',
            precision: assetPrecision));
    final requiredStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: msg.required.toInt(),
            ticker: asset?.ticker ?? '',
            precision: assetPrecision));

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
          color: SideSwapColors.blumine,
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
                        SideSwapColors.bitterSweet, BlendMode.srcIn),
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
                              color: SideSwapColors.hippieBlue,
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
                              color: SideSwapColors.hippieBlue,
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
                    backgroundColor: SideSwapColors.brightTurquoise,
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

class UnregisteredGaidAmpId extends StatelessWidget {
  const UnregisteredGaidAmpId({
    super.key,
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

class UnregisteredGaid extends ConsumerWidget {
  const UnregisteredGaid({
    super.key,
    required this.msg,
  });

  final From_SubmitResult_UnregisteredGaid msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ampId = ref.watch(ampIdProvider);
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
          color: SideSwapColors.blumine,
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
                          SideSwapColors.bitterSweet, BlendMode.srcIn),
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
                      if (ampId.isNotEmpty) ...[
                        UnregisteredGaidAmpId(ampId: ampId),
                      ],
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
                    backgroundColor: SideSwapColors.brightTurquoise,
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
