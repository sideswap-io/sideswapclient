import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class BalanceLine extends ConsumerWidget {
  const BalanceLine({super.key, this.onMaxPressed, this.amountSide = false});

  final VoidCallback? onMaxPressed;
  final bool amountSide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);

    return switch (onMaxPressed) {
      final onMaxPressed? when tradeDirState == TradeDir.SELL => Column(
        children: [
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 56,
                height: 24,
                child: DHoverButton(
                  builder: (context, states) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 13,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                        border: Border.all(
                          color: SideSwapColors.brightTurquoise,
                        ),
                        color:
                            states.isFocused ? const Color(0xFF007CA1) : null,
                      ),
                      child: Text(
                        'Max'.tr().toUpperCase(),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: SideSwapColors.brightTurquoise),
                      ),
                    );
                  },
                  onPressed: onMaxPressed,
                ),
              ),
            ],
          ),
        ],
      ),
      _ => SizedBox(),
    };
  }
}
