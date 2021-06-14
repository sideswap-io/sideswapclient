import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';

class PaymentSendPopup extends StatelessWidget {
  PaymentSendPopup({Key? key}) : super(key: key);

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
              builder: (context, watch, child) {
                final asset = watch(walletProvider)
                    .assets[watch(walletProvider).selectedWalletAsset];
                final precision = context
                    .read(walletProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                final sendAmountStr = amountStr(
                    watch(paymentProvider).sendAmountParsed,
                    precision: precision);
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
              builder: (context, watch, child) {
                final asset = watch(walletProvider)
                    .assets[watch(walletProvider).selectedWalletAsset];
                final precision = context
                    .read(walletProvider)
                    .getPrecisionForAssetId(assetId: asset?.assetId);
                var amount = double.tryParse(amountStr(
                        watch(paymentProvider).sendAmountParsed,
                        precision: precision)) ??
                    0;
                _dollarConversion = watch(walletProvider)
                    .getAmountUsd(asset?.assetId ?? '', amount)
                    .toStringAsFixed(2);

                _dollarConversion = replaceCharacterOnPosition(
                  input: _dollarConversion,
                  currencyChar: '\$',
                  currencyCharAlignment: CurrencyCharAlignment.begin,
                );
                return Text(
                  '≈ $_dollarConversion',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFD3E5F0),
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: DottedLine(
                dashColor: Color(0xFF2B6F95),
                dashGapColor: Colors.transparent,
                dashLength: 1.0,
                dashGapLength: 0.0,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Consumer(
                builder: (context, watch, child) => TxDetailsColumn(
                  description: 'To'.tr(),
                  details: watch(paymentProvider).sendAddrParsed,
                  detailsStyle: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: DottedLine(
                dashColor: Color(0xFF2B6F95),
                dashGapColor: Colors.transparent,
                dashLength: 1.0,
                dashGapLength: 0.0,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Consumer(
                builder: (context, watch, child) => TxDetailsColumn(
                  description: 'Network Fee'.tr(),
                  details:
                      '${amountStr(watch(paymentProvider).sendNetworkFee)} $kLiquidBitcoinTicker',
                  detailsStyle: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: DottedLine(
                dashColor: Color(0xFF2B6F95),
                dashGapColor: Colors.transparent,
                dashLength: 1.0,
                dashGapLength: 0.0,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.h, bottom: 40.h),
            child: CustomBigButton(
              width: MediaQuery.of(context).size.width,
              height: 54.h,
              backgroundColor: Color(0xFF00C5FF),
              text: 'SEND'.tr(),
              enabled: true,
              onPressed: () async {
                if (await context.read(walletProvider).isAuthenticated()) {
                  context.read(walletProvider).assetSendConfirm();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
