import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryType extends ConsumerWidget {
  const DTxHistoryType({super.key, required this.transItem, this.textStyle});

  final TransItem transItem;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final icon = transItem.hasPeg()
        ? TxImageSmall(
            assetName: transItem.peg.isPegIn
                ? 'assets/tx_icons/pegin.svg'
                : 'assets/tx_icons/pegout.svg',
          )
        : TxImageSmall(assetName: transItemHelper.getTxImageAssetName());
    final typeName = transItem.hasPeg()
        ? transItem.peg.isPegIn
              ? 'Peg-In'.tr()
              : 'Peg-Out'.tr()
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
