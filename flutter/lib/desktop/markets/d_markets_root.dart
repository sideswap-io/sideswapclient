import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/main/d_charts.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/timer_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/markets/widgets/market_type_buttons.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_thumb_shape.dart';
import 'package:sideswap/screens/markets/widgets/order_tracking_slider_track_shape.dart';
import 'package:sideswap/screens/markets/widgets/switch_buton.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

const sellColor = Color(0xFFFF7878);
const buyColor = Color(0xFF2CCCBF);

String marketTypeName(MarketType type) {
  switch (type) {
    case MarketType.stablecoin:
      return 'Stablecoins'.tr();
    case MarketType.amp:
      return 'AMP Listings'.tr();
    case MarketType.token:
      return 'Token Market'.tr();
  }
}

MarketType? assetMarketType(Asset asset) {
  if (asset.swapMarket) {
    return MarketType.stablecoin;
  }
  if (asset.ampMarket) {
    return MarketType.amp;
  }
  if (!asset.unregistered) {
    return MarketType.token;
  }
  return null;
}

bool isPricedInLiquid(Asset asset) {
  return !asset.swapMarket;
}

AccountAsset getBalanceAccount(Asset asset) {
  return AccountAsset(
    asset.ampMarket ? AccountType.amp : AccountType.reg,
    asset.assetId,
  );
}

String productName(Asset asset) {
  if (isPricedInLiquid(asset)) {
    return '${asset.ticker} / $kLiquidBitcoinTicker';
  }
  return '$kLiquidBitcoinTicker / ${asset.ticker}';
}

int Function(RequestOrder a, RequestOrder b) compareRequestOrder(int sign) {
  return ((a, b) => sign * a.price.compareTo(b.price));
}

class DMarkets extends ConsumerStatefulWidget {
  const DMarkets({super.key});

  @override
  ConsumerState<DMarkets> createState() => _DMarketsState();
}

class _DMarketsState extends ConsumerState<DMarkets> {
  MarketSelectedType selectedMarketType = MarketSelectedType.orders;
  late String selectedAssetId;

  late MarketsProvider markets;

  bool showCharts = false;

  @override
  void initState() {
    super.initState();
    markets = ref.read(marketsProvider);
    selectedAssetId = ref.read(walletProvider).tetherAssetId();
    updateSelected();
  }

  @override
  void dispose() {
    markets.unsubscribeIndexPrice();
    markets.unsubscribeMarket();
    super.dispose();
  }

  void updateSelected() {
    final selectedAsset = ref.read(walletProvider).assets[selectedAssetId]!;
    if (selectedAsset.swapMarket || selectedAsset.ampMarket) {
      markets.subscribeIndexPrice(selectedAssetId);
      markets.subscribeSwapMarket(selectedAssetId);
    } else {
      markets.subscribeTokenMarket();
    }
  }

  void handleAssetSelected(String value) {
    setState(() {
      selectedAssetId = value;
      updateSelected();
    });
  }

  void handleChartsPressed() {
    setState(() {
      showCharts = true;
    });
  }

  void handleChartsBackPressed() {
    setState(() {
      showCharts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: showCharts,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _MakeOrderPanel(
                        selectedAssetId: selectedAssetId,
                        onAssetSelected: handleAssetSelected,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _OrdersPanel(
                            selectedAssetId: selectedAssetId,
                            onChartsPressed: handleChartsPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _WorkingOrders(
                  onAssetSelected: handleAssetSelected,
                ),
              ],
            ),
          ),
        ),
        if (showCharts)
          DCharts(
              assetId: selectedAssetId, onBackPressed: handleChartsBackPressed)
      ],
    );
  }
}

class _MakeOrderPanel extends ConsumerStatefulWidget {
  const _MakeOrderPanel({
    required this.selectedAssetId,
    required this.onAssetSelected,
  });

  final String selectedAssetId;
  final ValueChanged<String> onAssetSelected;

  @override
  ConsumerState<_MakeOrderPanel> createState() => _MakeOrderPanelState();
}

