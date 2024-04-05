import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_detail.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_receiver.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_addr_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DSendPopup extends ConsumerWidget {
  const DSendPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdTx = ref.watch(paymentCreatedTxNotifierProvider);

    return switch (createdTx) {
      CreatedTx() => const DSendPopupReview(),
      _ => const DSendPopupCreate(),
    };
  }
}

class DSendPopupCreate extends HookConsumerWidget {
  const DSendPopupCreate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(outputsReaderNotifierProvider);
    final reviewButtonEnabled = ref.watch(sendPopupReviewButtonEnabledProvider);
    final addMoreOutputsButtonEnabled =
        ref.watch(sendPopupAddMoreOutputsButtonEnabledProvider);
    final showInsufficientFunds =
        ref.watch(sendPopupShowInsufficientFundsProvider);
    final selectedAccountAsset =
        ref.watch(sendPopupSelectedAccountAssetNotifierProvider);
    final eiCreateTransaction = ref.watch(eiCreateTransactionNotifierProvider);
    final balances = ref.watch(balancesNotifierProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final allAccounts = ref.watch(allAlwaysShowAccountAssetsProvider);
    final regularLiquidAccount = AccountAsset(AccountType.reg, liquidAssetId);
    final accounts = allAccounts
        .where((account) =>
            (balances[account] ?? 0) != 0 || account == regularLiquidAccount)
        .toList();

    final amountController = useTextEditingController();
    final addressController = useTextEditingController();
    final addressFocusNode = useFocusNode();
    final amountFocusNode = useFocusNode();

    final isMaxPressed = useState(false);

    void insertOutputs() {
      final selectedAccountAsset =
          ref.read(sendPopupSelectedAccountAssetNotifierProvider);
      final amount = ref.read(sendPopupDecimalAmountProvider);
      final address = ref.read(sendPopupAddressNotifierProvider);
      final assetId = selectedAccountAsset.assetId ?? '';
      final satoshi = ref.read(satoshiForAmountProvider(
          amount: amount.toString(), assetId: assetId));

      if (amount == Decimal.zero || address.isEmpty) {
        return;
      }

      ref
          .read(outputsReaderNotifierProvider.notifier)
          .insertOutput(assetId: assetId, address: address, satoshi: satoshi);
    }

    void cleanupOnClose() {
      ref.invalidate(sendAssetNotifierProvider);
      ref.invalidate(sendPopupSelectedAccountAssetNotifierProvider);
      ref.invalidate(sendPopupAmountNotifierProvider);
      ref.invalidate(sendPopupAddressNotifierProvider);
    }

    useEffect(() {
      Future.microtask(() => cleanupOnClose());

      return;
    }, const []);

    // set text field related providers
    useEffect(() {
      addressController.addListener(() {
        Future.microtask(() => ref
            .read(sendPopupAddressNotifierProvider.notifier)
            .setAddress(addressController.text));
      });
      amountController.addListener(() {
        final amount = ref.read(sendPopupAmountNotifierProvider);
        if (amount == amountController.text) {
          return;
        }

        Future.microtask(() {
          ref
              .read(sendPopupAmountNotifierProvider.notifier)
              .setAmount(amountController.text);
        });
      });

      return;
    }, [addressController, amountController]);

    final parsedAddressResult = ref.watch(sendPopupParseAddressProvider);

    useEffect(() {
      (switch (parsedAddressResult) {
        Left(value: final _) => addressFocusNode.requestFocus(),
        Right(value: final _) => amountFocusNode.requestFocus(),
      });

      return;
    }, [parsedAddressResult]);

    useEffect(() {
      if (eiCreateTransaction is EICreateTransactionData) {
        Future.microtask(() {
          addressController.text = eiCreateTransaction.address;
          amountController.text = eiCreateTransaction.amount;
          ref
              .read(eiCreateTransactionNotifierProvider.notifier)
              .setState(EICreateTransactionEmpty());
        });
      }

      return;
    }, [eiCreateTransaction]);

    final defaultCurrencyConversion =
        ref.watch(sendPopupDefaultCurrencyConversionProvider);

    useEffect(() {
      parsedAddressResult.match((l) {
        logger.d('Invalid address');
      }, (r) {
        if (r.amount > 0) {
          amountController.text = r.amount.toString();
        }
      });

      return;
    }, [parsedAddressResult]);

    final outputsData = ref.watch(outputsReaderNotifierProvider);

    useAsyncEffect(() async {
      (switch (outputsData) {
        Left(value: final l) => () async {
            if (l.message != null) {
              final flushbar = Flushbar<void>(
                messageText: Text(l.message!),
                duration: const Duration(seconds: 5),
                backgroundColor: SideSwapColors.chathamsBlue,
              );
              await flushbar.show(context);
            }
          }(),
        _ => () {}(),
      });

      return;
    }, [outputsData]);

    return DPopupWithClose(
      width: 580,
      height: 630,
      onClose: () {
        ref
            .read(eiCreateTransactionNotifierProvider.notifier)
            .setState(EICreateTransactionEmpty());
        Navigator.of(context).pop();
        cleanupOnClose();
      },
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text(
              'Create transaction'.tr(),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address'.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: SideSwapColors.brightTurquoise,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 76,
              child: Column(
                children: [
                  DAddrTextField(
                    focusNode: addressFocusNode,
                    autofocus: true,
                    controller: addressController,
                    onPressed: () {
                      ref.invalidate(sendPopupAddressNotifierProvider);
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SwapSideAmount(
              showInsufficientFunds: showInsufficientFunds,
              defaultCurrencyConversion2: defaultCurrencyConversion,
              focusNode: amountFocusNode,
              availableAssets: accounts,
              dropdownValue: selectedAccountAsset,
              swapType: SwapType.atomic,
              text: 'Send',
              isMaxVisible: true,
              showAccountsInPopup: true,
              controller: amountController,
              balance: ref.read(balanceStringProvider(selectedAccountAsset)),
              onChanged: (value) {
                isMaxPressed.value = false;
              },
              onSubmitted: (_) async {
                final errorMessage = ref
                    .read(paymentHelperProvider)
                    .outputsPaymentSend(isGreedy: isMaxPressed.value);
                if (errorMessage != null) {
                  final flushbar = Flushbar<void>(
                    messageText: Text(errorMessage),
                    duration: const Duration(seconds: 5),
                    backgroundColor: SideSwapColors.chathamsBlue,
                  );
                  await flushbar.show(context);
                }
              },
              onDropdownChanged: (accountAsset) {
                if (selectedAccountAsset != accountAsset) {
                  ref
                      .read(sendAssetNotifierProvider.notifier)
                      .setSendAsset(accountAsset);
                  amountController.clear();
                }
                amountFocusNode.requestFocus();
              },
              onMaxPressed: () {
                isMaxPressed.value = true;
                amountController.text =
                    ref.read(balanceStringProvider(selectedAccountAsset));
              },
            ),
            const DSendPopupOutputs(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DCustomButton(
                  width: 245,
                  height: 44,
                  onPressed: switch (addMoreOutputsButtonEnabled) {
                    AsyncLoading() => null,
                    _ => () {
                        insertOutputs();
                        amountController.text = '';
                        addressController.text = '';
                        addressFocusNode.requestFocus();
                      },
                  },
                  child: Text('Add more outputs'.tr().toUpperCase()),
                ),
                DCustomButton(
                  width: 245,
                  height: 44,
                  isFilled: true,
                  onPressed: switch (reviewButtonEnabled) {
                    AsyncLoading() => null,
                    _ => () async {
                        insertOutputs();
                        amountController.text = '';
                        addressController.text = '';

                        final errorMessage = ref
                            .read(paymentHelperProvider)
                            .outputsPaymentSend(isGreedy: isMaxPressed.value);
                        if (errorMessage != null) {
                          final flushbar = Flushbar<void>(
                            messageText: Text(errorMessage),
                            duration: const Duration(seconds: 5),
                            backgroundColor: SideSwapColors.chathamsBlue,
                          );
                          await flushbar.show(context);
                        }
                      },
                  },
                  child: Text('Review'.tr().toUpperCase()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DSendPopupReview extends ConsumerWidget {
  const DSendPopupReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdTx = ref.watch(paymentCreatedTxNotifierProvider);
    final sendTxState = ref.watch(sendTxStateNotifierProvider);

    final feePerByteStr =
        '${createdTx?.feePerByte.toStringAsFixed(3) ?? 0} s/b';
    final txSizeStr =
        '${createdTx?.size.toString() ?? 0} Bytes / ${createdTx?.vsize.toString() ?? 0} VBytes';
    final amountProvider = ref.watch(amountToStringProvider);
    final feeStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: createdTx?.networkFee.toInt() ?? 0, ticker: 'L-BTC'));

    const headerStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.brightTurquoise,
    );

    void cleanupOnBack() {
      ref.invalidate(paymentCreatedTxNotifierProvider);
    }

    void cleanupOnClose() {
      cleanupOnBack();
      ref.invalidate(outputsReaderNotifierProvider);
      ref.invalidate(outputsCreatorProvider);
      ref.invalidate(sendAssetNotifierProvider);
      ref.invalidate(sendPopupSelectedAccountAssetNotifierProvider);
      ref.invalidate(sendPopupAmountNotifierProvider);
      ref.invalidate(sendPopupAddressNotifierProvider);
    }

    return DPopupWithClose(
      width: 580,
      height: 605,
      onClose: () {
        cleanupOnClose();
        Navigator.of(context).pop();
      },
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
              child: Column(
                children: [
                  Text(
                    'Confirm transaction'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Address'.tr(), style: headerStyle),
                      Text('Amount'.tr(), style: headerStyle),
                    ],
                  ),
                  const SizedBox(height: 14),
                  switch (createdTx) {
                    CreatedTx(addressees: final addresses) => () {
                        final listHeight = (addresses.length * 44.0);
                        final containerHeight =
                            listHeight > 180 ? 180.0 : listHeight;
                        return Container(
                          height: containerHeight,
                          constraints: const BoxConstraints(
                              minHeight: 44, maxHeight: 180),
                          decoration: const BoxDecoration(
                            color: SideSwapColors.prussianBlue,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: CustomScrollView(
                            slivers: [
                              SliverList.builder(
                                itemBuilder: (context, index) {
                                  return RowTxReceiver(
                                    address: addresses[index].address,
                                    assetId: addresses[index].assetId,
                                    amount: addresses[index].amount.toInt(),
                                    index: index,
                                  );
                                },
                                itemCount: addresses.length,
                              )
                            ],
                          ),
                        );
                      }(),
                    _ => const SizedBox(),
                  },
                ],
              ),
            ),
          ),
          Container(
            color: SideSwapColors.chathamsBlue,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  RowTxDetail(name: 'Fee per byte'.tr(), value: feePerByteStr),
                  RowTxDetail(name: 'Transaction size'.tr(), value: txSizeStr),
                  RowTxDetail(name: 'Network Fee'.tr(), value: feeStr),
                  RowTxDetail(
                      name: 'Number of inputs'.tr(),
                      value: createdTx?.inputCount.toString() ?? ''),
                  RowTxDetail(
                      name: 'Number of outputs'.tr(),
                      value: createdTx?.outputCount.toString() ?? ''),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DCustomButton(
                        width: 160,
                        height: 44,
                        onPressed: sendTxState == const SendTxStateEmpty()
                            ? () {
                                cleanupOnBack();
                              }
                            : null,
                        child: Text(
                          'BACK'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: 0.28,
                          ),
                        ),
                      ),
                      DCustomButton(
                        width: 160,
                        height: 44,
                        onPressed: () async {
                          final result = await ref
                              .read(desktopDialogProvider)
                              .openViewTx();
                          return switch (result) {
                            DialogReturnValueAccepted() => () async {
                                final navigator = Navigator.of(context);
                                await ref
                                    .read(desktopDialogProvider)
                                    .openExportTxSuccess();
                                navigator.pop();
                              }(),
                            _ => () {}(),
                          };
                        },
                        child: Text(
                          'EXPORT TX'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: 0.28,
                          ),
                        ),
                      ),
                      DCustomButton(
                        width: 160,
                        height: 44,
                        autofocus: true,
                        isFilled: true,
                        onPressed: sendTxState == const SendTxStateEmpty()
                            ? () async {
                                if (await ref
                                    .read(walletProvider)
                                    .isAuthenticated()) {
                                  if (createdTx != null) {
                                    ref
                                        .read(walletProvider)
                                        .assetSendConfirmCommon(
                                            createdTx.req.account);
                                  }
                                }
                              }
                            : null,
                        child: Row(
                          children: [
                            const Spacer(),
                            Text(
                              'BROADCAST'.tr(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                height: 0,
                                letterSpacing: 0.28,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  switch (sendTxState) {
                                    SendTxStateSending() => const SpinKitCircle(
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    _ => const SizedBox(),
                                  },
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DSendPopupOutputs extends ConsumerWidget {
  const DSendPopupOutputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputsData = ref.watch(outputsReaderNotifierProvider);

    return switch (outputsData) {
      Right(value: final r)
          when r.receivers != null && r.receivers!.isNotEmpty =>
        () {
          final listHeight = (r.receivers!.length * 44.0);
          final containerHeight = listHeight > 132 ? 132.0 : listHeight;

          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 186),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Outputs list'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SideSwapColors.brightTurquoise,
                      ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: containerHeight,
                  constraints:
                      const BoxConstraints(minHeight: 44, maxHeight: 132),
                  decoration: const BoxDecoration(
                    color: SideSwapColors.prussianBlue,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          return DSendPopupOutputItem(
                              outputsData: r, index: index);
                        },
                        itemCount: r.receivers!.length,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }(),
      _ => const SizedBox(),
    };
  }
}

class DSendPopupOutputItem extends ConsumerWidget {
  const DSendPopupOutputItem({
    required this.outputsData,
    required this.index,
    super.key,
  });

  final OutputsData outputsData;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = outputsData.receivers?[index];

    return switch (item) {
      final item? => () {
          return Consumer(
            builder: (context, ref, child) {
              final icon = ref
                  .watch(assetImageProvider)
                  .getCustomImage(item.assetId, width: 24, height: 24);
              final ticker =
                  ref.watch(assetsStateProvider)[item.assetId]?.ticker ?? '';
              final assetPrecision = ref
                  .watch(assetUtilsProvider)
                  .getPrecisionForAssetId(assetId: item.assetId);
              final amountString = ref
                  .watch(amountToStringProvider)
                  .amountToString(AmountToStringParameters(
                      amount: item.satoshi ?? 0, precision: assetPrecision));

              return DSendPopupAddressAmountItem(
                address: item.address ?? '',
                amount: amountString,
                ticker: ticker,
                index: index,
                icon: icon,
                onPressed: () {
                  ref
                      .read(outputsReaderNotifierProvider.notifier)
                      .removeOutput(index);
                },
              );
            },
          );
        }(),
      null => const SizedBox(),
    };
  }
}

class DSendPopupAddressAmountItem extends StatelessWidget {
  const DSendPopupAddressAmountItem({
    super.key,
    required this.address,
    required this.amount,
    this.icon,
    required this.ticker,
    this.onPressed,
    required this.index,
  });

  final String address;
  final String amount;
  final Widget? icon;
  final String ticker;
  final void Function()? onPressed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 1),
            switch (index) {
              0 => const SizedBox(),
              _ => const Divider(
                  height: 1,
                  thickness: 1,
                  color: SideSwapColors.lapisLazuli,
                ),
            },
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 155,
                  child: ExtendedText(
                    address,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflowWidget: TextOverflowWidget(
                      position: TextOverflowPosition.middle,
                      align: TextOverflowAlign.center,
                      child: Text(
                        '...',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                ...switch (icon) {
                  final icon? => [
                      icon,
                      const SizedBox(width: 8),
                    ],
                  _ => [
                      const SizedBox(),
                    ],
                },
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40),
                  child: Text(
                    ticker,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...switch (onPressed) {
                  final onPressed? => [
                      const SizedBox(width: 8),
                      DIconButton(
                          icon: const Icon(
                            Icons.close,
                            color: SideSwapColors.brightTurquoise,
                            size: 16,
                          ),
                          onPressed: onPressed),
                    ],
                  _ => [
                      const SizedBox(),
                    ],
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
