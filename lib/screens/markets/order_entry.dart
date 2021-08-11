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
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/markets_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/order_price_field.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';

class OrderEntry extends StatefulWidget {
  const OrderEntry({Key? key}) : super(key: key);

  @override
  _OrderEntryState createState() => _OrderEntryState();
}

class _OrderEntryState extends State<OrderEntry> {
  final TextEditingController deliverController = TextEditingController();
  final TextEditingController receiveController = TextEditingController();
  final TextEditingController priceAmountController = TextEditingController();
  late FocusNode deliverFocusNode;
  late FocusNode priceFocusNode;
  bool isValid = false;
  bool showInsufficientFunds = false;
  bool isContinued = false;
  String receiveConversion = '';
  String priceConversion = '';
  bool tracking = false;
  double sliderValue = 0;
  String trackingPrice = '';
  bool displaySlider = false;
  bool inversePrice = false;

  BuildContext? currentContext;

  @override
  void initState() {
    super.initState();

    currentContext = context.read(walletProvider).navigatorKey.currentContext;

    deliverController.addListener(() {
      receiveController.text = context
          .read(requestOrderProvider)
          .calculateReceiveAmount(
              deliverController.text, priceAmountController.text);
      validate();
    });

    priceAmountController.addListener(() {
      receiveController.text = context
          .read(requestOrderProvider)
          .calculateReceiveAmount(
              deliverController.text, priceAmountController.text);
      validate();
    });

    deliverFocusNode = FocusNode();
    priceFocusNode = FocusNode();

    inversePrice = !context.read(requestOrderProvider).isDeliverLiquid();

    context.read(marketsProvider).subscribeIndexPrice(
        assetId: context.read(requestOrderProvider).priceAsset.assetId);

    final indexPrice = context.read(requestOrderProvider).indexPrice;
    final isToken = context.read(requestOrderProvider).isDeliverToken();

    if (isToken || indexPrice.isEmpty) {
      tracking = false;
    }

    displaySlider = tracking;
    if (!tracking && (!isToken && indexPrice.isNotEmpty)) {
      displaySlider = true;
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild(context));
  }

  @override
  void dispose() {
    if (currentContext != null) {
      currentContext!.read(marketsProvider).unsubscribeIndexPrice();
    }

    deliverController.dispose();
    receiveController.dispose();
    priceAmountController.dispose();
    deliverFocusNode.dispose();
    priceFocusNode.dispose();
    super.dispose();
  }