class _MakeOrderPanelState extends ConsumerState<_MakeOrderPanel> {
  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  FocusNode focusNodeAmount = FocusNode();
  FocusNode focusNodePrice = FocusNode();

  bool isSell = true;
  bool expanded = false;
  bool trackingToggled = false;
  double trackingValue = 0.0;

  @override
  void dispose() {
    controllerAmount.dispose();
    controllerPrice.dispose();
    focusNodePrice.dispose();
    focusNodeAmount.dispose();
    super.dispose();
  }

  void handleAssetSelected(String value) {
    setState(() {
      final wallet = ref.read(walletProvider);
      final selectedAsset = wallet.assets[value]!;
      expanded = false;
      if (widget.selectedAssetId != value) {
        widget.onAssetSelected(value);
        if (assetMarketType(selectedAsset) == MarketType.token) {
          isSell = true;
        }
        reset();
      }
    });
  }

  void handleSubmit() async {
    final wallet = ref.read(walletProvider);
    final asset = wallet.assets[widget.selectedAssetId]!;
    final amount = double.tryParse(controllerAmount.text) ?? 0.0;
    final price = double.tryParse(controllerPrice.text) ?? 0.0;
    final isAssetAmount = !asset.swapMarket;
    final indexPrice =
        trackingToggled ? trackerValueToIndexPrice(trackingValue) : null;
    final account = getBalanceAccount(asset);
    final sign = isSell ? -1 : 1;
    final amountWithSign = amount * sign;

    wallet.submitOrder(
      widget.selectedAssetId,
      amountWithSign,
      price,
      isAssetAmount: isAssetAmount,
      indexPrice: indexPrice,
      account: account.account,
    );
    reset();
  }

  void handleMax() {
    final wallet = ref.read(walletProvider);
    final asset = wallet.assets[widget.selectedAssetId]!;
    final account = isPricedInLiquid(asset)
        ? getBalanceAccount(asset)
        : AccountAsset(AccountType.reg, wallet.liquidAssetId());
    final balance = ref.watch(balancesProvider).balances[account] ?? 0;
    final balanceStr = amountStr(balance, precision: asset.precision);
    setState(() {
      setValue(controllerAmount, balanceStr);
      focusNodePrice.requestFocus();
    });
  }

  void handleTrackingToggled(bool value) {
    setState(() {
      controllerPrice.clear();
      trackingToggled = value;
      trackingValue = 0;
    });
  }

  void handleTrackingChanged(double value) {
    setState(() {
      trackingValue = value;
    });
  }

  void handleIsSellChanged(bool value) {
    setState(() {
      isSell = value;
      controllerAmount.clear();
      focusNodeAmount.requestFocus();
    });
  }

