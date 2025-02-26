import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class MarketsBottomButtonsPanel extends ConsumerWidget {
  const MarketsBottomButtonsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.maxFinite,
      height: 59,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            MarketTypeButton(
              marketTypeSwitchState: MarketTypeSwitchState.market(),
            ),
            SizedBox(width: 16),
            MarketTypeButton(
              marketTypeSwitchState: MarketTypeSwitchState.limit(),
            ),
          ],
        ),
      ),
    );
  }
}

class MarketTypeButton extends ConsumerWidget {
  const MarketTypeButton({super.key, required this.marketTypeSwitchState});

  final MarketTypeSwitchState marketTypeSwitchState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: CustomBigButton(
        height: 39,
        text:
            marketTypeSwitchState == MarketTypeSwitchState.market()
                ? 'Market order'.tr()
                : 'Limit order'.tr(),
        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.32,
        ),
        backgroundColor: SideSwapColors.turquoise,
        onPressed: () {
          (switch (marketTypeSwitchState) {
            MarketTypeSwitchStateMarket() => ref
                .read(pageStatusNotifierProvider.notifier)
                .setStatus(Status.marketSwap),
            MarketTypeSwitchStateLimit() => ref
                .read(pageStatusNotifierProvider.notifier)
                .setStatus(Status.marketLimit),
          });
        },
      ),
    );
  }
}
