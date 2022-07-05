import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
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
  bool trackingSelected = true;
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
        validate(ref);
      }
    });

    receiveController.addListener(() {
      final requestOrder = ref.read(requestOrderProvider);
      // Check isSellOrder to prevent cascading notifications after price edit
      if (!requestOrder.isSellOrder()) {
        deliverController.text = requestOrder.calculateDeliverAmount(
            receiveController.text, priceAmountController.text);
        validate(ref);
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
      validate(ref);
    });

    deliverFocusNode = FocusNode();
    priceFocusNode = FocusNode();
    receiveFocusNode = FocusNode();

    inversePrice = !ref.read(requestOrderProvider).isDeliverLiquid();

    ref.read(marketsProvider).subscribeIndexPrice(
        ref.read(requestOrderProvider).tokenAccountAsset().asset);

    final indexPrice = ref.read(requestOrderProvider).indexPrice;
    final isToken = ref.read(requestOrderProvider).isDeliverToken();

    displaySlider = isTracking(ref);
    if (!isTracking(ref) && (!isToken && indexPrice.isNotEmpty)) {
      displaySlider = true;
    }

    focusEnterAmount(ref, context);
  }

  bool isTracking(WidgetRef ref) {
    final requests = ref.read(requestOrderProvider);
    final indexPrice = requests.indexPrice;
    final isToken = ref.read(requestOrderProvider).isDeliverToken();
    return trackingSelected && !isToken && indexPrice.isNotEmpty;
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

  void focusEnterAmount(WidgetRef ref, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(requestOrderProvider).isSellOrder()) {
        FocusScope.of(context).requestFocus(deliverFocusNode);
        setValue(deliverController, '');
      } else {
        FocusScope.of(context).requestFocus(receiveFocusNode);
        setValue(receiveController, '');
      }
    });
  }

  void clearData(WidgetRef ref) {
    deliverController.clear();
    priceAmountController.clear();
    receiveController.clear();
    validate(ref);
  }

  void validate(WidgetRef ref) {
    updateDollarConversion(ref);

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

  void updateDollarConversion(WidgetRef ref) {
    final priceAssetId = ref.read(requestOrderProvider).priceAsset.assetId;
    setState(() {
      if (priceAssetId == ref.read(walletProvider).tetherAssetId()) {
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
      if (receiveAssetId.asset == ref.read(walletProvider).tetherAssetId()) {
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
    if (isTracking(ref)) {
      final indexPrice =
          double.tryParse(ref.read(requestOrderProvider).indexPrice) ?? 0;
      trackingPercent = 1 + (sliderValue / 100);
      price = indexPrice;
    }

    final accountAsset = ref.read(requestOrderProvider).tokenAccountAsset();
    final assetId = accountAsset.asset;

    ref.read(walletProvider).submitOrder(
          assetId,
          amount,
          price,
          isAssetAmount: isAssetAmount,
          indexPrice: isTracking(ref) ? trackingPercent : null,
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

      if (!isTracking(ref)) {
        priceAmountController.text = '';
      } else {
        sliderValue = 0;
      }
    });

    calculateTrackingPrice(ref);
  }

  void calculateTrackingPrice(WidgetRef ref) {
    final ticker = ref.read(requestOrderProvider).priceAsset.ticker;

    final trackingPriceFixed = ref.read(marketsProvider).calculateTrackingPrice(
        sliderValue, ref.read(requestOrderProvider).priceAsset.assetId);

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
    final isToken = ref.read(requestOrderProvider).isDeliverToken();
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
                              top: displaySlider ? 255.h : 228.h),
                          child: Container(
                            color: const Color(0xFF135579),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 147.h, left: 16.w, right: 16.w),
                          child: Consumer(
                            builder: (context, ref, child) {
                              final asset =
                                  ref.watch(requestOrderProvider).priceAsset;
                              final icon = ref
                                  .watch(requestOrderProvider)
                                  .priceAssetIcon();
                              final indexPrice =
                                  ref.watch(requestOrderProvider).indexPrice;

                              displaySlider = isTracking(ref);
                              if (!isTracking(ref) &&
                                  (!isToken && indexPrice.isNotEmpty)) {
                                displaySlider = true;
                              }

                              return OrderPriceField(
                                focusNode: priceFocusNode,
                                asset: asset,
                                icon: icon,
                                controller: priceAmountController,
                                dollarConversion: priceConversion,
                                tracking: isTracking(ref),
                                trackingPrice: trackingPrice,
                                displaySlider: displaySlider,
                                onToggleTracking: isToken || indexPrice.isEmpty
                                    ? null
                                    : onToggleTracking,
                                onEditingComplete: () {
                                  validate(ref);
                                  SystemChannels.textInput
                                      .invokeMethod<void>('TextInput.hide');
                                },
                                sliderValue: sliderValue,
                                onSliderChanged: (value) {
                                  setState(() {
                                    sliderValue = value;
                                  });

                                  calculateTrackingPrice(ref);
                                },
                                invertColors: inversePrice,
                              );
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 12.h, left: 16.w, right: 16.w),
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final requests =
                                      ref.watch(requestOrderProvider);
                                  final deliverAssetId =
                                      requests.deliverAssetId;
                                  final deliverAssets =
                                      requests.deliverAssets();
                                  final disabledAssets =
                                      requests.disabledAssets();
                                  final balance = requests.deliverBalance();
                                  final precision =
                                      requests.deliverAsset()?.precision ?? 0;
                                  final hint = DecimalCutterTextInputFormatter(
                                    decimalRange: precision,
                                  )
                                      .formatEditUpdate(
                                          const TextEditingValue(
                                              text: '0.00000000'),
                                          const TextEditingValue(
                                              text: '0.00000000'))
                                      .text;
                                  final readOnly = !requests.isSellOrder();
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
                                      clearData(ref);
                                      setState(() {
                                        inversePrice = !ref
                                            .read(requestOrderProvider)
                                            .isDeliverLiquid();
                                      });
                                      focusEnterAmount(ref, context);
                                    },
                                    onMaxPressed: () {
                                      var amount = balance;
                                      final newValue =
                                          replaceCharacterOnPosition(
                                        input: amount,
                                      );

                                      deliverController.text = newValue;

                                      deliverController.value =
                                          TextEditingValue(
                                        text: newValue,
                                        selection: TextSelection.collapsed(
                                            offset: newValue.length),
                                      );

                                      validate(ref);
                                    },
                                    onEditingCompleted: () {
                                      if (displaySlider) {
                                        validate(ref);
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
                                  top: displaySlider ? 252.h : 193.h,
                                  left: 16.w,
                                  right: 16.w),
                              child: Consumer(
                                builder: (context, ref, child) {
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
                                      clearData(ref);
                                      focusEnterAmount(ref, context);
                                    },
                                    onEditingCompleted: () {
                                      if (displaySlider) {
                                        validate(ref);
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
                              padding: EdgeInsets.only(
                                  top: 29.h,
                                  bottom: 24.h,
                                  left: 16.w,
                                  right: 16.w),
                              child: CustomBigButton(
                                width: double.maxFinite,
                                height: 54.h,
                                backgroundColor: const Color(0xFF00C5FF),
                                enabled: isValid,
                                onPressed: isValid ? onContinue : null,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      'CONTINUE'.tr(),
                                      style: GoogleFonts.roboto(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (isContinued) ...[
                                      Padding(
                                        padding: EdgeInsets.only(left: 124.w),
                                        child: SizedBox(
                                          width: 32.w,
                                          height: 32.w,
                                          child: SpinKitCircle(
                                            color: Colors.white,
                                            size: 32.w,
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