  void reset() {
    setState(() {
      controllerAmount.clear();
      controllerPrice.clear();
      trackingValue = 0.0;
      trackingToggled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const headerDefaultColor = Color(0xFF043857);
    const headerActiveColor = Color(0xFF084366);
    const panelColor = Color(0xFF1C6086);

    final wallet = ref.watch(walletProvider);
    final selectedAsset = wallet.assets[widget.selectedAssetId]!;
    final selectedMarket = assetMarketType(selectedAsset)!;
    final pricedInLiquid = isPricedInLiquid(selectedAsset);
    final balanceAssetId = pricedInLiquid == isSell
        ? widget.selectedAssetId
        : wallet.liquidAssetId();
    final trackingAvailable = selectedAsset.swapMarket;

    final priceHint = trackingToggled
        ? priceStr(
            ref
                    .read(marketsProvider)
                    .getIndexPriceForAsset(widget.selectedAssetId) *
                trackerValueToIndexPrice(trackingValue),
            false)
        : '0';

    return Container(
      width: 377,
      decoration: BoxDecoration(
        color: expanded ? headerActiveColor : panelColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          DHoverButton(
            builder: (context, states) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: states.isHovering || expanded
                      ? headerActiveColor
                      : headerDefaultColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Product'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF00C5FF),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Text(
                          productName(selectedAsset),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SvgPicture.asset(
                          expanded
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
                          value: isSell,
                          activeToggleBackground: isSell ? sellColor : buyColor,
                          inactiveToggleBackground: const Color(0xFF0E4D72),
                          backgroundColor: const Color(0xFF0E4D72),
                          borderColor: const Color(0xFF0E4D72),
                          onToggle: selectedMarket != MarketType.token
                              ? handleIsSellChanged
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            onPressed: () {
              setState(() {
                expanded = !expanded;
              });
            },
          ),
          if (!expanded)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: FocusTraversalGroup(
                  child: Column(
                    children: [
                      DOrderAmountEnter(
                        caption: 'Amount'.tr(),
                        assetId: pricedInLiquid
                            ? widget.selectedAssetId
                            : wallet.liquidAssetId(),
                        controller: controllerAmount,
                        autofocus: true,
                        focusNode: focusNodeAmount,
                        onEditingComplete: () {
                          focusNodePrice.requestFocus();
                        },
                      ),
                      const SizedBox(height: 8),
                      if (isSell)
                        FocusTraversalGroup(
                          descendantsAreFocusable: false,
                          child: _BalanceLine(
                            assetId: balanceAssetId,
                            onMaxPressed: handleMax,
                          ),
                        ),
                      const SizedBox(height: 8),
                      DOrderAmountEnter(
                        caption: isSell ? 'Offer price'.tr() : 'Bid price'.tr(),
                        assetId: pricedInLiquid
                            ? wallet.liquidAssetId()
                            : widget.selectedAssetId,
                        controller: controllerPrice,
                        isPriceField: true,
                        focusNode: focusNodePrice,
                        onEditingComplete: handleSubmit,
                        readonly: trackingToggled,
                        hintText: priceHint,
                      ),
                      if (!isSell)
                        _BalanceLine(
                          assetId: balanceAssetId,
                          onMaxPressed: null,
                        ),
                      if (trackingAvailable)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: DEnterTrackingPrice(
                            trackingToggled: trackingToggled,
                            trackingValue: trackingValue,
                            invertColors: !isSell,
                            onTrackingChanged: handleTrackingChanged,
                            onTrackingToggle: handleTrackingToggled,
                          ),
                        ),
                      const Spacer(),
                      _MakeOrderButton(
                        isSell: isSell,
                        onPressed: handleSubmit,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          if (expanded)
            Expanded(
              child: ProductColumns(
                selectedAssetId: widget.selectedAssetId,
                onAssetSelected: handleAssetSelected,
              ),
            )
        ],
      ),
    );
  }
}

class ProductColumns extends StatelessWidget {
  const ProductColumns({
    Key? key,
    required this.selectedAssetId,
    required this.onAssetSelected,
  }) : super(key: key);

  final String selectedAssetId;
  final ValueChanged<String> onAssetSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AssetSelector(
            marketType: MarketType.stablecoin,
            selectedAssetId: selectedAssetId,
            onAssetSelected: onAssetSelected,
          ),
          _AssetSelector(
            marketType: MarketType.amp,
            selectedAssetId: selectedAssetId,
            onAssetSelected: onAssetSelected,
          ),
          _AssetSelector(
            marketType: MarketType.token,
            selectedAssetId: selectedAssetId,
            onAssetSelected: onAssetSelected,
          ),
        ],
      ),
    );
  }
}

class _AssetSelector extends ConsumerWidget {
  const _AssetSelector({
    required this.marketType,
    required this.selectedAssetId,
    required this.onAssetSelected,
  });

  final MarketType marketType;
  final String selectedAssetId;
  final ValueChanged<String> onAssetSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);

    // Only show token assets that we could sell or buy
    final tokenAssetsToSell = ref
        .watch(balancesProvider)
        .balances
        .entries
        .where((e) => e.key.account == AccountType.reg && e.value > 0)
        .map((e) => e.key.asset);
    final tokenAssetsToBuy = ref
        .watch(marketsProvider)
        .marketOrders
        .where((e) => e.marketType == MarketType.token)
        .map((e) => e.assetId);
    final validTokenAssets = Set<String>.from(tokenAssetsToSell);
    validTokenAssets.addAll(tokenAssetsToBuy);

