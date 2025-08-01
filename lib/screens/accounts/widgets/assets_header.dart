import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class AssetsHeader extends ConsumerWidget {
  const AssetsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allVisibleAssets = ref.watch(allVisibleAssetsProvider);

    final defaultCurrencyConversion = ref.watch(
      assetsTotalDefaultCurrencyBalanceStringProvider(allVisibleAssets),
    );
    final defaultCurrencyTicker = ref.watch(defaultCurrencyTickerProvider);

    final lbtcConversion = ref.watch(
      assetsTotalLbtcBalanceProvider(allVisibleAssets),
    );

    return Container(
      height: 120,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: SideSwapColors.chathamsBlue,
      ),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Total Value'.tr(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                  color: SideSwapColors.airSuperiorityBlue,
                ),
              ),
              Text(
                '$lbtcConversion L-BTC',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 28),
              ),
              Text(
                '$defaultCurrencyTicker $defaultCurrencyConversion',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Row(children: [SizedBox(width: 6), WalletTransactions()]),
          ),
        ],
      ),
    );
  }
}

class WalletTransactions extends HookConsumerWidget {
  const WalletTransactions({
    super.key,
    this.backgroundColor = SideSwapColors.chathamsBlue,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomBigButton(
      width: 32,
      height: 32,
      backgroundColor: backgroundColor,
      onPressed: () {
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.transactions);
      },
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: SvgPicture.asset(
            'assets/transactions_mobile.svg',
            colorFilter: const ColorFilter.mode(
              SideSwapColors.brightTurquoise,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
