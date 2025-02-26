import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class LimitMinimumFeeError extends ConsumerWidget {
  const LimitMinimumFeeError({super.key, this.text = ''});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: SideSwapColors.bitterSweet),
        ),
      ],
    );
  }
}
