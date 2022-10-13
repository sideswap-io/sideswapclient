import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class SwapMarketOrderDetails extends ConsumerStatefulWidget {
  const SwapMarketOrderDetails({
    super.key,
    required this.requestOrder,
  });

  final RequestOrder requestOrder;

  @override
  SwapMarketOrderDetailsState createState() => SwapMarketOrderDetailsState();
}

class SwapMarketOrderDetailsState
    extends ConsumerState<SwapMarketOrderDetails> {
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
                                  .watch(walletProvider)
                                  .getPrecisionForAssetId(
                                      assetId: widget.requestOrder.assetId);

                              return OrderTable(
                                orderDetailsData:
                                    OrderDetailsData.fromRequestOrder(
                                  widget.requestOrder,
                                  assetPrecision,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 40, left: 16, right: 16),
                      child: CustomBigButton(
                        width: double.maxFinite,
                        height: 54,
                        backgroundColor: const Color(0xFF00C5FF),
                        text: 'SWAP'.tr(),
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
