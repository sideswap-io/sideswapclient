import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/widgets/animated_dropdown_arrow.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/markets/d_enter_tracking_price.dart';
import 'package:sideswap/desktop/markets/d_order_amount_enter.dart';
import 'package:sideswap/desktop/markets/widgets/balance_line.dart';
import 'package:sideswap/desktop/markets/widgets/make_order_button.dart';
import 'package:sideswap/desktop/markets/widgets/product_columns.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

class MakeOrderPanel extends HookConsumerWidget {
  const MakeOrderPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const headerDefaultColor = SideSwapColors.prussianBlue;
    const headerActiveColor = Color(0xFF084366);
    const panelColor = SideSwapColors.chathamsBlue;

    final trackingToggled = useState(false);
    final trackingValue = useState(0.0);
    final makeOrderSide = ref.watch(makeOrderSideStateProvider);
    final isSell = makeOrderSide == MakeOrderSide.sell;
    final expanded = useState(false);
    final controllerAmount = useTextEditingController();
    final controllerPrice = useTextEditingController();
    final focusNodeAmount = useFocusNode();
    final focusNodePrice = useFocusNode();

    useEffect(() {
      controllerAmount.addListener(() {
        Future.microtask(() => ref
            .read(marketOrderAmountNotifierProvider.notifier)
            .setOrderAmount(controllerAmount.text));
      });

      controllerPrice.addListener(() {
        Future.microtask(() => ref
            .read(marketOrderPriceNotifierProvider.notifier)
            .setOrderPrice(controllerPrice.text));
      });

      return;
    }, [controllerAmount, controllerPrice]);

    useEffect(() {
      controllerPrice.clear();
      trackingValue.value = 0;

      return;
    }, [trackingToggled.value]);

