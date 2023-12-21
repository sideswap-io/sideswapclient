import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/friends_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
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

  final _labelStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: SideSwapColors.brightTurquoise,
  );

  final _approximateStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: SideSwapColors.airSuperiorityBlue,
  );

  AccountAsset getSelectedAssetId() {
    final result = ref.read(paymentProvider).paymentAmountPageArguments.result;
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);

    // use regular wallet lbtc if assetid is lbtc or is empty
    if (result?.assetId == null || result?.assetId == liquidAssetId) {
      return AccountAsset(AccountType.reg, liquidAssetId);
    }

    // let's check other assets and return it if found and balance is > 0
    final balances = ref.read(balancesNotifierProvider);
    for (var account in balances.keys) {
      if (account.assetId == result?.assetId && balances[account] != 0) {
        return account;
      }
    }

    // otherwise use regular wallet with given assetId
    return AccountAsset(AccountType.reg, result?.assetId);
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
    final assetPrecision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: accountAsset.assetId);
    final amountAsAsset = toFloat(amountInSat, precision: assetPrecision);
    amount =
        amountAsAsset == 0 ? "" : amountAsAsset.toStringAsFixed(assetPrecision);

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

    Future.microtask(() => ref.read(paymentProvider).insufficientFunds = false);

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
      Future.microtask(() {
        ref.read(paymentProvider).insufficientFunds = false;
      });
      setState(() {
        enabled = false;
        amount = '0';
      });
      return;
    }

    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: accountAsset.assetId);
    final balance = ref.read(balancesNotifierProvider)[accountAsset];
    final newValue = value.replaceAll(' ', '');
    final newAmount = double.tryParse(newValue)?.toDouble();
    final amountStr = ref.read(amountToStringProvider).amountToString(
        AmountToStringParameters(amount: balance ?? 0, precision: precision));
    final realBalance = double.tryParse(amountStr);

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
      Future.microtask(() {
        ref.read(paymentProvider).insufficientFunds = false;
      });
      return;
    }

    setState(() {
      enabled = false;
    });
    Future.microtask(() {
      ref.read(paymentProvider).insufficientFunds = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(balancesNotifierProvider, ((previous, next) {
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
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
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
                      // TODO: need fix - set as new widget
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
    final amountProvider = ref.watch(amountToStringProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                padding: const EdgeInsets.only(top: 24),
                child: Consumer(
                  builder: (context, watch, _) {
                    final showError = ref.watch(
                        paymentProvider.select((p) => p.insufficientFunds));
                    final newAmount = double.tryParse(amount) ?? 0;
                    final usdAmount = ref.watch(
                        amountUsdProvider(accountAsset.assetId, newAmount));
                    dollarConversion = usdAmount.toStringAsFixed(2);
                    final visibleConversion = ref
                        .watch(walletProvider)
                        .isAmountUsdAvailable(accountAsset.assetId);
                    dollarConversion = replaceCharacterOnPosition(
                        input: dollarConversion, currencyChar: '\$');
                    final isAmp = accountAsset.account.isAmp;
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
                                const SizedBox(width: 4, height: 24),
                                if (isAmp) const AmpFlag()
                              ],
                            ),
                            if (showError) ...[
                              Text(
                                'Insufficient funds'.tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: SideSwapColors.bitterSweet,
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
                padding: const EdgeInsets.only(top: 10),
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
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        final balance =
                            ref.watch(balancesNotifierProvider)[accountAsset] ??
                                0;
                        final precision = ref
                            .watch(assetUtilsProvider)
                            .getPrecisionForAssetId(
                                assetId: accountAsset.assetId);
                        final balanceStr = amountProvider.amountToString(
                            AmountToStringParameters(
                                amount: balance, precision: precision));
                        return Text(
                          'Balance: {}',
                          style: _approximateStyle,
                        ).tr(args: [balanceStr]);
                      },
                    ),
                    Container(
                      width: 54,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: SideSwapColors.brightTurquoise,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            final precision = ref
                                .read(assetUtilsProvider)
                                .getPrecisionForAssetId(
                                    assetId: accountAsset.assetId);
                            final balance = ref.read(
                                    balancesNotifierProvider)[accountAsset] ??
                                0;
                            final text = amountProvider.amountToString(
                                AmountToStringParameters(
                                    amount: balance, precision: precision));

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
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          'MAX',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: SideSwapColors.brightTurquoise,
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
              const EdgeInsets.only(top: 36, bottom: 24, left: 16, right: 16),
          child: Consumer(builder: (context, ref, _) {
            final buttonEnabled = enabled &&
                !ref.watch(walletProvider.select((p) => p.isCreatingTx));
            return CustomBigButton(
              width: double.infinity,
              height: 54,
              backgroundColor: SideSwapColors.brightTurquoise,
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