  void afterBuild(BuildContext context) {
    FocusScope.of(context).requestFocus(deliverFocusNode);
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
        context.read(requestOrderProvider).deliverAsset()?.precision ?? 0;
    final deliverAmount = context
        .read(walletProvider)
        .parseAssetAmount(deliverController.text, precision: precision);
    if (deliverAmount == null) {
      setState(() {
        showInsufficientFunds = false;
        isValid = false;
      });
      return;
    }

    final balance = context
        .read(balancesProvider)
        .balances[context.read(requestOrderProvider).deliverAssetId];
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

    if (context
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
    final priceAssetId = context.read(requestOrderProvider).priceAsset.assetId;
    setState(() {
      if (priceAssetId == context.read(walletProvider).tetherAssetId()) {
        priceConversion = '';
      } else {
        priceConversion = context
            .read(requestOrderProvider)
            .dollarConversionFromString(
                priceAssetId, priceAmountController.text);
      }
    });

    final receiveAssetId = context.read(requestOrderProvider).receiveAssetId;

    setState(() {
      if (receiveAssetId == context.read(walletProvider).tetherAssetId()) {
        receiveConversion = '';
      } else {
        receiveConversion = context
            .read(requestOrderProvider)
            .dollarConversionFromString(receiveAssetId, receiveController.text);
      }
    });
  }

  void onContinue() {
    // hide keyboard
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');

    final isLiquid = context.read(requestOrderProvider).isDeliverLiquid();
    final isToken = context.read(requestOrderProvider).isDeliverToken();
    final isAssetAmount = isToken || !isLiquid;

    var amountStr = deliverController.text;
    var amount = double.tryParse(amountStr) ?? 0;

    final priceAmount = double.tryParse(priceAmountController.text) ?? 0;
    var price = priceAmount;

    var trackingPercent = .0;
    if (tracking) {
      final indexPrice =
          double.tryParse(context.read(requestOrderProvider).indexPrice) ?? 0;
      trackingPercent = 1 + (sliderValue / 100);
      price = indexPrice;
    }

    if (isLiquid) {
      // selling bitcoin
      amount = amount * -1;
    }

    if (isToken) {
      if (price != 0) {
        price = 1 / priceAmount;
      }
    }

    if (isAssetAmount) {
      amount = amount * -1;
    }

    context.read(walletProvider).submitOrder(
          context.read(requestOrderProvider).tokenAssetId(),
          amount,
          price,
          isAssetAmount: isAssetAmount,
          indexPrice: tracking ? trackingPercent : null,
        );

    setState(() {
      isValid = false;
      isContinued = true;
    });
  }

  void onToggleTracking(bool value) {
    setState(() {
      tracking = value;

      if (!tracking) {
        priceAmountController.text = '';
      } else {
        sliderValue = 0;
      }
    });

    calculateTrackingPrice();
  }

  void calculateTrackingPrice() {
    final ticker = context.read(requestOrderProvider).priceAsset.ticker;

    final trackingPriceFixed = context
        .read(marketsProvider)
        .calculateTrackingPrice(inversePrice ? -sliderValue : sliderValue,
            context.read(requestOrderProvider).priceAsset.assetId);

    setState(() {
      priceAmountController.text = trackingPriceFixed;
      trackingPrice =
          '${replaceCharacterOnPosition(input: trackingPriceFixed)} $ticker';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isToken = context.read(requestOrderProvider).isDeliverToken();
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Order entry'.tr(),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();

          context.read(walletProvider).goBack();
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
                            builder: (context, watch, child) {
                              final asset =
                                  watch(requestOrderProvider).priceAsset;
                              final icon =
                                  watch(requestOrderProvider).priceAssetIcon();
                              final indexPrice =
                                  watch(requestOrderProvider).indexPrice;

                              if (isToken || indexPrice.isEmpty) {
                                tracking = false;
                              }

                              displaySlider = tracking;
                              if (!tracking &&
                                  (!isToken && indexPrice.isNotEmpty)) {
                                displaySlider = true;
                              }

                              return OrderPriceField(
                                focusNode: priceFocusNode,
                                description: 'Price'.tr(),
                                asset: asset,
                                icon: icon,
                                controller: priceAmountController,
                                dollarConversion: priceConversion,
                                tracking: tracking,
                                trackingPrice: trackingPrice,
                                displaySlider: displaySlider,
                                onToggleTracking: isToken || indexPrice.isEmpty
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
                                builder: (context, watch, child) {
                                  final deliverAssetId =
                                      watch(requestOrderProvider)
                                          .deliverAssetId;
                                  final deliverAssets =
                                      watch(requestOrderProvider)
                                          .deliverAssets();
                                  final balance = watch(requestOrderProvider)
                                      .deliverBalance();
                                  final precision = context
                                          .read(requestOrderProvider)
                                          .deliverAsset()
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
                                    text: 'Deliver'.tr(),
                                    focusNode: deliverFocusNode,
                                    controller: deliverController,
                                    dropdownValue: deliverAssetId,
                                    availableAssets: deliverAssets,
                                    balance: balance,
                                    isMaxVisible: true,
                                    hintText: hint,
                                    showHintText: true,
                                    swapType: SwapType.atomic,
                                    showInsufficientFunds:
                                        showInsufficientFunds,
                                    onDropdownChanged: (value) {
                                      final deliverAsset = context
                                          .read(requestOrderProvider)
                                          .deliverAssetId;
                                      if (deliverAsset == value) {
                                        return;
                                      }

                                      context
                                          .read(requestOrderProvider)
                                          .deliverAssetId = value;
                                      clearData();
                                      setState(() {
                                        inversePrice = !context
                                            .read(requestOrderProvider)
                                            .isDeliverLiquid();
                                      });
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
                                  top: displaySlider ? 252.h : 193.h,
                                  left: 16.w,
                                  right: 16.w),
                              child: Consumer(
                                builder: (context, watch, child) {
                                  final receiveAsset =
                                      watch(requestOrderProvider)
                                          .receiveAssetId;
                                  final receiveAssets =
                                      watch(requestOrderProvider)
                                          .receiveAssets();
                                  final balance = watch(requestOrderProvider)
                                      .receiveBalance();
                                  final precision = context
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
                                    controller: receiveController,
                                    dropdownValue: receiveAsset,
                                    availableAssets: receiveAssets,
                                    swapType: SwapType.atomic,
                                    balance: balance,
                                    hintText: hint,
                                    showHintText: true,
                                    readOnly: true,
                                    dropdownReadOnly: receiveAssets.length == 1,
                                    dollarConversion: receiveConversion,
                                    onDropdownChanged: (value) {
                                      final receiveAsset = context
                                          .read(requestOrderProvider)
                                          .receiveAssetId;
                                      if (receiveAsset == value) {
                                        return;
                                      }
                                      context
                                          .read(requestOrderProvider)
                                          .receiveAssetId = value;
                                      clearData();
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
