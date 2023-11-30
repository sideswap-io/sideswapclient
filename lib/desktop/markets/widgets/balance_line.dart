import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class BalanceLine extends ConsumerWidget {
  const BalanceLine({
    super.key,
    this.onMaxPressed,
    this.amountSide = false,
  });

  final VoidCallback? onMaxPressed;
  final bool amountSide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final makeOrderSide = ref.watch(makeOrderSideStateProvider);

    return SizedBox(
      height: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: switch (makeOrderSide) {
                    MakeOrderSide.sell => BalanceLineSellSide(
                        amountSide: amountSide,
                      ),
                    MakeOrderSide.buy => BalanceLineBuySide(
                        amountSide: amountSide,
                      ),
                  },
                ),
              ),
            ],
          ),
          switch (onMaxPressed) {
            final onMaxPressed? => SizedBox(
                width: 56,
                height: 24,
                child: DHoverButton(
                  builder: (context, states) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 13),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                          color: SideSwapColors.brightTurquoise,
                        ),
                        color:
                            states.isFocused ? const Color(0xFF007CA1) : null,
                      ),
                      child: Text(
                        'Max'.tr().toUpperCase(),
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: SideSwapColors.brightTurquoise,
                                ),
                      ),
                    );
                  },
                  onPressed: onMaxPressed,
                ),
              ),
            _ => const SizedBox(),
          },
        ],
      ),
    );
  }
}

class BalanceLineBuySide extends ConsumerWidget {
  const BalanceLineBuySide({
    super.key,
    this.amountSide = false,
  });

  final bool amountSide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aggregateVolume = ref.watch(marketOrderAggregateVolumeProvider);
    final aggregateTicker = ref.watch(marketOrderAggregateVolumeTickerProvider);
    final aggregateTooHigh = ref.watch(makeOrderAggregateVolumeTooHighProvider);

    final balance = ref.watch(makeOrderBalanceProvider);
    final makeOrderSide = ref.watch(makeOrderSideStateProvider);
    final isSell = makeOrderSide == MakeOrderSide.sell;
    final balanceHint = isSell ? 'Balance'.tr() : 'Buying power'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!amountSide) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$balanceHint:',
                style: const TextStyle(
                  fontSize: 13,
                  color: SideSwapColors.airSuperiorityBlue,
                ),
              ),
              Row(
                children: [
                  Text(
                    balance.balanceString,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF96C6E4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Consumer(
                    builder: (context, ref, _) {
                      final icon = ref
                          .watch(assetImageProvider)
                          .getSmallImage(balance.assetId);

                      return SizedBox(width: 16, height: 16, child: icon);
                    },
                  ),
                  const SizedBox(width: 2),
                  Text(
                    balance.ticker,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF96C6E4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aggregate bid amount:'.tr(),
                style: TextStyle(
                  fontSize: 13,
                  color: aggregateTooHigh
                      ? SideSwapColors.bitterSweet
                      : SideSwapColors.airSuperiorityBlue,
                ),
              ),
              Row(
                children: [
                  Text(
                    aggregateVolume.asString(),
                    style: TextStyle(
                      fontSize: 13,
                      color: aggregateTooHigh
                          ? SideSwapColors.bitterSweet
                          : const Color(0xFF96C6E4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Consumer(
                    builder: (context, ref, _) {
                      final icon = ref
                          .watch(assetImageProvider)
                          .getSmallImage(aggregateVolume.accountAsset?.assetId);

                      return SizedBox(width: 16, height: 16, child: icon);
                    },
                  ),
                  const SizedBox(width: 2),
                  Text(
                    aggregateTicker,
                    style: TextStyle(
                      fontSize: 13,
                      color: aggregateTooHigh
                          ? SideSwapColors.bitterSweet
                          : const Color(0xFF96C6E4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class BalanceLineSellSide extends ConsumerWidget {
  const BalanceLineSellSide({
    super.key,
    this.amountSide = false,
  });

  final bool amountSide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aggregateVolume = ref.watch(marketOrderAggregateVolumeProvider);
    final aggregateTicker = ref.watch(marketOrderAggregateVolumeTickerProvider);
    final balance = ref.watch(makeOrderBalanceProvider);
    final makeOrderSide = ref.watch(makeOrderSideStateProvider);
    final isSell = makeOrderSide == MakeOrderSide.sell;
    final balanceHint = isSell ? 'Balance'.tr() : 'Buying power'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (amountSide) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$balanceHint:',
                style: const TextStyle(
                  fontSize: 13,
                  color: SideSwapColors.airSuperiorityBlue,
                ),
              ),
              Row(
                children: [
                  Text(
                    balance.balanceString,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF96C6E4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Consumer(
                    builder: (context, ref, _) {
                      final icon = ref
                          .watch(assetImageProvider)
                          .getSmallImage(balance.assetId);

                      return SizedBox(width: 16, height: 16, child: icon);
                    },
                  ),
                  const SizedBox(width: 2),
                  Text(
                    balance.ticker,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF96C6E4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aggregate offer value:'.tr(),
                style: const TextStyle(
                  fontSize: 13,
                  color: SideSwapColors.airSuperiorityBlue,
                ),
              ),
              Row(
                children: [
                  Text(
                    aggregateVolume.asString(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF96C6E4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Consumer(
                    builder: (context, ref, _) {
                      final icon = ref
                          .watch(assetImageProvider)
                          .getSmallImage(aggregateVolume.accountAsset?.assetId);

                      return SizedBox(width: 16, height: 16, child: icon);
                    },
                  ),
                  const SizedBox(width: 2),
                  Text(
                    aggregateTicker,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF96C6E4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
