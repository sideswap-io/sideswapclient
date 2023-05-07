import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/screens/swap/widgets/rounded_text_label.dart';
import 'package:sideswap/screens/swap/widgets/swap_arrows_button.dart';

class SwapMiddleIcon extends ConsumerWidget {
  const SwapMiddleIcon({
    super.key,
    required this.visibleToggles,
    this.onTap,
  });

  final _swapIconSize = 48.0;
  final bool visibleToggles;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          SwapArrowsButton(
            radius: _swapIconSize,
            onTap: onTap,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Consumer(
              builder: (context, ref, _) {
                final price = ref.watch(swapPriceStateNotifierProvider);
                return Visibility(
                  visible: price != null,
                  child: RoundedTextLabel(
                    text: ref
                            .read(swapPriceStateNotifierProvider.notifier)
                            .getPriceText() ??
                        '',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
