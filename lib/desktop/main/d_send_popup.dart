import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/common/button/d_radio_button.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';
import 'package:sideswap/desktop/main/widgets/d_send_popup_deduct_fee.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_detail.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_receiver.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_addr_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payjoin_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DSendPopup extends ConsumerWidget {
  const DSendPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createTxState = ref.watch(createTxStateNotifierProvider);
    final createdTx = switch (createTxState) {
      CreateTxStateCreated(createdTx: final createdTx) => createdTx,
      CreateTxStateError(errorMsg: final errorMsg) => () {
        if (errorMsg != null) {
          Future.microtask(() async {
            await ref.read(utilsProvider).showErrorDialog(errorMsg);
          });
        }
        return null;
      }(),
      _ => null,
    };
    ref.listen(selectedInputsHelperProvider, (previous, next) {});

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
    ref.listen(selectedInputsHelperProvider, (previous, next) {});
    ref.watch(outputsReaderNotifierProvider);
    final reviewButtonEnabled = ref.watch(sendPopupReviewButtonEnabledProvider);
    final addMoreOutputsButtonEnabled = ref.watch(
      sendPopupAddMoreOutputsButtonEnabledProvider,
    );
    final showInsufficientFunds = ref.watch(
      sendPopupShowInsufficientFundsProvider,
    );
    final selectedAssetId = ref.watch(sendPopupSelectedAssetIdNotifierProvider);
    final optionAsset = ref.watch(assetFromAssetIdProvider(selectedAssetId));
    final eiCreateTransaction = ref.watch(eiCreateTransactionNotifierProvider);
    final balances = ref.watch(assetBalanceProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final allAssets = ref.watch(allAlwaysShowAssetsProvider);
    final assetIds = allAssets
        .map((e) => e.assetId)
        .where(
          (assetId) =>
              (balances[assetId] ?? 0) != 0 || assetId == liquidAssetId,
        )
        .toList();

    final amountController = useTextEditingController();
    final addressController = useTextEditingController();
    final addressFocusNode = useFocusNode();
    final amountFocusNode = useFocusNode();

    void insertOutputs() {
      return optionAsset.match(() {}, (asset) {
        final amount = ref.read(sendPopupDecimalAmountProvider);
        final address = ref.read(sendPopupAddressNotifierProvider);
        final satoshi = ref
            .read(satoshiRepositoryProvider)
            .satoshiForAmount(
              amount: amount.toString(),
              assetId: selectedAssetId,
            );

        if (amount == Decimal.zero || address.isEmpty) {
          return;
        }

        ref
            .read(outputsReaderNotifierProvider.notifier)
            .insertOutput(
              assetId: selectedAssetId,
              address: address,
              satoshi: satoshi,
              account: asset.ampMarket ? Account.AMP_ : Account.REG,
            );
      });
    }

    void cleanupOnClose() {
      ref.invalidate(sendAssetIdNotifierProvider);
      ref.invalidate(sendPopupSelectedAssetIdNotifierProvider);
      ref.invalidate(sendPopupAmountNotifierProvider);
      ref.invalidate(sendPopupAddressNotifierProvider);
    }

    // set text field related providers
    useEffect(() {
      addressController.addListener(() {
        Future.microtask(
          () => ref
              .read(sendPopupAddressNotifierProvider.notifier)
              .setAddress(addressController.text),
        );
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

    final defaultCurrencyConversion = ref.watch(
      sendPopupDefaultCurrencyConversionProvider,
    );

    useEffect(() {
      parsedAddressResult.match(
        (l) {
          logger.d('Invalid address');
        },
        (r) {
          if (r.amount > 0) {
            amountController.text = r.amount.toString();
          }
        },
      );

      return;
    }, [parsedAddressResult]);

    final outputsData = ref.watch(outputsReaderNotifierProvider);

    useAsyncEffect(() async {
      await (switch (outputsData) {
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

    final selectedInputs = ref.watch(selectedInputsNotifierProvider);

    return DPopupWithClose(
      width: 580,
      height: 710,
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 8),
            DAddrTextField(
              focusNode: addressFocusNode,
              autofocus: true,
              controller: addressController,
              onPressed: () {
                ref.invalidate(sendPopupAddressNotifierProvider);
              },
            ),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final paymentHelper = ref.watch(paymentHelperProvider);
                final balanceStr = ref.watch(balanceStringWithInputsProvider);

                return SwapSideAmount(
                  showInsufficientFunds: showInsufficientFunds,
                  defaultCurrencyConversion2: defaultCurrencyConversion,
                  focusNode: amountFocusNode,
                  availableAssets: assetIds,
                  dropdownValue: selectedAssetId,
                  swapType: const SwapType.atomic(),
                  text: 'Send',
                  isMaxVisible: true,
                  isInputsVisible: true,
                  showAccountsInPopup: true,
                  controller: amountController,
                  balance: balanceStr,
                  onSubmitted: (_) async {
                    final errorMessage = paymentHelper.outputsPaymentSend(
                      selectedInputs: selectedInputs,
                    );
                    if (errorMessage != null) {
                      final flushbar = Flushbar<void>(
                        messageText: Text(errorMessage),
                        duration: const Duration(seconds: 5),
                        backgroundColor: SideSwapColors.chathamsBlue,
                      );
                      await flushbar.show(context);
                    }
                  },
                  onDropdownChanged: (assetId) {
                    if (selectedAssetId != assetId) {
                      ref
                          .read(sendAssetIdNotifierProvider.notifier)
                          .setSendAsset(assetId);
                      amountController.clear();
                    }
                    amountFocusNode.requestFocus();
                  },
                  onMaxPressed: () {
                    amountController.text = ref.read(
                      balanceStringWithInputsProvider,
                    );
                  },
                  onSelectInputs: () {
                    ref.read(desktopDialogProvider).showSelectInputs();
                  },
                );
              },
            ),
            const DSendPopupOutputs(),
            const Spacer(),
            Consumer(
              builder: (context, ref, child) {
                final outputsDataLength = ref.watch(outputsDataLengthProvider);
                return switch (outputsDataLength) {
                  final length when length > 0 => const DSendPopupDeductFee(),
                  _ => const SizedBox(),
                };
              },
            ),
            const SizedBox(height: 16),
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
                Consumer(
                  builder: (context, ref, child) {
                    final paymentHelper = ref.watch(paymentHelperProvider);
                    return DCustomButton(
                      width: 245,
                      height: 44,
                      isFilled: true,
                      onPressed: switch (reviewButtonEnabled) {
                        AsyncLoading() => null,
                        _ => () async {
                          insertOutputs();
                          amountController.text = '';
                          addressController.text = '';

                          final errorMessage = paymentHelper.outputsPaymentSend(
                            selectedInputs: selectedInputs,
                          );
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
                    );
                  },
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
    final createTxState = ref.watch(createTxStateNotifierProvider);
    final createdTx = switch (createTxState) {
      CreateTxStateCreated(createdTx: final createdTx) => createdTx,
      _ => null,
    };
    final createdTxHelper = ref.watch(createdTxHelperProvider(createdTx));
    final sendTxState = ref.watch(sendTxStateNotifierProvider);

    const headerStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.brightTurquoise,
    );

    void cleanupOnBack() {
      ref.invalidate(createTxStateNotifierProvider);
    }

    void cleanupOnClose() {
      cleanupOnBack();
      ref.invalidate(selectedInputsNotifierProvider);
      ref.invalidate(outputsReaderNotifierProvider);
      ref.invalidate(outputsCreatorProvider);
      ref.invalidate(sendAssetIdNotifierProvider);
      ref.invalidate(sendPopupSelectedAssetIdNotifierProvider);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Address'.tr(), style: headerStyle),
                      SizedBox(width: 214),
                      Text('Amount'.tr(), style: headerStyle),
                    ],
                  ),
                  const SizedBox(height: 14),
                  switch (createdTx) {
                    CreatedTx(addressees: final addresses) => () {
                      final listHeight = (addresses.length * 44.0);
                      final containerHeight = listHeight > 180
                          ? 180.0
                          : listHeight;
                      return Container(
                        height: containerHeight,
                        constraints: const BoxConstraints(
                          minHeight: 44,
                          maxHeight: 180,
                        ),
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
                            ),
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
                  RowTxDetail(
                    name: 'Fee per byte'.tr(),
                    value: createdTxHelper.feePerByte(),
                  ),
                  RowTxDetail(
                    name: 'Transaction size'.tr(),
                    value: createdTxHelper.txSize(),
                  ),
                  RowTxDetail(
                    name: 'Discount vsize'.tr(),
                    value: createdTxHelper.vsize(),
                  ),
                  RowTxDetail(
                    name: 'Network Fee'.tr(),
                    value: createdTxHelper.networkFee(),
                  ),
                  ...switch (createdTxHelper.hasServerFee()) {
                    true => [
                      RowTxDetail(
                        name: 'Server fee'.tr(),
                        value: createdTxHelper.serverFee(),
                      ),
                    ],
                    _ => [const SizedBox()],
                  },
                  RowTxDetail(
                    name: 'Number of inputs'.tr(),
                    value: createdTxHelper.inputCount(),
                  ),
                  RowTxDetail(
                    name: 'Number of outputs'.tr(),
                    value: createdTxHelper.outputCount(),
                  ),
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
                        onPressed: sendTxState == const SendTxStateEmpty()
                            ? () async {
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
                              }
                            : null,
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
                                        .assetSendConfirmCommon(createdTx);
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DSendPopupOutputs extends HookConsumerWidget {
  const DSendPopupOutputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputsData = ref.watch(outputsReaderNotifierProvider);
    final scrollController = useScrollController();
    const maxHeight = 186.0;

    return switch (outputsData) {
      Right(value: final r)
          when r.receivers != null && r.receivers!.isNotEmpty =>
        () {
          final listHeight = (r.receivers!.length * 44.0);
          final containerHeight = listHeight > 132 ? 132.0 : listHeight;

          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
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
                  constraints: const BoxConstraints(
                    minHeight: 44,
                    maxHeight: 132,
                  ),
                  decoration: const BoxDecoration(
                    color: SideSwapColors.prussianBlue,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Scrollbar(
                    thumbVisibility: (r.receivers?.length ?? 0) >= 4,
                    controller: scrollController,
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverList.builder(
                          itemBuilder: (context, index) {
                            return DSendPopupOutputItem(
                              outputsData: r,
                              index: index,
                            );
                          },
                          itemCount: r.receivers!.length,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        }(),
      _ => const SizedBox(height: maxHeight),
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
                .watch(assetImageRepositoryProvider)
                .getCustomImage(item.assetId, width: 24, height: 24);
            final ticker =
                ref.watch(assetsStateProvider)[item.assetId]?.ticker ?? '';
            final assetPrecision = ref
                .watch(assetUtilsProvider)
                .getPrecisionForAssetId(assetId: item.assetId);
            final amountString = ref
                .watch(amountToStringProvider)
                .amountToString(
                  AmountToStringParameters(
                    amount: item.satoshi ?? 0,
                    precision: assetPrecision,
                  ),
                );

            return DSendPopupAddressAmountItem(
              address: item.address ?? '',
              amount: amountString,
              ticker: ticker,
              index: index,
              icon: icon,
              showRadioButton: (outputsData.receivers?.length ?? 0) > 1,
              account: item.account ?? Account.REG,
              onPressed: () {
                ref
                    .read(outputsReaderNotifierProvider.notifier)
                    .removeOutput(index);
                final radioButtonIndex = ref.read(
                  payjoinRadioButtonIndexNotifierProvider,
                );
                if (radioButtonIndex == index) {
                  ref.invalidate(payjoinRadioButtonIndexNotifierProvider);
                }
              },
            );
          },
        );
      }(),
      null => const SizedBox(),
    };
  }
}

class DSendPopupAddressAmountItem extends ConsumerWidget {
  const DSendPopupAddressAmountItem({
    super.key,
    required this.address,
    required this.amount,
    this.icon,
    required this.ticker,
    this.onPressed,
    required this.index,
    this.showRadioButton = false,
    this.account = Account.REG,
  });

  final String address;
  final String amount;
  final Widget? icon;
  final String ticker;
  final void Function()? onPressed;
  final int index;
  final bool showRadioButton;
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radioButtonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .outputsRadioButtonTheme;
    final radioButtonIndex = ref.watch(payjoinRadioButtonIndexNotifierProvider);

    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  width: onPressed == null ? 250 : 222,
                  child: Row(
                    children: switch (showRadioButton) {
                      true => [
                        DRadioButton(
                          checked: index == radioButtonIndex,
                          onChanged: (value) {
                            ref
                                .watch(
                                  payjoinRadioButtonIndexNotifierProvider
                                      .notifier,
                                )
                                .setState(index);
                          },
                          style: radioButtonStyle,
                          content: SizedBox(
                            width: 155,
                            child: MiddleEllipsisText(
                              text: address,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ],
                      _ => [
                        SizedBox(
                          width: 155,
                          child: MiddleEllipsisText(
                            text: address,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    },
                  ),
                ),
                // const Spacer(),
                Text(amount, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                ...switch (icon) {
                  final icon? => [icon, const SizedBox(width: 8)],
                  _ => [const SizedBox()],
                },
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 50),
                  child: Text(
                    ticker,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ...switch (account) {
                  Account.AMP_ => [
                    const AmpFlag(
                      width: 36,
                      height: 15,
                      textStyle: TextStyle(
                        color: Color(0xFF73A6C5),
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ],
                  _ => [
                    const SizedBox(
                      width: 44, // ampFlag + margin
                    ),
                  ],
                },
                ...switch (onPressed) {
                  final onPressed? => [
                    const SizedBox(width: 8),
                    DIconButton(
                      icon: const Icon(
                        Icons.close,
                        color: SideSwapColors.brightTurquoise,
                        size: 16,
                      ),
                      onPressed: onPressed,
                    ),
                  ],
                  _ => [const SizedBox()],
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
