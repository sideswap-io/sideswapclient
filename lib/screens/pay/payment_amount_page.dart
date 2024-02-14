import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

part 'payment_amount_page.g.dart';

@riverpod
class PaymentPageSelectedAccountAssetNotifier
    extends _$PaymentPageSelectedAccountAssetNotifier {
  @override
  AccountAsset build() {
    final result = ref.watch(paymentAmountPageArgumentsNotifierProvider).result;
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    // use regular wallet lbtc if assetid is lbtc or is empty
    if (result?.assetId == null || result?.assetId == liquidAssetId) {
      return AccountAsset(AccountType.reg, liquidAssetId);
    }

    // let's check other assets and return it if found and balance is > 0
    final balances = ref.watch(balancesNotifierProvider);
    for (var account in balances.keys) {
      if (account.assetId == result?.assetId && balances[account] != 0) {
        return account;
      }
    }

    // otherwise use regular wallet with given assetId
    return AccountAsset(AccountType.reg, result?.assetId);
  }

  void setSelectedAccountAsset(AccountAsset value) {
    state = value;
  }
}

class PaymentAmountPageArguments {
  PaymentAmountPageArguments({
    this.result,
    this.friend,
  });

  QrCodeResult? result;
  Friend? friend;
}

class PaymentAmountPage extends ConsumerWidget {
  const PaymentAmountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    child: const IntrinsicHeight(
                      child: PaymentAmountPageBody(),
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
}

class PaymentAmountPageBody extends HookConsumerWidget {
  const PaymentAmountPageBody({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountProvider = ref.watch(amountToStringProvider);

    const labelStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.brightTurquoise,
    );

    const approximateStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: SideSwapColors.airSuperiorityBlue,
    );

    final amount = useState('0');
    final tickerAmountController = useTextEditingController();
    final tickerAmountFocusNode = useFocusNode();
    final enabled = useState(false);
    final friend = useState<Friend?>(null);
    final isMaxPressed = useState(false);
    final availableAssets = ref.watch(walletProvider).sendAssetsWithBalance();
    final accountAsset =
        ref.watch(paymentPageSelectedAccountAssetNotifierProvider);

    Future<void> validate(String value) async {
      final accountAsset =
          ref.read(paymentPageSelectedAccountAssetNotifierProvider);

      if (value.isEmpty) {
        ref
            .read(paymentInsufficientFundsNotifierProvider.notifier)
            .setInsufficientFunds(false);
        enabled.value = false;
        amount.value = '0';
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
        enabled.value = false;
        amount.value = '0';
        return;
      }

      amount.value = newValue;

      if (newAmount <= 0) {
        enabled.value = false;
        return;
      }

      if (newAmount <= realBalance) {
        enabled.value = true;

        ref
            .read(paymentInsufficientFundsNotifierProvider.notifier)
            .setInsufficientFunds(false);
        return;
      }

      enabled.value = false;

      ref
          .read(paymentInsufficientFundsNotifierProvider.notifier)
          .setInsufficientFunds(true);
    }

    final balances = ref.watch(balancesNotifierProvider);

    useEffect(() {
      if (tickerAmountController.text.isNotEmpty) {
        validate(tickerAmountController.text);
      }

      return;
    }, [balances]);

    // one time run
    useEffect(() {
      // Asset amount always has precision 8, see here for details:
      // https://github.com/btcpayserver/btcpayserver/pull/1402
      // https://github.com/Blockstream/green_android/issues/86
      final amountAsBtc =
          ref.read(paymentAmountPageArgumentsNotifierProvider).result?.amount ??
              .0;
      final amountInSat = toIntAmount(amountAsBtc);
      final assetPrecision = ref
          .read(assetUtilsProvider)
          .getPrecisionForAssetId(assetId: accountAsset.assetId);
      final amountAsAsset = toFloat(amountInSat, precision: assetPrecision);
      amount.value = amountAsAsset == 0
          ? ""
          : amountAsAsset.toStringAsFixed(assetPrecision);

      if (!availableAssets.contains(accountAsset)) {
        availableAssets.add(accountAsset);
      }
      availableAssets.sort();

      if (amount.value != '0') {
        tickerAmountController.text = amount.value;
      }

      Future.microtask(() => ref
          .read(paymentInsufficientFundsNotifierProvider.notifier)
          .setInsufficientFunds(false));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(tickerAmountFocusNode);
      });

