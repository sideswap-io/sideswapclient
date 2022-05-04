import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';

class SwapPromptTable extends ConsumerWidget {
  const SwapPromptTable({
    Key? key,
    required this.swap,
    required this.enabled,
  }) : super(key: key);

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
  const SwapPrompt({Key? key}) : super(key: key);

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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: Text(
                      'Swap Review',
                      style: GoogleFonts.roboto(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.h),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        color: const Color(0xFF043857),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
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
                    height: 54.h,
                    enabled: enabled,
                    backgroundColor: const Color(0xFF00C5FF),
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
                            padding: EdgeInsets.only(right: 200.w),
                            child: SpinKitCircle(
                              size: 32.w,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                        Text(
                          'Swap'.tr(),
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54.h,
                      text: 'Cancel'.tr(),
                      textColor: const Color(0xFF00C5FF),
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