    final assets = wallet.assetsList.map((e) => wallet.assets[e]!).where((e) =>
        e.assetId != wallet.liquidAssetId() &&
        e.assetId != wallet.bitcoinAssetId() &&
        assetMarketType(e) == marketType &&
        (marketType != MarketType.token ||
            validTokenAssets.contains(e.assetId)));

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    marketTypeName(marketType),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF00C5FF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(height: 1, color: const Color(0xFF3E82A8)),
                  const SizedBox(height: 9),
                ],
              ),
            ),
            Column(
              children: assets.map((e) {
                final icon = wallet.assetImagesSmall[e.assetId]!;
                final selected = e.assetId == selectedAssetId;
                return DHoverButton(
                  builder: (context, states) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: selected
                            ? Colors.grey
                            : (states.isHovering
                                ? const Color(0xFF12577A)
                                : null),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: icon,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            e.ticker,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  onPressed: () {
                    onAssetSelected(e.assetId);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MakeOrderButton extends StatelessWidget {
  const _MakeOrderButton({
    required this.isSell,
    this.onPressed,
  });

  final bool isSell;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = isSell ? sellColor : buyColor;
    return DCustomFilledBigButton(
      width: 344,
      height: 44,
      onPressed: onPressed,
      style: DButtonStyle(
        padding: ButtonState.all(EdgeInsets.zero),
        textStyle: ButtonState.all(
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ButtonState.resolveWith((states) {
          if (states.isDisabled) {
            return color.lerpWith(Colors.black, 0.3);
          }
          if (states.isPressing) {
            return color.lerpWith(Colors.black, 0.2);
          }
          if (states.isHovering) {
            return color.lerpWith(Colors.black, 0.1);
          }
          return color;
        }),
        foregroundColor: ButtonState.resolveWith(
          (states) {
            if (states.isDisabled) {
              return Colors.white.lerpWith(Colors.black, 0.3);
            }
            return Colors.white;
          },
        ),
        shape: ButtonState.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        border: ButtonState.resolveWith((states) {
          return const BorderSide(color: Colors.transparent, width: 1);
        }),
      ),
      child: Text(
        'Continue'.tr().toUpperCase(),
      ),
    );
  }
}

class DOrderAmountEnter extends ConsumerStatefulWidget {
  const DOrderAmountEnter({
    super.key,
    required this.caption,
    required this.assetId,
    required this.controller,
    this.isPriceField = false,
    this.autofocus = false,
    this.focusNode,
    this.onEditingComplete,
    this.readonly = false,
    this.hintText = '0',
  });

  final String caption;
  final String assetId;
  final TextEditingController controller;
  final bool isPriceField;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final bool readonly;
  final String hintText;

  @override
  ConsumerState<DOrderAmountEnter> createState() => _DOrderAmountEnterState();
}

class _DOrderAmountEnterState extends ConsumerState<DOrderAmountEnter> {
  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final asset = wallet.assets[widget.assetId]!;
    final icon = wallet.assetImagesSmall[widget.assetId]!;
    final precision =
        (widget.isPriceField && asset.swapMarket) ? 2 : asset.precision;
    final showDollarConversion =
        widget.isPriceField && widget.assetId == wallet.liquidAssetId();
    final dollarConversion = showDollarConversion
        ? ref
            .read(requestOrderProvider)
            .dollarConversionFromString(widget.assetId, widget.controller.text)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00C5FF),
              ),
            ),
            if (showDollarConversion && dollarConversion!.isNotEmpty)
              Text(
                '≈ $dollarConversion',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF83B4D2),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              asset.ticker,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                textAlign: TextAlign.end,
                controller: widget.controller,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  // filled: true,
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: widget.hintText,
                  hintStyle: MaterialStateTextStyle.resolveWith((states) {
                    return TextStyle(
                        color: states.contains(MaterialState.focused) &&
                                !widget.readonly
                            ? Colors.transparent
                            : const Color(0x7FFFFFFF));
                  }),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  CommaTextInputFormatter(),
                  if (precision == 0) ...[
                    FilteringTextInputFormatter.deny(RegExp('[\\-|,\\ .]')),
                  ] else ...[
                    FilteringTextInputFormatter.deny(RegExp('[\\-|,\\ ]')),
                  ],
                  DecimalTextInputFormatter(decimalRange: precision),
                ],
                autofocus: widget.autofocus,
                onEditingComplete: widget.onEditingComplete,
                onChanged: (value) {
                  setState(() {});
                },
                focusNode: widget.focusNode,
                readOnly: widget.readonly,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _EnterAmountSeparator(),
      ],
    );
  }
}

