import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/screens/swap/widgets/rounded_text_label.dart';
import 'package:sideswap/screens/swap/widgets/swap_arrows_button.dart';

class SwapMiddleIcon extends ConsumerWidget {
  SwapMiddleIcon({
    Key? key,
    required this.visibleToggles,
    this.onTap,
  }) : super(key: key);

  final _swapIconSize = 48.w;
  final bool visibleToggles;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _swapType = watch(swapProvider).swapType();
    final _topPadding = _swapType != SwapType.atomic
        ? visibleToggles
            ? 275.h
            : 205.h
        : 205.h;

    return Padding(
      padding: EdgeInsets.only(top: _topPadding - _swapIconSize / 2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          children: [
            SwapArrowsButton(
              radius: _swapIconSize,
              onTap: onTap,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Consumer(
                builder: (context, watch, _) {
                  final price = watch(swapProvider).getPriceText();
                  return Visibility(
                    visible: price != null,
                    child: RoundedTextLabel(
                      text: price ?? '',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
