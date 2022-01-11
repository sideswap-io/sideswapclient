import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/pay/widgets/payment_amount_receiver_field.dart';
import 'package:sideswap/screens/pay/widgets/payment_send_amount.dart';

class PaymentAmountPageArguments {
  PaymentAmountPageArguments({
    this.result,
    this.friend,
  });

  QrCodeResult? result;
  Friend? friend;
}

class PaymentAmountPage extends StatefulWidget {
  const PaymentAmountPage({Key? key}) : super(key: key);

  @override
  _PaymentAmountPageState createState() => _PaymentAmountPageState();
}

class _PaymentAmountPageState extends State<PaymentAmountPage> {
  String dollarConversion = '';
  late AccountAsset accountAsset;
  late List<AccountAsset> availableAssets;
  bool enabled = false;
  String amount = '0';
  TextEditingController? tickerAmountController;
  late FocusNode tickerAmountFocusNode;
  Friend? friend;

  final _labelStyle = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF00C5FF),
  );

  final _approximateStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF709EBA),
  );

  AccountAsset getSelectedAssetId() {
    final wallet = context.read(walletProvider);
    final payAssetId = context
        .read(paymentProvider)
        .paymentAmountPageArguments
        .result
        ?.assetId;
    if (payAssetId != null) {
      for (var account in context.read(balancesProvider).balances.keys) {
        if (account.asset == payAssetId) {
          return account;
        }
      }
      return AccountAsset(AccountType.regular, payAssetId);
    }
    final account = wallet.selectedWalletAsset;
    if (account != null) {
      return account;
    }
    return AccountAsset(AccountType.regular, wallet.liquidAssetId());
  }

  @override
  void initState() {
    super.initState();

    dollarConversion = '0.0';
    amount = context
            .read(paymentProvider)
            .paymentAmountPageArguments
            .result
            ?.amount
            ?.toStringAsFixed(8) ??
        '0';
    accountAsset = getSelectedAssetId();
    availableAssets = context.read(walletProvider).sendAssetsWithBalance();
    if (!availableAssets.contains(accountAsset)) {
      availableAssets.add(accountAsset);
    }
    availableAssets.sort();

    enabled = false;
    tickerAmountController = TextEditingController()
      ..addListener(() {
        validate(tickerAmountController?.text ?? '');
      });

    if (amount != '0') {
      tickerAmountController?.text = amount;
    }

    tickerAmountFocusNode = FocusNode();

    context.read(paymentProvider).insufficientFunds = false;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(tickerAmountFocusNode);
    });
  }

  @override
  void dispose() {
    tickerAmountFocusNode.dispose();
    tickerAmountController?.dispose();
    super.dispose();
  }

  void validate(String value) {
    if (value.isEmpty) {
      context.read(paymentProvider).insufficientFunds = false;
      setState(() {
        enabled = false;
        amount = '0';
      });
      return;
    }

    final precision = context
        .read(walletProvider)
        .getPrecisionForAssetId(assetId: accountAsset.asset);
    final balance = context.read(balancesProvider).balances[accountAsset];
    final newValue = value.replaceAll(' ', '');
    final newAmount = double.tryParse(newValue)?.toDouble();
    final realBalance = double.tryParse(
      amountStr(balance ?? 0, precision: precision),
    );
    if (newAmount == null || realBalance == null) {
      setState(() {
        enabled = false;
        amount = '0';
      });
      return;
    }

    setState(() {
      amount = newValue;
    });

    if (newAmount <= 0) {
      setState(() {
        enabled = false;
      });
      return;
    }

    if (newAmount <= realBalance) {
      setState(() {
        enabled = true;
      });
      context.read(paymentProvider).insufficientFunds = false;
      return;
    }

    setState(() {
      enabled = false;
    });
    context.read(paymentProvider).insufficientFunds = true;
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Pay'.tr(),
        showTrailingButton: true,
        onTrailingButtonPressed: () {
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
                  final friend =
                      watch(paymentProvider).paymentAmountPageArguments.friend;
                  final address = watch(paymentProvider)
                      .paymentAmountPageArguments
                      .result
                      ?.address;
                  return PaymentAmountReceiverField(
                    text: address ?? '',
                    labelStyle: _labelStyle,
                    friend: friend,
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.h),
                child: Consumer(
                  builder: (context, watch, child) {
                    final showError = watch(paymentProvider).insufficientFunds;
                    final newAmount = double.tryParse(amount) ?? 0;
                    final newAssetId = watch(walletProvider)
                        .getAssetById(accountAsset.asset)
                        ?.assetId;
                    final usdAmount = watch(walletProvider)
                        .getAmountUsd(newAssetId, newAmount);
                    dollarConversion = usdAmount.toStringAsFixed(2);
                    final visibleConversion = context
                        .read(walletProvider)
                        .isAmountUsdAvailable(newAssetId);
                    dollarConversion = replaceCharacterOnPosition(
                        input: dollarConversion, currencyChar: '\$');
                    final isAmp = accountAsset.account.isAmp();
                    return Column(
                      children: [
                        if (showError) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: visibleConversion,
                                child: Text(
                                  '≈ $dollarConversion',
                                  style: _approximateStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Send'.tr(),
                                  style: _labelStyle,
                                ),
                                SizedBox(
                                  width: 4.w,
                                  height: 24.h,
                                ),
                                if (isAmp) const AmpFlag()
                              ],
                            ),
                            if (showError) ...[
                              Text(
                                'Insufficient funds'.tr(),
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFFFF7878),
                                ),
                              ),
                            ] else ...[
                              Visibility(
                                visible: visibleConversion,
                                child: Text(
                                  '≈ $dollarConversion',
                                  style: _approximateStyle,
                                ),
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
                  availableDropdownAssets: availableAssets,
                  controller: tickerAmountController,
                  dropdownValue: accountAsset,
                  focusNode: tickerAmountFocusNode,
                  validate: (value) => validate(value),
                  onDropdownChanged: (value) {
                    setState(() {
                      accountAsset = value;
                      tickerAmountController?.text = '';
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 14.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProviderListener<BalancesNotifier>(
                      provider: balancesProvider,
                      onChange: (context, state) {
                        if (tickerAmountController != null &&
                            tickerAmountController!.text.isNotEmpty) {
                          validate(tickerAmountController?.text ?? '');
                        }
                      },
                      child: Consumer(
                        builder: (context, watch, child) {
                          final balance =
                              watch(balancesProvider).balances[accountAsset] ??
                                  0;
                          final precision = context
                              .read(walletProvider)
                              .getPrecisionForAssetId(
                                  assetId: accountAsset.asset);
                          return Text(
                            'PAYMENT_BALANCE',
                            style: _approximateStyle,
                          ).tr(args: [
                            (amountStr(balance, precision: precision))
                          ]);
                        },
                      ),
                    ),
                    Container(
                      width: 54.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        border: Border.all(
                          color: const Color(0xFF00C5FF),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            final precision = context
                                .read(walletProvider)
                                .getPrecisionForAssetId(
                                    assetId: accountAsset.asset);
                            final text = amountStr(
                                context
                                        .read(balancesProvider)
                                        .balances[accountAsset] ??
                                    0,
                                precision: precision);
                            if (tickerAmountController?.value != null) {
                              tickerAmountController!.value =
                                  tickerAmountController!.value.copyWith(
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
                            color: const Color(0xFF00C5FF),
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
        const Spacer(),
        Padding(
          padding:
              EdgeInsets.only(top: 36.h, bottom: 24.h, left: 16.w, right: 16.w),
          child: Consumer(builder: (context, watch, child) {
            final buttonEnabled =
                enabled && !watch(walletProvider).isCreatingTx;
            return CustomBigButton(
              width: double.infinity,
              height: 54.h,
              backgroundColor: const Color(0xFF00C5FF),
              text: 'CONTINUE'.tr(),
              enabled: buttonEnabled,
              onPressed: buttonEnabled
                  ? () {
                      context.read(paymentProvider).selectPaymentSend(
                            amount.toString(),
                            accountAsset,
                            address: context
                                .read(paymentProvider)
                                .paymentAmountPageArguments
                                .result
                                ?.address,
                            friend: friend,
                          );
                    }
                  : null,
            );
          }),
        ),
      ],
    );
  }
}
