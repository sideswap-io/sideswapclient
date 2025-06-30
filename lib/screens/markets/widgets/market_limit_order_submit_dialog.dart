import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/desktop/markets/widgets/d_order_submit_dialog.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/onboarding/widgets/error_icon.dart';
import 'package:sideswap/screens/onboarding/widgets/success_icon.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const orderSubmitRouteName = '/orderSubmitDialog';

class OrderSubmitDialog extends HookConsumerWidget {
  const OrderSubmitDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != orderSubmitRouteName;
      });

      // clear order submit state
      Future.microtask(() {
        ref.invalidate(orderSubmitNotifierProvider);
        ref.invalidate(orderSubmitSuccessNotifierProvider);
        ref.invalidate(orderSubmitErrorNotifierProvider);
        ref.invalidate(orderSubmitUnregisteredGaidNotifierProvider);
      });
    });

    final optionOrderSubmitSuccess = ref.watch(
      orderSubmitSuccessNotifierProvider,
    );
    final optionOrderSubmitError = ref.watch(orderSubmitErrorNotifierProvider);
    final optionOrderSubmitUnregisteredGaid = ref.watch(
      orderSubmitUnregisteredGaidNotifierProvider,
    );

    useEffect(
      () {
        if (optionOrderSubmitSuccess.isNone() &&
            optionOrderSubmitError.isNone() &&
            optionOrderSubmitUnregisteredGaid.isNone()) {
          closeCallback();
        }
        return;
      },
      [
        optionOrderSubmitSuccess,
        optionOrderSubmitError,
        optionOrderSubmitUnregisteredGaid,
      ],
    );

    return switch (FlavorConfig.isDesktop) {
      true => optionOrderSubmitSuccess.match(
        () => optionOrderSubmitError.match(
          () => optionOrderSubmitUnregisteredGaid.match(
            () => SizedBox(),
            (_) => OrderSubmitUnregisteredGaid(onClose: closeCallback),
          ),
          (_) => OrderSubmitErrorDialog(onClose: closeCallback),
        ),
        (_) => OrderSubmitSuccessDialog(onClose: closeCallback),
      ),
      _ => optionOrderSubmitSuccess.match(
        () => optionOrderSubmitError.match(
          () => optionOrderSubmitUnregisteredGaid.match(
            () => SizedBox(),
            (_) => MobileOrderSubmitUnregisteredGaid(onClose: closeCallback),
          ),
          (_) => MobileOrderSubmitErrorDialog(onClose: closeCallback),
        ),
        (_) => MobileOrderSubmitSuccessDialog(
          onClose: () {
            ref.invalidate(limitOrderPriceProvider);
            ref.invalidate(limitOrderAmountProvider);
            ref.invalidate(limitOrderAmountControllerNotifierProvider);
            ref.invalidate(limitOrderPriceControllerNotifierProvider);
            closeCallback();
            ref
                .read(pageStatusNotifierProvider.notifier)
                .setStatus(Status.registered);
            ref
                .read(selectedMarketTypeButtonNotifierProvider.notifier)
                .setSelectedMarketType(SelectedMarketTypeButtonEnum.orders);
          },
        ),
      ),
    };
  }
}

class MobileOrderSubmitUnregisteredGaid extends HookConsumerWidget {
  const MobileOrderSubmitUnregisteredGaid({required this.onClose, super.key});

  final void Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      onClose: () {
        onClose();
      },
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            ErrorIcon(width: 166, height: 166),
            SizedBox(height: 32),
            Text(
              'Unregistered AMP ID'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final optionUnregisteredGaid = ref.watch(
                  orderSubmitUnregisteredGaidNotifierProvider,
                );
                return optionUnregisteredGaid.match(
                  () => SizedBox(),
                  (domainAgent) => Column(
                    children: [
                      Text(
                        'Please register your AMP ID at'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          await openUrl('https://$domainAgent');
                        },
                        child: Text(
                          'https://$domainAgent',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: SideSwapColors.brightTurquoise,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Spacer(),
            CustomBigButton(
              width: double.infinity,
              height: 54,
              text: 'CLOSE'.tr(),
              backgroundColor: SideSwapColors.brightTurquoise,
              onPressed: () {
                onClose();
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class MobileOrderSubmitErrorDialog extends HookConsumerWidget {
  const MobileOrderSubmitErrorDialog({required this.onClose, super.key});

  final void Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      onClose: () {
        onClose();
      },
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            ErrorIcon(width: 166, height: 166),
            SizedBox(height: 32),
            Text(
              'Order submit error'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Consumer(
              builder: (context, ref, child) {
                final optionOrderSubmitError = ref.watch(
                  orderSubmitErrorNotifierProvider,
                );

                return optionOrderSubmitError.match(
                  () => SizedBox(),
                  (error) => Text(
                    error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
            Spacer(),
            CustomBigButton(
              width: double.infinity,
              height: 54,
              text: 'CLOSE'.tr(),
              backgroundColor: SideSwapColors.brightTurquoise,
              onPressed: () {
                onClose();
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class MobileOrderSubmitSuccessDialog extends HookConsumerWidget {
  const MobileOrderSubmitSuccessDialog({required this.onClose, super.key});

  final void Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionOrderSubmitSuccess = ref.watch(
      orderSubmitSuccessNotifierProvider,
    );

    return SideSwapPopup(
      onClose: () {
        onClose();
      },
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onClose();
        }
      },
      child: optionOrderSubmitSuccess.match(
        () {
          return SizedBox();
        },
        (order) {
          final isSell = order.tradeDir == TradeDir.SELL;
          final dirStr = isSell ? 'Sell'.tr() : 'Buy'.tr();
          final dirColor = isSell
              ? Theme.of(context).extension<MarketColorsStyle>()!.sellColor
              : Theme.of(context).extension<MarketColorsStyle>()!.buyColor;

          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 32),
                  SuccessIcon(width: 166, height: 166),
                  SizedBox(height: 32),
                  Text(
                    'Order submit success'.tr(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Product'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(
                        order.productName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Amount'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(
                        order.amountString,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 8),
                            order.amountIcon,
                            Spacer(),
                            Text(order.baseAsset.toNullable()?.ticker ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Price per unit'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(
                        order.priceString,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 8),
                            order.priceIcon,
                            Spacer(),
                            Text(order.quoteAsset.toNullable()?.ticker ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Total'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(
                        order.total,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 8),
                            order.priceIcon,
                            Spacer(),
                            Text(order.quoteAsset.toNullable()?.ticker ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Side'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(
                        dirStr,
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: dirColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Order type'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(order.orderTypeDescription),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Two step'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(order.offlineSwapTypeDescription),
                    ],
                  ),
                  Spacer(),
                  CustomBigButton(
                    width: double.infinity,
                    height: 54,
                    text: 'OK'.tr(),
                    backgroundColor: SideSwapColors.brightTurquoise,
                    onPressed: () {
                      onClose();
                    },
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
