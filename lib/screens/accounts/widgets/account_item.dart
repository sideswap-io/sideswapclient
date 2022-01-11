import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class AccountItem extends ConsumerWidget {
  final AccountAsset accountAsset;
  final int balance;
  final ValueChanged<AccountAsset> onSelected;
  final bool disabled;
  const AccountItem({
    Key? key,
    required this.accountAsset,
    this.balance = 0,
    required this.onSelected,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final wallet = watch(walletProvider);
    final asset = wallet.assets[accountAsset.asset]!;
    final assetImage = wallet.assetImagesBig[accountAsset.asset];
    final precision =
        wallet.getPrecisionForAssetId(assetId: accountAsset.asset);
    final amountString = amountStr(
      context.read(balancesProvider).balances[accountAsset] ?? 0,
      precision: precision,
    );
    final isAmp = accountAsset.account.isAmp();
    final amount = precision == 0
        ? int.tryParse(amountString) ?? 0
        : double.tryParse(amountString) ?? .0;
    final amountUsd = wallet.getAmountUsd(accountAsset.asset, amount);
    var _dollarConversion = '0.0';
    _dollarConversion = amountUsd.toStringAsFixed(2);
    _dollarConversion = replaceCharacterOnPosition(
        input: _dollarConversion, currencyChar: '\$');
    final textColor = disabled ? const Color(0xFFAAAAAA) : Colors.white;
    final backgrounColor =
        disabled ? const Color(0xFF034569) : const Color(0xFF135579);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SizedBox(
        height: 80.h,
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
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                SizedBox(
                  width: 48.w,
                  height: 48.w,
                  child: assetImage,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: SizedBox(
                    width: 257.w,
                    height: 48.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                asset.name,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Text(
                                amountString,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.roboto(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  color: textColor,
                                ),
                              ),
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
                                  asset.ticker,
                                  style: GoogleFonts.roboto(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF6B91A8),
                                  ),
                                ),
                                if (isAmp) const AmpFlag(fontSize: 14),
                              ],
                            ),
                            if (amountUsd != 0) ...[
                              Text(
                                '≈ $_dollarConversion',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF6B91A8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
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