class _EnterAmountSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0xFF5294B9),
    );
  }
}

class _BalanceLine extends ConsumerWidget {
  const _BalanceLine({
    required this.assetId,
    required this.onMaxPressed,
  });

  final String assetId;
  final VoidCallback? onMaxPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.read(walletProvider).assets[assetId]!;
    final account = getBalanceAccount(asset);
    final balance = ref.watch(balancesProvider).balances[account] ?? 0;
    final balanceStr =
        amountStrNamed(balance, asset.ticker, precision: asset.precision);
    final balanceHint =
        onMaxPressed != null ? 'Balance'.tr() : 'Buying power'.tr();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text('$balanceHint: $balanceStr',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF96C6E4),
              )),
        ),
        if (onMaxPressed != null)
          DHoverButton(
            builder: (context, states) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(
                    color: const Color(0xFF00C5FF),
                  ),
                  color: states.isFocused ? const Color(0xFF007CA1) : null,
                ),
                child: Text(
                  'Max'.tr().toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF00C5FF),
                    fontSize: 12,
                  ),
                ),
              );
            },
            onPressed: onMaxPressed,
          ),
      ],
    );
  }
}

class DEnterTrackingPrice extends StatelessWidget {
  const DEnterTrackingPrice({
    super.key,
    required this.trackingToggled,
    required this.trackingValue,
    required this.invertColors,
    required this.onTrackingChanged,
    required this.onTrackingToggle,
  });

  final bool trackingToggled;
  final double trackingValue;
  final bool invertColors;
  final ValueChanged<double> onTrackingChanged;
  final ValueChanged<bool>? onTrackingToggle;

