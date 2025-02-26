import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/error_icon.dart';

class MobileStartOrderErrorDialog extends HookConsumerWidget {
  const MobileStartOrderErrorDialog({required this.onClose, super.key});

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
            SizedBox(height: 100),
            ErrorIcon(width: 166, height: 166),
            SizedBox(height: 32),
            Text(
              'Order error'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final optionStartOrderError = ref.watch(
                  marketStartOrderErrorNotifierProvider,
                );

                return optionStartOrderError.match(
                  () => () {
                    return SizedBox();
                  },
                  (startOrderError) => () {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(startOrderError.error)],
                    );
                  },
                )();
              },
            ),
            Spacer(),
            CustomBigButton(
              width: double.infinity,
              height: 54,
              text: 'CLOSE'.tr(),
              backgroundColor: SideSwapColors.brightTurquoise,
              onPressed: () {
                onClose();
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
