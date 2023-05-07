import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class DTxHistoryAmount extends HookConsumerWidget {
  const DTxHistoryAmount({
    super.key,
    required this.balance,
    required this.multipleOutputs,
  });

  final Balance balance;
  final bool multipleOutputs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (multipleOutputs) {
      return Text('Multiple outputs'.tr());
    }
    if (balance.amount == 0) {
      return Container();
    }
    final asset = ref
        .watch(assetsStateProvider.select((value) => value[balance.assetId]));
    final precision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final amount = amountProvider.amountToString(AmountToStringParameters(
        amount: balance.amount.toInt(), precision: precision));
    final icon =
        ref.watch(assetImageProvider).getVerySmallImage(balance.assetId);

    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Text('$amount ${asset?.ticker ?? ''}'),
      ],
    );
  }
}
