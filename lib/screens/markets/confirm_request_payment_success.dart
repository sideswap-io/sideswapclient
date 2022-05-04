import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/payment_requests_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ConfirmRequestPaymentSuccess extends ConsumerWidget {
  const ConfirmRequestPaymentSuccess({
    Key? key,
    required this.request,
  }) : super(key: key);

  final PaymentRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = request.amount;
    final ticker =
        ref.read(walletProvider).assets[request.assetId]?.ticker ?? '';

    return SideSwapPopup(
      onWillPop: () async {
        return false;
      },
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Success!'.tr(),
        descriptionWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'DONE_FRIEND_PAYMENT'.tr(args: [request.friend.contact.name]),
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                '$amount $ticker',
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF00C5FF),
                ),
              ),
            ),
          ],
        ),
        buttonText: 'DONE'.tr(),
        onPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
