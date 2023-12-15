import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/markets/widgets/make_order_button.dart';
import 'package:sideswap/desktop/markets/widgets/make_order_panel.dart';
import 'package:sideswap/listeners/markets_page_listener.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/swap_market_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/market_select_popup.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:easy_localization/easy_localization.dart';

part 'order_entry.g.dart';

class OrderEntry extends ConsumerWidget {
  const OrderEntry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: const IntrinsicHeight(
                child: Column(
                  children: [
                    MarketsPageListener(),
                    SizedBox(height: 14),
                    OrderEntryHeader(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            OrderEntryIndexPrice(),
                            Expanded(
                              child: OrderEntryAmount(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class OrderEntryHeader extends StatelessWidget {
  const OrderEntryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SideSwapColors.ataneoBlue,
            SideSwapColors.prussianBlue,
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            OrderEntryHeaderTickerDropdown(),
            Spacer(),
            OrderEntryHeaderBuySellButtons(),
            SizedBox(width: 8),
            OrderEntryCloseButton(),
          ],
        ),
      ),
    );
  }
}

@riverpod
String tickerDropdownProductName(TickerDropdownProductNameRef ref) {
  final swapMarketCurrentProduct = ref.watch(swapMarketCurrentProductProvider);
  final asset = ref.watch(assetsStateProvider
      .select((value) => value[swapMarketCurrentProduct.accountAsset.assetId]));
  final productName = ref.watch(assetUtilsProvider).productName(asset: asset);
  return productName;
}

class OrderEntryHeaderTickerDropdown extends ConsumerWidget {
  const OrderEntryHeaderTickerDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productName = ref.watch(tickerDropdownProductNameProvider);

    return TextButton(
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.zero),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push<void>(
          MaterialPageRoute(builder: (context) {
            return MarketSelectPopup(
              onAssetSelected: () {
                // subscribeToMarket();
              },
            );
          }),
        );
      },
      child: Row(
        children: [
          Text(
            productName,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(height: 0.05),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.expand_more,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}

@riverpod
MarketType selectedMarketType(SelectedMarketTypeRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final selectedAsset =
      ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];
  final selectedMarket = assetMarketType(selectedAsset);
  return selectedMarket;
}

@riverpod
bool isSellSide(IsSellSideRef ref) {
  final makeOrderSide = ref.watch(makeOrderSideStateProvider);
  final isSell = makeOrderSide == MakeOrderSide.sell;

  return isSell;
}

class OrderEntryHeaderBuySellButtons extends HookConsumerWidget {
  const OrderEntryHeaderBuySellButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketOrderSide = ref.watch(makeOrderSideStateProvider);
    final isSell = marketOrderSide == MakeOrderSide.sell;

    return Material(
      color: Colors.transparent,
      child: SwitchButton(
        width: 130,
        height: 35,
        borderRadius: 8,
        borderWidth: 2,
        fontSize: 13,
        activeText: 'Sell'.tr(),
        inactiveText: 'Buy'.tr(),
        value: isSell,
        activeToggleBackground:
            isSell ? SideSwapColors.bitterSweet : SideSwapColors.turquoise,
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
          ref.read(indexPriceButtonProvider.notifier).setIndexPrice('0');
        },
      ),
    );
  }
}

class OrderEntryCloseButton extends ConsumerWidget {
  const OrderEntryCloseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 24,
      height: 24,
      child: TextButton(
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: () {
          ref.read(walletProvider).goBack();
        },
        child: const Icon(
          Icons.close,
          color: SideSwapColors.pewterBlue,
        ),
      ),
    );
  }
}

