import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/screens/markets/widgets/autosign.dart';
import 'package:sideswap/screens/markets/widgets/order_type.dart';
import 'package:sideswap/screens/markets/widgets/share_and_copy_buttons_row.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';
import 'package:sideswap/screens/markets/widgets/time_to_live.dart';

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({
    Key? key,
    this.requestOrder,
  }) : super(key: key);

  final RequestOrder? requestOrder;

  @override
  _CreateOrderViewState createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  bool autoSignValue = true;
  bool orderTypePublicValue = true;

  late OrderDetailsData orderDetailsData;
  bool editMode = false;
  String expiresTitle = '';
  Timer? _expireTimer;
  bool isModifyDialogOpened = false;
  int ttlSeconds = kHalfHour;
  bool ttlLocked = false;

  @override
  void initState() {
    super.initState();

    if (widget.requestOrder != null) {
      orderDetailsData =
          OrderDetailsData.fromRequestOrder(widget.requestOrder!, context.read);

      orderTypePublicValue = !widget.requestOrder!.private;
      autoSignValue = orderDetailsData.autoSign;
      editMode = widget.requestOrder != null;
      final expires = widget.requestOrder!.getExpireDescription();
      expiresTitle = 'TTL: $expires';

      // Close current view when request expire
      _expireTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!widget.requestOrder!.getExpiresAt().isNegative) {
          final expires = widget.requestOrder!.getExpireDescription();
          setState(() {
            expiresTitle = 'TTL: $expires';
          });
        } else {
          timer.cancel();
          if (isModifyDialogOpened) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          context.read(walletProvider).setRegistered();
        }
      });
    } else {
      orderDetailsData = context.read(walletProvider).orderDetailsData;
      autoSignValue = orderDetailsData.autoSign;
      orderTypePublicValue = !orderDetailsData.private;
      if (orderDetailsData.isTracking) {
        ttlSeconds = kTwelveHours;
      } else {
        ttlSeconds = kHalfHour;
      }

      final isToken = context
          .read(requestOrderProvider)
          .isAssetToken(orderDetailsData.assetId);
      if (isToken) {
        ttlSeconds = kOneDay;
      }
    }

    if (editMode) {
      // set current edited data
      context.read(walletProvider).orderDetailsData = orderDetailsData;
    }
  }

  @override
  void dispose() {
    _expireTimer?.cancel();
    super.dispose();
  }

  void onGoBack() {
    if (widget.requestOrder != null) {
      context.read(walletProvider).setRegistered();
    } else {
      context.read(walletProvider).setSubmitDecision(
            accept: false,
            autosign: autoSignValue,
            private: !orderTypePublicValue,
            ttlSeconds: ttlSeconds,
          );
      context.read(walletProvider).setRegistered();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () async {
        onGoBack();
        return false;
      },
      appBar: editMode
          ? CustomAppBar(
              title: expiresTitle,
              showTrailingButton: true,
              trailingWidget: SvgPicture.asset(
                'assets/delete.svg',
                width: 24.w,
                height: 24.w,
              ),
              onTrailingButtonPressed: () {
                context
                    .read(walletProvider)
                    .cancelOrder(widget.requestOrder!.orderId);
                onGoBack();
              },
              onPressed: () {
                onGoBack();
              },
            )
          : CustomAppBar(
              title: 'Create order'.tr(),
              onPressed: () {
                onGoBack();
              },
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Consumer(
                  builder: (context, watch, child) {
                    if (widget.requestOrder != null) {
                      // update data if swapRequest has changed
                      final index = context
                          .read(marketsProvider)
                          .marketOrders
                          .indexWhere(
                              (e) => e.orderId == orderDetailsData.orderId);
                      if (index >= 0) {
                        final requestOrder =
                            watch(marketsProvider).marketOrders[index];
                        orderDetailsData = OrderDetailsData.fromRequestOrder(
                            requestOrder, context.read);
                      }
                    }

                    return CreateOrderViewBody(
                      autoSignValue: autoSignValue,
                      editMode: editMode,
                      orderDetailsData: orderDetailsData,
                      orderTypeValue: orderTypePublicValue,
                      requestOrder: widget.requestOrder,
                      ttlSeconds: ttlSeconds,
                      ttlLocked: ttlLocked,
                      onAutoSignToggle: editMode
                          ? null
                          : (value) {
                              setState(() {
                                autoSignValue = value;
                              });
                            },
                      onOrderTypeToggle: editMode
                          ? null
                          : (value) {
                              setState(() {
                                orderTypePublicValue = value;
                              });
                            },
                      onModifyPrice: () async {
                        isModifyDialogOpened = true;
                        await context
                            .read(marketsProvider)
                            .onModifyPrice(widget.requestOrder);
                        isModifyDialogOpened = false;
                      },
                      onTtlChanged: (value) async {
                        setState(() {
                          if (value != null) {
                            ttlSeconds = value;
                          }
                        });

                        if (editMode) {
                          if (await context
                              .read(walletProvider)
                              .isAuthenticated()) {
                            context.read(walletProvider).setSubmitDecision(
                                  accept: true,
                                  autosign: autoSignValue,
                                  private: !orderTypePublicValue,
                                  ttlSeconds: ttlSeconds,
                                );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CreateOrderViewBody extends StatelessWidget {
  const CreateOrderViewBody({
    Key? key,
    required this.autoSignValue,
    required this.editMode,
    required this.orderTypeValue,
    required this.orderDetailsData,
    this.onAutoSignToggle,
    this.onOrderTypeToggle,
    this.requestOrder,
    this.onModifyPrice,
    this.onTtlChanged,
    this.ttlSeconds = kTenMinutes,
    this.ttlLocked = false,
  }) : super(key: key);

  final bool autoSignValue;
  final bool editMode;
  final bool orderTypeValue;
  final OrderDetailsData orderDetailsData;
  final void Function(bool)? onAutoSignToggle;
  final void Function(bool)? onOrderTypeToggle;
  final RequestOrder? requestOrder;
  final void Function()? onModifyPrice;
  final void Function(int?)? onTtlChanged;
  final int ttlSeconds;
  final bool ttlLocked;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            OrderTable(
              orderDetailsData: orderDetailsData,
            ),
            Padding(
              padding: EdgeInsets.only(top: 21.h),
              child: AutoSign(
                value: autoSignValue,
                onToggle: onAutoSignToggle,
              ),
            ),
            if (!orderDetailsData.isTracking) ...[
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: OrderType(
                  value: orderTypeValue,
                  onToggle: onOrderTypeToggle,
                ),
              ),
            ],
            if (!editMode) ...[
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: TimeToLive(
                  dropdownValue: ttlSeconds,
                  dropdownItems: const [
                    kTenMinutes,
                    kHalfHour,
                    kOneHour,
                    kSixHours,
                    kTwelveHours,
                    kOneDay
                  ],
                  onChanged: onTtlChanged,
                  locked: onTtlChanged == null ? true : false,
                ),
              ),
            ],
            const Spacer(),
            if (editMode) ...[
              if (requestOrder!.private) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: ShareAndCopyButtonsRow(
                    onShare: () async {
                      await Share.share(context
                          .read(requestOrderProvider)
                          .getAddressToShare(orderDetailsData));
                    },
                    onCopy: () async {
                      await copyToClipboard(
                          context,
                          context
                              .read(requestOrderProvider)
                              .getAddressToShare(orderDetailsData));
                    },
                  ),
                ),
              ] else ...[
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54.h,
                    text: 'MODIFY PRICE'.tr(),
                    textColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    side:
                        BorderSide(color: const Color(0xFF00C5FF), width: 2.w),
                    onPressed: onModifyPrice,
                  ),
                ),
              ]
            ] else ...[
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: CustomBigButton(
                  width: double.maxFinite,
                  height: 54.h,
                  text: 'CREATE ORDER'.tr(),
                  textColor: Colors.white,
                  backgroundColor: const Color(0xFF00C5FF),
                  onPressed: () async {
                    if (await context.read(walletProvider).isAuthenticated()) {
                      context.read(walletProvider).setSubmitDecision(
                            accept: true,
                            autosign: autoSignValue,
                            private: !orderTypeValue,
                            ttlSeconds: ttlSeconds,
                          );
                    }
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
