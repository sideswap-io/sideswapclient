import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/common/utils/use_interval.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/prompt_allow_tx_chaining.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/listeners/order_review_listeners.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/order_details_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/markets/widgets/sign_type.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/screens/markets/widgets/autosign.dart';
import 'package:sideswap/screens/markets/widgets/order_type.dart';
import 'package:sideswap/screens/markets/widgets/share_and_copy_buttons_row.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';
import 'package:sideswap/screens/markets/widgets/time_to_live.dart';

// TODO (malcolmpl): Fix entire widget
class CreateOrderView extends HookConsumerWidget {
  const CreateOrderView({
    super.key,
    this.requestOrder,
  });

  final RequestOrder? requestOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetailsData = ref.watch(orderDetailsDataNotifierProvider);

    final autoSign = useState(false);
    final editMode = useState(false);
    final ttlLocked = useState(false);
    final buttonDisabled = useState(false);
    final expiresTitle = useState('');
    final isModifyDialogOpened = useState(false);

    useEffect(() {
      if (requestOrder != null) {
        final assetPrecision = ref
            .read(assetUtilsProvider)
            .getPrecisionForAssetId(assetId: requestOrder!.assetId);
        final newOrderDetailsData =
            OrderDetailsData.fromRequestOrder(requestOrder!, assetPrecision);
        Future.microtask(() => ref
            .read(orderDetailsDataNotifierProvider.notifier)
            .setOrderDetailsData(newOrderDetailsData));

        autoSign.value = newOrderDetailsData.autoSign;
        editMode.value = requestOrder != null;
        final expires = requestOrder!.getExpireDescription();
        expiresTitle.value = 'TTL: $expires';
      } else {
        autoSign.value = orderDetailsData.autoSign;
      }

      Future.microtask(() => ref
          .read(indexPriceSubscriberNotifierProvider.notifier)
          .subscribeOne(orderDetailsData.assetId));

      return;
    }, const []);

    // Close current view when request expire
    useInterval(() {
      if (requestOrder == null) {
        return;
      }

      final expiresAt = requestOrder!.getExpiresAt();
      if (expiresAt == null || !expiresAt.isNegative) {
        final expires = requestOrder!.getExpireDescription();
        expiresTitle.value = 'TTL: $expires';
      } else {
        if (isModifyDialogOpened.value) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.registered);
      }
    }, const Duration(seconds: 1));

    useAsyncEffect(() async {
      if (requestOrder case RequestOrder requestOrder) {
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
    }, [requestOrder, orderDetailsData]);

    final goBackCallback = useCallback(() {
      return switch (requestOrder) {
        RequestOrder(own: true, twoStep: true) => () {
            ref.read(walletProvider).goBack();
          }(),
        RequestOrder()? => ref
            .read(pageStatusNotifierProvider.notifier)
            .setStatus(Status.registered),
        _ => () {
            final twoStep = ref.read(orderReviewTwoStepProvider);
            final ttl = ref.read(orderReviewTtlProvider);
            final public = ref.read(orderReviewPublicProvider);

            ref.read(walletProvider).setSubmitDecision(
                  accept: false,
                  autosign: autoSign.value,
                  private: !public,
                  ttlSeconds: ttl,
                  twoStep: twoStep,
                );
            ref
                .read(pageStatusNotifierProvider.notifier)
                .setStatus(Status.registered);
          }(),
      };
    }, []);

    return SideSwapScaffold(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          goBackCallback();
        }
      },
      appBar: editMode.value
          ? CustomAppBar(
              title: expiresTitle.value,
              showTrailingButton: true,
              trailingWidget: SvgPicture.asset(
                'assets/delete.svg',
                width: 24,
                height: 24,
              ),
              onTrailingButtonPressed: () {
                ref.read(walletProvider).cancelOrder(requestOrder!.orderId);
                goBackCallback();
              },
              onPressed: () {
                goBackCallback();
              },
            )
          : CustomAppBar(
              title: 'Create order'.tr(),
              onPressed: () {
                goBackCallback();
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
                    if (requestOrder != null) {
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

                        useAsyncEffect(() async {
                          final orderDetailsData =
                              OrderDetailsData.fromRequestOrder(
                                  requestOrder, assetPrecision);

                          ref
                              .read(orderDetailsDataNotifierProvider.notifier)
                              .setOrderDetailsData(orderDetailsData);

                          return;
                        }, [requestOrder]);
                      }
                    }

                    final ttlSeconds = ref.watch(orderReviewTtlProvider);
                    final twoStep = ref.watch(orderReviewTwoStepProvider);
                    final public = ref.watch(orderReviewPublicProvider);

                    useAsyncEffect(() async {
                      if (twoStep) {
                        autoSign.value = true;
                      }

                      return;
                    }, [twoStep]);

                    return CreateOrderViewBody(
                      autoSign: autoSign,
                      twoStepSignValue: twoStep,
                      editMode: editMode,
                      orderDetailsData: orderDetailsData,
                      orderTypeValue: public,
                      requestOrder: requestOrder,
                      ttlSeconds: ttlSeconds,
                      ttlLocked: ttlLocked,
                      onPressed: buttonDisabled.value
                          ? null
                          : () async {
                              final wallet = ref.read(walletProvider);

                              bool allowChaining = false;
                              if (twoStep &&
                                  orderDetailsData.txChainingRequired) {
                                allowChaining =
                                    await allowTxChaining(context, ref);
                                if (!allowChaining) {
                                  return;
                                }
                              }

                              if (!await wallet.isAuthenticated()) {
                                return;
                              }

                              ref.read(walletProvider).setSubmitDecision(
                                    accept: true,
                                    autosign: autoSign.value,
                                    private: !public,
                                    ttlSeconds: ttlSeconds,
                                    twoStep: twoStep,
                                    allowTxChaining: allowChaining,
                                  );

                              buttonDisabled.value = true;
                            },
                      onAutoSignToggle: editMode.value
                          ? (value) {
                              ref.read(walletProvider).modifyOrderAutoSign(
                                  orderDetailsData.orderId, value);
                              autoSign.value = value;
                            }
                          : (value) {
                              autoSign.value = value;
                            },
                      onOrderTypeToggle: editMode.value
                          ? null
                          : (value) {
                              ref
                                  .read(orderReviewPublicProvider.notifier)
                                  .setPublic(value);
                            },
                      onTwoStepSignToggle: editMode.value
                          ? null
                          : (value) {
                              ref
                                  .read(orderReviewTwoStepProvider.notifier)
                                  .setTwoStep(value);
                            },
                      onModifyPrice: () async {
                        isModifyDialogOpened.value = true;
                        await ref
                            .read(marketsHelperProvider)
                            .onModifyPrice(ref, requestOrder);
                        isModifyDialogOpened.value = false;
                      },
                      onCancelOrder: () {
                        ref
                            .read(walletProvider)
                            .cancelOrder(requestOrder!.orderId);
                        goBackCallback();
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

                        if (editMode.value) {
                          if (await ref
                              .read(walletProvider)
                              .isAuthenticated()) {
                            ref.read(walletProvider).setSubmitDecision(
                                  accept: true,
                                  autosign: autoSign.value,
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
    required this.autoSign,
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
    required this.ttlLocked,
  });

  final ValueNotifier<bool> autoSign;
  final ValueNotifier<bool> editMode;
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
  final ValueNotifier<bool> ttlLocked;
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
                autoSign: autoSign.value,
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
            if (!editMode.value) ...[
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
            switch (editMode.value) {
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
