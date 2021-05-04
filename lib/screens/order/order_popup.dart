import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class OrderPopup extends StatefulWidget {
  const OrderPopup({Key key}) : super(key: key);

  @override
  _OrderPopupState createState() => _OrderPopupState();
}

class _OrderPopupState extends State<OrderPopup> {
  int seconds = 60;
  int percent = 100;
  Timer _percentTimer;

  @override
  void initState() {
    super.initState();
    final orderDetailsData = context.read(walletProvider).orderDetailsData;
    if (orderDetailsData.orderType == OrderType.execute) {
      _percentTimer = Timer.periodic(Duration(seconds: 1), onTimer);
    }
  }

  void onTimer(Timer timer) {
    seconds--;
    if (seconds == 0) {
      _percentTimer.cancel();
      context.read(walletProvider).setRegistered();
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      percent = seconds * 100 ~/ 60;
    });
  }

  @override
  void dispose() {
    _percentTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderDetailsData = context.read(walletProvider).orderDetailsData;
    return SideSwapPopup(
      sideSwapBackground: false,
      backgroundCoverColor: Colors.black.withOpacity(0.5),
      padding: EdgeInsets.only(top: 215.w),
      enableInsideTopPadding: false,
      hideCloseButton: true,
      backgroundColor: Color(0xFF1C6086),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: Text(
                orderDetailsData.orderType == OrderType.place
                    ? 'Submit an order'.tr()
                    : 'Sign an order'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: OrderDetails(
                placeOrderData: orderDetailsData,
              ),
            ),
            if (orderDetailsData.orderType == OrderType.execute) ...[
              Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: SideSwapProgressBar(
                  percent: percent,
                  text: '${seconds}s left',
                ),
              ),
            ],
            Spacer(),
            CustomBigButton(
              width: double.maxFinite,
              height: 54.h,
              text: orderDetailsData.orderType == OrderType.place
                  ? 'Place order'.tr()
                  : 'Execute order'.tr(),
              backgroundColor: Color(0xFF00C5FF),
              onPressed: () async {
                final auth =
                    await context.read(walletProvider).isAuthenticated();
                if (auth) {
                  switch (orderDetailsData.orderType) {
                    case OrderType.place:
                      context.read(walletProvider).setPlaceOrderSuccess();
                      break;
                    case OrderType.execute:
                      context.read(walletProvider).setExecuteOrderSuccess();
                      Navigator.of(context).pop();
                      break;
                  }
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
              child: CustomBigButton(
                width: double.maxFinite,
                height: 54.h,
                text: 'Cancel'.tr(),
                textColor: Color(0xFF00C5FF),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  context.read(walletProvider).goBack();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