@riverpod
({double indexPrice, String indexPriceStr, String lastPriceStr}) indexPriceData(
    IndexPriceDataRef ref) {
  final selectedAccountAsset =
      ref.watch(marketSelectedAccountAssetStateProvider);
  final asset = ref.watch(assetsStateProvider
      .select((value) => value[selectedAccountAsset.assetId]));
  final pricedInLiquid =
      ref.watch(assetUtilsProvider).isPricedInLiquid(asset: asset);
  final indexPrice = ref
      .watch(indexPriceForAssetProvider(selectedAccountAsset.assetId))
      .indexPrice;
  final lastPrice =
      ref.watch(lastIndexPriceForAssetProvider(selectedAccountAsset.assetId));
  final indexPriceStr = priceStr(indexPrice, pricedInLiquid);
  final lastPriceStr = priceStr(lastPrice, pricedInLiquid);

  return (
    indexPrice: indexPrice,
    indexPriceStr: indexPriceStr,
    lastPriceStr: lastPriceStr
  );
}

class OrderEntryIndexPrice extends ConsumerWidget {
  const OrderEntryIndexPrice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexPriceData = ref.watch(indexPriceDataProvider);
    final targetIndexPrice = ref.watch(targetIndexPriceProvider);

    return Container(
      height: 36,
      decoration: const BoxDecoration(
        color: SideSwapColors.blueSapphire,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: TextButton(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.zero),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        onPressed: () {
          ref
              .read(indexPriceButtonProvider.notifier)
              .setIndexPrice(targetIndexPrice);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              indexPriceData.indexPrice != 0
                  ? 'Index price:'.tr()
                  : 'Last price:'.tr(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  height: 0.08,
                  color: SideSwapColors.brightTurquoise),
            ),
            const SizedBox(width: 6),
            Consumer(
              builder: (context, ref, _) {
                final targetIndexPrice = ref.watch(targetIndexPriceProvider);
                return Text(
                  targetIndexPrice,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 15, height: 0.08),
                );
              },
            ),
            const SizedBox(width: 6),
            Consumer(
              builder: (context, ref, _) {
                final selectedAccountAsset =
                    ref.watch(marketSelectedAccountAssetStateProvider);

                final icon = ref
                    .watch(assetImageProvider)
                    .getSmallImage(selectedAccountAsset.assetId);

                return SizedBox(width: 16, child: icon);
              },
            ),
            const SizedBox(width: 2),
            Consumer(
              builder: (context, ref, _) {
                final ticker = ref.watch(selectedAssetTickerProvider);
                return Text(
                  ticker,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 15, height: 0.08),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OrderEntryAmount extends HookConsumerWidget {
  const OrderEntryAmount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAmount = useTextEditingController();
    final controllerPrice = useTextEditingController();
    final focusNodeAmount = useFocusNode();
    final focusNodePrice = useFocusNode();

    final trackingToggled = useState(false);
    final trackingValue = useState(0.0);

    final makeOrderSide = ref.watch(makeOrderSideStateProvider);
    final isSell = makeOrderSide == MakeOrderSide.sell;

    final callbackHandlers = ref.watch(orderEntryCallbackHandlersProvider);

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

    final buttonIndexPrice = ref.watch(indexPriceButtonProvider);

    useEffect(() {
      controllerPrice.text = buttonIndexPrice;

      return;
    });

    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);

    useEffect(() {
      callbackHandlers.reset(
          controllerAmount, controllerPrice, trackingValue, trackingToggled);

      return;
    }, [selectedAccountAsset]);

    return Column(
      children: [
        const SizedBox(height: 24),
        MakeOrderPanelAmountSide(
          controller: controllerAmount,
          focusNode: focusNodeAmount,
          onEditingComplete: focusNodePrice.requestFocus,
          onMaxPressed: () {
            callbackHandlers.handleMax(controllerAmount, focusNodePrice);
          },
        ),
        const SizedBox(height: 8),
        MakeOrderPanelValueSide(
          controller: controllerPrice,
          focusNode: focusNodePrice,
          onEditingComplete: () {
            callbackHandlers.submit(controllerAmount, controllerPrice,
                trackingToggled, trackingValue);
          },
          trackingToggled: trackingToggled,
          trackingValue: trackingValue,
        ),
        const Spacer(),
        MakeOrderButton(
          isSell: isSell,
          onPressed: () {
            callbackHandlers.submit(controllerAmount, controllerPrice,
                trackingToggled, trackingValue);
          },
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
