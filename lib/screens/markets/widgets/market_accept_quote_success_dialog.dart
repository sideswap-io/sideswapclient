import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/widgets/success_icon.dart';

const acceptQuoteSuccessRouteName = '/acceptQuoteSuccessDialog';

class MarketAcceptQuoteSuccessDialog extends HookConsumerWidget {
  const MarketAcceptQuoteSuccessDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != acceptQuoteSuccessRouteName;
      });
    });

    return switch (FlavorConfig.isDesktop) {
      true => AcceptQuoteSuccessDialog(onClose: closeCallback),
      _ => MobileAcceptQuoteSuccessDialog(onClose: closeCallback),
    };
  }
}

class AcceptQuoteSuccessDialog extends HookConsumerWidget {
  const AcceptQuoteSuccessDialog({required this.onClose, super.key});

  final void Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .dialogTheme
        .merge(
          const DContentDialogThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
          ),
        );

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 480, maxHeight: 256),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuccessIcon(
              width: 32,
              height: 32,
              iconColor: Colors.white,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: SideSwapColors.brightTurquoise,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text('Swap successfully accepted'.tr()),
          ],
        ),
        onClose: () {
          onClose();
        },
      ),
      content: SizedBox(
        width: 480,
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Spacer(),
              DCustomFilledBigButton(
                onPressed: () {
                  onClose();
                },
                child: Text('OK'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileAcceptQuoteSuccessDialog extends HookConsumerWidget {
  const MobileAcceptQuoteSuccessDialog({required this.onClose, super.key});

  final void Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      onClose: () {
        onClose();
      },
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 32),
            SuccessIcon(width: 166, height: 166),
            SizedBox(height: 32),
            Text(
              'Swap successfully accepted'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 24),
            Spacer(),
            CustomBigButton(
              width: double.infinity,
              height: 54,
              text: 'OK'.tr(),
              backgroundColor: SideSwapColors.brightTurquoise,
              onPressed: () {
                onClose();
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
