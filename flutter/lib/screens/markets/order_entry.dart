import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/order_price_field.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';

class OrderEntry extends ConsumerStatefulWidget {
  const OrderEntry({super.key});

  @override
  OrderEntryState createState() => OrderEntryState();
}

class OrderEntryState extends ConsumerState<OrderEntry> {
  final TextEditingController deliverController = TextEditingController();
  final TextEditingController receiveController = TextEditingController();
  final TextEditingController priceAmountController = TextEditingController();
  late FocusNode deliverFocusNode;
  late FocusNode receiveFocusNode;
  late FocusNode priceFocusNode;
  bool isValid = false;
  bool showInsufficientFunds = false;
  bool isContinued = false;
  String receiveConversion = '';
  String priceConversion = '';
  bool trackingSelected = false;
  double sliderValue = 0;
  String trackingPrice = '';
  bool displaySlider = false;
  bool inversePrice = false;

  BuildContext? currentContext;

  @override
  void initState() {
    super.initState();

    currentContext = ref.read(walletProvider).navigatorKey.currentContext;

    deliverController.addListener(() {
      final requestOrder = ref.read(requestOrderProvider);
      // Check isSellOrder to prevent cascading notifications after price edit
      if (requestOrder.isSellOrder()) {
        receiveController.text = requestOrder.calculateReceiveAmount(
            deliverController.text, priceAmountController.text);
        validate();
      }
    });

    receiveController.addListener(() {
      final requestOrder = ref.read(requestOrderProvider);
      // Check isSellOrder to prevent cascading notifications after price edit
      if (!requestOrder.isSellOrder()) {
        deliverController.text = requestOrder.calculateDeliverAmount(
            receiveController.text, priceAmountController.text);
        validate();
      }
    });

    priceAmountController.addListener(() {
      final requestOrder = ref.read(requestOrderProvider);
      if (requestOrder.isSellOrder()) {
        receiveController.text = requestOrder.calculateReceiveAmount(
            deliverController.text, priceAmountController.text);
      } else {
        deliverController.text = requestOrder.calculateDeliverAmount(
            receiveController.text, priceAmountController.text);
      }
      validate();
    });

    deliverFocusNode = FocusNode();
    priceFocusNode = FocusNode();
    receiveFocusNode = FocusNode();

    inversePrice = !ref.read(requestOrderProvider).isDeliverLiquid();

    ref.read(marketsProvider).subscribeIndexPrice(
        ref.read(requestOrderProvider).tokenAccountAsset().asset);

    displaySlider = isTracking();

    focusEnterAmount();
  }

  bool isTracking() {
    final requestOrderIndexPrice = ref.read(requestOrderIndexPriceProvider);
    final isToken = ref.read(requestOrderProvider).isDeliverToken();
    return trackingSelected && !isToken && requestOrderIndexPrice.isNotEmpty;
  }

  @override
  void dispose() {
    deliverController.dispose();
    receiveController.dispose();
    priceAmountController.dispose();
    deliverFocusNode.dispose();
    receiveFocusNode.dispose();
    priceFocusNode.dispose();
    super.dispose();
  }