    useEffect(() {
      controllerAmount.clear();
      focusNodeAmount.requestFocus();

      return;
    }, [isSell]);

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
      initialValue: 0,
    );

    final Animation<double> heightFactor = useMemoized(() {
      return animationController.drive(CurveTween(curve: Curves.easeIn));
    }, [animationController]);

    useEffect(() {
      if (expanded.value) {
        animationController.forward();
        return;
      }

      animationController.reverse();
      return;
    }, [expanded.value]);

    final drawProductColumns = useState<bool>(false);

    useEffect(() {
      animationController.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          drawProductColumns.value = false;
          return;
        }

        if (!drawProductColumns.value) {
          drawProductColumns.value = true;
        }
      });

      return;
    }, [animationController]);

    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);
    final selectedAsset =
        ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
    final buttonIndexPrice = ref.watch(indexPriceButtonAsyncNotifierProvider);

    final assetType = assetMarketType(selectedAsset);
    final trackingAvailable = assetType != MarketType.token;

    useEffect(() {
      (switch (buttonIndexPrice) {
        AsyncValue(hasValue: true, value: String data) when data.isNotEmpty =>
          () {
            controllerPrice.text = data;
          }(),
        _ => () {}(),
      });

      return;
    }, [buttonIndexPrice]);

    final callbackHandlers = ref.watch(orderEntryCallbackHandlersProvider);

    final stokrLastSelectedAccountAsset =
        ref.watch(stokrLastSelectedAccountAssetNotifierProvider);

    useEffect(() {
      final selectedAsset =
          ref.read(assetsStateProvider)[selectedAccountAsset.assetId];
      if (assetMarketType(selectedAsset) == MarketType.token) {
        Future.microtask(() => ref
            .read(makeOrderSideStateProvider.notifier)
            .setSide(MakeOrderSide.sell));
      }

      callbackHandlers.reset(
          controllerAmount, controllerPrice, trackingValue, trackingToggled);

      return;
    }, [selectedAccountAsset]);

    useEffect(() {
      if (selectedAccountAsset != stokrLastSelectedAccountAsset) {
        Future.microtask(() {
          callbackHandlers.stokrAssetRestrictedPopup();
          ref
              .read(stokrLastSelectedAccountAssetNotifierProvider.notifier)
              .setLastSelectedAccountAsset(selectedAccountAsset);
        });
      }

      return;
    }, [selectedAccountAsset, stokrLastSelectedAccountAsset]);

    // run only once on first build
    useEffect(() {
      callbackHandlers.reset(
          controllerAmount, controllerPrice, trackingValue, trackingToggled);

      return;
    }, const []);

    return Container(
      width: 377,
      decoration: const BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          DHoverButton(
            builder: (context, states) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: states.isHovering || expanded.value
                      ? headerActiveColor
                      : headerDefaultColor,
                  borderRadius: drawProductColumns.value
                      ? const BorderRadius.vertical(top: Radius.circular(8))
                      : const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Product'.tr(),
                      style: const TextStyle(
                        color: SideSwapColors.brightTurquoise,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            final productName = ref
                                .watch(assetUtilsProvider)
                                .productName(asset: selectedAsset);
                            return Text(
                              productName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        AnimatedDropdownArrow(target: expanded.value ? 1 : 0),
                        const Spacer(),
                        SwitchButton(
                          width: 142,
                          height: 35,
                          borderRadius: 8,
                          borderWidth: 3,
                          fontSize: 13,
                          activeText: 'Sell'.tr(),
                          inactiveText: 'Buy'.tr(),
                          value: makeOrderSide == MakeOrderSide.sell,
                          activeToggleBackground:
                              makeOrderSide == MakeOrderSide.sell
                                  ? sellColor
                                  : buyColor,
                          inactiveToggleBackground: const Color(0xFF0E4D72),
                          backgroundColor: const Color(0xFF0E4D72),
                          borderColor: const Color(0xFF0E4D72),
                          onToggle: (value) {
                            if (value) {
                              ref
                                  .read(makeOrderSideStateProvider.notifier)
                                  .setSide(MakeOrderSide.sell);
                            } else {
                              ref
                                  .read(makeOrderSideStateProvider.notifier)
                                  .setSide(MakeOrderSide.buy);
                            }
                            ref.invalidate(
                                indexPriceButtonAsyncNotifierProvider);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            onPressed: () {
              expanded.value = !expanded.value;
            },
          ),
          Flexible(
            child: Stack(
              children: [
                FocusTraversalGroup(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        children: [
                          MakeOrderPanelAmountSide(
                            controller: controllerAmount,
                            focusNode: focusNodeAmount,
                            onEditingComplete: focusNodePrice.requestFocus,
                            onMaxPressed: () {
                              callbackHandlers.handleMax(
                                  controllerAmount, focusNodePrice);
                            },
                          ),
                          const SizedBox(height: 8),
                          MakeOrderPanelValueSide(
                            controller: controllerPrice,
                            focusNode: focusNodePrice,
                            onEditingComplete: () {
                              callbackHandlers.submit(
                                  controllerAmount,
                                  controllerPrice,
                                  trackingToggled,
                                  trackingValue);
                            },
                            trackingToggled: trackingToggled,
                            trackingValue: trackingValue,
                            onChanged: (value) {
                              ref.invalidate(
                                  indexPriceButtonAsyncNotifierProvider);
                            },
                          ),
                          if (trackingAvailable)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: DEnterTrackingPrice(
                                trackingToggled: trackingToggled.value,
                                trackingValue: trackingValue.value,
                                invertColors: !isSell,
                                onTrackingChanged: (value) {
                                  trackingValue.value = value;
                                },
                                onTrackingToggle: (value) {
                                  trackingToggled.value = value;
                                },
                              ),
                            ),
                          const SizedBox(height: 8),
                          MakeOrderButton(
                            isSell: isSell,
                            onPressed: () {
                              callbackHandlers.submit(
                                  controllerAmount,
                                  controllerPrice,
                                  trackingToggled,
                                  trackingValue);
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController.view,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      heightFactor: heightFactor.value,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: headerActiveColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: switch (drawProductColumns.value) {
                    true => () {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ProductColumns(
                            onAssetSelected: () {
                              expanded.value = !expanded.value;
                              ref.invalidate(
                                  indexPriceButtonAsyncNotifierProvider);
                            },
                          ),
                        );
                      }(),
                    _ => () {
                        return const SizedBox();
                      }(),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MakeOrderPanelAmountSide extends ConsumerWidget {
  const MakeOrderPanelAmountSide({
    this.onMaxPressed,
    required this.controller,
    this.focusNode,
    this.onEditingComplete,
    super.key,
    this.onChanged,
  });

  final void Function()? onMaxPressed;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);
    final selectedAsset =
        ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
    final pricedInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final liquidAccountAsset =
        AccountAsset(selectedAccountAsset.account, liquidAssetId);
    ref.watch(marketOrderAmountNotifierProvider);

    return Column(
      children: [
        DOrderAmountEnter(
          caption: 'Amount'.tr(),
          accountAsset:
              pricedInLiquid ? selectedAccountAsset : liquidAccountAsset,
          controller: controller,
          autofocus: true,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
        ),
        FocusTraversalGroup(
          descendantsAreFocusable: false,
          child: BalanceLine(
            onMaxPressed: onMaxPressed,
            amountSide: true,
          ),
        ),
      ],
    );
  }
}

class MakeOrderPanelValueSide extends ConsumerWidget {
  const MakeOrderPanelValueSide({
    required this.trackingToggled,
    required this.trackingValue,
    required this.controller,
    this.focusNode,
    this.onEditingComplete,
    super.key,
    this.onChanged,
  });

  final ValueNotifier<bool> trackingToggled;
  final ValueNotifier<double> trackingValue;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);

    final indexPrice = ref
        .watch(indexPriceForAssetProvider(selectedAccountAsset.assetId))
        .indexPrice;
    final priceHint = trackingToggled.value
        ? priceStr(
            indexPrice * trackerValueToIndexPrice(trackingValue.value), false)
        : '0';
    final makeOrderSide = ref.watch(makeOrderSideStateProvider);
    final isSell = makeOrderSide == MakeOrderSide.sell;
    final selectedAsset =
        ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
    final pricedInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final liquidAccountAsset =
        AccountAsset(selectedAccountAsset.account, liquidAssetId);
    ref.watch(marketOrderPriceNotifierProvider);

    return Column(
      children: [
        DOrderAmountEnter(
          caption:
              isSell ? 'Offer price per unit'.tr() : 'Bid price per unit'.tr(),
          accountAsset:
              pricedInLiquid ? liquidAccountAsset : selectedAccountAsset,
          controller: controller,
          isPriceField: true,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          readonly: trackingToggled.value,
          hintText: priceHint,
          onChanged: onChanged,
        ),
        const BalanceLine(
          onMaxPressed: null,
        ),
      ],
    );
  }
}