  @override
  Widget build(BuildContext context) {
    const negativeColor = Color(0xFFFF7878);
    const positiveColor = Color(0xFF2CCCBF);
    const circleNegativeColor = Color(0xFF3E475F);
    const circlePositiveColor = Color(0xFF147385);

    const maxPercent = 1;
    const minPercent = -maxPercent;
    final startColor = invertColors ? positiveColor : negativeColor;
    final endColor = invertColors ? negativeColor : positiveColor;
    final circleStartColor =
        invertColors ? circlePositiveColor : circleNegativeColor;
    final circleEndColor =
        invertColors ? circleNegativeColor : circlePositiveColor;
    const percentTextStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
    const minPercentStr = '$minPercent%';
    const maxPercentStr = '+$maxPercent%';
    final valueStr = '${trackingValue > 0 ? '+' : ''}$trackingValue%';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xFF135579),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Track index price'.tr(),
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              FlutterSwitch(
                disabled: onTrackingToggle == null,
                value: trackingToggled,
                onToggle: (value) {
                  onTrackingToggle!(value);
                },
                width: 40,
                height: 22,
                toggleSize: 18,
                padding: 2,
                activeColor: const Color(0xFF00C5FF),
                inactiveColor: const Color(0xFF0B4160),
                toggleColor: Colors.white,
              ),
            ],
          ),
          if (trackingToggled)
            Column(
              children: [
                const SizedBox(height: 4),
                SizedBox(
                  height: 22,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: OrderTrackingSliderThumbShape(
                        minValue: minPercent.toDouble(),
                        maxValue: maxPercent.toDouble(),
                        negativeColor: startColor,
                        positiveColor: endColor,
                        circleNegativeColor: circleStartColor,
                        circlePositiveColor: circleEndColor,
                        customRadius: 10,
                        stokeRatio: 0.3,
                      ),
                      trackShape: OrderTrackingSliderTrackShape(
                        minValue: minPercent.toDouble(),
                        maxValue: maxPercent.toDouble(),
                        negativeColor: startColor,
                        positiveColor: endColor,
                        trackColor: const Color(0xFF1B8BC8),
                      ),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      min: minPercent.toDouble(),
                      max: maxPercent.toDouble(),
                      value: trackingValue,
                      onChanged: (value) {
                        onTrackingChanged(roundTrackerValue(value));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 8, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        minPercentStr,
                        style: percentTextStyle
                            .merge(TextStyle(color: startColor)),
                      ),
                      Text(
                        valueStr,
                        style: percentTextStyle,
                      ),
                      Text(
                        maxPercentStr,
                        style:
                            percentTextStyle.merge(TextStyle(color: endColor)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _OrdersPanel extends ConsumerWidget {
  const _OrdersPanel({
    required this.selectedAssetId,
    this.onChartsPressed,
  });

  final String selectedAssetId;
  final VoidCallback? onChartsPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final markets = ref.watch(marketsProvider);
    final orders = markets.marketOrders
        .where((e) => e.assetId == selectedAssetId && !e.private);
    final selectedAsset = wallet.assets[selectedAssetId]!;
    final pricedInLiquid = isPricedInLiquid(selectedAsset);
    final bids = orders.where((e) => e.sendBitcoins == pricedInLiquid).toList();
    final asks = orders.where((e) => e.sendBitcoins != pricedInLiquid).toList();
    const chartAvailable = true;

    bids.sort(compareRequestOrder(-1));
    asks.sort(compareRequestOrder(1));

    return SizedBox(
      width: 631,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Color(0xFF1C6086),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 56,
            child: Row(
              children: [
                Text(
                  'Order book'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                _IndexPrice(selectedAssetId: selectedAssetId),
                const Spacer(),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      if (chartAvailable)
                        _ChartButton(
                          onPressed: onChartsPressed,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          Row(children: const [
            _OrdersTitle(isLeft: true),
            SizedBox(width: 7),
            _OrdersTitle(isLeft: false),
          ]),
          const SizedBox(height: 7),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OrdersList(
                        orders: bids,
                        isBids: true,
                      ),
                      const SizedBox(width: 7),
                      _OrdersList(
                        orders: asks,
                        isBids: false,
                      ),
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.isBids,
  });

  final List<RequestOrder> orders;
  final bool isBids;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              isBids ? 'No active bids'.tr() : 'No active offers'.tr(),
              style: const TextStyle(
                color: Color(0xFF87C1E1),
              ),
            ),
          ),
        ),
      );
    }
    return Expanded(
      child: Column(
        children: orders.map((e) => _OrderItem(order: e)).toList(),
      ),
    );
  }
}

class _OrdersTitle extends StatelessWidget {
  const _OrdersTitle({
    required this.isLeft,
  });

  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      color: Color(0xFF00C5FF),
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isLeft ? 'Amount'.tr() : 'Offer'.tr(), style: titleStyle),
            Text(isLeft ? 'Bid'.tr() : 'Amount'.tr(), style: titleStyle),
          ],
        ),
      ),
    );
  }
}

class _OrderItem extends ConsumerWidget {
  const _OrderItem({
    required this.order,
  });

  final RequestOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.read(walletProvider).assets[order.assetId]!;
    final pricedInLiquid = isPricedInLiquid(asset);
    final isLeft = order.sendBitcoins == pricedInLiquid;
    final color = isLeft ? buyColor : sellColor;
    final amount = pricedInLiquid ? order.assetAmount : order.bitcoinAmount;
    final amountPrecision = pricedInLiquid ? asset.precision : 8;

    final list = [
      Text(
        amountStr(amount, precision: amountPrecision),
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      const Spacer(),
      if (order.own)
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      const SizedBox(width: 6),
      Text(
        priceStr(order.price, pricedInLiquid),
        style: TextStyle(
          fontSize: 13,
          color: color,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: DHoverButton(
        builder: (context, states) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: !states.isHovering
                  ? const Color(0xFF135579)
                  : (isLeft
                      ? const Color(0xFF176683)
                      : const Color(0xFF4C5D79)),
            ),
            child: Row(children: isLeft ? list : list.reversed.toList()),
          );
        },
        onPressed: () {
          if (order.own) {
            ref.read(walletProvider).setOrderRequestView(order);
          } else {
            ref.read(walletProvider).linkOrder(order.orderId);
          }
        },
      ),
    );
  }
}

