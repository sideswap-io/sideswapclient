import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';

class PaymentSendPopup extends StatelessWidget {
  const PaymentSendPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _dollarConversion = '0.0';

    return SideSwapPopup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send',
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00C5FF),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Consumer(
              builder: (context, ref, _) {
                final selectedAsset = ref.watch(
                    walletProvider.select((p) => p.selectedWalletAsset!.asset));
                final asset = ref.watch(
                    walletProvider.select((p) => p.assets[selectedAsset]));
                final precision = ref
                    .watch(walletProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                final sendAmountParsed = ref
                    .watch(paymentProvider.select((p) => p.sendAmountParsed));
                final sendAmountStr =
                    amountStr(sendAmountParsed, precision: precision);
                final amount = '$sendAmountStr ${asset?.ticker}';
                return Text(
                  amount,
                  style: GoogleFonts.roboto(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Consumer(
              builder: (context, ref, _) {
                final selectedAsset = ref.watch(
                    walletProvider.select((p) => p.selectedWalletAsset!.asset));
                final asset = ref.watch(
                    walletProvider.select((p) => p.assets[selectedAsset]));
                final precision = ref
                    .watch(walletProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                final sendAmountParsed = ref
                    .watch(paymentProvider.select((p) => p.sendAmountParsed));
                final amount = double.tryParse(
                        amountStr(sendAmountParsed, precision: precision)) ??
                    0;
                _dollarConversion = ref
                    .watch(walletProvider)
                    .getAmountUsd(asset?.assetId ?? '', amount)
                    .toStringAsFixed(2);

                _dollarConversion = replaceCharacterOnPosition(
                  input: _dollarConversion,
                  currencyChar: '\$',
                  currencyCharAlignment: CurrencyCharAlignment.begin,
                );
                final visibleConversion = ref
                    .watch(walletProvider)
                    .isAmountUsdAvailable(asset?.assetId);

                return Text(
                  visibleConversion ? '≈ $_dollarConversion' : '',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFFD3E5F0),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: const DottedLine(
              dashColor: Color(0xFF2B6F95),
              dashGapColor: Colors.transparent,
              dashLength: 1.0,
              dashGapLength: 0.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Consumer(builder: (context, ref, _) {
              final details =
                  ref.watch(paymentProvider.select((p) => p.sendAddrParsed));
              return TxDetailsColumn(
                description: 'To'.tr(),
                details: details,
                detailsStyle: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: const DottedLine(
              dashColor: Color(0xFF2B6F95),
              dashGapColor: Colors.transparent,
              dashLength: 1.0,
              dashGapLength: 0.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Consumer(builder: (context, ref, _) {
              final sendNetworkFee =
                  ref.watch(paymentProvider.select((p) => p.sendNetworkFee));
              return TxDetailsColumn(
                description: 'Network Fee'.tr(),
                details: '${amountStr(sendNetworkFee)} $kLiquidBitcoinTicker',
                detailsStyle: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: const DottedLine(
              dashColor: Color(0xFF2B6F95),
              dashGapColor: Colors.transparent,
              dashLength: 1.0,
              dashGapLength: 0.0,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
            child: Consumer(builder: (context, ref, _) {
              final buttonEnabled =
                  !ref.watch(walletProvider.select((p) => p.isSendingTx));
              return CustomBigButton(
                width: MediaQuery.of(context).size.width,
                height: 54.h,
                backgroundColor: const Color(0xFF00C5FF),
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