  void focusEnterAmount() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(requestOrderProvider).isSellOrder()) {
        FocusScope.of(context).requestFocus(deliverFocusNode);
        setControllerValue(deliverController, '');
      } else {
        FocusScope.of(context).requestFocus(receiveFocusNode);
        setControllerValue(receiveController, '');
      }
    });
  }

  void clearData() {
    deliverController.clear();
    priceAmountController.clear();
    receiveController.clear();
    validate();
  }

  void validate() {
    updateDollarConversion();

    final precision =
        ref.read(requestOrderProvider).deliverAsset()?.precision ?? 0;
    final deliverAmount = ref
        .read(walletProvider)
        .parseAssetAmount(deliverController.text, precision: precision);
    if (deliverAmount == null) {
      setState(() {
        showInsufficientFunds = false;
        isValid = false;
      });
      return;
    }

    final balance = ref
        .read(balancesProvider)
        .balances[ref.read(requestOrderProvider).deliverAssetId];
    if (balance == null) {
      setState(() {
        isValid = false;
      });
      return;
    }

    if (deliverAmount > balance) {
      setState(() {
        showInsufficientFunds = true;
        isValid = false;
      });
      return;
    } else {
      setState(() {
        showInsufficientFunds = false;
      });
    }

    if (ref
        .read(requestOrderProvider)
        .calculateReceiveAmount(
            deliverController.text, priceAmountController.text)
        .isNotEmpty) {
      setState(() {
        isValid = true;
      });
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  void updateDollarConversion() {
    final priceAssetId = ref.read(requestOrderProvider).priceAsset?.assetId;
    setState(() {
      if (priceAssetId == ref.read(tetherAssetIdProvider)) {
        priceConversion = '';
      } else {
        priceConversion = ref
            .read(requestOrderProvider)
            .dollarConversionFromString(
                priceAssetId, priceAmountController.text);
      }
    });

    final receiveAssetId = ref.read(requestOrderProvider).receiveAssetId;

    setState(() {
      if (receiveAssetId.asset == ref.read(tetherAssetIdProvider)) {
        receiveConversion = '';
      } else {
        receiveConversion = ref
            .read(requestOrderProvider)
            .dollarConversionFromString(
                receiveAssetId.asset, receiveController.text);
      }
    });
  }

  void onContinue() {
    // hide keyboard
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');

    final requestOrder = ref.read(requestOrderProvider);

    final isSendBitcoin = requestOrder.isDeliverLiquid();
    final isAmp = requestOrder.deliverAssetId.account == AccountType.amp ||
        requestOrder.receiveAssetId.account == AccountType.amp;
    final isAssetAmount = !isSendBitcoin || isAmp;
    final isSellOrder = requestOrder.isSellOrder();

    var amount = isSellOrder
        ? -(double.tryParse(deliverController.text) ?? 0)
        : (double.tryParse(receiveController.text) ?? 0);

    final priceAmount = double.tryParse(priceAmountController.text) ?? 0;
    var price = priceAmount;

    var trackingPercent = .0;
    if (isTracking()) {
      final requestOrderIndexPrice =
          double.tryParse(ref.read(requestOrderIndexPriceProvider)) ?? 0;
      trackingPercent = 1 + (sliderValue / 100);
      price = requestOrderIndexPrice;
    }

    final accountAsset = ref.read(requestOrderProvider).tokenAccountAsset();
    final assetId = accountAsset.asset;

    ref.read(walletProvider).submitOrder(
          assetId,
          amount,
          price,
          isAssetAmount: isAssetAmount,
          indexPrice: isTracking() ? trackingPercent : null,
          account: accountAsset.account,
        );

    setState(() {
      isValid = false;
      isContinued = true;
    });
  }

  void onToggleTracking(bool value) {
    setState(() {
      trackingSelected = value;
      priceAmountController.text = '';
      sliderValue = 0;
      trackingPrice = '';
      displaySlider = isTracking();
    });
    if (value) {
      calculateTrackingPrice();
    }
  }

  void calculateTrackingPrice() {
    final ticker = ref.read(requestOrderProvider).priceAsset?.ticker ?? '';

    final trackingAsset = ref.read(requestOrderProvider).priceAsset;
    final trackingPriceFixed = ref
        .read(indexPriceForAssetProvider(trackingAsset?.assetId))
        .calculateTrackingPrice(sliderValue);

    setState(() {
      if ((double.tryParse(trackingPriceFixed) ?? 0) != 0) {
        priceAmountController.text = trackingPriceFixed;
      } else {
        priceAmountController.text = '';
      }
      trackingPrice =
          '${replaceCharacterOnPosition(input: trackingPriceFixed)} $ticker';
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestOrderIndexPrice = ref.watch(requestOrderIndexPriceProvider);
    final requestOrder = ref.watch(requestOrderProvider);
    final marketTyple = requestOrder.marketType();
    final isStablecoin = marketTyple == MarketType.stablecoin;
    final isToken = marketTyple == MarketType.token;
    final deliverLiquid = requestOrder.isDeliverLiquid();

    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Order entry'.tr(),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();

          ref.read(marketsProvider).unsubscribeIndexPrice();
          ref.read(walletProvider).goBack();
        },
        backgroundColor: const Color(0xFF064363),
      ),
      backgroundColor: const Color(0xFF064363),
      sideSwapBackground: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          final currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: displaySlider
                                  ? 215
                                  : (isStablecoin ? 200 : 180)),
                          child: Container(
                            color: SideSwapColors.chathamsBlue,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: displaySlider
                                  ? 115
                                  : (isStablecoin ? 115 : 95),
                              left: 16,
                              right: 16),
                          child: Builder(
                            builder: (context) {
                              final asset =
                                  ref.watch(requestOrderProvider).priceAsset;
                              final productAssetId = ref
                                  .watch(requestOrderProvider)
                                  .tokenAccountAsset()
                                  .asset;
                              final productAsset = ref.watch(assetsStateProvider
                                  .select((value) => value[productAssetId]));
                              final icon = ref
                                  .watch(assetImageProvider)
                                  .getSmallImage(asset?.assetId);

                              displaySlider = isTracking();

                              return OrderPriceField(
                                focusNode: priceFocusNode,
                                asset: asset,
                                productAsset: productAsset,
                                icon: icon,
                                controller: priceAmountController,
                                dollarConversion: priceConversion,
                                tracking: isTracking(),
                                trackingPrice: trackingPrice,
                                displaySlider: displaySlider,
                                onToggleTracking:
                                    isToken || requestOrderIndexPrice.isEmpty
                                        ? null
                                        : onToggleTracking,
                                onEditingComplete: () {
                                  validate();
                                  SystemChannels.textInput
                                      .invokeMethod<void>('TextInput.hide');
                                },
                                sliderValue: sliderValue,
                                onSliderChanged: (value) {
                                  setState(() {
                                    sliderValue = value;
                                  });

                                  calculateTrackingPrice();
                                },
                                invertColors: inversePrice,
                              );
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 16, right: 16),
                              child: Builder(
                                builder: (context) {
                                  final deliverAssetId =
                                      requestOrder.deliverAssetId;
                                  final deliverAssets =
                                      requestOrder.deliverAssets();
                                  final disabledAssets =
                                      requestOrder.disabledAssets();
                                  final balance = requestOrder.deliverBalance();
                                  final precision =
                                      requestOrder.deliverAsset()?.precision ??
                                          0;
                                  final hint = DecimalCutterTextInputFormatter(
                                    decimalRange: precision,
                                  )
                                      .formatEditUpdate(
                                          const TextEditingValue(
                                              text: '0.00000000'),
                                          const TextEditingValue(
                                              text: '0.00000000'))
                                      .text;
                                  final readOnly = !requestOrder.isSellOrder();
                                  return SwapSideAmount(
                                    text: 'Deliver'.tr(),
                                    focusNode: deliverFocusNode,
                                    controller: deliverController,
                                    dropdownValue: deliverAssetId,
                                    availableAssets: deliverAssets,
                                    disabledAssets: disabledAssets,
                                    balance: balance,
                                    isMaxVisible: !readOnly,
                                    hintText: hint,
                                    showHintText: true,
                                    readOnly: readOnly,
                                    swapType: SwapType.atomic,
                                    showInsufficientFunds:
                                        showInsufficientFunds,
                                    showAccountsInPopup: true,
                                    onDropdownChanged: (value) {
                                      final deliverAsset = ref
                                          .read(requestOrderProvider)
                                          .deliverAssetId;
                                      if (deliverAsset == value) {
                                        return;
                                      }

                                      ref
                                          .read(requestOrderProvider)
                                          .deliverAssetId = value;
                                      clearData();
                                      setState(() {
                                        inversePrice = !ref
                                            .read(requestOrderProvider)
                                            .isDeliverLiquid();
                                      });
                                      focusEnterAmount();
                                    },
                                    onMaxPressed: () {
                                      setControllerValue(
                                          deliverController, balance);
                                      validate();
                                    },
                                    onEditingCompleted: () {
                                      if (displaySlider) {
                                        validate();
                                      }
                                      if (displaySlider) {
                                        FocusScope.of(context).unfocus();
                                      } else {
                                        FocusScope.of(context)
                                            .requestFocus(priceFocusNode);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: displaySlider
                                      ? 190
                                      : (isStablecoin
                                          ? 160
                                          : (deliverLiquid ? 150 : 140)),
                                  left: 16,
                                  right: 16),
                              child: Builder(
                                builder: (context) {
                                  final requests =
                                      ref.watch(requestOrderProvider);
                                  final receiveAsset = requests.receiveAssetId;
                                  final receiveAssets =
                                      requests.receiveAssets();
                                  final balance = requests.receiveBalance();
                                  final precision = ref
                                          .read(requestOrderProvider)
                                          .receiveAsset()
                                          ?.precision ??
                                      0;
                                  final hint = DecimalCutterTextInputFormatter(
                                    decimalRange: precision,
                                  )
                                      .formatEditUpdate(
                                          const TextEditingValue(
                                              text: '0.00000000'),
                                          const TextEditingValue(
                                              text: '0.00000000'))
                                      .text;
                                  return SwapSideAmount(
                                    text: 'Receive'.tr(),
                                    focusNode: receiveFocusNode,
                                    controller: receiveController,
                                    dropdownValue: receiveAsset,
                                    availableAssets: receiveAssets,
                                    swapType: SwapType.atomic,
                                    balance: balance,
                                    hintText: hint,
                                    showHintText: true,
                                    readOnly: requests.isSellOrder(),
                                    dropdownReadOnly: receiveAssets.length == 1,
                                    dollarConversion: receiveConversion,
                                    showAccountsInPopup: true,
                                    onDropdownChanged: (value) {
                                      final receiveAsset = ref
                                          .read(requestOrderProvider)
                                          .receiveAssetId;
                                      if (receiveAsset == value) {
                                        return;
                                      }
                                      ref
                                          .read(requestOrderProvider)
                                          .receiveAssetId = value;
                                      clearData();
                                      focusEnterAmount();
                                    },
                                    onEditingCompleted: () {
                                      if (displaySlider) {
                                        validate();
                                      }
                                      if (displaySlider) {
                                        FocusScope.of(context).unfocus();
                                      } else {
                                        FocusScope.of(context)
                                            .requestFocus(priceFocusNode);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 29, bottom: 24, left: 16, right: 16),
                              child: CustomBigButton(
                                width: double.maxFinite,
                                height: 54,
                                backgroundColor: SideSwapColors.brightTurquoise,
                                enabled: isValid,
                                onPressed: isValid ? onContinue : null,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      'CONTINUE'.tr(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (isContinued) ...[
                                      const Padding(
                                        padding: EdgeInsets.only(left: 124),
                                        child: SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: SpinKitCircle(
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
