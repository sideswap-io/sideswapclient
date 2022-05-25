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

class PaymentAmountPage extends ConsumerStatefulWidget {
  const PaymentAmountPage({super.key});

  @override
  PaymentAmountPageState createState() => PaymentAmountPageState();
}

class PaymentAmountPageState extends ConsumerState<PaymentAmountPage> {
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
    final payAssetId =
        ref.read(paymentProvider).paymentAmountPageArguments.result?.assetId;
    if (payAssetId != null) {
      for (var account in ref.read(balancesProvider).balances.keys) {
        if (account.asset == payAssetId) {
          return account;
        }
      }
      return AccountAsset(AccountType.regular, payAssetId);
    }
    final account = ref.read(walletProvider).selectedWalletAsset;
    if (account != null) {
      return account;
    }
    return AccountAsset(
        AccountType.regular, ref.read(walletProvider).liquidAssetId());
  }

  @override
  void initState() {
    super.initState();

    dollarConversion = '0.0';

    accountAsset = getSelectedAssetId();

    // Asset amount always has precision 8, see here for details:
    // https://github.com/btcpayserver/btcpayserver/pull/1402
    // https://github.com/Blockstream/green_android/issues/86
    final amountAsBtc =
        ref.read(paymentProvider).paymentAmountPageArguments.result?.amount ??
            0.0;
    final amountInSat = toIntAmount(amountAsBtc);
    final assetPrecison =
        ref.read(walletProvider).assets[accountAsset.asset]?.precision ?? 8;
    final amountAsAsset = toFloat(amountInSat, precision: assetPrecison);
    amount = amountAsAsset.toStringAsFixed(assetPrecison);

    availableAssets = ref.read(walletProvider).sendAssetsWithBalance();
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

    ref.read(paymentProvider).insufficientFunds = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      ref.read(paymentProvider).insufficientFunds = false;
      setState(() {
        enabled = false;
        amount = '0';
      });
      return;
    }

    final precision = ref
        .read(walletProvider)
        .getPrecisionForAssetId(assetId: accountAsset.asset);
    final balance = ref.read(balancesProvider).balances[accountAsset];
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
      ref.read(paymentProvider).insufficientFunds = false;
      return;
    }

    setState(() {
      enabled = false;
    });
    ref.read(paymentProvider).insufficientFunds = true;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BalancesNotifier>(balancesProvider, ((previous, next) {
      // validate every time when balancesProvider will change
      if (tickerAmountController != null &&
          tickerAmountController!.text.isNotEmpty) {
        validate(tickerAmountController?.text ?? '');
      }
    }));
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Pay'.tr(),
        showTrailingButton: true,
        onTrailingButtonPressed: () {
          ref.read(walletProvider).setRegistered();
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
                builder: (context, watch, _) {
                  final friend = ref.watch(paymentProvider
                      .select((p) => p.paymentAmountPageArguments.friend));
                  final address = ref.watch(paymentProvider.select(
                      (p) => p.paymentAmountPageArguments.result?.address));
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
                  builder: (context, watch, _) {
                    final showError = ref.watch(
                        paymentProvider.select((p) => p.insufficientFunds));
                    final newAmount = double.tryParse(amount) ?? 0;
                    final newAssetId = ref
                        .watch(walletProvider)
                        .getAssetById(accountAsset.asset)
                        ?.assetId;
                    final usdAmount = ref
                        .watch(walletProvider)
                        .getAmountUsd(newAssetId, newAmount);
                    dollarConversion = usdAmount.toStringAsFixed(2);
                    final visibleConversion = ref
                        .watch(walletProvider)
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
                    Consumer(
                      builder: (context, ref, _) {
                        final balance = ref.watch(balancesProvider
                            .select((p) => p.balances[accountAsset] ?? 0));
                        final precision = ref
                            .watch(walletProvider)
                            .getPrecisionForAssetId(
                                assetId: accountAsset.asset);
                        return Text(
                          'Balance: {}',
                          style: _approximateStyle,
                        ).tr(
                            args: [(amountStr(balance, precision: precision))]);
                      },
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
                            final precision = ref
                                .read(walletProvider)
                                .getPrecisionForAssetId(
                                    assetId: accountAsset.asset);
                            final text = amountStr(
                                ref
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
          child: Consumer(builder: (context, ref, _) {
            final buttonEnabled = enabled &&
                !ref.watch(walletProvider.select((p) => p.isCreatingTx));
            return CustomBigButton(
              width: double.infinity,
              height: 54.h,
              backgroundColor: const Color(0xFF00C5FF),
              text: 'CONTINUE'.tr(),
              enabled: buttonEnabled,
              onPressed: buttonEnabled
                  ? () {
                      ref.read(paymentProvider).selectPaymentSend(
                            amount.toString(),
                            accountAsset,
                            address: ref
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