class _IndexPrice extends ConsumerWidget {
  const _IndexPrice({
    required this.selectedAssetId,
  });

  final String selectedAssetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final asset = wallet.assets[selectedAssetId]!;
    final pricedInLiquid = isPricedInLiquid(asset);
    final indexPrice =
        ref.watch(marketsProvider).getIndexPriceForAsset(selectedAssetId);
    final lastPrice =
        ref.watch(marketsProvider).getLastPriceForAsset(selectedAssetId);
    final indexPriceStr = priceStr(indexPrice, pricedInLiquid);
    final lastPriceStr = priceStr(lastPrice, pricedInLiquid);
    final icon = wallet.assetImagesVerySmall[selectedAssetId]!;

    return Visibility(
      visible: indexPrice != 0 || lastPrice != 0,
      child: Row(
        children: [
          Container(
            width: 1,
            color: const Color(0xFF28749E),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(
                color: const Color(0xFF1C6086),
              ),
            ),
            child: Row(
              children: [
                Text(
                  indexPrice != 0 ? 'Index price:'.tr() : 'Last price:'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF3983AD),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  indexPrice != 0 ? indexPriceStr : lastPriceStr,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 5),
                icon,
                const SizedBox(width: 3),
                Text(
                  asset.ticker,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            color: const Color(0xFF28749E),
          ),
        ],
      ),
    );
  }
}

class _ChartButton extends StatelessWidget {
  const _ChartButton({
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: const Color(0xFF00C5FF),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/chart.svg',
                width: 14,
                height: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Chart'.tr(),
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
      onPressed: onPressed,
    );
  }
}

class _OrdersRow extends StatelessWidget {
  const _OrdersRow({
    required this.list,
  });

  final List<Widget> list;

  @override
  Widget build(BuildContext context) {
    const flexes = [153, 210, 210, 210, 97, 143, 107, 184];
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(
          flex: flexes[index],
          child: list[index],
        ),
      ),
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF87C1E1),
        fontSize: 12,
      ),
    );
  }
}

class _WorkingOrderAmount extends StatelessWidget {
  const _WorkingOrderAmount({
    required this.text,
    required this.assetId,
    required this.wallet,
  });

  final String text;
  final String assetId;
  final WalletChangeNotifier wallet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        wallet.assetImagesVerySmall[assetId]!,
        const SizedBox(width: 4),
        Text(text),
        // Text('$text ${asset.ticker}'),
      ],
    );
  }
}

class _WorkingOrder extends ConsumerWidget {
  const _WorkingOrder({
    required this.order,
    required this.wallet,
  });

  final RequestOrder order;
  final WalletChangeNotifier wallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSell =
        order.sendBitcoins == (order.marketType == MarketType.stablecoin);
    final dirStr = isSell ? 'Sell'.tr() : 'Buy'.tr();
    final dirColor = isSell ? sellColor : buyColor;
    final priceType = order.indexPrice == 0 ? 'Limit'.tr() : 'Tracking'.tr();
    final orderType = order.private ? 'Private'.tr() : 'Public'.tr();
    final asset = wallet.assets[order.assetId]!;
    final priceInLiquid = isPricedInLiquid(asset);
    final assetAmountStr =
        amountStr(order.assetAmount, precision: asset.precision);
    final bitcoinAmountStr = amountStr(order.bitcoinAmount);

