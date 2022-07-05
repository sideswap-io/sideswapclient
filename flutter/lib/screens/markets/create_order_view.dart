import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

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

class CreateOrderView extends ConsumerStatefulWidget {
  const CreateOrderView({
    super.key,
    this.requestOrder,
  });

  final RequestOrder? requestOrder;

  @override
  CreateOrderViewState createState() => CreateOrderViewState();
}

class CreateOrderViewState extends ConsumerState<CreateOrderView> {
  bool autoSignValue = true;
  bool orderTypePublicValue = true;

  late OrderDetailsData orderDetailsData;
  bool editMode = false;
  String expiresTitle = '';
  Timer? _expireTimer;
  bool isModifyDialogOpened = false;
  int ttlSeconds = kOneWeek;
  bool ttlLocked = false;
  bool buttonDisabled = false;

  @override
  void initState() {
    super.initState();

    if (widget.requestOrder != null) {
      final assetPrecision = ref
          .read(walletProvider)
          .getPrecisionForAssetId(assetId: widget.requestOrder!.assetId);
      orderDetailsData = OrderDetailsData.fromRequestOrder(
          widget.requestOrder!, assetPrecision);

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
          ref.read(walletProvider).setRegistered();
        }
      });
    } else {
      orderDetailsData = ref.read(walletProvider).orderDetailsData;
      autoSignValue = orderDetailsData.autoSign;
      orderTypePublicValue = !orderDetailsData.private;
      ttlSeconds = kOneWeek;

      final isToken =
          ref.read(requestOrderProvider).isAssetToken(orderDetailsData.assetId);
      if (isToken) {
        ttlSeconds = kOneWeek;
      }
    }

    ref.read(marketsProvider).subscribeIndexPrice(orderDetailsData.assetId);

    if (editMode) {
      // set current edited data
      ref.read(walletProvider).orderDetailsData = orderDetailsData;
    }
  }

  @override
  void dispose() {
    _expireTimer?.cancel();
    super.dispose();
  }

  void onGoBack(WidgetRef ref) {
    ref.read(marketsProvider).unsubscribeIndexPrice();

    if (widget.requestOrder != null) {
      ref.read(walletProvider).setRegistered();
    } else {
      ref.read(walletProvider).setSubmitDecision(
            accept: false,
            autosign: autoSignValue,
            private: !orderTypePublicValue,
            ttlSeconds: ttlSeconds,
          );
      ref.read(walletProvider).setRegistered();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () async {
        onGoBack(ref);
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
                ref
                    .read(walletProvider)
                    .cancelOrder(widget.requestOrder!.orderId);
                onGoBack(ref);
              },
              onPressed: () {
                onGoBack(ref);
              },
            )
          : CustomAppBar(
              title: 'Create order'.tr(),
              onPressed: () {
                onGoBack(ref);
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
                  builder: (context, ref, child) {
                    if (widget.requestOrder != null) {
                      // update data if swapRequest has changed
                      final index = ref
                          .read(marketsProvider)
                          .marketOrders
                          .indexWhere(
                              (e) => e.orderId == orderDetailsData.orderId);
                      if (index >= 0) {
                        final requestOrder =
                            ref.watch(marketsProvider).marketOrders[index];
                        final assetPrecision = ref
                            .read(walletProvider)
                            .getPrecisionForAssetId(
                                assetId: requestOrder.assetId);
                        orderDetailsData = OrderDetailsData.fromRequestOrder(
                            requestOrder, assetPrecision);
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
                      onPressed: buttonDisabled
                          ? null
                          : () async {
                              if (await ref
                                  .read(walletProvider)
                                  .isAuthenticated()) {
                                ref.read(walletProvider).setSubmitDecision(
                                      accept: true,
                                      autosign: autoSignValue,
                                      private: !orderTypePublicValue,
                                      ttlSeconds: ttlSeconds,
                                    );
                                setState(() {
                                  buttonDisabled = true;
                                });
                              }
                            },
                      onAutoSignToggle: editMode
                          ? (value) {
                              ref.read(walletProvider).modifyOrderAutoSign(
                                  orderDetailsData.orderId, value);
                              setState(() {
                                autoSignValue = value;
                              });
                            }
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
                        await ref
                            .read(marketsProvider)
                            .onModifyPrice(ref, widget.requestOrder);
                        isModifyDialogOpened = false;
                      },
                      onTtlChanged: (value) async {
                        setState(() {
                          if (value != null) {
                            ttlSeconds = value;
                          }
                        });

                        if (editMode) {
                          if (await ref
                              .read(walletProvider)
                              .isAuthenticated()) {
                            ref.read(walletProvider).setSubmitDecision(
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

class CreateOrderViewBody extends ConsumerWidget {
  const CreateOrderViewBody({
    super.key,
    required this.autoSignValue,
    required this.editMode,
    required this.orderTypeValue,
    required this.orderDetailsData,
    required this.onPressed,
    this.onAutoSignToggle,
    this.onOrderTypeToggle,
    this.requestOrder,
    this.onModifyPrice,
    this.onTtlChanged,
    this.ttlSeconds = kTenMinutes,
    this.ttlLocked = false,
  });

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
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: OrderType(
                value: orderTypeValue,
                onToggle: onOrderTypeToggle,
              ),
            ),
            if (!editMode) ...[
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: TimeToLive(
                  dropdownValue: ttlSeconds,
                  dropdownItems: availableTtlValues(),
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
                      await Share.share(ref
                          .read(requestOrderProvider)
                          .getAddressToShare(orderDetailsData));
                    },
                    onCopy: () async {
                      await copyToClipboard(
                          context,
                          ref
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
                  onPressed: onPressed,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
