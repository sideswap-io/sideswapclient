import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryType extends ConsumerWidget {
  const DTxHistoryType({super.key, required this.transItem, this.textStyle});

  final TransItem transItem;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final icon =
        transItem.hasPeg()
            ? PegImageSmall(isPegIn: transItem.peg.isPegIn)
            : TxImageSmall(assetName: transItemHelper.getTxImageAssetName());
    final typeName =
        transItem.hasPeg()
            ? pegTypeName(transItem.peg.isPegIn)
            : transItemHelper.txTypeName();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 11),
        Text(typeName, style: textStyle),
      ],
    );
  }
}
