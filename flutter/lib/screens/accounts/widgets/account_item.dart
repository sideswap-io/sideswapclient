import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class AccountItem extends ConsumerWidget {
  final AccountAsset accountAsset;
  final int balance;
  final ValueChanged<AccountAsset> onSelected;
  final bool disabled;
  const AccountItem({
    super.key,
    required this.accountAsset,
    this.balance = 0,
    required this.onSelected,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final asset = ref.watch(
        assetsStateProvider.select((value) => value[accountAsset.asset]));
    final icon = ref.watch(assetImageProvider).getBigImage(accountAsset.asset);
    final precision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: accountAsset.asset);
    final balance = ref.watch(balancesProvider).balances[accountAsset] ?? 0;
    final amountProvider = ref.watch(amountToStringProvider);
    final amountString = amountProvider.amountToString(
        AmountToStringParameters(amount: balance, precision: precision));
    final isAmp = accountAsset.account.isAmp();
    final amount = precision == 0
        ? int.tryParse(amountString) ?? 0
        : double.tryParse(amountString) ?? .0;
    final amountUsd = wallet.getAmountUsd(accountAsset.asset, amount);
    var dollarConversion = '0.0';
    dollarConversion = amountUsd.toStringAsFixed(2);
    dollarConversion =
        replaceCharacterOnPosition(input: dollarConversion, currencyChar: '\$');
    final textColor = disabled ? const Color(0xFFAAAAAA) : Colors.white;
    final backgrounColor =
        disabled ? const Color(0xFF034569) : SideSwapColors.chathamsBlue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 80,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgrounColor,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: disabled
              ? null
              : () {
                  onSelected(accountAsset);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: icon,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: 48,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  asset?.name ?? '',
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Consumer(
                                builder: (context, ref, child) {
                                  final bitcoinAssetId =
                                      ref.watch(bitcoinAssetIdProvider);
                                  return Visibility(
                                    visible: asset?.assetId != bitcoinAssetId,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        amountString,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.normal,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    asset?.ticker ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF6B91A8),
                                    ),
                                  ),
                                  if (isAmp) const AmpFlag(fontSize: 14),
                                ],
                              ),
                              if (amountUsd != 0) ...[
                                Text(
                                  '≈ $dollarConversion',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF6B91A8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
