// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'package:sideswap/common/helpers.dart';
// import 'package:sideswap/common/sideswap_colors.dart';
// import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
// import 'package:sideswap/common/utils/market_helpers.dart';
// import 'package:sideswap/common/widgets/custom_app_bar.dart';
// import 'package:sideswap/common/widgets/custom_big_button.dart';
// import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
// import 'package:sideswap/models/account_asset.dart';
// import 'package:sideswap/providers/balances_provider.dart';
// import 'package:sideswap/providers/markets_provider.dart';
// import 'package:sideswap/providers/request_order_provider.dart';
// import 'package:sideswap/providers/swap_provider.dart';
// import 'package:sideswap/providers/wallet.dart';
// import 'package:sideswap/providers/wallet_assets_providers.dart';
// import 'package:sideswap/screens/markets/widgets/order_price_field.dart';
// import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';

// class OrderEntry2 extends StatefulHookConsumerWidget {
//   const OrderEntry2({super.key});

//   @override
//   OrderEntryState2 createState() => OrderEntryState2();
// }

// class OrderEntryState2 extends ConsumerState<OrderEntry2> {
//   final TextEditingController deliverController = TextEditingController();
//   final TextEditingController receiveController = TextEditingController();
//   final TextEditingController priceAmountController = TextEditingController();
//   late FocusNode deliverFocusNode;
//   late FocusNode receiveFocusNode;
//   late FocusNode priceFocusNode;
//   bool isValid = false;
//   bool showInsufficientFunds = false;
//   bool isContinued = false;
//   String receiveConversion = '';
//   String priceConversion = '';
//   bool trackingSelected = false;
//   double sliderValue = 0;
//   String trackingPrice = '';
//   bool displaySlider = false;
//   bool inversePrice = false;

//   BuildContext? currentContext;

//   @override
//   void initState() {
//     super.initState();

//     currentContext = ref.read(walletProvider).navigatorKey.currentContext;

//     deliverController.addListener(() {
//       Future.microtask(() {
//         final requestOrder = ref.read(requestOrderProvider);
//         final isSellOrder = ref.read(isSellOrderProvider);
//         // Check isSellOrder to prevent cascading notifications after price edit
//         if (isSellOrder) {
//           receiveController.text = requestOrder.calculateReceiveAmount(
//               deliverController.text, priceAmountController.text);
//           validate();
//         }
//       });
//     });

//     receiveController.addListener(() {
//       Future.microtask(() {
//         final requestOrder = ref.read(requestOrderProvider);
//         final isSellOrder = ref.read(isSellOrderProvider);
//         // Check isSellOrder to prevent cascading notifications after price edit
//         if (!isSellOrder) {
//           deliverController.text = requestOrder.calculateDeliverAmount(
//               receiveController.text, priceAmountController.text);
//           validate();
//         }
//       });
//     });

//     priceAmountController.addListener(() {
//       Future.microtask(() {
//         final requestOrder = ref.read(requestOrderProvider);
//         final isSellOrder = ref.read(isSellOrderProvider);
//         if (isSellOrder) {
//           receiveController.text = requestOrder.calculateReceiveAmount(
//               deliverController.text, priceAmountController.text);
//         } else {
//           deliverController.text = requestOrder.calculateDeliverAmount(
//               receiveController.text, priceAmountController.text);
//         }
//         validate();
//       });
//     });

//     deliverFocusNode = FocusNode();
//     priceFocusNode = FocusNode();
//     receiveFocusNode = FocusNode();

//     Future.microtask(() {
//       inversePrice = !ref.read(isDeliverLiquidProvider);

//       final tokenAssetId = ref.read(tokenAccountAssetProvider).assetId;
//       ref.read(marketsProvider).subscribeIndexPrice(tokenAssetId);

//       displaySlider = isTracking();

//       focusEnterAmount();
//     });
//   }