      return;
    }, const []);

    useEffect(() {
      tickerAmountController.addListener(() async {
        await validate(tickerAmountController.text);
      });

      return;
    }, [tickerAmountController]);

    useEffect(() {
      if (!availableAssets.contains(accountAsset)) {
        availableAssets.add(accountAsset);
      }
      availableAssets.sort();

      return;
    }, [accountAsset, availableAssets]);

    useEffect(() {
      isMaxPressed.value = false;

      return;
    }, [accountAsset]);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, watch, _) {
                  final paymentAmountPageArguments =
                      ref.watch(paymentAmountPageArgumentsNotifierProvider);
                  final friend = paymentAmountPageArguments.friend;
                  final address = paymentAmountPageArguments.result?.address;

                  return PaymentAmountReceiverField(
                    text: address ?? '',
                    labelStyle: labelStyle,
                    friend: friend,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Consumer(
                  builder: (context, watch, _) {
                    final showError =
                        ref.watch(paymentInsufficientFundsNotifierProvider);
                    final newAmount = double.tryParse(amount.value) ?? 0;
                    final usdAmount = ref.watch(
                        amountUsdProvider(accountAsset.assetId, newAmount));
                    var dollarConversion = usdAmount.toStringAsFixed(2);
                    final visibleConversion = ref
                        .watch(walletProvider)
                        .isAmountUsdAvailable(accountAsset.assetId);
                    dollarConversion = replaceCharacterOnPosition(
                        input: dollarConversion, currencyChar: '\$');
                    final isAmp = accountAsset.account.isAmp;
                    return Column(
                      children: [
                        ...switch (showError) {
                          true => [
                              Row(
                                children: [
                                  ...switch (visibleConversion) {
                                    true => [
                                        Text(
                                          '≈ $dollarConversion',
                                          style: approximateStyle,
                                        ),
                                      ],
                                    _ => [const SizedBox()],
                                  },
                                ],
                              )
                            ],
                          _ => [const SizedBox()],
                        },
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Send'.tr(),
                                  style: labelStyle,
                                ),
                                const SizedBox(width: 4, height: 24),
                                if (isAmp) const AmpFlag()
                              ],
                            ),
                            ...switch (showError) {
                              true => [
                                  Text(
                                    'Insufficient funds'.tr(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: SideSwapColors.bitterSweet,
                                    ),
                                  ),
                                ],
                              _ => [
                                  switch (visibleConversion) {
                                    true => Text(
                                        '≈ $dollarConversion',
                                        style: approximateStyle,
                                      ),
                                    _ => const SizedBox(),
                                  }
                                ],
                            },
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
                  validate: (value) async => await validate(value),
                  onChanged: (value) {
                    isMaxPressed.value = false;
                  },
                  onDropdownChanged: (value) {
                    ref
                        .read(paymentPageSelectedAccountAssetNotifierProvider
                            .notifier)
                        .setSelectedAccountAsset(value);
                    tickerAmountController.text = '';
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
                        return const Text(
                          'Balance: {}',
                          style: approximateStyle,
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

                          tickerAmountController.value =
                              tickerAmountController.value.copyWith(
                            text: text,
                            selection: TextSelection(
                                baseOffset: text.length,
                                extentOffset: text.length),
                            composing: TextRange.empty,
                          );

                          isMaxPressed.value = true;
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
            final buttonEnabled = enabled.value &&
                !ref.watch(walletProvider.select((p) => p.isCreatingTx));
            return CustomBigButton(
              width: double.infinity,
              height: 54,
              backgroundColor: SideSwapColors.brightTurquoise,
              text: 'CONTINUE'.tr(),
              enabled: buttonEnabled,
              onPressed: buttonEnabled
                  ? () {
                      final paymentAmountPageArguments =
                          ref.read(paymentAmountPageArgumentsNotifierProvider);
                      ref.read(paymentHelperProvider).selectPaymentSend(
                            amount.value,
                            accountAsset,
                            address: paymentAmountPageArguments.result?.address,
                            friend: friend.value,
                            isGreedy: isMaxPressed.value,
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
