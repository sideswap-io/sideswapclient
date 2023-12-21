import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DWorkingOrderAmount extends HookConsumerWidget {
  const DWorkingOrderAmount({
    super.key,
    required this.text,
    required this.assetId,
  });

  final String text;
  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = ref.watch(assetImageProvider).getVerySmallImage(assetId);
    return Row(
      children: [
        icon,
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}
