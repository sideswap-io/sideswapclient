import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
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
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';

class MakeOrderPanel extends HookConsumerWidget {
  const MakeOrderPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const headerDefaultColor = Color(0xFF043857);
    const headerActiveColor = Color(0xFF084366);
    const panelColor = SideSwapColors.chathamsBlue;

    final trackingToggled = useState(false);
    final trackingValue = useState(0.0);
    final isSell = useState(true);
    final expanded = useState(false);
    final controllerAmount = useTextEditingController();
    final controllerPrice = useTextEditingController();
    final focusNodeAmount = useFocusNode();
    final focusNodePrice = useFocusNode();

    useEffect(() {
      controllerPrice.clear();
      trackingValue.value = 0;

      return;
    }, [trackingToggled.value]);

    useEffect(() {
      controllerAmount.clear();
      focusNodeAmount.requestFocus();

      return;
    }, [isSell.value]);

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

    final selectedAssetId = ref.watch(marketSelectedAssetIdProvider);
    final selectedAsset = ref.watch(assetsStateProvider)[selectedAssetId];
    final liquidAssetId = ref.watch(liquidAssetIdProvider);
    final pricedInLiquid =
        ref.watch(assetUtilsProvider).isPricedInLiquid(asset: selectedAsset);
    final buttonIndexPrice = ref.watch(indexPriceButtonProvider);

    final selectedMarket = assetMarketType(selectedAsset)!;
    final balanceAssetId =
        pricedInLiquid == isSell.value ? selectedAssetId : liquidAssetId;
    final trackingAvailable = selectedAsset?.swapMarket == true;

    useEffect(() {
      controllerPrice.text = buttonIndexPrice;

      return;
    }, [buttonIndexPrice]);

    final resetCallback = useCallback(() {
      controllerAmount.clear();
      controllerPrice.clear();
      trackingValue.value = 0.0;
      trackingToggled.value = false;
    }, []);

    final submitCallback = useCallback(() {
      final wallet = ref.read(walletProvider);
      final asset = ref.read(assetsStateProvider)[selectedAssetId];
      final amount = double.tryParse(controllerAmount.text) ?? 0.0;
      final price = double.tryParse(controllerPrice.text) ?? 0.0;
      final isAssetAmount = !(asset?.swapMarket == true);
      final indexPrice = trackingToggled.value
          ? trackerValueToIndexPrice(trackingValue.value)
          : null;
      final account = getBalanceAccount(asset);
      final sign = isSell.value ? -1 : 1;
      final amountWithSign = amount * sign;

      wallet.submitOrder(
        selectedAssetId,
        amountWithSign,
        price,
        isAssetAmount: isAssetAmount,
        indexPrice: indexPrice,
        account: account.account,
      );

      resetCallback();
    }, [selectedAssetId, trackingValue.value, isSell.value]);

    final handleMaxCallback = useCallback(() {
      final asset = ref.read(assetsStateProvider)[selectedAssetId];
      final assetPrecision = ref
          .read(assetUtilsProvider)
          .getPrecisionForAssetId(assetId: selectedAssetId);
      final isPricedInLiquid =
          ref.read(assetUtilsProvider).isPricedInLiquid(asset: asset);
      final liquidAssetId = ref.read(liquidAssetIdProvider);
      final account = isPricedInLiquid
          ? getBalanceAccount(asset)
          : AccountAsset(AccountType.reg, liquidAssetId);
      final balance = ref.read(balancesProvider).balances[account] ?? 0;
      final amountProvider = ref.read(amountToStringProvider);
      final balanceStr = amountProvider.amountToString(
          AmountToStringParameters(amount: balance, precision: assetPrecision));
      setControllerValue(controllerAmount, balanceStr);
      focusNodePrice.requestFocus();
    }, [selectedAssetId]);

    useEffect(() {
      final selectedAsset = ref.read(assetsStateProvider)[selectedAssetId];
      if (assetMarketType(selectedAsset) == MarketType.token) {
        isSell.value = true;
      }

      resetCallback();

      return;
    }, [selectedAssetId]);

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
                  borderRadius: expanded.value
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
                        SvgPicture.asset(
                          expanded.value
                              ? 'assets/arrow_up.svg'
                              : 'assets/arrow_down.svg',
                        ),
                        const Spacer(),
                        SwitchButton(
                          width: 142,
                          height: 35,
                          borderRadius: 8,
                          borderWidth: 3,
                          fontSize: 13,
                          activeText: 'Sell'.tr(),
                          inactiveText: 'Buy'.tr(),
                          value: isSell.value,
                          activeToggleBackground:
                              isSell.value ? sellColor : buyColor,
                          inactiveToggleBackground: const Color(0xFF0E4D72),
                          backgroundColor: const Color(0xFF0E4D72),
                          borderColor: const Color(0xFF0E4D72),
                          onToggle: selectedMarket != MarketType.token
                              ? (value) {
                                  isSell.value = value;
                                }
                              : null,
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
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: FocusTraversalGroup(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DOrderAmountEnter(
                            caption: 'Amount'.tr(),
                            assetId: pricedInLiquid
                                ? selectedAssetId
                                : liquidAssetId,
                            controller: controllerAmount,
                            autofocus: true,
                            focusNode: focusNodeAmount,
                            onEditingComplete: () {
                              focusNodePrice.requestFocus();
                            },
                          ),
                          const SizedBox(height: 8),
                          if (isSell.value)
                            FocusTraversalGroup(
                              descendantsAreFocusable: false,
                              child: BalanceLine(
                                assetId: balanceAssetId,
                                onMaxPressed: handleMaxCallback,
                              ),
                            ),
                          const SizedBox(height: 8),
                          Consumer(
                            builder: (context, ref, child) {
                              final indexPrice = ref
                                  .watch(indexPriceForAssetProvider(
                                      selectedAssetId))
                                  .indexPrice;
                              final priceHint = trackingToggled.value
                                  ? priceStr(
                                      indexPrice *
                                          trackerValueToIndexPrice(
                                              trackingValue.value),
                                      false)
                                  : '0';

                              return DOrderAmountEnter(
                                caption: isSell.value
                                    ? 'Offer price'.tr()
                                    : 'Bid price'.tr(),
                                assetId: pricedInLiquid
                                    ? liquidAssetId
                                    : selectedAssetId,
                                controller: controllerPrice,
                                isPriceField: true,
                                focusNode: focusNodePrice,
                                onEditingComplete: submitCallback,
                                readonly: trackingToggled.value,
                                hintText: priceHint,
                              );
                            },
                          ),
                          if (!isSell.value)
                            BalanceLine(
                              assetId: balanceAssetId,
                              onMaxPressed: null,
                            ),
                          if (trackingAvailable)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: DEnterTrackingPrice(
                                trackingToggled: trackingToggled.value,
                                trackingValue: trackingValue.value,
                                invertColors: !isSell.value,
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
                            isSell: isSell.value,
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
                    return ClipRRect(
                      child: Align(
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
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: ProductColumns(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
