import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/token_market_order_details.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/markets/widgets/time_to_live.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/screens/markets/widgets/autosign.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';

class OrderPopup extends ConsumerStatefulWidget {
  const OrderPopup({Key? key}) : super(key: key);

  @override
  _OrderPopupState createState() => _OrderPopupState();
}

class _OrderPopupState extends ConsumerState<OrderPopup> {
  int seconds = 60;
  int percent = 100;
  Timer? _percentTimer;
  bool autoSign = true;
  bool enabled = true;
  bool percentEnabled = false;
  bool orderTypeValue = false;
  late int ttlSeconds;
  late final bool showAssetDetails;

  @override
  void initState() {
    super.initState();
    final orderDetailsData = ref.read(walletProvider).orderDetailsData;
    autoSign = orderDetailsData.autoSign;
    ttlSeconds = kOneWeek;
    showAssetDetails = orderDetailsData.marketType == MarketType.amp &&
        orderDetailsData.orderType == OrderDetailsDataType.quote;

    // if (orderDetailsData.orderType == OrderType.execute) {
    //   _percentTimer = Timer.periodic(Duration(seconds: 1), onTimer);
    // }
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (showAssetDetails) {
        ref
            .read(tokenMarketProvider)
            .requestAssetDetails(assetId: orderDetailsData.assetId);
      }
    });
  }

  void onTimer(WidgetRef ref, Timer timer) {
    seconds--;
    if (seconds == 0) {
      _percentTimer?.cancel();
      ref.read(walletProvider).setRegistered();
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
    ref.read(walletProvider).setSubmitDecision(
          autosign: autoSign,
          accept: false,
        );
    ref.read(walletProvider).goBack();
  }

  Widget buildStatsRow(
      WidgetRef ref, BuildContext context, String title, double value) {
    final wallet = ref.read(walletProvider);
    final price = value.toStringAsFixed(8);
    final dollarConversion = ref
        .read(requestOrderProvider)
        .dollarConversion(wallet.liquidAssetId(), value);

    return Column(
      children: [
        Text('$title ($kLiquidBitcoinTicker)',
            style: defaultInfoStyle.copyWith(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            )),
        SizedBox(height: 4.h),
        Text(price,
            style: defaultInfoStyle.copyWith(
              color: Colors.white,
            )),
        SizedBox(height: 4.h),
        Text(
          dollarConversion.isEmpty ? '' : '≈ $dollarConversion',
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF709EBA),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      sideSwapBackground: false,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF064363),
      appBar: CustomAppBar(
        onPressed: () {
          onClose();
        },
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final orderDetailsData = ref.watch(walletProvider).orderDetailsData;
            OrderDetailsDataType? orderType =
                orderDetailsData.orderType ?? OrderDetailsDataType.submit;
            final dataAvailable = orderDetailsData.isDataAvailable();
            final assetDetails = ref
                .watch(tokenMarketProvider)
                .assetDetails[orderDetailsData.assetId];
            final chartUrl = assetDetails?.chartUrl;
            final chartStats = assetDetails?.chartStats;

            var orderDescription = '';
            switch (orderType) {
              case OrderDetailsDataType.submit:
                orderDescription = 'Submit an order'.tr();
                break;
              case OrderDetailsDataType.quote:
                orderDescription = 'Submit response'.tr();
                break;
              case OrderDetailsDataType.sign:
                orderDescription = 'Accept swap'.tr();
                break;
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (orderType == OrderDetailsDataType.sign) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 67.h),
                      child: Container(
                        height: 109.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.w)),
                          color: const Color(0xFF014767),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 24.h),
                                child: Container(
                                  width: 26.w,
                                  height: 26.w,
                                  decoration: const BoxDecoration(
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
                    padding: EdgeInsets.only(top: 12.h),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        color: const Color(0xFF043857),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.r),
                        child: OrderTable(
                          orderDetailsData: orderDetailsData,
                          enabled: dataAvailable,
                        ),
                      ),
                    ),
                  ),
                  if (orderType == OrderDetailsDataType.quote &&
                      percentEnabled) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: SideSwapProgressBar(
                        percent: percent,
                        text: '${seconds}s left',
                      ),
                    ),
                  ],
                  if (orderType == OrderDetailsDataType.submit) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: AutoSign(
                        value: autoSign,
                        onToggle: (value) {
                          setState(() {
                            autoSign = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: TimeToLive(
                          dropdownValue: ttlSeconds,
                          dropdownItems: availableTtlValues(),
                          onChanged: (value) {
                            setState(() {
                              ttlSeconds = value!;
                            });
                          }),
                    ),
                    const OrderTypeTracking(),
                  ],
                  const Spacer(),
                  if (showAssetDetails && assetDetails != null) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.w),
                      child: Column(
                        children: [
                          if (chartStats != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildStatsRow(ref, context, '30d Low'.tr(),
                                    chartStats.low),
                                buildStatsRow(ref, context, '30d High'.tr(),
                                    chartStats.high),
                                buildStatsRow(
                                    ref, context, 'Last'.tr(), chartStats.last),
                              ],
                            ),
                          if (chartUrl != null)
                            OrderTableRow(
                              description: 'Chart:'.tr(),
                              topPadding: 14.h,
                              displayDivider: false,
                              style: defaultInfoStyle,
                              customValue: GestureDetector(
                                onTap: () async {
                                  await openUrl(chartUrl);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/web_icon.svg',
                                      width: 18.w,
                                      height: 18.w,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      'sideswap.io',
                                      style: defaultInfoStyle.copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  CustomBigButton(
                    width: double.maxFinite,
                    height: 54.h,
                    enabled: dataAvailable && enabled,
                    backgroundColor: const Color(0xFF00C5FF),
                    onPressed: () async {
                      final auth =
                          await ref.read(walletProvider).isAuthenticated();
                      if (auth) {
                        setState(() {
                          enabled = false;
                        });
                        switch (orderType) {
                          case OrderDetailsDataType.submit:
                          case OrderDetailsDataType.quote:
                          case OrderDetailsDataType.sign:
                            ref.read(walletProvider).setSubmitDecision(
                                  autosign: autoSign,
                                  accept: true,
                                  private: false,
                                  ttlSeconds: ttlSeconds,
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
                              ? orderType == OrderDetailsDataType.submit ||
                                      orderType == OrderDetailsDataType.sign
                                  ? 'SUBMIT'.tr()
                                  : 'SUBMIT RESPONSE'.tr()
                              : orderType == OrderDetailsDataType.sign
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
                    padding: EdgeInsets.only(top: 0.h, bottom: 0.h),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54.h,
                      text: 'Cancel'.tr(),
                      textColor: const Color(0xFF00C5FF),
                      backgroundColor: Colors.transparent,
                      enabled: enabled,
                      onPressed: onClose,
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

class OrderTypeTracking extends StatelessWidget {
  const OrderTypeTracking({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Container(
        height: 51.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
          color: const Color(0xFF014767),
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
                builder: (context, ref, child) {
                  final indexPrice =
                      ref.watch(walletProvider).orderDetailsData.isTracking;
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
