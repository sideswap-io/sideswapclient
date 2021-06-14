import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/widgets/payment_amount_receiver_field.dart';
import 'package:sideswap/screens/pay/widgets/payment_send_amount.dart';

class PaymentAmountPageArguments {
  PaymentAmountPageArguments({
    this.result,
  });

  QrCodeResult? result;
}

class PaymentAmountPage extends StatefulWidget {
  PaymentAmountPage({Key? key}) : super(key: key);

  @override
  _PaymentAmountPageState createState() => _PaymentAmountPageState();
}

class _PaymentAmountPageState extends State<PaymentAmountPage> {
  String _dollarConversion = '';
  String _assetId = '';
  bool _enabled = false;
  String _amount = '0';
  TextEditingController? _tickerAmountController;
  FocusNode _tickerAmountFocusNode = FocusNode();

  final _labelStyle = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: Color(0xFF00C5FF),
  );

  final _approximateStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Color(0xFF709EBA),
  );

  String getSelectedAssetId() {
    final wallet = context.read(walletProvider);
    final assetId = wallet.selectedWalletAsset;
    if (assetId.isNotEmpty) {
      return assetId;
    }
    final balances = wallet.balances;
    if (balances[wallet.liquidAssetId()] != 0) {
      return wallet.liquidAssetId() ?? '';
    }

    try {
      final nonZeroAsset =
          balances.entries.firstWhere((item) => item.value > 0);
      return nonZeroAsset.key;
    } on StateError {
      return wallet.liquidAssetId() ?? '';
    }
  }

  @override
  void initState() {
    super.initState();
    _dollarConversion = '0.0';
    _amount = context
            .read(paymentProvider)
            .paymentAmountPageArguments
            .result
            ?.amount
            ?.toStringAsFixed(8) ??
        '0';
    _assetId = context
            .read(walletProvider)
            .assets[context
                .read(paymentProvider)
                .paymentAmountPageArguments
                .result
                ?.assetId]
            ?.assetId ??
        getSelectedAssetId();
    _enabled = false;
    _tickerAmountController = TextEditingController()
      ..addListener(() {
        validate(_tickerAmountController?.text ?? '');
      });

    if (_amount != '0') {
      _tickerAmountController?.text = _amount;
    }

    _tickerAmountFocusNode = FocusNode();

    context.read(paymentProvider).insufficientFunds = false;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_tickerAmountFocusNode);
    });
  }

  @override
  void dispose() {
    _tickerAmountController?.dispose();
    super.dispose();
  }

  void validate(String value) {
    if (value.isEmpty) {
      context.read(paymentProvider).insufficientFunds = false;
      setState(() {
        _enabled = false;
        _amount = '0';
      });
      return;
    }

    final precision =
        context.read(walletProvider).getPrecisionForAssetId(assetId: _assetId);
    final balance = context.read(walletProvider).balances[_assetId];
    final newValue = value.replaceAll(' ', '');
    final amount = double.tryParse(newValue)?.toDouble();
    final realBalance = double.tryParse(
      amountStr(balance ?? 0, precision: precision),
    );
    if (amount == null || realBalance == null) {
      setState(() {
        _enabled = false;
        _amount = '0';
      });
      return;
    }

    setState(() {
      _amount = newValue;
    });

    if (amount <= 0) {
      setState(() {
        _enabled = false;
      });
      return;
    }

    if (amount <= realBalance) {
      setState(() {
        _enabled = true;
      });
      context.read(paymentProvider).insufficientFunds = false;
      return;
    }

    setState(() {
      _enabled = false;
    });
    context.read(paymentProvider).insufficientFunds = true;
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Pay'.tr(),
        rightCloseButton: true,
        onRightCloseButtonPressed: () {
          context.read(walletProvider).setRegistered();
        },
      ),
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: buildBody(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, watch, child) {
                  final address = watch(paymentProvider)
                      .paymentAmountPageArguments
                      .result
                      ?.address;
                  return PaymentAmountReceiverField(
                    text: address ?? '',
                    labelStyle: _labelStyle,
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: Consumer(
                  builder: (context, watch, child) {
                    final showError = watch(paymentProvider).insufficientFunds;
                    final amount = double.tryParse(_amount) ?? 0;
                    final assetId =
                        watch(walletProvider).getAssetById(_assetId)?.assetId;
                    _dollarConversion = watch(walletProvider)
                        .getAmountUsd(assetId, amount)
                        .toStringAsFixed(2);
                    _dollarConversion = replaceCharacterOnPosition(
                        input: _dollarConversion, currencyChar: '\$');
                    return Column(
                      children: [
                        if (showError) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '≈ $_dollarConversion',
                                style: _approximateStyle,
                              ),
                            ],
                          ),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Send',
                              style: _labelStyle,
                            ),
                            if (showError) ...[
                              Text(
                                'Insufficient funds'.tr(),
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFFF7878),
                                ),
                              ),
                            ] else ...[
                              Text(
                                '≈ $_dollarConversion',
                                style: _approximateStyle,
                              ),
                            ],
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: PaymentSendAmount(
                  controller: _tickerAmountController,
                  dropdownValue: _assetId,
                  focusNode: _tickerAmountFocusNode,
                  validate: (value) => validate(value),
                  onDropdownChanged: (value) {
                    setState(() {
                      _assetId = value;
                      _tickerAmountController?.text = '';
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 14.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(
                      builder: (context, watch, child) {
                        final balance =
                            watch(walletProvider).balances[_assetId];
                        final precision = context
                            .read(walletProvider)
                            .getPrecisionForAssetId(assetId: _assetId);
                        return Text(
                          'PAYMENT_BALANCE',
                          style: _approximateStyle,
                        ).tr(args: [
                          '${amountStr(balance ?? 0, precision: precision)}'
                        ]);
                      },
                    ),
                    Container(
                      width: 54.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        border: Border.all(
                          color: Color(0xFF00C5FF),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            final precision = context
                                .read(walletProvider)
                                .getPrecisionForAssetId(assetId: _assetId);
                            final text = amountStr(
                                context
                                        .read(walletProvider)
                                        .balances[_assetId] ??
                                    0,
                                precision: precision);
                            if (_tickerAmountController?.value != null) {
                              _tickerAmountController!.value =
                                  _tickerAmountController!.value.copyWith(
                                text: text,
                                selection: TextSelection(
                                    baseOffset: text.length,
                                    extentOffset: text.length),
                                composing: TextRange.empty,
                              );
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.w),
                            ),
                          ),
                        ),
                        child: Text(
                          'MAX',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF00C5FF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding:
              EdgeInsets.only(top: 36.h, bottom: 24.h, left: 16.w, right: 16.w),
          child: CustomBigButton(
            width: double.infinity,
            height: 54.h,
            backgroundColor: Color(0xFF00C5FF),
            text: 'CONTINUE'.tr(),
            enabled: _enabled,
            onPressed: _enabled
                ? () {
                    context.read(paymentProvider).selectPaymentSend(
                          context
                              .read(paymentProvider)
                              .paymentAmountPageArguments
                              .result
                              ?.address,
                          _amount.toString(),
                          _assetId,
                        );
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
