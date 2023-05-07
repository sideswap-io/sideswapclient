import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

class RowTxReceiver extends ConsumerWidget {
  const RowTxReceiver({
    super.key,
    required this.address,
    required this.assetId,
    required this.amount,
  });

  final String address;
  final String assetId;
  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[assetId]));
    final icon = ref.watch(assetImageProvider).getSmallImage(assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final amountStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: amount,
            ticker: asset?.ticker ?? '',
            precision: asset?.precision ?? 8));

    return Row(
      children: [
        Expanded(child: Text(address)),
        const SizedBox(width: 116),
        Text(amountStr),
        const SizedBox(width: 8),
        icon,
      ],
    );
  }
}