//   bool isTracking() {
//     final requestOrderIndexPrice = ref.read(requestOrderIndexPriceProvider);
//     final isToken = ref.read(isDeliverTokenProvider);
//     return trackingSelected && !isToken && requestOrderIndexPrice.isNotEmpty;
//   }

//   @override
//   void dispose() {
//     deliverController.dispose();
//     receiveController.dispose();
//     priceAmountController.dispose();
//     deliverFocusNode.dispose();
//     receiveFocusNode.dispose();
//     priceFocusNode.dispose();
//     super.dispose();
//   }

//   void focusEnterAmount() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (ref.read(isSellOrderProvider)) {
//         FocusScope.of(context).requestFocus(deliverFocusNode);
//         setControllerValue(deliverController, '');
//       } else {
//         FocusScope.of(context).requestFocus(receiveFocusNode);
//         setControllerValue(receiveController, '');
//       }
//     });
//   }

//   void clearData() {
//     deliverController.clear();
//     priceAmountController.clear();
//     receiveController.clear();
//     validate();
//   }

//   void validate() {
//     updateDollarConversion();

//     final precision = ref.read(deliverAssetPrecisionProvider);
//     final deliverAmount = ref
//         .read(walletProvider)
//         .parseAssetAmount(deliverController.text, precision: precision);
//     if (deliverAmount == null) {
//       setState(() {
//         showInsufficientFunds = false;
//         isValid = false;
//       });
//       return;
//     }

//     final deliverAccountAsset =
//         ref.read(deliverOrderEntryAccountAssetProvider).accountAsset;

//     final balance = ref.read(balancesProvider).balances[deliverAccountAsset];
//     if (balance == null) {
//       setState(() {
//         isValid = false;
//       });
//       return;
//     }

//     if (deliverAmount > balance) {
//       setState(() {
//         showInsufficientFunds = true;
//         isValid = false;
//       });
//       return;
//     } else {
//       showInsufficientFunds = false;
//     }

//     if (ref
//         .read(requestOrderProvider)
//         .calculateReceiveAmount(
//             deliverController.text, priceAmountController.text)
//         .isNotEmpty) {
//       setState(() {
//         isValid = true;
//       });
//     } else {
//       setState(() {
//         isValid = false;
//       });
//     }
//   }

//   void updateDollarConversion() {
//     final priceAssetId = ref.read(priceAssetProvider)?.assetId;

//     if (priceAssetId == ref.read(tetherAssetIdStateProvider)) {
//       priceConversion = '';
//     } else {
//       priceConversion = ref.read(dollarConversionFromStringProvider(
//           priceAssetId, priceAmountController.text));
//     }

//     final receiveAccountAsset =
//         ref.read(receiveOrderEntryAccountAssetProvider).accountAsset;

//     if (receiveAccountAsset.assetId == ref.read(tetherAssetIdStateProvider)) {
//       receiveConversion = '';
//     } else {
//       receiveConversion = ref.read(dollarConversionFromStringProvider(
//           receiveAccountAsset.assetId, receiveController.text));
//     }
//   }

//   void onContinue() {
//     // hide keyboard
//     SystemChannels.textInput.invokeMethod<void>('TextInput.hide');

//     final isSellOrder = ref.read(isSellOrderProvider);
//     final isSendBitcoin = ref.read(isDeliverLiquidProvider);
//     final receiveAccountAsset =
//         ref.read(receiveOrderEntryAccountAssetProvider).accountAsset;
//     final deliverAccountAsset =
//         ref.read(deliverOrderEntryAccountAssetProvider).accountAsset;

//     final isAmp = deliverAccountAsset.account == AccountType.amp ||
//         receiveAccountAsset.account == AccountType.amp;
//     final isAssetAmount = !isSendBitcoin || isAmp;

//     var amount = isSellOrder
//         ? -(double.tryParse(deliverController.text) ?? 0)
//         : (double.tryParse(receiveController.text) ?? 0);

//     final priceAmount = double.tryParse(priceAmountController.text) ?? 0;
//     var price = priceAmount;

