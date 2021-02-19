import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/swap/widgets/swap_middle_icon.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:sideswap/screens/swap/widgets/top_swap_buttons.dart';

class SwapMain extends StatefulWidget {
  @override
  _SwapMainState createState() => _SwapMainState();
}

class _SwapMainState extends State<SwapMain> {
  TextEditingController _swapAmountController;
  TextEditingController _swapAddressRecvController;

  String _lastSwapAmountValue;
  FocusNode _deliverFocusNode;
  FocusNode _receiveFocusNode;
  String _swapAmount = '';
  // Do not delete - for future use
  final bool _visibleToggles = false;

  bool pegInInfoDisplayed = false;
  bool pegOutInfoDisplayed = false;
  String _addressErrorText;
  bool addressLabelVisible = false;

  @override
  void initState() {
    super.initState();

    _swapAmountController = TextEditingController();
    _swapAmountController.addListener(onSwapAmountControllerChanged);
    _swapAddressRecvController = TextEditingController();
    _deliverFocusNode = FocusNode();
    _receiveFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_deliverFocusNode);
    });
  }

  @override
  void dispose() {
    _swapAmountController.dispose();
    _swapAddressRecvController.dispose();
    _deliverFocusNode.dispose();
    _receiveFocusNode.dispose();
    super.dispose();
  }

  void onSwapAmountControllerChanged() {
    final value = _swapAmount;

    validateSwapSendAsset();

    if (value == _lastSwapAmountValue) {
      return;
    }
    _lastSwapAmountValue = value;

    final amount = context.read(walletProvider).parseBitcoinAmount(value);
    context.read(swapProvider).setSwapAmount(amount);
  }

  bool validate(String value, String ticker) {
    if (value.isEmpty) {
      context.read(swapProvider).showInsufficientFunds = false;
      return false;
    }

    final balance = context.read(walletProvider).balances[ticker];
    final amount = double.tryParse(value);
    final realBalance = double.tryParse(amountStr(balance ?? 0));
    if (amount == null || realBalance == null) {
      return false;
    }

    if (amount <= realBalance) {
      context.read(swapProvider).showInsufficientFunds = false;
      return true;
    }

    context.read(swapProvider).showInsufficientFunds = true;

    return false;
  }

  void validateSwapSendAsset() {
    final value = _swapAmount;
    final _swapSendAsset = context.read(swapProvider).swapSendAsset;
    validate(value, _swapSendAsset);
  }

  void refreshSwapAmount() {
    context.read(swapProvider).swapReset();

    final value = _swapAmount;
    validateSwapSendAsset();
    final amount = context.read(walletProvider).parseBitcoinAmount(value);
    context.read(swapProvider).setSwapAmount(amount);
  }

  Future<bool> onClose() async {
    FocusManager.instance.primaryFocus.unfocus();
    context.read(swapProvider).swapReset();
    context.read(swapProvider).setSwapPeg(false);
    return context.read(walletProvider).goBack();
  }

  void clearAmountController() async {
    await Future.microtask(() {
      context.read(swapProvider).swapRecvAmount = 0;
      _swapAmountController.clear();
      _swapAmount = '';
      context.read(swapProvider).didAssetReplaced = false;
    });
  }

  void clearAddressController() {
    _swapAddressRecvController.clear();
    validateAddress(_swapAddressRecvController.text);
  }

  void validateAddress(String text) {
    if (text == null || text.isEmpty) {
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
          FocusManager.instance.primaryFocus.unfocus();
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
                      onTap: () {
                        final _swapRecvAsset =
                            context.read(swapProvider).swapRecvAsset;
                        final _swapSendAsset =
                            context.read(swapProvider).swapSendAsset;
                        context
                            .read(swapProvider)
                            .setSelectedLeftAsset(_swapRecvAsset);
                        context
                            .read(swapProvider)
                            .setSelectedRightAsset(_swapSendAsset);

                        clearAddressController();
                      },
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 237.h),
                          child: buildReceiveAmount(),
                        ),
                        Spacer(),
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
          final _recvAmount = watch(swapProvider).swapRecvAmount ?? 0;
          final _swapType = watch(swapProvider).swapType();
          final _swapTypeStr =
              context.read(swapProvider).swapTypeStr(_swapType).toUpperCase();
          var _enabled = _recvAmount > 0 || _swapType == SwapType.pegIn;
          if (_swapType == SwapType.pegOut) {
            _enabled = (_recvAmount > 0 || _swapType == SwapType.pegIn) &&
                _swapAddressRecvController.text != null &&
                _swapAddressRecvController.text.isNotEmpty &&
                _addressErrorText == null;
          }

          if (_swapType == SwapType.pegIn && !pegInInfoDisplayed) {
            context.read(swapProvider).showPegInInformation();
            pegInInfoDisplayed = true;
          }

          if (_swapType == SwapType.pegOut && !pegOutInfoDisplayed) {
            context.read(swapProvider).showPegOutInformation();
            pegOutInfoDisplayed = true;
          }

          return CustomBigButton(
            width: double.infinity,
            height: 54.h,
            text: _swapTypeStr,
            enabled: _enabled,
            backgroundColor: Color(0xFF00C5FF),
            onPressed: _enabled && _addressErrorText == null
                ? () {
                    context.read(swapProvider).swapAccept(context);
                  }
                : null,
          );
        },
      ),
    );
  }

  Widget buildReceiveAmount() {
    return Consumer(
      builder: (context, watch, child) {
        final _swapRecvAssets = watch(swapProvider).swapRecvAssets();
        final _swapRecvAsset = watch(swapProvider).swapRecvAsset;
        final _swapRecvWallet = watch(swapProvider).swapRecvWallet;
        final _recvAmount = watch(swapProvider).swapRecvAmount ?? 0;
        final _recvAmountStr = _recvAmount != 0 ? amountStr(_recvAmount) : '';
        final _balance = watch(walletProvider).balances[_swapRecvAsset];
        final _balanceStr = amountStr(_balance ?? 0);
        final _swapType = watch(swapProvider).swapType();

        if (watch(swapProvider).didAssetReplaced) {
          clearAmountController();
        }
        return SwapSideAmount(
          text: 'Receive'.tr(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          controller: TextEditingController()
            ..text = replaceCharacterOnPosition(
              input: _recvAmountStr,
            ),
          addressController: _swapAddressRecvController,
          readOnly: true,
          hintText: '0.0',
          showHintText: true,
          dropdownReadOnly:
              _swapType == SwapType.atomic && _swapRecvAsset.length > 1
                  ? false
                  : true,
          visibleToggles: _visibleToggles,
          balance: _balanceStr,
          dropdownValue: _swapRecvAsset,
          availableAssets: _swapRecvAssets,
          labelGroupValue: _swapRecvWallet,
          addressErrorText: _addressErrorText,
          focusNode: _receiveFocusNode,
          isAddressLabelVisible: addressLabelVisible,
          localLabelOnChanged: (value) =>
              context.read(swapProvider).setRecvRadioCb(SwapWallet.local),
          externalLabelOnChanged: (value) =>
              context.read(swapProvider).setRecvRadioCb(SwapWallet.extern),
          onDropdownChanged: (value) =>
              context.read(swapProvider).setSelectedRightAsset(value),
          onChanged: (value) {
            final newValue = replaceCharacterOnPosition(
              input: value,
            );
            _swapAddressRecvController.value = TextEditingValue(
              text: newValue,
              selection: TextSelection.collapsed(offset: newValue.length),
            );
          },
          onAddressTap: () async {
            final value = await Clipboard.getData(Clipboard.kTextPlain);
            if (value.text != null) {
              var text = value.text.replaceAll('\n', '');
              text = text.replaceAll(' ', '');
              final wallet = context.read(walletProvider);
              if (wallet.isAddrValid(text, AddrType.bitcoin)) {
                await pasteFromClipboard(_swapAddressRecvController);
              }
              validateAddress(_swapAddressRecvController.text);
            }
          },
          onAddressEditingCompleted: () async {
            final text = _swapAddressRecvController.text;
            validateAddress(text);
            FocusScope.of(context).requestFocus(FocusNode());
          },
          onAddressChanged: (text) {
            validateAddress(text);
          },
          onAddressLabelClose: () {
            setState(() {
              _swapAddressRecvController.clear();
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
        final _swapSendAsset = watch(swapProvider).swapSendAsset;
        final _balance = watch(walletProvider).balances[_swapSendAsset];
        final _balanceStr = amountStr(_balance ?? 0);
        final _swapSendAssets = watch(swapProvider).swapSendAssets();
        final _swapSendWallet = watch(swapProvider).swapSendWallet;
        final _isReadOnly = _swapSendWallet == SwapWallet.extern;

        if (watch(swapProvider).didAssetReplaced) {
          clearAmountController();
        }

        validateSwapSendAsset();

        return SwapSideAmount(
          text: 'Deliver'.tr(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          controller: _swapAmountController,
          focusNode: _deliverFocusNode,
          isMaxVisible: true,
          balance: _balanceStr,
          readOnly: _isReadOnly,
          visibleToggles: _visibleToggles,
          dropdownValue: _swapSendAsset,
          availableAssets: _swapSendAssets,
          labelGroupValue: _swapSendWallet,
          localLabelOnChanged: (value) =>
              context.read(swapProvider).setSendRadioCb(SwapWallet.local),
          externalLabelOnChanged: (value) =>
              context.read(swapProvider).setSendRadioCb(SwapWallet.extern),
          onDropdownChanged: (value) =>
              context.read(swapProvider).setSelectedLeftAsset(value),
          onChanged: (value) {
            _swapAmount = value.replaceAll(' ', '');
            final newValue = replaceCharacterOnPosition(
              input: value,
            );
            _swapAmountController.value = TextEditingValue(
              text: newValue,
              selection: TextSelection.collapsed(offset: newValue.length),
            );

            refreshSwapAmount();
          },
          onMaxPressed: () {
            final _swapSendAsset = context.read(swapProvider).swapSendAsset;

            var amount = amountStr(
                context.read(walletProvider).balances[_swapSendAsset] ?? 0);
            _swapAmount = amount.replaceAll(' ', '');

            final newValue = replaceCharacterOnPosition(
              input: amount,
            );
            _swapAmountController.value = TextEditingValue(
              text: newValue,
              selection: TextSelection.collapsed(offset: newValue.length),
            );

            refreshSwapAmount();
          },
        );
      },
    );
  }

  Widget buildTopButtons(BuildContext context) {
    return TopSwapButtons(
      onSwapPressed: () {
        context.read(swapProvider).setSwapPeg(false);

        clearAddressController();
        _swapAmountController.clear();
        context.read(swapProvider).swapReset();
      },
      onPegPressed: () {
        context.read(swapProvider).setSwapPeg(true);

        // always set as peg-in
        context.read(swapProvider).setSelectedLeftAsset(kBitcoinTicker);
        context.read(swapProvider).setSelectedRightAsset(kLiquidBitcoinTicker);

        clearAddressController();
        _swapAmountController.clear();
        context.read(swapProvider).swapReset();
      },
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
            color: Color(0xFF1C6086),
          ),
        );
      },
    );
  }
}

// Do not delete this class yet
class SwapWaitPegTx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      child: Consumer(
        builder: (context, watch, child) {
          final _address = watch(swapProvider).swapPegAddressServer ?? '';
          final _sendAmount = amountStr(watch(swapProvider).swapSendAmount);
          final _recvAmount = amountStr(watch(swapProvider).swapRecvAmount);
          final _swapSendAsset = watch(swapProvider).swapSendAsset;
          final _swapRecvWallet = watch(swapProvider).swapRecvWallet;
          final _swapRecvAsset = watch(swapProvider).swapRecvAsset;
          final _swapRecvAddressExternal =
              watch(swapProvider).swapRecvAddressExternal ?? '<EMPTY>'.tr();

          return Column(
            children: [
              Container(
                width: 263.w,
                height: 263.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.w,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Consumer(
                    builder: (context, watch, child) => QrImage(
                      data: _address ?? '',
                      version: QrVersions.auto,
                      size: 223.w,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'SWAP_SEND_ASSET_RECEIVING_ADDRESS',
                style: TextStyle(fontSize: 24),
              ).tr(args: ['${_swapSendAsset}']),
              Text(_address),
              Visibility(
                visible: _swapRecvWallet == SwapWallet.extern,
                child: Column(
                  children: [
                    Text(
                      'SWAP_RECV_ASSET_YOUR_ADDRESS',
                      style: TextStyle(fontSize: 24),
                    ).tr(args: ['${_swapRecvAsset}']),
                    Text(_swapRecvAddressExternal),
                  ],
                ),
              ),
              Spacer(),
              Text('SWAP_SEND_AMOUNT').tr(
                args: ['$_sendAmount', '${_swapSendAsset}'],
              ),
              Text('SWAP_RECV_AMOUNT').tr(
                args: ['$_recvAmount', '${_swapRecvAsset}'],
              ),
              Spacer(),
              ShareAddress(addr: _address),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
