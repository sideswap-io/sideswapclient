import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/markets/market_select_popup.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketHeader extends StatelessWidget {
  const MarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [SideSwapColors.ataneoBlue, SideSwapColors.prussianBlue],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            MarketHeaderTickerDropdown(),
            Spacer(),
            MarketHeaderBuySellButtons(),
            SizedBox(width: 8),
            MarketHeaderCloseButton(),
          ],
        ),
      ),
    );
  }
}

class MarketHeaderTickerDropdown extends ConsumerWidget {
  const MarketHeaderTickerDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productName = ref.watch(subscribedMarketProductNameProvider);

    return TextButton(
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push<void>(
          MaterialPageRoute(
            builder: (context) {
              return MarketSelectPopup();
            },
          ),
        );
      },
      child: Row(
        children: [
          Text(
            productName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(height: 0.05),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.expand_more, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}

class MarketHeaderBuySellButtons extends HookConsumerWidget {
  const MarketHeaderBuySellButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);

    return Material(
      color: Colors.transparent,
      child: SwitchButton(
        width: 130,
        height: 35,
        borderRadius: 8,
        borderWidth: 2,
        fontSize: 13,
        activeText: 'Sell'.tr(),
        inactiveText: 'Buy'.tr(),
        value: tradeDirState == TradeDir.SELL,
        activeToggleBackground:
            tradeDirState == TradeDir.SELL
                ? SideSwapColors.bitterSweet
                : SideSwapColors.turquoise,
        inactiveToggleBackground: SideSwapColors.darkCerulean,
        backgroundColor: SideSwapColors.darkCerulean,
        borderColor: SideSwapColors.darkCerulean,
        onToggle: (value) {
          if (value) {
            ref
                .read(tradeDirStateNotifierProvider.notifier)
                .setSide(TradeDir.SELL);
          } else {
            ref
                .read(tradeDirStateNotifierProvider.notifier)
                .setSide(TradeDir.BUY);
          }
        },
      ),
    );
  }
}

class MarketHeaderCloseButton extends ConsumerWidget {
  const MarketHeaderCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 24,
      height: 24,
      child: TextButton(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: () {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
        },
        child: const Icon(Icons.close, color: SideSwapColors.pewterBlue),
      ),
    );
  }
}