//     var trackingPercent = .0;
//     if (isTracking()) {
//       final requestOrderIndexPrice =
//           double.tryParse(ref.read(requestOrderIndexPriceProvider)) ?? 0;
//       trackingPercent = 1 + (sliderValue / 100);
//       price = requestOrderIndexPrice;
//     }

//     final accountAsset = ref.read(tokenAccountAssetProvider);
//     final assetId = accountAsset.assetId;

//     ref.read(walletProvider).submitOrder(
//           assetId,
//           amount,
//           price,
//           isAssetAmount: isAssetAmount,
//           indexPrice: isTracking() ? trackingPercent : null,
//           account: accountAsset.account,
//         );
//     ref
//         .read(marketSelectedAssetIdStateProvider.notifier)
//         .setSelectedAssetId(assetId!);
//     setState(() {
//       isValid = false;
//       isContinued = true;
//     });
//   }

//   void onToggleTracking(bool value) {
//     setState(() {
//       trackingSelected = value;
//       priceAmountController.text = '';
//       sliderValue = 0;
//       trackingPrice = '';
//       displaySlider = isTracking();
//     });
//     if (value) {
//       calculateTrackingPrice();
//     }
//   }

//   void calculateTrackingPrice() {
//     final ticker = ref.read(priceAssetProvider)?.ticker ?? '';

//     final trackingAsset = ref.read(priceAssetProvider);
//     final trackingPriceFixed = ref
//         .read(indexPriceForAssetProvider(trackingAsset?.assetId))
//         .calculateTrackingPrice(sliderValue);

//     setState(() {
//       if ((double.tryParse(trackingPriceFixed) ?? 0) != 0) {
//         priceAmountController.text = trackingPriceFixed;
//       } else {
//         priceAmountController.text = '';
//       }
//       trackingPrice =
//           '${replaceCharacterOnPosition(input: trackingPriceFixed)} $ticker';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final requestOrderIndexPrice = ref.watch(requestOrderIndexPriceProvider);
//     final marketType = ref.watch(marketTypeProvider);
//     final isStablecoin = marketType == MarketType.stablecoin;
//     final isToken = marketType == MarketType.token;
//     final deliverLiquid = ref.watch(isDeliverLiquidProvider);
//     final orderEntryProductPair = ref.watch(orderEntryProductProvider);

//     // TODO (malcolmpl): remove when done
//     ref.listen(orderEntryProductProvider, (previous, next) {});

//     // listen to index price when token is changed
//     ref.listen(priceAssetProvider, (previous, next) {
//       if (previous == next) {
//         return;
//       }

//       ref.read(marketsProvider).subscribeIndexPrice(next?.assetId);
//     });

//     return SideSwapScaffold(
//       appBar: CustomAppBar(
//         title: 'Order entry'.tr(),
//         onPressed: () {
//           FocusManager.instance.primaryFocus?.unfocus();

//           ref.read(marketsProvider).unsubscribeIndexPrice();
//           ref.read(walletProvider).goBack();
//         },
//         backgroundColor: const Color(0xFF064363),
//       ),
//       backgroundColor: const Color(0xFF064363),
//       sideSwapBackground: false,
//       body: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () {
//           final currentFocus = FocusScope.of(context);

//           if (!currentFocus.hasPrimaryFocus &&
//               currentFocus.focusedChild != null) {
//             FocusManager.instance.primaryFocus?.unfocus();
//           }
//         },
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minWidth: constraints.maxWidth,
//                   minHeight: constraints.maxHeight,
//                 ),
//                 child: IntrinsicHeight(
//                   child: SafeArea(
//                     child: Stack(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(
//                               top: displaySlider
//                                   ? 215
//                                   : (isStablecoin ? 200 : 180)),
//                           child: Container(
//                             color: SideSwapColors.chathamsBlue,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               top: displaySlider
//                                   ? 115
//                                   : (isStablecoin ? 115 : 95),
//                               left: 16,
//                               right: 16),
//                           child: Builder(
//                             builder: (context) {
//                               final priceAsset = ref.watch(priceAssetProvider);
//                               final productAssetId =
//                                   ref.watch(tokenAccountAssetProvider).assetId;
//                               final productAsset = ref.watch(assetsStateProvider
//                                   .select((value) => value[productAssetId]));
//                               final icon = ref
//                                   .watch(assetImageProvider)
//                                   .getSmallImage(priceAsset?.assetId);

