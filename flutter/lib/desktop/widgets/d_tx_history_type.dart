import 'package:flutter/material.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';

class DTxHistoryType extends StatelessWidget {
  const DTxHistoryType({
    super.key,
    required this.tx,
    required this.txType,
  });

  final TransItem tx;
  final TxType txType;

  @override
  Widget build(BuildContext context) {
    final icon = tx.hasPeg()
        ? PegImageSmall(isPegIn: tx.peg.isPegIn)
        : TxImageSmall(txType: txType);
    final typeName =
        tx.hasPeg() ? pegTypeName(tx.peg.isPegIn) : txTypeName(txType);
    return Row(
      children: [
        icon,
        const SizedBox(width: 11),
        Text(typeName),
      ],
    );
  }
}