    return _OrdersRow(
      list: [
        Text(productName(asset)),
        _WorkingOrderAmount(
          assetId: priceInLiquid ? order.assetId : wallet.liquidAssetId(),
          text: priceInLiquid ? assetAmountStr : bitcoinAmountStr,
          wallet: wallet,
        ),
        _WorkingOrderAmount(
          assetId: priceInLiquid ? wallet.liquidAssetId() : order.assetId,
          text: priceStr(order.price, priceInLiquid),
          wallet: wallet,
        ),
        _WorkingOrderAmount(
          assetId: !priceInLiquid ? order.assetId : wallet.liquidAssetId(),
          text: !priceInLiquid ? assetAmountStr : bitcoinAmountStr,
          wallet: wallet,
        ),
        Text(
          dirStr,
          style: TextStyle(
            color: dirColor,
          ),
        ),
        Text(priceType),
        Text(orderType),
        Row(
          children: [
            SvgPicture.asset('assets/clock.svg'),
            const SizedBox(width: 6),
            Consumer(builder: (context, ref, _) {
              ref.watch(timerProvider);
              return Text(order.getExpireDuration().toStringCustomShort());
            }),
            const Spacer(),
            if (order.private)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _WorkingOrderButton(
                  icon: 'assets/copy3.svg',
                  onPressed: () {
                    final shareUrl = ref
                        .read(requestOrderProvider)
                        .getAddressToShareById(order.orderId);
                    copyToClipboard(context, shareUrl);
                  },
                ),
              ),
            const SizedBox(width: 4),
            _WorkingOrderButton(
              icon: 'assets/edit2.svg',
              onPressed: () {
                ref.read(walletProvider).setOrderRequestView(order);
              },
            ),
            const SizedBox(width: 4),
            _WorkingOrderButton(
              icon: 'assets/delete2.svg',
              onPressed: () async {
                wallet.cancelOrder(order.orderId);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkingOrderButton extends StatelessWidget {
  const _WorkingOrderButton({
    required this.icon,
    required this.onPressed,
  });

  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: SvgPicture.asset(
            icon,
            color: states.isHovering ? Colors.white : null,
          ),
        );
      },
      onPressed: onPressed,
    );
  }
}

class _WorkingOrders extends ConsumerStatefulWidget {
  const _WorkingOrders({
    required this.onAssetSelected,
  });

  final ValueChanged<String> onAssetSelected;

  @override
  ConsumerState<_WorkingOrders> createState() => _WorkingOrdersState();
}

class _WorkingOrdersState extends ConsumerState<_WorkingOrders> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final orders = ref.watch(marketsProvider).getOwnOrders();
    // final visibleCount = min(orders.length, 3);
    const visibleCount = 3;
    const horizontalPadding = 26.0;
    const separatorPadding = 16.0;
    final isConnected = wallet.serverConnection.value;

    if (visibleCount == 0) {
      return Container();
    }

    return Container(
      decoration: const BoxDecoration(
          color: Color(0xFF1C6086),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Working orders'.tr(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12,
            ),
            child: _OrdersRow(list: [
              _OrdersHeader(text: 'Trading pair'.tr()),
              _OrdersHeader(text: 'Amount'.tr()),
              _OrdersHeader(text: 'Price'.tr()),
              _OrdersHeader(text: 'Total'.tr()),
              _OrdersHeader(text: 'Side'.tr()),
              _OrdersHeader(text: 'Limit/Tracking'.tr()),
              _OrdersHeader(text: 'Order type'.tr()),
              _OrdersHeader(text: 'TTL'.tr()),
            ]),
          ),
          SizedBox(
            height: 44.0 * visibleCount,
            child: orders.isEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: separatorPadding),
                        child: Container(
                          height: 1,
                          color: const Color(0xFF2B6F95),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isConnected
                            ? 'No working orders'.tr()
                            : 'Connecting ...'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF87C1E1),
                        ),
                      ),
                    ],
                  )
                : Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        final order = orders[index];

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: separatorPadding),
                              child: Container(
                                height: 1,
                                color: const Color(0xFF2B6F95),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: separatorPadding,
                              ),
                              child: DHoverButton(
                                builder: (context, states) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal:
                                          horizontalPadding - separatorPadding,
                                    ),
                                    color: states.isHovering
                                        ? const Color(0xFF22668C)
                                        : null,
                                    child: _WorkingOrder(
                                        order: order, wallet: wallet),
                                  );
                                },
                                onPressed: () {
                                  widget.onAssetSelected(order.assetId);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: orders.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