//                               displaySlider = isTracking();

//                               return OrderPriceField(
//                                 focusNode: priceFocusNode,
//                                 asset: priceAsset,
//                                 productAsset: productAsset,
//                                 icon: icon,
//                                 controller: priceAmountController,
//                                 dollarConversion: priceConversion,
//                                 tracking: isTracking(),
//                                 displaySlider: displaySlider,
//                                 onToggleTracking:
//                                     isToken || requestOrderIndexPrice.isEmpty
//                                         ? null
//                                         : (value) {
//                                             Future.microtask(
//                                                 () => onToggleTracking(value));
//                                           },
//                                 onEditingComplete: () {
//                                   Future.microtask(() {
//                                     validate();
//                                     SystemChannels.textInput
//                                         .invokeMethod<void>('TextInput.hide');
//                                   });
//                                 },
//                                 // sliderValue: sliderValue,
//                                 onSliderChanged: (value) {
//                                   setState(() {
//                                     sliderValue = value;
//                                   });

//                                   Future.microtask(() {
//                                     calculateTrackingPrice();
//                                   });
//                                 },
//                                 invertColors: inversePrice,
//                               );
//                             },
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 0, left: 16, right: 16),
//                               child: Builder(
//                                 builder: (context) {
//                                   return Consumer(
//                                     builder: (context, ref, child) {
//                                       final disabledAssets = ref.watch(
//                                           disableAccountAssetListProvider);
//                                       final balance =
//                                           ref.watch(deliverBalanceProvider);
//                                       final precision = ref
//                                           .watch(deliverAssetPrecisionProvider);
//                                       final hint =
//                                           DecimalCutterTextInputFormatter(
//                                         decimalRange: precision,
//                                       )
//                                               .formatEditUpdate(
//                                                   const TextEditingValue(
//                                                       text: '0.00000000'),
//                                                   const TextEditingValue(
//                                                       text: '0.00000000'))
//                                               .text;
//                                       final isSellOrder =
//                                           ref.watch(isSellOrderProvider);
//                                       final readOnly = !isSellOrder;
//                                       final dropdownReadOnly =
//                                           orderEntryProductPair.deliver
//                                                   .accountAssetList.length ==
//                                               1;

//                                       return SwapSideAmount(
//                                         text: 'Deliver'.tr(),
//                                         focusNode: deliverFocusNode,
//                                         controller: deliverController,
//                                         dropdownValue: orderEntryProductPair
//                                             .deliver.accountAsset,
//                                         availableAssets: orderEntryProductPair
//                                             .deliver.accountAssetList,
//                                         dropdownReadOnly: dropdownReadOnly,
//                                         disabledAssets: disabledAssets,
//                                         balance: balance,
//                                         isMaxVisible: !readOnly,
//                                         hintText: hint,
//                                         showHintText: true,
//                                         readOnly: readOnly,
//                                         swapType: SwapType.atomic,
//                                         showInsufficientFunds:
//                                             showInsufficientFunds,
//                                         showAccountsInPopup: true,
//                                         onDropdownChanged: (value) {
//                                           ref
//                                               .read(
//                                                   marketSelectedAssetIdStateProvider
//                                                       .notifier)
//                                               .setSelectedAssetId(
//                                                   value.assetId ?? '');

//                                           inversePrice = !ref
//                                               .read(isDeliverLiquidProvider);

