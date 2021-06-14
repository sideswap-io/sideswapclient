import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class OrderPopup extends StatefulWidget {
  const OrderPopup({Key? key}) : super(key: key);

  @override
  _OrderPopupState createState() => _OrderPopupState();
}

class _OrderPopupState extends State<OrderPopup> {
  int seconds = 60;
  int percent = 100;
  Timer? _percentTimer;
  bool autoSign = true;
  bool enabled = true;
  bool percentEnabled = false;

  @override
  void initState() {
    super.initState();
    // final orderDetailsData = context.read(walletProvider).orderDetailsData;
    // if (orderDetailsData.orderType == OrderType.execute) {
    //   _percentTimer = Timer.periodic(Duration(seconds: 1), onTimer);
    // }
  }

  void onTimer(Timer timer) {
    seconds--;
    if (seconds == 0) {
      _percentTimer?.cancel();
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
    _percentTimer?.cancel();
    super.dispose();
  }

  void onClose() {
    context.read(walletProvider).setSubmitDecision(
          autosign: autoSign,
          accept: false,
        );
    context.read(walletProvider).goBack();
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      sideSwapBackground: false,
      backgroundCoverColor: Colors.black.withOpacity(0.5),
      enableInsideTopPadding: false,
      backgroundColor: Color(0xFF1C6086),
      onClose: onClose,
      child: Center(
        child: Consumer(
          builder: (context, watch, child) {
            final orderDetailsData = watch(walletProvider).orderDetailsData;
            var orderType = orderDetailsData.orderType;
            final dataAvailable = orderDetailsData.isDataAvailable();

            var orderDescription = '';
            switch (orderType) {
              case OrderType.submit:
                orderDescription = 'Submit an order'.tr();
                break;
              case OrderType.quote:
                orderDescription = 'Submit response'.tr();
                break;
              case OrderType.sign:
                orderDescription = 'Accept swap'.tr();
                break;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (orderType == OrderType.sign) ...[
                  Padding(
                    padding: EdgeInsets.only(top: 62.h),
                    child: Container(
                      height: 109.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.w)),
                        color: Color(0xFF014767),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 24.h),
                              child: Container(
                                width: 26.w,
                                height: 26.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00C5FF),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/success.svg',
                                    width: 11.w,
                                    height: 11.w,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: Text(
                                'Your order has been matched'.tr(),
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Text(
                    orderDescription,
                    style: GoogleFonts.roboto(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: OrderDetails(
                    placeOrderData: orderDetailsData,
                    enabled: dataAvailable,
                  ),
                ),
                if (orderType == OrderType.quote && percentEnabled) ...[
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: SideSwapProgressBar(
                      percent: percent,
                      text: '${seconds}s left',
                    ),
                  ),
                ],
                if (orderType == OrderType.submit) ...[
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: OrderAutoSign(
                      enabled: dataAvailable && enabled,
                      autoSign: autoSign,
                      onToggle: (value) {
                        setState(() {
                          autoSign = value;
                        });
                      },
                    ),
                  ),
                  OrderTypeTracking(),
                ],
                Spacer(),
                CustomBigButton(
                  width: double.maxFinite,
                  height: 54.h,
                  enabled: dataAvailable && enabled,
                  backgroundColor: Color(0xFF00C5FF),
                  onPressed: () async {
                    final auth =
                        await context.read(walletProvider).isAuthenticated();
                    if (auth) {
                      setState(() {
                        enabled = false;
                      });
                      switch (orderType) {
                        case OrderType.submit:
                        case OrderType.quote:
                        case OrderType.sign:
                          context.read(walletProvider).setSubmitDecision(
                                autosign: autoSign,
                                accept: true,
                              );
                          break;
                      }
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
                        enabled
                            ? orderType == OrderType.submit ||
                                    orderType == OrderType.sign
                                ? 'SUBMIT'.tr()
                                : 'SUBMIT RESPONSE'.tr()
                            : orderType == OrderType.sign
                                ? 'Broadcasting'.tr()
                                : 'Awaiting acceptance'.tr(),
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
                    textColor: Color(0xFF00C5FF),
                    backgroundColor: Colors.transparent,
                    enabled: enabled,
                    onPressed: onClose,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class OrderTypeTracking extends StatelessWidget {
  const OrderTypeTracking({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Container(
        height: 51.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
          color: Color(0xFF014767),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order type:'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              Consumer(
                builder: (context, watch, child) {
                  final indexPrice =
                      watch(walletProvider).orderDetailsData.indexPrice;
                  return Text(
                    indexPrice ? 'Price tracking'.tr() : 'Limit order'.tr(),
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderAutoSign extends StatelessWidget {
  const OrderAutoSign({
    Key? key,
    this.enabled = false,
    this.autoSign = true,
    this.onToggle,
  }) : super(key: key);

  final bool enabled;
  final bool autoSign;
  final void Function(bool)? onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 129.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        color: Color(0xFF014767),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
        child: Row(
          children: [
            Container(
              width: 207.w,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Auto-sign'.tr(),
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Your order will be automatically signed if your app is left running while the order is active.'
                          .tr(),
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff569BBA),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Column(
              children: [
                Container(
                  width: 61.w,
                  child: Opacity(
                    opacity: enabled ? 1.0 : 0.5,
                    child: AbsorbPointer(
                      absorbing: enabled ? false : true,
                      child: FlutterSwitch(
                        value: autoSign,
                        onToggle: onToggle ?? (_) {},
                        width: 61.w,
                        height: 31.h,
                        toggleSize: 27.h,
                        padding: 2.h,
                        activeColor: Color(0xFF00C5FF),
                        inactiveColor: Color(0xFF164D6A),
                        toggleColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
