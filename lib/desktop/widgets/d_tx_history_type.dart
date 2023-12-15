import 'package:flutter/material.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryType extends StatelessWidget {
  const DTxHistoryType({
    super.key,
    required this.tx,
    required this.txType,
    this.textStyle,
  });

  final TransItem tx;
  final TxType txType;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final icon = tx.hasPeg()
        ? PegImageSmall(isPegIn: tx.peg.isPegIn)
        : TxImageSmall(txType: txType);
    final typeName =
        tx.hasPeg() ? pegTypeName(tx.peg.isPegIn) : txTypeName(txType);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 11),
        Text(
          typeName,
          style: textStyle,
        ),
      ],
    );
  }
}
