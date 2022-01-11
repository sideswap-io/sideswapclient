import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fixnum/fixnum.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/swap/widgets/swap_middle_icon.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:sideswap/screens/swap/widgets/top_swap_buttons.dart';

class SwapMain extends StatefulWidget {
  const SwapMain({Key? key}) : super(key: key);
  @override
  _SwapMainState createState() => _SwapMainState();
}

enum Subscribe {
  empty,
  send,
  recv,
}

class _SwapMainState extends State<SwapMain> {
  TextEditingController? _swapSendAmountController;
  TextEditingController? _swapRecvAmountController;
  TextEditingController? _swapAddressRecvController;

  late FocusNode _deliverFocusNode;
  late FocusNode _receiveFocusNode;
  // Do not use _receiveAddressFocusNode for now because it cause exception after dispose call
  //late FocusNode _receiveAddressFocusNode;
  Subscribe subscribe = Subscribe.empty;
  // Do not delete - for future use
  final bool _visibleToggles = false;

  bool pegInInfoDisplayed = false;
  bool pegOutInfoDisplayed = false;
  String? _addressErrorText;
  bool addressLabelVisible = false;
  int blocks = 2;

  BuildContext? currentContext;

  bool authInProgress = false;

  @override
  void initState() {
    super.initState();

    _swapSendAmountController = TextEditingController();
    _swapRecvAmountController = TextEditingController();
    _swapAddressRecvController = TextEditingController();
    _deliverFocusNode = FocusNode();
    _receiveFocusNode = FocusNode();
    //_receiveAddressFocusNode = FocusNode();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_deliverFocusNode);
    });

    final serverStatus = context.read(walletProvider).serverStatus;
    if (serverStatus?.bitcoinFeeRates != null) {
      blocks = serverStatus!.bitcoinFeeRates.first.blocks;
    }

    currentContext = context.read(walletProvider).navigatorKey.currentContext;

    subscribeToPriceStream();
  }

  @override
  void dispose() {
    _swapSendAmountController?.dispose();
    _swapRecvAmountController?.dispose();
    _swapAddressRecvController?.dispose();
    _deliverFocusNode.dispose();
    _receiveFocusNode.dispose();
    //_receiveAddressFocusNode.dispose();
    if (currentContext != null) {
      currentContext!.read(walletProvider).unsubscribeFromPriceStream();
    }
    super.dispose();
  }

  void onFeeRateChanged(FeeRate feeRate) {
    blocks = feeRate.blocks;
    refreshSwapAmount();
  }

  void onSwapSendAmountChanged(String value) {
    subscribe = Subscribe.send;
    final newValue = replaceCharacterOnPosition(
      input: value,
    );

    if (_swapSendAmountController != null) {
      _swapSendAmountController!.value = fixCursorPosition(
          controller: _swapSendAmountController!, newValue: newValue);
    }

    refreshSwapAmount();
    subscribeToPriceStream();
  }

  void onSwapRecvAmountChanged(String value) {
    subscribe = Subscribe.recv;
    final newValue = replaceCharacterOnPosition(
      input: value,
    );

    if (_swapRecvAmountController != null) {
      _swapRecvAmountController!.value = fixCursorPosition(
          controller: _swapRecvAmountController!, newValue: newValue);
    }

    refreshSwapAmount();
    subscribeToPriceStream();
  }

  void onMaxSendPressed() {
    final swapSendAsset = context.read(swapProvider).swapSendAsset!;
    final swapSendAccount = AccountAsset(AccountType.regular, swapSendAsset);
    final precision = context
        .read(walletProvider)
        .getPrecisionForAssetId(assetId: swapSendAsset);
    final _balance = context.read(balancesProvider).balances[swapSendAccount];
    final _balanceStr = amountStr(_balance ?? 0, precision: precision);

    var amount = _balanceStr;
    subscribe = Subscribe.send;

    final newValue = replaceCharacterOnPosition(
      input: amount,
    );
    _swapSendAmountController?.value = TextEditingValue(
      text: newValue,
      selection: TextSelection.collapsed(offset: newValue.length),
    );

    refreshSwapAmount();
    subscribeToPriceStream();
  }

  void subscribeToPriceStream() {
    final wallet = context.read(walletProvider);
    final swaps = context.read(swapProvider);
    final type = swaps.swapType();

    wallet.unsubscribeFromPriceStream();

    if (type == SwapType.atomic) {
      final swapSendAsset = swaps.swapSendAsset ?? '';
      final swapRecvAsset = swaps.swapRecvAsset ?? '';
      final sendAmount = (subscribe == Subscribe.send) ? getSendAmount() : null;
      final recvAmount = (subscribe == Subscribe.recv) ? getRecvAmount() : null;
      final sendBitcoins = swapSendAsset == wallet.liquidAssetId();
      final asset = sendBitcoins ? swapRecvAsset : swapSendAsset;
      wallet.subscribeToPriceStream(
          asset, sendBitcoins, sendAmount, recvAmount, updateFromPriceStream);
    }
  }

  void setDeliverAsset(AccountAsset accountAsset) {
    context.read(swapProvider).setSelectedLeftAsset(accountAsset.asset);
    subscribeToPriceStream();
  }

  void setReceiveAsset(AccountAsset accountAsset) {
    context.read(swapProvider).setSelectedRightAsset(accountAsset.asset);
    subscribeToPriceStream();
  }

  void toggleAssets() {
    final _swapRecvAsset = context.read(swapProvider).swapRecvAsset;
    final _swapSendAsset = context.read(swapProvider).swapSendAsset;
    context.read(swapProvider).setSelectedLeftAsset(_swapRecvAsset ?? '');
    context.read(swapProvider).setSelectedRightAsset(_swapSendAsset ?? '');
    clearAddressController();
    clearAmountController();
    subscribeToPriceStream();
  }

  void switchToSwaps() {
    final swap = context.read(swapProvider);

    swap.setSwapPeg(false);
    clearAddressController();
    clearAmountController();
    swap.swapReset();
    subscribeToPriceStream();
  }

  void switchToPegs() {
    final swap = context.read(swapProvider);
    final wallet = context.read(walletProvider);

    swap.setSwapPeg(true);
    swap.setSelectedLeftAsset(wallet.bitcoinAssetId());
    swap.setSelectedRightAsset(wallet.liquidAssetId());
    clearAddressController();
    clearAmountController();
    swap.swapReset();
    subscribeToPriceStream();
  }

  void updateFromPriceStream(From_UpdatePriceStream msg) {
    final swaps = context.read(swapProvider);
    final wallet = context.read(walletProvider);
    // Do not update amounts while waiting for swap transaction
    if (swaps.swapState != SwapState.idle || authInProgress) {
      return;
    }

    swaps.swapNetworkError = msg.errorMsg;
    swaps.price = msg.hasPrice() ? msg.price : null;

    if (subscribe == Subscribe.send) {
      if (msg.hasRecvAmount()) {
        swaps.swapRecvAmount = msg.recvAmount.toInt();
        final recvAsset = swaps.swapRecvAsset;
        final recvPrecision =
            wallet.getPrecisionForAssetId(assetId: recvAsset ?? '');
        final recvAmount = swaps.swapRecvAmount;
        final recvAmountStr = recvAmount != 0
            ? amountStr(recvAmount, precision: recvPrecision)
            : '';
        _swapRecvAmountController!.text = replaceCharacterOnPosition(
          input: recvAmountStr,
        );
      } else {
        _swapRecvAmountController!.text = '';
      }
    }

    if (subscribe == Subscribe.recv) {
      if (msg.hasSendAmount()) {
        swaps.swapSendAmount = msg.sendAmount.toInt();
        final sendAsset = swaps.swapSendAsset;
        final sendPrecision =
            wallet.getPrecisionForAssetId(assetId: sendAsset ?? '');
        final sendAmount = swaps.swapSendAmount;
        final sendAmountStr = sendAmount != 0
            ? amountStr(sendAmount, precision: sendPrecision)
            : '';
        _swapSendAmountController!.text = replaceCharacterOnPosition(
          input: sendAmountStr,
        );
      } else {
        _swapSendAmountController!.text = '';
      }
    }
  }

  int getAssetAmount(String asset, String value) {
    final wallet = context.read(walletProvider);
    final precision = wallet.getPrecisionForAssetId(assetId: asset);
    final amount = wallet.parseAssetAmount(value, precision: precision) ?? 0;
    return amount;
  }

  int getSendAmount() {
    final sendAsset = context.read(swapProvider).swapSendAsset;
    return getAssetAmount(sendAsset ?? '', _swapSendAmountController!.text);
  }

  int getRecvAmount() {
    final recvAsset = context.read(swapProvider).swapRecvAsset;
    return getAssetAmount(recvAsset ?? '', _swapRecvAmountController!.text);
  }

  bool insufficientFunds() {
    final swapSendAsset = context.read(swapProvider).swapSendAsset!;
    final sendAccount = AccountAsset(AccountType.regular, swapSendAsset);
    final balance = context.read(balancesProvider).balances[sendAccount] ?? 0;
    final sendAmount = getSendAmount();
    return sendAmount > 0 && sendAmount > balance;
  }

  void swapAccept() async {
    final wallet = context.read(walletProvider);
    final swaps = context.read(swapProvider);
    // Remember amounts before calling async functions
    final sendAmount = getSendAmount();
    final recvAmount = getRecvAmount();
    final price = swaps.price;
    final type = swaps.swapType();
    final sendAccount = AccountAsset(AccountType.regular, swaps.swapSendAsset!);

    final maxBalance = swaps.swapSendWallet == SwapWallet.local
        ? context.read(balancesProvider).balances[sendAccount] ?? 0
        : kMaxCoins;
    if (type != SwapType.pegIn) {
      if (sendAmount <= 0 || sendAmount > maxBalance) {
        await context
            .read(utilsProvider)
            .showErrorDialog('Please enter correct amount'.tr());
        return;
      }
    }

    if (type == SwapType.pegOut) {
      final addrType = swaps.swapAddrType(swaps.swapType());
      if (!wallet.isAddrValid(swaps.swapRecvAddressExternal, addrType)) {
        await context.read(utilsProvider).showErrorDialog(
            'PLEASE_ENTER_CORRECT_ADDRESS'
                .tr(args: [(swaps.addrTypeStr(addrType))]));
        return;
      }
    }

    authInProgress = true;
    final authSucceed = await wallet.isAuthenticated();
    authInProgress = false;
    if (!authSucceed) {
      return;
    }

    if (type == SwapType.pegIn) {
      final msg = To();
      msg.pegInRequest = To_PegInRequest();
      wallet.sendMsg(msg);
      swaps.swapState = SwapState.sent;
      return;
    }

    if (type == SwapType.pegOut) {
      final msg = To();
      msg.pegOutRequest = To_PegOutRequest();
      msg.pegOutRequest.sendAmount = Int64(sendAmount);
      msg.pegOutRequest.recvAddr = swaps.swapRecvAddressExternal;
      msg.pegOutRequest.blocks = blocks;
      wallet.sendMsg(msg);
      swaps.swapState = SwapState.sent;
    }

    if (type == SwapType.atomic) {
      final msg = To();
      msg.swapRequest = To_SwapRequest();
      final swapSendAsset = swaps.swapSendAsset ?? '';
      final sendBitcoins = swapSendAsset == wallet.liquidAssetId();
      final swapRecvAsset = swaps.swapRecvAsset ?? '';
      final asset = sendBitcoins ? swapRecvAsset : swapSendAsset;
      msg.swapRequest.sendBitcoins = sendBitcoins;
      msg.swapRequest.asset = asset;
      msg.swapRequest.sendAmount = Int64(sendAmount);
      msg.swapRequest.recvAmount = Int64(recvAmount);
      msg.swapRequest.price = price ?? 0.0;
      wallet.sendMsg(msg);
      swaps.swapState = SwapState.sent;
    }
  }

  void refreshSwapAmount() {
    context.read(swapProvider).swapReset();
  }

  void clearAmountController() {
    context.read(swapProvider).swapSendAmount = 0;
    context.read(swapProvider).swapRecvAmount = 0;
    _swapSendAmountController?.clear();
    _swapRecvAmountController?.clear();
    subscribe = Subscribe.empty;
  }

  void clearAddressController() {
    _swapAddressRecvController?.clear();
    validateAddress(_swapAddressRecvController?.text ?? '');
  }

  void validateAddress(String text) {
    if (text.isEmpty) {
      setState(() {
        _addressErrorText = null;
        addressLabelVisible = false;
      });
      return;
    }

    if (context.read(walletProvider).isAddrValid(text, AddrType.bitcoin)) {
      setState(() {
        _addressErrorText = null;
        addressLabelVisible = true;
        FocusManager.instance.primaryFocus?.unfocus();
      });
    } else {
      setState(() {
        _addressErrorText = 'Wrong address'.tr();
        addressLabelVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                child: Stack(
                  children: [
                    buildBottomBackground(),
                    SwapMiddleIcon(
                      visibleToggles: _visibleToggles,
                      onTap: toggleAssets,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 237.h),
                          child: buildReceiveAmount(),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: buildBottomButton(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: buildTopButtons(context),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: buildDeliverAmount(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildBottomButton() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
      child: Consumer(
        builder: (context, watch, child) {
          final swapType = watch(swapProvider).swapType();
          final swapTypeStr =
              context.read(swapProvider).swapTypeStr(swapType).toUpperCase();
          bool enabled;
          switch (swapType) {
            case SwapType.atomic:
              enabled = getSendAmount() > 0 &&
                  getRecvAmount() > 0 &&
                  !insufficientFunds();
              break;
            case SwapType.pegIn:
              enabled = true;
              break;
            case SwapType.pegOut:
              enabled = getSendAmount() > 0 &&
                  !insufficientFunds() &&
                  _swapAddressRecvController != null &&
                  _swapAddressRecvController!.text.isNotEmpty &&
                  _addressErrorText == null;
              break;
          }

          if (swapType == SwapType.pegIn && !pegInInfoDisplayed) {
            context.read(swapProvider).showPegInInformation();
            pegInInfoDisplayed = true;
          }

          if (swapType == SwapType.pegOut && !pegOutInfoDisplayed) {
            context.read(swapProvider).showPegOutInformation();
            pegOutInfoDisplayed = true;
          }

          final swapState = watch(swapProvider).swapState;

          enabled = enabled && swapState == SwapState.idle;

          return CustomBigButton(
            width: double.infinity,
            height: 54.h,
            enabled: enabled,
            backgroundColor: const Color(0xFF00C5FF),
            onPressed: enabled ? () => swapAccept() : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  swapTypeStr,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                if (swapState == SwapState.sent) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 84.w),
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
          );
        },
      ),
    );
  }

  Widget buildReceiveAmount() {
    return Consumer(
      builder: (context, watch, child) {
        final _swapRecvAssets = watch(swapProvider)
            .swapRecvAssets()
            .map((e) => AccountAsset(AccountType.regular, e))
            .toList();
        final _swapRecvAsset = watch(swapProvider).swapRecvAsset!;
        final _swapRecvWallet = watch(swapProvider).swapRecvWallet;
        final _precision = context
            .read(walletProvider)
            .getPrecisionForAssetId(assetId: _swapRecvAsset);
        final swapRecvAccount =
            AccountAsset(AccountType.regular, _swapRecvAsset);
        final _balance = watch(balancesProvider).balances[swapRecvAccount];
        final _balanceStr = amountStr(_balance ?? 0, precision: _precision);
        final _swapType = watch(swapProvider).swapType();
        final swapState = watch(swapProvider).swapState;

        final serverStatus = watch(walletProvider).serverStatus;
        final feeRates = (_swapType == SwapType.pegOut &&
                _swapRecvWallet == SwapWallet.extern &&
                serverStatus != null)
            ? serverStatus.bitcoinFeeRates
            : <FeeRate>[];
        // Show error in one place only
        final serverError = subscribe != Subscribe.recv
            ? ''
            : watch(swapProvider).swapNetworkError;

        return SwapSideAmount(
          text: 'Receive'.tr(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          controller: _swapRecvAmountController!,
          addressController: _swapAddressRecvController!,
          isMaxVisible: false,
          readOnly: _swapType != SwapType.atomic || swapState != SwapState.idle,
          hintText: '0.0',
          showHintText: _swapType == SwapType.atomic,
          dropdownReadOnly:
              _swapType == SwapType.atomic && _swapRecvAsset.length > 1
                  ? false
                  : true,
          feeRates: feeRates,
          onFeeRateChanged: onFeeRateChanged,
          visibleToggles: _visibleToggles,
          balance: _balanceStr,
          dropdownValue: AccountAsset(AccountType.regular, _swapRecvAsset),
          availableAssets: _swapRecvAssets,
          labelGroupValue: _swapRecvWallet,
          addressErrorText: _addressErrorText,
          focusNode: _receiveFocusNode,
          //receiveAddressFocusNode: _receiveAddressFocusNode,
          receiveAddressFocusNode: null,
          isAddressLabelVisible: addressLabelVisible,
          swapType: _swapType,
          showInsufficientFunds: false,
          errorDescription: serverError,
          localLabelOnChanged: (value) =>
              context.read(swapProvider).setRecvRadioCb(SwapWallet.local),
          externalLabelOnChanged: (value) =>
              context.read(swapProvider).setRecvRadioCb(SwapWallet.extern),
          onDropdownChanged: setReceiveAsset,
          onChanged: onSwapRecvAmountChanged,
          onAddressEditingCompleted: () async {
            final text = _swapAddressRecvController?.text ?? '';
            validateAddress(text);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onAddressChanged: (text) {
            validateAddress(text);
          },
          onAddressLabelClose: () {
            setState(() {
              _swapAddressRecvController?.clear();
              addressLabelVisible = false;
            });
          },
        );
      },
    );
  }

  Widget buildDeliverAmount() {
    return Consumer(
      builder: (context, watch, child) {
        final swapSendAsset = AccountAsset(
            AccountType.regular, watch(swapProvider).swapSendAsset!);
        final balance = watch(balancesProvider).balances[swapSendAsset] ?? 0;
        final precision = context
            .read(walletProvider)
            .getPrecisionForAssetId(assetId: swapSendAsset.asset);
        final balanceStr = amountStr(balance, precision: precision);
        final swapSendAssets = watch(swapProvider)
            .swapSendAssets()
            .map((e) => AccountAsset(AccountType.regular, e))
            .toList();
        final swapSendWallet = watch(swapProvider).swapSendWallet;
        final swapState = watch(swapProvider).swapState;
        final swapType = watch(swapProvider).swapType();
        final serverError = subscribe == Subscribe.recv
            ? ''
            : watch(swapProvider).swapNetworkError;
        final showInsufficientFunds = insufficientFunds() && serverError == '';

        return SwapSideAmount(
          text: 'Deliver'.tr(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          controller: _swapSendAmountController!,
          focusNode: _deliverFocusNode,
          isMaxVisible: true,
          balance: balanceStr,
          readOnly: swapSendWallet == SwapWallet.extern ||
              swapState != SwapState.idle,
          hintText: '0.0',
          showHintText: true,
          visibleToggles: _visibleToggles,
          dropdownValue: swapSendAsset,
          availableAssets: swapSendAssets,
          labelGroupValue: swapSendWallet,
          swapType: swapType,
          showInsufficientFunds: showInsufficientFunds,
          errorDescription: serverError,
          localLabelOnChanged: (value) =>
              context.read(swapProvider).setSendRadioCb(SwapWallet.local),
          externalLabelOnChanged: (value) =>
              context.read(swapProvider).setSendRadioCb(SwapWallet.extern),
          onDropdownChanged: setDeliverAsset,
          onChanged: onSwapSendAmountChanged,
          onMaxPressed: onMaxSendPressed,
        );
      },
    );
  }

  Widget buildTopButtons(BuildContext context) {
    return TopSwapButtons(
      onSwapPressed: switchToSwaps,
      onPegPressed: switchToPegs,
    );
  }

  Widget buildBottomBackground() {
    return Consumer(
      builder: (context, watch, child) {
        final _swapType = watch(swapProvider).swapType();
        return Padding(
          padding: EdgeInsets.only(
              top: _swapType != SwapType.atomic
                  ? _visibleToggles
                      ? 275.h
                      : 205.h
                  : 205.h),
          child: Container(
            color: const Color(0xFF1C6086),
          ),
        );
      },
    );
  }
}