//                                           clearData();
//                                           focusEnterAmount();
//                                         },
//                                         onMaxPressed: () {
//                                           Future.microtask(() {
//                                             setControllerValue(
//                                                 deliverController, balance);
//                                             validate();
//                                           });
//                                         },
//                                         onEditingCompleted: () {
//                                           Future.microtask(() {
//                                             if (displaySlider) {
//                                               validate();
//                                             }
//                                             if (displaySlider) {
//                                               FocusScope.of(context).unfocus();
//                                             } else {
//                                               FocusScope.of(context)
//                                                   .requestFocus(priceFocusNode);
//                                             }
//                                           });
//                                         },
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   top: displaySlider
//                                       ? 190
//                                       : (isStablecoin
//                                           ? 160
//                                           : (deliverLiquid ? 150 : 140)),
//                                   left: 16,
//                                   right: 16),
//                               child: Builder(
//                                 builder: (context) {
//                                   return Consumer(
//                                     builder: (context, ref, child) {
//                                       final balance =
//                                           ref.watch(receiveBalanceProvider);
//                                       final precision = ref
//                                           .watch(receiveAssetPrecisionProvider);
//                                       final hint =
//                                           DecimalCutterTextInputFormatter(
//                                         decimalRange: precision,
//                                       )
//                                               .formatEditUpdate(
//                                                   const TextEditingValue(
//                                                       text: '0.00000000'),
//                                                   const TextEditingValue(
//                                                       text: '0.00000000'))
//                                               .text;
//                                       // TODO (malcolmpl): fix read only
//                                       final dropdownReadOnly =
//                                           orderEntryProductPair.receive
//                                                   .accountAssetList.length ==
//                                               1;
//                                       final isSellOrder =
//                                           ref.watch(isSellOrderProvider);
//                                       return SwapSideAmount(
//                                         text: 'Receive'.tr(),
//                                         focusNode: receiveFocusNode,
//                                         controller: receiveController,
//                                         dropdownValue: orderEntryProductPair
//                                             .receive.accountAsset,
//                                         availableAssets: orderEntryProductPair
//                                             .receive.accountAssetList,
//                                         swapType: SwapType.atomic,
//                                         balance: balance,
//                                         hintText: hint,
//                                         showHintText: true,
//                                         readOnly: isSellOrder,
//                                         dropdownReadOnly: dropdownReadOnly,
//                                         dollarConversion: receiveConversion,
//                                         showAccountsInPopup: true,
//                                         onDropdownChanged: (value) {
//                                           ref
//                                               .read(
//                                                   marketSelectedAssetIdStateProvider
//                                                       .notifier)
//                                               .setSelectedAssetId(
//                                                   value.assetId ?? '');
//                                           clearData();
//                                           focusEnterAmount();
//                                         },
//                                         onEditingCompleted: () {
//                                           Future.microtask(() {
//                                             if (displaySlider) {
//                                               validate();
//                                             }
//                                             if (displaySlider) {
//                                               FocusScope.of(context).unfocus();
//                                             } else {
//                                               FocusScope.of(context)
//                                                   .requestFocus(priceFocusNode);
//                                             }
//                                           });
//                                         },
//                                       );
//                                     },
//                                   );
//                                 },
//                               ),
//                             ),
//                             const Spacer(),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 29, bottom: 24, left: 16, right: 16),
//                               child: CustomBigButton(
//                                 width: double.maxFinite,
//                                 height: 54,
//                                 backgroundColor: SideSwapColors.brightTurquoise,
//                                 enabled: isValid,
//                                 onPressed: isValid
//                                     ? () {
//                                         Future.microtask(() => onContinue());
//                                       }
//                                     : null,
//                                 child: Stack(
//                                   alignment: Alignment.center,
//                                   children: [
//                                     Text(
//                                       'CONTINUE'.tr(),
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.normal,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     if (isContinued) ...[
//                                       const Padding(
//                                         padding: EdgeInsets.only(left: 124),
//                                         child: SizedBox(
//                                           width: 32,
//                                           height: 32,
//                                           child: SpinKitCircle(
//                                             color: Colors.white,
//                                             size: 32,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
