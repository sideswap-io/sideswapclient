import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:sideswap/providers/order_details_provider.dart';
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

class OrderPopup extends HookConsumerWidget {
  const OrderPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetailsData = ref.watch(orderDetailsDataNotifierProvider);

    final autoSign = useState(true);
    final ttlSeconds = useState(kOneWeek);
    final showAssetDetails = useState(false);
    final percentEnabled = useState(false);
    final enabled = useState(true);
    const seconds = 60;
    const percent = 100;

    useEffect(() {
      autoSign.value = orderDetailsData.autoSign;
      ttlSeconds.value = kOneWeek;
      showAssetDetails.value = orderDetailsData.marketType == MarketType.amp &&
          orderDetailsData.orderType == OrderDetailsDataType.quote;

      if (showAssetDetails.value) {
        ref
            .read(tokenMarketProvider)
            .requestAssetDetails(assetId: orderDetailsData.assetId);
      }

      return;
    }, const []);

    final onCloseCallback = useCallback(() {
      ref.read(walletProvider).setSubmitDecision(
            autosign: autoSign.value,
            accept: false,
          );
      ref.read(walletProvider).goBack();
    }, []);

    return SideSwapScaffold(
      sideSwapBackground: false,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF064363),
      appBar: CustomAppBar(
        onPressed: onCloseCallback,
      ),
      body: SafeArea(
        child: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final orderDetailsData =
                  ref.watch(orderDetailsDataNotifierProvider);
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
                          color: SideSwapColors.prussianBlue,
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
                        percentEnabled.value) ...[
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
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
                          autoSign: autoSign.value,
                          onToggle: (value) {
                            autoSign.value = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: TimeToLive(
                            dropdownValue: ttlSeconds.value,
                            dropdownItems: availableTtlValues(false),
                            onChanged: (value) {
                              ttlSeconds.value = value!;
                            }),
                      ),
                      const OrderTypeTracking(),
                    ],
                    const Spacer(),
                    if (showAssetDetails.value && assetDetails != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            if (chartStats != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OrderPopupStatsRow(
                                      title: '30d Low'.tr(),
                                      value: chartStats.low),
                                  OrderPopupStatsRow(
                                      title: '30d High'.tr(),
                                      value: chartStats.high),
                                  OrderPopupStatsRow(
                                      title: 'Last'.tr(),
                                      value: chartStats.last),
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
                      enabled: dataAvailable && enabled.value,
                      backgroundColor: SideSwapColors.brightTurquoise,
                      onPressed: () async {
                        final auth =
                            await ref.read(walletProvider).isAuthenticated();
                        if (auth) {
                          enabled.value = false;

                          switch (orderType) {
                            case OrderDetailsDataType.submit:
                            case OrderDetailsDataType.quote:
                            case OrderDetailsDataType.sign:
                              ref.read(walletProvider).setSubmitDecision(
                                    autosign: autoSign.value,
                                    accept: true,
                                    private: false,
                                    ttlSeconds: ttlSeconds.value,
                                  );
                              break;
                          }
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!enabled.value) ...[
                            Padding(
                              padding: const EdgeInsets.only(right: 200),
                              child: SpinKitCircle(
                                size: 32,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                          Text(
                            enabled.value
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
                        enabled: enabled.value,
                        onPressed: onCloseCallback,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
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
                      ref.watch(orderDetailsDataNotifierProvider).isTracking;
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
    final defaultCurrencyConversion =
        ref.watch(defaultCurrencyConversionProvider(liquidAssetId, value));

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
          defaultCurrencyConversion.isEmpty
              ? ''
              : '≈ $defaultCurrencyConversion',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: SideSwapColors.airSuperiorityBlue,
          ),
        ),
      ],
    );
  }
}
