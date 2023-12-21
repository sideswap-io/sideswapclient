import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/prompt_allow_tx_chaining.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/listeners/order_review_listeners.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/sign_type.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/screens/markets/widgets/autosign.dart';
import 'package:sideswap/screens/markets/widgets/order_type.dart';
import 'package:sideswap/screens/markets/widgets/share_and_copy_buttons_row.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';
import 'package:sideswap/screens/markets/widgets/time_to_live.dart';
import 'package:sideswap/screens/qr_scanner/address_qr_scanner.dart';

class CreateOrderView extends StatefulHookConsumerWidget {
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

  late OrderDetailsData orderDetailsData;
  bool editMode = false;
  String expiresTitle = '';
  Timer? _expireTimer;
  bool isModifyDialogOpened = false;
  bool ttlLocked = false;
  bool buttonDisabled = false;

  @override
  void initState() {
    super.initState();

    if (widget.requestOrder != null) {
      final assetPrecision = ref
          .read(assetUtilsProvider)
          .getPrecisionForAssetId(assetId: widget.requestOrder!.assetId);
      orderDetailsData = OrderDetailsData.fromRequestOrder(
          widget.requestOrder!, assetPrecision);

      autoSignValue = orderDetailsData.autoSign;
      editMode = widget.requestOrder != null;
      final expires = widget.requestOrder!.getExpireDescription();
      expiresTitle = 'TTL: $expires';

      // Close current view when request expire
      _expireTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final expiresAt = widget.requestOrder!.getExpiresAt();
        if (expiresAt == null || !expiresAt.isNegative) {
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

  void onGoBack() {
    ref.read(marketsProvider).unsubscribeIndexPrice();

    return switch (widget.requestOrder) {
      RequestOrder(own: true, twoStep: true) => () {
          ref.read(walletProvider).goBack();
        }(),
      RequestOrder()? => ref.read(walletProvider).setRegistered(),
      _ => () {
          final twoStep = ref.read(orderReviewTwoStepProvider);
          final ttl = ref.read(orderReviewTtlProvider);
          final public = ref.read(orderReviewPublicProvider);

          ref.read(walletProvider).setSubmitDecision(
                accept: false,
                autosign: autoSignValue,
                private: !public,
                ttlSeconds: ttl,
                twoStep: twoStep,
              );
          ref.read(walletProvider).setRegistered();
        }(),
    };
  }

  @override
  Widget build(BuildContext context) {
    orderDetailsData = ref.watch(walletProvider).orderDetailsData;

    useAsyncEffect(() async {
      if (widget.requestOrder case RequestOrder requestOrder) {
        ref
            .read(orderReviewPublicProvider.notifier)
            .setPublic(!requestOrder.private);
        ref
            .read(orderReviewTwoStepProvider.notifier)
            .setTwoStep(requestOrder.twoStep);
      } else {
        ref
            .read(orderReviewPublicProvider.notifier)
            .setPublic(!orderDetailsData.private);
        ref
            .read(orderReviewTwoStepProvider.notifier)
            .setTwoStep(!orderDetailsData.isTracking);
      }

      return;
    }, [widget.requestOrder, orderDetailsData]);

    return SideSwapScaffold(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          onGoBack();
        }
      },
      appBar: editMode
          ? CustomAppBar(
              title: expiresTitle,
              showTrailingButton: true,
              trailingWidget: SvgPicture.asset(
                'assets/delete.svg',
                width: 24,
                height: 24,
              ),
              onTrailingButtonPressed: () {
                ref
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
                child: HookConsumer(
                  builder: (context, ref, child) {
                    if (widget.requestOrder != null) {
                      // update data if swapRequest has changed
                      final marketOrderList =
                          ref.watch(marketRequestOrderListProvider);
                      final index = marketOrderList.indexWhere(
                          (e) => e.orderId == orderDetailsData.orderId);
                      if (index >= 0) {
                        final requestOrder = marketOrderList[index];
                        final assetPrecision = ref
                            .watch(assetUtilsProvider)
                            .getPrecisionForAssetId(
                                assetId: requestOrder.assetId);
                        orderDetailsData = OrderDetailsData.fromRequestOrder(
                            requestOrder, assetPrecision);
                      }
                    }

                    final ttlSeconds = ref.watch(orderReviewTtlProvider);
                    final twoStep = ref.watch(orderReviewTwoStepProvider);
                    final public = ref.watch(orderReviewPublicProvider);

                    useEffect(() {
                      // if order is offline turn on autosign too
                      if (twoStep) {
                        autoSignValue = true;
                      }

                      return;
                    }, [twoStep]);

                    return CreateOrderViewBody(
                      autoSignValue: autoSignValue,
                      twoStepSignValue: twoStep,
                      editMode: editMode,
                      orderDetailsData: orderDetailsData,
                      orderTypeValue: public,
                      requestOrder: widget.requestOrder,
                      ttlSeconds: ttlSeconds,
                      ttlLocked: ttlLocked,
                      onPressed: buttonDisabled
                          ? null
                          : () async {
                              final wallet = ref.read(walletProvider);

                              bool allowChaining = false;
                              if (twoStep &&
                                  wallet.orderDetailsData.txChainingRequired) {
                                allowChaining = await allowTxChaining(context);
                                if (!allowChaining) {
                                  return;
                                }
                              }

                              if (!await wallet.isAuthenticated()) {
                                return;
                              }

                              ref.read(walletProvider).setSubmitDecision(
                                    accept: true,
                                    autosign: autoSignValue,
                                    private: !public,
                                    ttlSeconds: ttlSeconds,
                                    twoStep: twoStep,
                                    allowTxChaining: allowChaining,
                                  );

                              setState(() {
                                buttonDisabled = true;
                              });
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
                              ref
                                  .read(orderReviewPublicProvider.notifier)
                                  .setPublic(value);
                            },
                      onTwoStepSignToggle: editMode
                          ? null
                          : (value) {
                              ref
                                  .read(orderReviewTwoStepProvider.notifier)
                                  .setTwoStep(value);
                            },
                      onModifyPrice: () async {
                        isModifyDialogOpened = true;
                        await ref
                            .read(marketsProvider)
                            .onModifyPrice(ref, widget.requestOrder);
                        isModifyDialogOpened = false;
                      },
                      onCancelOrder: () {
                        ref
                            .read(walletProvider)
                            .cancelOrder(widget.requestOrder!.orderId);
                        onGoBack();
                      },
                      onTtlChanged: (value) async {
                        if (value case int value) {
                          ref
                              .read(orderReviewTtlChangedFlagProvider.notifier)
                              .setTtlChanged();
                          ref
                              .read(orderReviewTtlProvider.notifier)
                              .setTtl(value);
                        }

                        if (editMode) {
                          if (await ref
                              .read(walletProvider)
                              .isAuthenticated()) {
                            ref.read(walletProvider).setSubmitDecision(
                                  accept: true,
                                  autosign: autoSignValue,
                                  private: !public,
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
    required this.twoStepSignValue,
    required this.onPressed,
    this.onAutoSignToggle,
    this.onOrderTypeToggle,
    this.onTwoStepSignToggle,
    this.requestOrder,
    this.onModifyPrice,
    this.onCancelOrder,
    this.onTtlChanged,
    this.ttlSeconds = kTenMinutes,
    this.ttlLocked = false,
  });

  final bool autoSignValue;
  final bool editMode;
  final bool orderTypeValue;
  final bool twoStepSignValue;
  final OrderDetailsData orderDetailsData;
  final void Function(bool)? onAutoSignToggle;
  final void Function(bool)? onOrderTypeToggle;
  final void Function(bool)? onTwoStepSignToggle;
  final RequestOrder? requestOrder;
  final VoidCallback? onModifyPrice;
  final VoidCallback? onCancelOrder;
  final void Function(int?)? onTtlChanged;
  final int ttlSeconds;
  final bool ttlLocked;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const OrderReviewTtlChangedFlagListener(),
            const OrderReviewTwoStepListener(),

            OrderTable(
              orderDetailsData: orderDetailsData,
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SignType(
                twoStep: twoStepSignValue,
                onToggle: onTwoStepSignToggle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: AutoSign(
                value: autoSignValue || twoStepSignValue,
                onToggle: twoStepSignValue ? null : onAutoSignToggle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OrderType(
                value: orderTypeValue,
                onToggle: onOrderTypeToggle,
              ),
            ),
            if (!editMode) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TimeToLive(
                  dropdownValue: ttlSeconds,
                  dropdownItems: availableTtlValues(twoStepSignValue),
                  onChanged: onTtlChanged,
                  locked: onTtlChanged == null ? true : false,
                ),
              ),
            ],
            const Spacer(),
            // bottom button
            switch (editMode) {
              // edit && private
              true when requestOrder!.private => Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: ShareAndCopyButtonsRow(
                    onShare: () async {
                      await Share.share(ref.read(
                          addressToShareByOrderIdProvider(
                              orderDetailsData.orderId)));
                    },
                    onCopy: () async {
                      await copyToClipboard(
                          context,
                          ref.read(addressToShareByOrderIdProvider(
                              orderDetailsData.orderId)));
                    },
                  ),
                ),
              // edit && offline
              true when twoStepSignValue => Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
                    text: 'CANCEL ORDER'.tr(),
                    textColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                        color: SideSwapColors.brightTurquoise, width: 2),
                    onPressed: onCancelOrder,
                  ),
                ),
              // any other edit
              true => Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
                    text: 'MODIFY PRICE'.tr(),
                    textColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                        color: SideSwapColors.brightTurquoise, width: 2),
                    onPressed: onModifyPrice,
                  ),
                ),
              // create order
              _ => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
                    text: 'CREATE ORDER'.tr(),
                    textColor: Colors.white,
                    backgroundColor: SideSwapColors.brightTurquoise,
                    onPressed: onPressed,
                  ),
                ),
            },
          ],
        ),
      ),
    );
  }
}
