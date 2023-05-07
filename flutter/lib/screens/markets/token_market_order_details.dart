import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/token_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class TokenMarketOrderDetails extends ConsumerStatefulWidget {
  const TokenMarketOrderDetails({
    super.key,
    required this.requestOrder,
  });

  final RequestOrder requestOrder;

  @override
  TokenMarketOrderDetailsState createState() => TokenMarketOrderDetailsState();
}

TextStyle defaultInfoStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: Color(0xFF709EBA),
);

class TokenMarketOrderDetailsState
    extends ConsumerState<TokenMarketOrderDetails> {
  String expiresTitle = '';
  Timer? _expireTimer;

  @override
  void initState() {
    super.initState();

    final expires = widget.requestOrder.getExpireDescription();
    expiresTitle = 'TTL: $expires';

    // Close current view when request expire
    _expireTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final expiresAt = widget.requestOrder.getExpiresAt();
      if (expiresAt == null || !expiresAt.isNegative) {
        final expires = widget.requestOrder.getExpireDescription();
        setState(() {
          expiresTitle = 'TTL: $expires';
        });
      } else {
        timer.cancel();
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterBuild(ref, context));
  }

  void afterBuild(WidgetRef ref, BuildContext context) async {
    ref
        .read(tokenMarketProvider)
        .requestAssetDetails(assetId: widget.requestOrder.assetId);
  }

  @override
  void dispose() {
    _expireTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF064363),
      appBar: CustomAppBar(
        title: expiresTitle,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xFF043857),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Consumer(
                            builder: (context, ref, _) {
                              final assetPrecision = ref
                                  .watch(assetUtilsProvider)
                                  .getPrecisionForAssetId(
                                      assetId: widget.requestOrder.assetId);
                              return OrderTable(
                                orderDetailsData:
                                    OrderDetailsData.fromRequestOrder(
                                  widget.requestOrder,
                                  assetPrecision,
                                ),
                                useTokenView: true,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final assetDetails =
                            ref.watch(tokenMarketAssetDetailsProvider);
                        final assetId = widget.requestOrder.assetId;
                        if (!assetDetails.containsKey(assetId)) {
                          return Container();
                        }

                        final assetDetailsData = assetDetails[assetId];
                        final stats = assetDetailsData?.stats;
                        final chartsUrl = assetDetailsData?.chartUrl;

                        final asset = ref.watch(assetsStateProvider.select(
                            (value) => value[widget.requestOrder.assetId]));
                        final ticker = asset?.ticker ?? '';
                        final domain = asset?.domain ?? '';
                        final statsAmount = (stats?.issuedAmount ?? 0) -
                            (stats?.burnedAmount ?? 0);
                        final amountProvider =
                            ref.watch(amountToStringProvider);
                        final amountStr = amountProvider.amountToString(
                            AmountToStringParameters(
                                amount: statsAmount,
                                precision: asset?.precision ?? 0));
                        final circulatingAmount =
                            (stats == null || stats.hasBlindedIssuances)
                                ? '-'
                                : amountStr;

                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 34, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Token info:'.tr(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFF337BA3),
                                ),
                              ),
                              if (stats != null) ...[
                                OrderTableRow(
                                  description: 'Circulating amount:'.tr(),
                                  value: '$circulatingAmount $ticker',
                                  topPadding: 14,
                                  displayDivider: false,
                                  style: defaultInfoStyle,
                                ),
                              ],
                              if (domain.isNotEmpty) ...[
                                GestureDetector(
                                  onTap: () async {
                                    if (domain.isNotEmpty) {
                                      await openUrl('https://$domain');
                                    }
                                  },
                                  child: OrderTableRow(
                                    description: 'Link:'.tr(),
                                    topPadding: 14,
                                    displayDivider: false,
                                    style: defaultInfoStyle,
                                    customValue: Text(
                                      domain,
                                      style: defaultInfoStyle.copyWith(
                                        decoration: domain.isNotEmpty
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              if (chartsUrl != null) ...[
                                GestureDetector(
                                  onTap: () async {
                                    await openUrl(chartsUrl);
                                  },
                                  child: OrderTableRow(
                                    description: 'Chart:'.tr(),
                                    topPadding: 14,
                                    displayDivider: false,
                                    style: defaultInfoStyle,
                                    customValue: Text(
                                      'sideswap.io',
                                      style: defaultInfoStyle.copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 40, left: 16, right: 16),
                      child: CustomBigButton(
                        width: double.maxFinite,
                        height: 54,
                        backgroundColor: SideSwapColors.brightTurquoise,
                        text: widget.requestOrder.isSell()
                            ? 'SELL'.tr()
                            : 'BUY'.tr(),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          ref
                              .read(walletProvider)
                              .linkOrder(widget.requestOrder.orderId);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
