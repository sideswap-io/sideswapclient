import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/payment_requests_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/widgets/friend_widget.dart';
import 'package:sideswap/screens/markets/confirm_request_payment_success.dart';

class ConfirmRequestPayment extends ConsumerWidget {
  const ConfirmRequestPayment({Key? key, required this.request})
      : super(key: key);

  final PaymentRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = request.amount;
    final ticker =
        ref.read(walletProvider).assets[request.assetId]?.ticker ?? '';

    return SideSwapPopup(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      onClose: () {
        Navigator.of(context).pop();
      },
      backgroundColor: const Color(0xFF1C6086),
      enableInsideTopPadding: false,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: Column(
              children: [
                Text(
                  'Confirm the payment'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: FriendWidget(
                    friend: request.friend,
                    backgroundColor: const Color(0xFF135579),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: Text(
                    '$amount $ticker',
                    style: GoogleFonts.roboto(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                CustomBigButton(
                  width: double.maxFinite,
                  height: 54.h,
                  text: 'CONFIRM'.tr(),
                  backgroundColor: const Color(0xFF00C5FF),
                  textColor: Colors.white,
                  onPressed: () async {
                    final authenticated =
                        await ref.read(walletProvider).isAuthenticated();
                    if (authenticated) {
                      await Navigator.of(context, rootNavigator: true)
                          .push<void>(
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmRequestPaymentSuccess(request: request),
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54.h,
                    text: 'CANCEL'.tr(),
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
