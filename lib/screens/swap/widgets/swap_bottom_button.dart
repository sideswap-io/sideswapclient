import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/providers/swap_provider.dart';

class SwapBottomButton extends HookConsumerWidget {
  const SwapBottomButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(swapEnabledStateProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: CustomBigButton(
        width: double.infinity,
        height: 54,
        enabled: enabled,
        backgroundColor: SideSwapColors.brightTurquoise,
        onPressed:
            enabled ? () => ref.read(swapHelperProvider).swapAccept() : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final swapTypeStr = ref.watch(swapTypeStringProvider);

                return Text(
                  swapTypeStr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                );
              },
            ),
            Consumer(
              builder: (context, ref, _) {
                final swapState = ref.watch(swapStateNotifierProvider);
                if (swapState == const SwapState.sent()) {
                  return const Padding(
                    padding: EdgeInsets.only(left: 84),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
