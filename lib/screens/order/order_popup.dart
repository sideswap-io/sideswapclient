import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/token_market_order_details.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/markets/widgets/time_to_live.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/screens/markets/widgets/autosign.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';

class OrderPopup extends ConsumerStatefulWidget {
  const OrderPopup({super.key});

  @override
  OrderPopupState createState() => OrderPopupState();
}

class OrderPopupState extends ConsumerState<OrderPopup> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
            final assetDetails = ref.watch(
                tokenMarketAssetDetailsProvider)[orderDetailsData.assetId];
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (orderType == OrderDetailsDataType.sign) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 67),
                      child: Container(
                        height: 109,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: SideSwapColors.chathamsBlue,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: SideSwapColors.brightTurquoise,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/success.svg',
                                      width: 11,
                                      height: 11,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  'Your order has been matched'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
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
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      orderDescription,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF043857),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
                      padding: const EdgeInsets.only(top: 20),
                      child: SideSwapProgressBar(
                        percent: percent,
                        text: '${seconds}s left',
                      ),
                    ),
                  ],
                  if (orderType == OrderDetailsDataType.submit) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
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
                      padding: const EdgeInsets.only(top: 6),
                      child: TimeToLive(
                          dropdownValue: ttlSeconds,
                          dropdownItems: availableTtlValues(false),
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          if (chartStats != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OrderPopupStatsRow(
                                    title: '30d Low'.tr(),
                                    value: chartStats.low),
                                OrderPopupStatsRow(
                                    title: '30d High'.tr(),
                                    value: chartStats.high),
                                OrderPopupStatsRow(
                                    title: 'Last'.tr(), value: chartStats.last),
                              ],
                            ),
                          if (chartUrl != null)
                            OrderTableRow(
                              description: 'Chart:'.tr(),
                              topPadding: 14,
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
                                      width: 18,
                                      height: 18,
                                    ),
                                    const SizedBox(width: 4),
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
                    height: 54,
                    enabled: dataAvailable && enabled,
                    backgroundColor: SideSwapColors.brightTurquoise,
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
                            padding: const EdgeInsets.only(right: 200),
                            child: SpinKitCircle(
                              size: 32,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                        Text(
                          enabled
                              ? (orderType == OrderDetailsDataType.submit ||
                                      orderType == OrderDetailsDataType.sign
                                  ? 'SUBMIT'.tr()
                                  : 'SIGN SWAP'.tr())
                              : (orderType == OrderDetailsDataType.sign ||
                                      (orderType ==
                                              OrderDetailsDataType.quote &&
                                          orderDetailsData.twoStep)
                                  ? 'Broadcasting'.tr()
                                  : 'Awaiting acceptance'.tr()),
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
                    padding: const EdgeInsets.only(bottom: 24),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54,
                      text: 'Cancel'.tr(),
                      textColor: SideSwapColors.brightTurquoise,
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Container(
        height: 51,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: SideSwapColors.chathamsBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order type:'.tr(),
                style: const TextStyle(
                  fontSize: 16,
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
                    style: const TextStyle(
                      fontSize: 16,
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

class OrderPopupStatsRow extends ConsumerWidget {
  const OrderPopupStatsRow({this.title = '', this.value = 0, super.key});

  final String title;
  final double value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = value.toStringAsFixed(8);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final dollarConversion =
        ref.watch(dollarConversionProvider(liquidAssetId, value));

    return Column(
      children: [
        Text('$title ($kLiquidBitcoinTicker)',
            style: defaultInfoStyle.copyWith(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            )),
        const SizedBox(height: 4),
        Text(price,
            style: defaultInfoStyle.copyWith(
              color: Colors.white,
            )),
        const SizedBox(height: 4),
        Text(
          dollarConversion.isEmpty ? '' : '≈ $dollarConversion',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF709EBA),
          ),
        ),
      ],
    );
  }
}
