import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class BalanceLine extends ConsumerWidget {
  const BalanceLine({
    super.key,
    required this.assetId,
    required this.onMaxPressed,
  });

  final String assetId;
  final VoidCallback? onMaxPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[assetId]));
    final assetPrecision =
        ref.watch(assetUtilsProvider).getPrecisionForAssetId(assetId: assetId);
    final account = getBalanceAccount(asset);
    final balance = ref.watch(balancesProvider).balances[account] ?? 0;
    final amountProvider = ref.watch(amountToStringProvider);
    final balanceStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: balance,
            ticker: asset?.ticker ?? '',
            precision: assetPrecision));
    final balanceHint =
        onMaxPressed != null ? 'Balance'.tr() : 'Buying power'.tr();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text('$balanceHint: $balanceStr',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF96C6E4),
              )),
        ),
        if (onMaxPressed != null)
          DHoverButton(
            builder: (context, states) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                    color: SideSwapColors.brightTurquoise,
                  ),
                  color: states.isFocused ? const Color(0xFF007CA1) : null,
                ),
                child: Text(
                  'Max'.tr().toUpperCase(),
                  style: const TextStyle(
                    color: SideSwapColors.brightTurquoise,
                    fontSize: 12,
                  ),
                ),
              );
            },
            onPressed: onMaxPressed,
          ),
      ],
    );
  }
}
