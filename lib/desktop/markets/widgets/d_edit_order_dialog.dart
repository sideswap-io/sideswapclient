import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/button_styles.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider.dart';
import 'package:sideswap/common/widgets/sideswap_slider/sideswap_slider_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/markets/widgets/d_tracking_price.dart';
import 'package:sideswap/providers/limit_edit_order_providers.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';
import 'package:sideswap/screens/markets/widgets/market_amount_text_field.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const orderEditRouteName = '/desktopOrderEdit';

class DEditOrderDialog extends HookConsumerWidget {
  const DEditOrderDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .dialogTheme
        .merge(
          const DContentDialogThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
          ),
        );

    final optionOrder = ref.watch(marketEditDetailsOrderNotifierProvider);

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != orderEditRouteName;
      });
    });

    final editAmountController = useTextEditingController();
    final amountFocusNode = useFocusNode();

    useEffect(() {
      editAmountController.addListener(() {
        Future.microtask(() {
          ref
              .read(marketEditOrderAmountControllerNotifierProvider.notifier)
              .setState(editAmountController.text);
        });
      });

      return;
    }, const []);

    final editPriceController = useTextEditingController();
    final priceFocusNode = useFocusNode();

    useEffect(() {
      editPriceController.addListener(() {
        Future.microtask(() {
          ref
              .read(marketEditOrderPriceControllerNotifierProvider.notifier)
              .setState(editPriceController.text);
        });
      });

      return;
    }, const []);

    final optionOldSubscribedAssetPair = useState(Option<AssetPair>.none());
    final marketSubscribeAssetPairNotifier = ref.watch(
      marketSubscribedAssetPairNotifierProvider.notifier,
    );

    useEffect(() {
      optionOrder.match(
        () => () {},
        (order) => () {
          // set startup values
          editAmountController.text = order.amountTextInputString;
          editPriceController.text = order.priceMobileString;

          if (order.isPriceTracking) {
            // set tracking value on startup
            Future.microtask(
              () => ref
                  .read(
                    marketLimitTrackIndexPriceValueNotifierProvider.notifier,
                  )
                  .setState(
                    TrackingValue(
                      trackingValue: order.priceTrackingPercent.toDouble(),
                    ),
                  ),
            );

            // saved old subscribed market
            final optionSubscribedAssetPair = ref.read(
              marketSubscribedAssetPairNotifierProvider,
            );
            optionSubscribedAssetPair.match(() => () {}, (assetPair) {
              optionOldSubscribedAssetPair.value = Option.of(assetPair);
            });

            // subscribe to the market from the order asset pair
            Future.microtask(
              () => ref
                  .read(marketSubscribedAssetPairNotifierProvider.notifier)
                  .setState(order.assetPair),
            );
          }
        },
      )();

      return () {
        // subscribe to the previously subscribed market
        optionOldSubscribedAssetPair.value.match(() => () {}, (assetPair) {
          Future.microtask(
            () => marketSubscribeAssetPairNotifier.setState(assetPair),
          );
        });
      };
    }, const []);

    final trackingOrderAmount = ref.watch(limitEditOrderPriceProvider);

    useEffect(() {
      optionOrder.match(() {}, (order) {
        if (!order.isPriceTracking) {
          return;
        }

        editPriceController.text = trackingOrderAmount.asString();
      });

      return;
    }, [optionOrder, trackingOrderAmount]);

    final acceptEnabled = ref.watch(marketEditOrderAcceptEnabledProvider);

    final optionEditAmount = ref.watch(marketEditOrderAmountProvider);
    final optionEditPrice = ref.watch(marketEditOrderPriceProvider);

    useEffect(() {
      // update order amount
      optionEditAmount.match(
        () {},
        (amount) => optionOrder.match(() {}, (order) {
          if (amount.amount != order.amountDecimal) {
            Future.microtask(() {
              order.ownOrder.origAmount = Int64(amount.asSatoshi());
              ref
                  .read(marketEditDetailsOrderNotifierProvider.notifier)
                  .setState(order);
            });
          }
        }),
      );

      // update order price
      optionEditPrice.match(
        () {},
        (editPrice) => optionOrder.match(() {}, (order) {
          if (editPrice.asDouble() != order.ownOrder.price) {
            Future.microtask(() {
              order.ownOrder.price = editPrice.asDouble();
              ref
                  .read(marketEditDetailsOrderNotifierProvider.notifier)
                  .setState(order);
            });
          }
        }),
      );

      return;
    }, [optionEditAmount, optionEditPrice, optionOrder]);

    final showDeleteDialogCallback = useCallback(() {
      return showDialog<bool>(
        context: context,
        builder: (context) {
          return HookBuilder(
            builder: (context) {
              final dialogNoFocusNode = useFocusNode();

              useEffect(() {
                dialogNoFocusNode.requestFocus();

                return;
              }, const []);

              return AlertDialog(
                title: Text('Delete order?'.tr()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: <Widget>[
                  TextButton(
                    style: Theme.of(
                      context,
                    ).extension<SideswapYesButtonStyle>()!.style,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(true);
                    },
                    child: Text('Yes').tr(),
                  ),
                  TextButton(
                    focusNode: dialogNoFocusNode,
                    style: Theme.of(
                      context,
                    ).extension<SideswapNoButtonStyle>()!.style,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(false);
                    },
                    child: Text('No').tr(),
                  ),
                ],
              );
            },
          );
        },
      );
    });

    final trackingPriceStyle = Theme.of(
      context,
    ).extension<DTrackingPriceStyle>();

    final defaultTrackingStyle = DTrackingPriceStyle(
      negativeColor:
          trackingPriceStyle?.negativeColor ?? SideSwapColors.bitterSweet,
      positiveColor:
          trackingPriceStyle?.positiveColor ?? SideSwapColors.turquoise,
      circleNegativeColor:
          trackingPriceStyle?.circleNegativeColor ?? SideSwapColors.policeBlue,
      circlePositiveColor:
          trackingPriceStyle?.circlePositiveColor ??
          SideSwapColors.metallicSeaweed,
      textStyle:
          trackingPriceStyle?.textStyle ??
          Theme.of(context).textTheme.titleSmall,
      switchActiveColor:
          trackingPriceStyle?.switchActiveColor ??
          SideSwapColors.brightTurquoise,
      switchInactiveColor:
          trackingPriceStyle?.switchInactiveColor ?? SideSwapColors.ataneoBlue,
      switchToggleColor: trackingPriceStyle?.switchToggleColor ?? Colors.white,
    );

    final invertColors = optionOrder.match(
      () => false,
      (order) => order.tradeDir == TradeDir.BUY,
    );

    final startColor = invertColors
        ? defaultTrackingStyle.positiveColor!
        : defaultTrackingStyle.negativeColor!;
    final endColor = invertColors
        ? defaultTrackingStyle.negativeColor!
        : defaultTrackingStyle.positiveColor!;
    final circleStartColor = invertColors
        ? defaultTrackingStyle.circlePositiveColor!
        : defaultTrackingStyle.circleNegativeColor!;
    final circleEndColor = invertColors
        ? defaultTrackingStyle.circleNegativeColor!
        : defaultTrackingStyle.circlePositiveColor!;
    final textStyle = defaultTrackingStyle.textStyle!;

    final trackingValue = ref.watch(
      marketLimitTrackIndexPriceValueNotifierProvider,
    );

    const maxPercent = 5.0;
    final minPercent = -maxPercent;
    final minPercentStr = '$minPercent%';
    final maxPercentStr = '+$maxPercent%';
    final valueStr =
        '${trackingValue.asDouble() > 0 ? '+' : ''}${trackingValue.asDouble()}%';

    final trackingRangeConverter = ref.watch(trackingRangeConverterProvider);

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 635),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text('Edit order'.tr()),
        onClose: () {
          closeCallback();
        },
      ),
      content: SizedBox(
        width: 580,
        height: 530,
        child: optionOrder.match(
          () => const SizedBox(),
          (order) => Column(
            children: [
              order.baseAsset.match(
                () => const SizedBox(),
                (baseAsset) => MarketAmountTextField(
                  caption: 'Amount'.tr(),
                  asset: baseAsset,
                  controller: editAmountController,
                  autofocus: true,
                  focusNode: amountFocusNode,
                  onEditingComplete: () {},
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 12),
              order.quoteAsset.match(
                () => const SizedBox(),
                (quoteAsset) => MarketAmountTextField(
                  caption: order.tradeDir == TradeDir.SELL
                      ? 'Offer price per unit'.tr()
                      : 'Bid price per unit'.tr(),
                  asset: quoteAsset,
                  controller: editPriceController,
                  autofocus: true,
                  focusNode: priceFocusNode,
                  readonly: order.isPriceTracking,
                  onEditingComplete: () {},
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 12),
              MarketDeliverRow(
                deliverAsset: order.tradeDir == TradeDir.SELL
                    ? order.baseAsset
                    : order.quoteAsset,
                deliverAmount: order.tradeDir == TradeDir.SELL
                    ? order.amountString
                    : order.total,
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.glacier.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              MarketReceiveRow(
                receiveAsset: order.tradeDir == TradeDir.SELL
                    ? order.quoteAsset
                    : order.baseAsset,
                receiveAmount: order.tradeDir == TradeDir.SELL
                    ? order.total
                    : order.amountString,
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.glacier.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Order type'.tr(),
                    style: Theme.of(
                      context,
                    ).extension<MarketAssetRowStyle>()!.labelStyle,
                  ),
                  const Spacer(),
                  Text(
                    order.orderTypeDescription,
                    style: Theme.of(
                      context,
                    ).extension<MarketAssetRowStyle>()!.amountStyle,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.glacier.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final side = order.tradeDir == TradeDir.SELL
                      ? 'Sell'.tr()
                      : 'Buy'.tr();
                  final sideColor = order.tradeDir == TradeDir.SELL
                      ? Theme.of(
                          context,
                        ).extension<MarketColorsStyle>()!.sellColor
                      : Theme.of(
                          context,
                        ).extension<MarketColorsStyle>()!.buyColor;

                  return Row(
                    children: [
                      Text(
                        'Side'.tr(),
                        style: Theme.of(context)
                            .extension<MarketAssetRowStyle>()!
                            .labelStyle
                            ?.copyWith(color: SideSwapColors.brightTurquoise),
                      ),
                      const Spacer(),
                      Text(
                        side,
                        style: Theme.of(context)
                            .extension<MarketAssetRowStyle>()!
                            .amountStyle
                            ?.copyWith(color: sideColor),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 12),
              ...switch (order.isPriceTracking) {
                true => [
                  ColoredContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 34,
                          child: Row(
                            children: [
                              Text(
                                'Track index price'.tr(),
                                style: Theme.of(
                                  context,
                                ).extension<MarketAssetRowStyle>()!.labelStyle,
                              ),
                              const Spacer(),
                              FlutterSwitch(
                                disabled: true,
                                value: true,
                                onToggle: (value) {},
                                width: 40,
                                height: 22,
                                toggleSize: 18,
                                padding: 2,
                                activeColor:
                                    trackingPriceStyle!.switchActiveColor!,
                                inactiveColor:
                                    trackingPriceStyle.switchInactiveColor!,
                                toggleColor:
                                    trackingPriceStyle.switchToggleColor!,
                              ),
                            ],
                          ),
                        ),
                        SideSwapSlider(
                          min: -5,
                          max: 5,
                          value: trackingValue.asDouble(),
                          themeData: SideSwapSliderThemeData(
                            axisInteraction:
                                SideSwapSliderAxisInteraction.center,
                            activeTrackColor: endColor,
                            inactiveTrackMarkColor: startColor,
                            activeTrackMarkColor: Colors.white,
                            inactiveTrackColor: SideSwapColors.navyBlue,
                            trackShape: SideSwapDefaultSliderTrackShape(
                              leftGradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  startColor,
                                  SideSwapColors.navyBlue
                                      .withValues(alpha: 0.24)
                                      .withValues(alpha: .1),
                                ],
                              ),
                              rightGradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  SideSwapColors.navyBlue
                                      .withValues(alpha: 0.24)
                                      .withValues(alpha: .1),
                                  endColor,
                                ],
                              ),
                            ),
                            hatchMarkShape: SideSwapDefaultSliderHatchMarkShape(
                              markHeight: 0,
                              padding: 4.0,
                            ),
                            thumbShape: SideSwapDefaultSliderThumbShape(
                              thumbColor: trackingValue.asDouble() < 0
                                  ? circleStartColor
                                  : trackingValue.asDouble() > 0
                                  ? circleEndColor
                                  : SideSwapColors.prussianBlue,
                              frameColor: SideSwapColors.navyBlue,
                              leftColor: startColor,
                              rightColor: endColor,
                            ),
                          ),
                          marks: [
                            SideSwapSliderTrackMark(value: -5),
                            SideSwapSliderTrackMark(value: -4),
                            SideSwapSliderTrackMark(value: -3),
                            SideSwapSliderTrackMark(value: -2),
                            SideSwapSliderTrackMark(value: -1),
                            SideSwapSliderTrackMark(value: 0),
                            SideSwapSliderTrackMark(value: 1),
                            SideSwapSliderTrackMark(value: 2),
                            SideSwapSliderTrackMark(value: 3),
                            SideSwapSliderTrackMark(value: 4),
                            SideSwapSliderTrackMark(value: 5),
                          ],
                          onChanged: (value) {
                            final newValue = trackingRangeConverter
                                .toRangeWithPrecision(value);
                            ref
                                .read(
                                  marketLimitTrackIndexPriceValueNotifierProvider
                                      .notifier,
                                )
                                .setState(
                                  TrackingValue(trackingValue: newValue),
                                );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 8,
                            bottom: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                minPercentStr,
                                style: textStyle.copyWith(color: startColor),
                              ),
                              Text(valueStr, style: textStyle),
                              Text(
                                maxPercentStr,
                                style: textStyle.copyWith(color: endColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                false => [],
              },
              const Spacer(),
              Row(
                children: [
                  DCustomButton(
                    width: 120,
                    height: 39,
                    onPressed: () {
                      closeCallback();
                      ref.invalidate(marketEditDetailsOrderNotifierProvider);
                    },
                    child: Text('Back'.tr()),
                  ),
                  const Spacer(),
                  DCustomFilledBigButton(
                    width: 120,
                    height: 39,
                    onPressed: acceptEnabled
                        ? () {
                            final editAmount = optionEditAmount.toNullable();
                            final editPrice = optionEditPrice.toNullable();
                            if (editAmount == null || editPrice == null) {
                              return;
                            }

                            // we're use external variable to keep tracking price (order.priceTracking is ommited in this place)
                            final newPriceTracking = trackingValue
                                .asDecimalPercent()
                                .toDouble();

                            final msg = To();
                            msg.orderEdit = To_OrderEdit(
                              orderId: order.orderId,
                              baseAmount: Int64(editAmount.asSatoshi()),
                              price: order.isPriceTracking
                                  ? null
                                  : editPrice.asDouble(),
                              priceTracking: order.isPriceTracking
                                  ? newPriceTracking
                                  : null,
                            );
                            ref.read(walletProvider).sendMsg(msg);

                            closeCallback();
                            ref.invalidate(
                              marketEditDetailsOrderNotifierProvider,
                            );
                          }
                        : null,
                    child: Text('Accept'.tr()),
                  ),
                  const Spacer(),
                  DCustomFilledBigButton(
                    width: 120,
                    height: 39,
                    onPressed: () async {
                      final ret = await showDeleteDialogCallback();

                      if (ret == true) {
                        final msg = To();
                        msg.orderCancel = To_OrderCancel(
                          orderId: order.orderId,
                        );
                        ref.read(walletProvider).sendMsg(msg);

                        closeCallback();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_forever, size: 24),
                        SizedBox(width: 4),
                        Text('Delete'.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
