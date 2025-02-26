import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryWallet extends StatelessWidget {
  const DTxHistoryWallet({super.key, required this.tx, this.textStyle});

  final TransItem tx;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final isAmp = tx.tx.balances.any(
      (e) => AccountType.fromPb(tx.account).isAmp,
    );
    final isRegular = tx.tx.balances.any(
      (e) => AccountType.fromPb(tx.account).isRegular,
    );
    final accountName =
        tx.hasPeg()
            ? ''
            : ((isAmp && isRegular)
                ? 'Regular/AMP'.tr()
                : (isAmp ? 'AMP' : 'Regular'.tr()));
    return Text(accountName, style: textStyle);
  }
}
