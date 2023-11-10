import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';

class PaymentSendPopup extends StatelessWidget {
  const PaymentSendPopup({super.key});

  @override
  Widget build(BuildContext context) {
    var dollarConversion = '0.0';

    return SideSwapPopup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Consumer(
              builder: (context, ref, _) {
                final selectedWalletAsset =
                    ref.watch(selectedWalletAssetProvider);
                final asset = ref.watch(assetsStateProvider
                    .select((value) => value[selectedWalletAsset?.assetId]));
                final precision = ref
                    .watch(assetUtilsProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                final sendAmountParsed = ref
                    .watch(paymentProvider.select((p) => p.sendAmountParsed));
                final amountProvider = ref.watch(amountToStringProvider);
                final sendAmountStr = amountProvider.amountToString(
                    AmountToStringParameters(
                        amount: sendAmountParsed, precision: precision));

                final amount = '$sendAmountStr ${asset?.ticker}';
                return Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Consumer(
              builder: (context, ref, _) {
                final selectedWalletAsset =
                    ref.watch(selectedWalletAssetProvider);
                final asset = ref.watch(assetsStateProvider
                    .select((value) => value[selectedWalletAsset?.assetId]));
                final precision = ref
                    .watch(assetUtilsProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                final sendAmountParsed = ref
                    .watch(paymentProvider.select((p) => p.sendAmountParsed));
                final amountProvider = ref.watch(amountToStringProvider);
                final amountStr = amountProvider.amountToString(
                    AmountToStringParameters(
                        amount: sendAmountParsed, precision: precision));
                final amount = double.tryParse(amountStr) ?? 0;
                dollarConversion = ref
                    .watch(walletProvider)
                    .getAmountUsd(asset?.assetId ?? '', amount)
                    .toStringAsFixed(2);

                dollarConversion = replaceCharacterOnPosition(
                  input: dollarConversion,
                  currencyChar: '\$',
                  currencyCharAlignment: CurrencyCharAlignment.begin,
                );
                final visibleConversion = ref
                    .watch(walletProvider)
                    .isAmountUsdAvailable(asset?.assetId);

                return Text(
                  visibleConversion ? '≈ $dollarConversion' : '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFD3E5F0),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: DottedLine(
              dashColor: SideSwapColors.jellyBean,
              dashGapColor: Colors.transparent,
              dashLength: 1.0,
              dashGapLength: 0.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Consumer(builder: (context, ref, _) {
              final details =
                  ref.watch(paymentProvider.select((p) => p.sendAddrParsed));
              return TxDetailsColumn(
                description: 'To'.tr(),
                details: details,
                detailsStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              );
            }),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: DottedLine(
              dashColor: SideSwapColors.jellyBean,
              dashGapColor: Colors.transparent,
              dashLength: 1.0,
              dashGapLength: 0.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Consumer(builder: (context, ref, _) {
              final sendNetworkFee =
                  ref.watch(paymentProvider.select((p) => p.sendNetworkFee));
              final amountProvider = ref.watch(amountToStringProvider);
              final networkFeeAmount = amountProvider.amountToStringNamed(
                  AmountToStringNamedParameters(
                      amount: sendNetworkFee, ticker: kLiquidBitcoinTicker));
              return TxDetailsColumn(
                description: 'Network Fee'.tr(),
                details: networkFeeAmount,
                detailsStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              );
            }),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: DottedLine(
              dashColor: SideSwapColors.jellyBean,
              dashGapColor: Colors.transparent,
              dashLength: 1.0,
              dashGapLength: 0.0,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: Consumer(builder: (context, ref, _) {
              final buttonEnabled =
                  !ref.watch(walletProvider.select((p) => p.isSendingTx));
              return CustomBigButton(
                width: MediaQuery.of(context).size.width,
                height: 54,
                backgroundColor: SideSwapColors.brightTurquoise,
                text: 'SEND'.tr(),
                enabled: buttonEnabled,
                onPressed: buttonEnabled
                    ? () async {
                        if (await ref.read(walletProvider).isAuthenticated()) {
                          ref.read(walletProvider).assetSendConfirmMobile();
                        }
                      }
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }
}
