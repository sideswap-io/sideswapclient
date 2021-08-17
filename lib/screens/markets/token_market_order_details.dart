import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/token_market_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class TokenMarketOrderDetails extends StatefulWidget {
  const TokenMarketOrderDetails({
    Key? key,
    required this.requestOrder,
  }) : super(key: key);

  final RequestOrder requestOrder;

  @override
  _TokenMarketOrderDetailsState createState() =>
      _TokenMarketOrderDetailsState();
}

class _TokenMarketOrderDetailsState extends State<TokenMarketOrderDetails> {
  String expiresTitle = '';
  Timer? _expireTimer;

  TextStyle defaultInfoStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF709EBA),
  );

  @override
  void initState() {
    super.initState();

    final expires = widget.requestOrder.getExpireDescription();
    expiresTitle = 'TTL: $expires';

    // Close current view when request expire
    _expireTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!widget.requestOrder.getExpiresAt().isNegative) {
        final expires = widget.requestOrder.getExpireDescription();
        setState(() {
          expiresTitle = 'TTL: $expires';
        });
      } else {
        timer.cancel();
        Navigator.of(context, rootNavigator: true).pop();
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild(context));
  }

  void afterBuild(BuildContext context) async {
    context
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
                padding: EdgeInsets.only(top: 26.h),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                          color: const Color(0xFF043857),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: OrderTable(
                            orderDetailsData: OrderDetailsData.fromRequestOrder(
                              widget.requestOrder,
                              context.read,
                            ),
                            useTokenView: true,
                          ),
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final assetDetails =
                            watch(tokenMarketProvider).assetDetails;
                        final assetId = widget.requestOrder.assetId;
                        if (!assetDetails.containsKey(assetId)) {
                          return Container();
                        }

                        final assetDetailsData = assetDetails[assetId];
                        final stats = assetDetailsData?.stats;

                        final asset = context
                            .read(walletProvider)
                            .assets[widget.requestOrder.assetId];
                        final ticker = asset?.ticker ?? '';
                        final domain = asset?.domain ?? '';
                        final circulatingAmount = (stats == null ||
                                stats.hasBlindedIssuances)
                            ? '-'
                            : amountStr(stats.issuedAmount - stats.burnedAmount,
                                precision: asset!.precision);

                        return Padding(
                          padding: EdgeInsets.only(
                              top: 34.h, left: 16.w, right: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Token info:'.tr(),
                                style: GoogleFonts.roboto(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12.h),
                                child: const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFF337BA3),
                                ),
                              ),
                              if (stats != null) ...[
                                OrderTableRow(
                                  description: 'Circulating amount:'.tr(),
                                  value: '$circulatingAmount $ticker',
                                  topPadding: 14.h,
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
                                    topPadding: 14.h,
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
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 40.h, left: 16.w, right: 16.w),
                      child: CustomBigButton(
                        width: double.maxFinite,
                        height: 54.h,
                        backgroundColor: const Color(0xFF00C5FF),
                        text: 'BUY'.tr(),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          context
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
