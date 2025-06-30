import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/payment_amount_page_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/pay/widgets/payment_amount_receiver_field.dart';
import 'package:sideswap/screens/pay/widgets/payment_send_amount.dart';

class PaymentAmountPageArguments {
  PaymentAmountPageArguments({this.result});

  QrCodeResult? result;
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
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
        },
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
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

    ref.listen(createTxStateNotifierProvider, (_, next) {
      (switch (next) {
        CreateTxStateCreated() => Future.microtask(() {
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.paymentSend);
        }),
        CreateTxStateError(errorMsg: final errorMsg) => () {
          if (errorMsg != null) {
            Future.microtask(() async {
              await ref.read(utilsProvider).showErrorDialog(errorMsg);
            });
          }
          return null;
        }(),
        _ => () {}(),
      });
    });

    final amount = useState('0');
    final tickerAmountController = useTextEditingController();
    final tickerAmountFocusNode = useFocusNode();
    final enabled = useState(false);
    final isMaxPressed = useState(false);
    final availableAssets = ref.watch(allVisibleAssetsProvider).toList();

    // TODO (malcolmpl): move validate function to paymentPageRepository
    final paymentPageRepository = ref.watch(paymentPageRepositoryProvider);
    final optionAsset = ref.watch(paymentPageSelectedAssetProvider);

    Future<void> validate(String value) async {
      final optionAsset = ref.read(paymentPageSelectedAssetProvider);
      await optionAsset.match(() {}, (asset) async {
        if (value.isEmpty) {
          await Future.microtask(
            () => ref
                .read(paymentInsufficientFundsNotifierProvider.notifier)
                .setInsufficientFunds(false),
          );
          enabled.value = false;
          amount.value = '0';
          return;
        }

        final newValue = value.replaceAll(' ', '');
        final newAmount = double.tryParse(newValue)?.toDouble();
        final realBalance = ref.read(assetBalanceDoubleProvider(asset));

        if (newAmount == null) {
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

          await Future.microtask(
            () => ref
                .read(paymentInsufficientFundsNotifierProvider.notifier)
                .setInsufficientFunds(false),
          );
          return;
        }

        enabled.value = false;

        await Future.microtask(
          () => ref
              .read(paymentInsufficientFundsNotifierProvider.notifier)
              .setInsufficientFunds(true),
        );
      });
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
      final optionAsset = ref.read(paymentPageSelectedAssetProvider);
      // Asset amount always has precision 8, see here for details:
      // https://github.com/btcpayserver/btcpayserver/pull/1402
      // https://github.com/Blockstream/green_android/issues/86
      optionAsset.match(() {}, (asset) {
        final amountAsBtc =
            ref
                .read(paymentAmountPageArgumentsNotifierProvider)
                .result
                ?.amount ??
            .0;
        final amountInSat = toIntAmount(amountAsBtc);
        final amountAsAsset = toFloat(amountInSat, precision: asset.precision);
        amount.value = amountAsAsset == 0
            ? ""
            : amountAsAsset.toStringAsFixed(asset.precision);

        if (!availableAssets.contains(asset)) {
          availableAssets.add(asset);
        }

        if (amount.value != '0') {
          tickerAmountController.text = amount.value;
        }
      });

      Future.microtask(
        () => ref
            .read(paymentInsufficientFundsNotifierProvider.notifier)
            .setInsufficientFunds(false),
      );

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
      optionAsset.match(() {}, (asset) {
        if (!availableAssets.contains(asset)) {
          availableAssets.add(asset);
        }
      });

      return;
    }, [availableAssets, optionAsset]);

    useEffect(() {
      isMaxPressed.value = false;

      return;
    }, [optionAsset]);

    final createTxState = ref.watch(createTxStateNotifierProvider);

    useEffect(() {
      if (createTxState == const CreateTxStateCreating()) {
        enabled.value = false;
        return;
      }

      enabled.value = true;

      return;
    }, [createTxState]);

    return optionAsset.match(
      () => const SizedBox(),
      (asset) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, watch, _) {
                    final paymentAmountPageArguments = ref.watch(
                      paymentAmountPageArgumentsNotifierProvider,
                    );
                    final address = paymentAmountPageArguments.result?.address;

                    return PaymentAmountReceiverField(
                      text: address ?? '',
                      labelStyle: labelStyle,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Consumer(
                    builder: (context, watch, _) {
                      final showError = ref.watch(
                        paymentInsufficientFundsNotifierProvider,
                      );
                      final newAmount = double.tryParse(amount.value) ?? 0;
                      final defaultCurrencyAmount = ref.watch(
                        amountUsdInDefaultCurrencyProvider(
                          asset.assetId,
                          newAmount,
                        ),
                      );
                      final defaultCurrencyTicker = ref.watch(
                        defaultCurrencyTickerProvider,
                      );
                      var defaultCurrencyConversion = defaultCurrencyAmount
                          .toStringAsFixed(2);
                      final visibleConversion = ref.watch(
                        isAmountUsdAvailableProvider(asset.assetId),
                      );
                      defaultCurrencyConversion = replaceCharacterOnPosition(
                        input: defaultCurrencyConversion,
                        currencyChar: defaultCurrencyTicker,
                      );

                      return Column(
                        children: [
                          ...switch (showError) {
                            true => [
                              Row(
                                children: [
                                  ...switch (visibleConversion) {
                                    true => [
                                      Text(
                                        '≈ $defaultCurrencyConversion',
                                        style: approximateStyle,
                                      ),
                                    ],
                                    _ => [const SizedBox()],
                                  },
                                ],
                              ),
                            ],
                            _ => [const SizedBox()],
                          },
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Send'.tr(), style: labelStyle),
                                  const SizedBox(width: 4, height: 24),
                                  if (asset.ampMarket) const AmpFlag(),
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
                                      '≈ $defaultCurrencyConversion',
                                      style: approximateStyle,
                                    ),
                                    _ => const SizedBox(),
                                  },
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
                    availableDropdownAssets: availableAssets
                        .map((e) => e.assetId)
                        .toList(),
                    controller: tickerAmountController,
                    dropdownValue: asset.assetId,
                    focusNode: tickerAmountFocusNode,
                    validate: (value) async => await validate(value),
                    onChanged: (value) {
                      isMaxPressed.value = false;
                    },
                    onDropdownChanged: (value) {
                      ref
                          .read(
                            paymentPageSelectedAssetIdNotifierProvider.notifier,
                          )
                          .setState(value);
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
                          final assetBalanceString = ref.watch(
                            assetBalanceStringProvider(asset),
                          );

                          return Text(
                            'Balance: {}'.tr(args: [assetBalanceString]),
                            style: approximateStyle,
                          );
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
                            final assetBalanceString = ref.read(
                              assetBalanceStringProvider(asset),
                            );

                            tickerAmountController.value =
                                tickerAmountController.value.copyWith(
                                  text: assetBalanceString,
                                  selection: TextSelection(
                                    baseOffset: assetBalanceString.length,
                                    extentOffset: assetBalanceString.length,
                                  ),
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
            padding: const EdgeInsets.only(
              top: 36,
              bottom: 24,
              left: 16,
              right: 16,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                final paymentHelper = ref.watch(paymentHelperProvider);

                return CustomBigButton(
                  width: double.infinity,
                  height: 54,
                  backgroundColor: SideSwapColors.brightTurquoise,
                  text: 'CONTINUE'.tr(),
                  onPressed: enabled.value
                      ? () {
                          final paymentAmountPageArguments = ref.read(
                            paymentAmountPageArgumentsNotifierProvider,
                          );
                          paymentHelper.selectPaymentSend(
                            amount.value,
                            asset,
                            address: paymentAmountPageArguments.result?.address,
                            isGreedy: isMaxPressed.value,
                          );
                        }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
