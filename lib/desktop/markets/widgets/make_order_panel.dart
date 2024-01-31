import 'package:decimal/decimal.dart';
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
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
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
    final buttonIndexPrice = ref.watch(indexPriceButtonStreamNotifierProvider);

    final trackingAvailable = selectedAsset?.swapMarket == true;

    useEffect(() {
      (switch (buttonIndexPrice) {
        AsyncValue(hasValue: true, value: String data) when data.isNotEmpty =>
          () {
            controllerPrice.text = data;
          }(),
        _ => () {
            controllerPrice.clear();
          }(),
      });

      return;
    }, [buttonIndexPrice]);

    final resetCallback = useCallback(() {
      controllerAmount.clear();
      controllerPrice.clear();
      trackingValue.value = 0.0;
      trackingToggled.value = false;

      Future.microtask(() => ref.invalidate(makeOrderSideStateProvider));
    }, []);

    final submitCallback = useCallback(() {
      final asset = ref.read(assetsStateProvider)[selectedAccountAsset.assetId];
      final amount = double.tryParse(controllerAmount.text) ?? 0.0;
      final price = double.tryParse(controllerPrice.text) ?? 0.0;
      final isAssetAmount = !(asset?.swapMarket == true);
      final indexPrice = trackingToggled.value
          ? trackerValueToIndexPrice(trackingValue.value)
          : null;
      final account = ref.watch(accountAssetFromAssetProvider(asset));
      final sign = isSell ? -1 : 1;
      final amountWithSign = amount * sign;

      ref.read(walletProvider).submitOrder(
            selectedAccountAsset.assetId,
            amountWithSign,
            price,
            isAssetAmount: isAssetAmount,
            indexPrice: indexPrice,
            account: account.account,
          );
      ref.invalidate(indexPriceButtonStreamNotifierProvider);
      resetCallback();
    }, [selectedAccountAsset, trackingValue.value, isSell]);

    final pricePerUnit = ref.watch(marketOrderPriceNotifierProvider);

    // called when max button is clicked
    final handleMaxCallback = useCallback(() {
      final asset = ref.read(assetsStateProvider)[selectedAccountAsset.assetId];
      final assetPrecision = ref
          .read(assetUtilsProvider)
          .getPrecisionForAssetId(assetId: selectedAccountAsset.assetId);
      final isPricedInLiquid =
          ref.read(assetUtilsProvider).isPricedInLiquid(asset: asset);

      final marketSide = ref.read(makeOrderSideStateProvider);
      // on buy side calculate max amount based on index price and buying power
      if (marketSide == MakeOrderSide.buy) {
        final indexPrice = ref
            .read(indexPriceForAssetProvider(selectedAccountAsset.assetId))
            .indexPrice;
        final lastPrice = ref
            .read(lastIndexPriceForAssetProvider(selectedAccountAsset.assetId));
        final indexPriceStr = priceStr(indexPrice, isPricedInLiquid);
        final lastPriceStr = priceStr(lastPrice, isPricedInLiquid);
        final targetIndexPriceStr =
            indexPrice != 0 ? indexPriceStr : lastPriceStr;
        ref
            .read(indexPriceButtonStreamNotifierProvider.notifier)
            .setIndexPrice(targetIndexPriceStr);

        final orderBalance = ref.read(makeOrderBalanceProvider);

        final targetIndexPrice =
            Decimal.tryParse(targetIndexPriceStr) ?? Decimal.zero;
        final balance = orderBalance.asDecimal();
        if (targetIndexPrice != Decimal.zero) {
          final targetAmount = (balance / targetIndexPrice)
              .toDecimal(scaleOnInfinitePrecision: assetPrecision)
              .toStringAsFixed(assetPrecision);
          setControllerValue(controllerAmount, targetAmount);
          return;
        }
      }

      // for sell side insert max balance only
      final liquidAssetId = ref.read(liquidAssetIdStateProvider);
      final account = isPricedInLiquid
          ? ref.read(accountAssetFromAssetProvider(asset))
          : AccountAsset(AccountType.reg, liquidAssetId);
      final balance = ref.read(balancesNotifierProvider)[account] ?? 0;
      final amountProvider = ref.read(amountToStringProvider);
      final balanceStr = amountProvider.amountToString(
          AmountToStringParameters(amount: balance, precision: assetPrecision));
      setControllerValue(controllerAmount, balanceStr);
      focusNodePrice.requestFocus();
    }, [selectedAccountAsset, pricePerUnit]);

    useEffect(() {
      final selectedAsset =
          ref.read(assetsStateProvider)[selectedAccountAsset.assetId];
      if (assetMarketType(selectedAsset) == MarketType.token) {
        Future.microtask(() => ref
            .read(makeOrderSideStateProvider.notifier)
            .setSide(MakeOrderSide.sell));
      }

      resetCallback();

      return;
    }, [selectedAccountAsset]);

    // run only once on first build
    useEffect(() {
      resetCallback();

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
                                indexPriceButtonStreamNotifierProvider);
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
                            onMaxPressed: handleMaxCallback,
                          ),
                          const SizedBox(height: 8),
                          MakeOrderPanelValueSide(
                            controller: controllerPrice,
                            focusNode: focusNodePrice,
                            onEditingComplete: submitCallback,
                            trackingToggled: trackingToggled,
                            trackingValue: trackingValue,
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
                            onPressed: submitCallback,
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
                                  indexPriceButtonStreamNotifierProvider);
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
  });

  final void Function()? onMaxPressed;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;

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
  });

  final ValueNotifier<bool> trackingToggled;
  final ValueNotifier<double> trackingValue;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;

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
          onChanged: (value) {},
        ),
        const BalanceLine(
          onMaxPressed: null,
        ),
      ],
    );
  }
}
