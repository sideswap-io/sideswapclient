import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class SwapPromptTable extends ConsumerWidget {
  const SwapPromptTable({
    super.key,
    required this.swap,
    required this.enabled,
  });

  final SwapDetails swap;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        OrderTableRow.assetAmount(
          description: 'Deliver'.tr(),
          amount: swap.sendAmount.toInt(),
          assetId: swap.sendAsset,
          orderTableRowType: OrderTableRowType.normal,
        ),
        OrderTableRow.assetAmount(
          description: 'Receive'.tr(),
          amount: swap.recvAmount.toInt(),
          assetId: swap.recvAsset,
          displayDivider: false,
          orderTableRowType: OrderTableRowType.normal,
        ),
      ],
    );
  }
}

class SwapPrompt extends ConsumerWidget {
  const SwapPrompt({super.key});

  void onClose(WidgetRef ref, BuildContext context) {
    ref.read(walletProvider).goBack();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      sideSwapBackground: false,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF064363),
      appBar: CustomAppBar(
        onPressed: () => onClose(ref, context),
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final swap = ref.watch(walletProvider).swapDetails!;
            final enabled = !ref.watch(walletProvider).swapPromptWaitingTx;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Text(
                      'Swap Review',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF043857),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SwapPromptTable(
                          enabled: enabled,
                          swap: swap,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
                    enabled: enabled,
                    backgroundColor: SideSwapColors.brightTurquoise,
                    onPressed: () async {
                      final auth =
                          await ref.read(walletProvider).isAuthenticated();
                      if (auth) {
                        ref.read(walletProvider).swapReviewAccept();
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (!enabled) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 200),
                            child: SpinKitCircle(
                              size: 32,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                        Text(
                          'Swap'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54,
                      text: 'Cancel'.tr(),
                      textColor: SideSwapColors.brightTurquoise,
                      backgroundColor: Colors.transparent,
                      enabled: enabled,
                      onPressed: () => onClose(ref, context),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
