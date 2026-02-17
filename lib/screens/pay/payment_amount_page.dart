import 'package:another_flushbar/flushbar.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/utils_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/pay/widgets/payment_amount_receiver_field.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class PaymentAmountPageArguments {
  PaymentAmountPageArguments({this.result});

  QrCodeResult? result;
}

class PaymentAmountPage extends HookConsumerWidget {
  const PaymentAmountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createTxState = ref.watch(createTxStateProvider);
    final createdTx = switch (createTxState) {
      CreateTxStateCreated(createdTx: final createdTx) => createdTx,
      CreateTxStateError(errorMsg: final errorMsg) => () {
        if (errorMsg != null) {
          Future.microtask(() async {
            await ref.read(utilsProvider).showErrorDialog(errorMsg);

            ref.invalidate(createTxStateProvider);
            ref.invalidate(selectedInputsProvider);
            ref.invalidate(outputsReaderProvider);
            ref.invalidate(outputsCreatorProvider);
            ref.invalidate(sendAssetIdProvider);
            ref.invalidate(sendPopupSelectedAssetIdProvider);
            ref.invalidate(sendPopupAmountProvider);
          });
        }
        return null;
      }(),
      _ => null,
    };
    ref.listen(selectedInputsHelperProvider, (previous, next) {});

    useEffect(() {
      if (createdTx != null) {
        FocusManager.instance.primaryFocus?.unfocus();
        Future.microtask(
          () => ref
              .read(pageStatusProvider.notifier)
              .setStatus(Status.paymentSend),
        );
      }

      return;
    }, [createdTx]);

    return const PaymentAmountPageCreateTx();
  }
}

class PaymentAmountPageCreateTx extends HookConsumerWidget {
  const PaymentAmountPageCreateTx({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanupOnClose = useCallback(() {
      ref.invalidate(createTxStateProvider);
      ref.invalidate(selectedInputsProvider);
      ref.invalidate(outputsReaderProvider);
      ref.invalidate(outputsCreatorProvider);
      ref.invalidate(sendAssetIdProvider);
      ref.invalidate(sendPopupSelectedAssetIdProvider);
      ref.invalidate(sendPopupAmountProvider);
      ref.invalidate(sendPopupAddressProvider);
    });

    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Create transaction'.tr(),
        showTrailingButton: true,
        trailingWidget: CustomCloseButton(
          onPressed: () {
            ref
                .read(eiCreateTransactionProvider.notifier)
                .setState(EICreateTransactionEmpty());
            cleanupOnClose();
            ref.read(pageStatusProvider.notifier).setStatus(Status.registered);
          },
        ),
        onPressed: () {
          ref
              .read(eiCreateTransactionProvider.notifier)
              .setState(EICreateTransactionEmpty());
          ref.read(walletProvider).goBack();
          cleanupOnClose();
        },
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
          cleanupOnClose();
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
                      child: PaymentAmountPageCreateTxBody(),
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

class PaymentAmountPageCreateTxBody extends HookConsumerWidget {
  const PaymentAmountPageCreateTxBody({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(outputsReaderProvider, (_, _) {});

    final paymentAmountPageArguments = ref.watch(
      paymentAmountPageArgumentsProvider,
    );
    final address = paymentAmountPageArguments.result?.address ?? '';
    final amount = paymentAmountPageArguments.result?.amount?.toString() ?? '';

    useEffect(() {
      Future.microtask(
        () => ref.read(sendPopupAddressProvider.notifier).setAddress(address),
      );

      return;
    }, const []);

    final balances = ref.watch(assetBalanceProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final allAssets = ref.watch(allVisibleAssetsProvider);
    final assetIds = allAssets
        .map((e) => e.assetId)
        .where(
          (assetId) =>
              (balances[assetId] ?? 0) != 0 || assetId == liquidAssetId,
        )
        .toList();

    final amountController = useTextEditingController(text: amount);
    final amountFocusNode = useFocusNode();

    final insertOutputsCallback = useCallback(() {
      final selectedAssetId = ref.read(sendPopupSelectedAssetIdProvider);
      final optionAsset = ref.read(assetFromAssetIdProvider(selectedAssetId));

      return optionAsset.match(() {}, (asset) {
        final amount = ref.read(sendPopupDecimalAmountProvider);
        final address = ref.read(sendPopupAddressProvider);
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
            .read(outputsReaderProvider.notifier)
            .insertOutput(
              assetId: selectedAssetId,
              address: address,
              satoshi: satoshi,
              account: asset.ampMarket ? Account.AMP_ : Account.REG,
            );
      });
    });

    final reviewButtonEnabled = ref.watch(sendPopupReviewButtonEnabledProvider);

    // set text field related providers
    useEffect(() {
      amountController.addListener(() {
        final amount = ref.read(sendPopupAmountProvider);
        if (amount == amountController.text) {
          return;
        }

        Future.microtask(() {
          ref
              .read(sendPopupAmountProvider.notifier)
              .setAmount(amountController.text);
        });
      });

      return;
    }, [amountController]);

    final createTxState = ref.watch(createTxStateProvider);
    useEffect(() {
      (switch (createTxState) {
        CreateTxStateError(errorMsg: final _) => () {
          amountController.text = '';
        },
        _ => null,
      });

      return;
    }, [createTxState]);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          PaymentAmountReceiverField(
            text: address,
            labelStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          const SizedBox(height: 24),
          Consumer(
            builder: (context, ref, child) {
              final showInsufficientFunds = ref.watch(
                sendPopupShowInsufficientFundsProvider,
              );

              final defaultCurrencyConversion = ref.watch(
                sendPopupDefaultCurrencyConversionProvider,
              );

              final balanceStr = ref.watch(balanceStringWithInputsProvider);
              final selectedAssetId = ref.watch(
                sendPopupSelectedAssetIdProvider,
              );
              final selectedInputs = ref.watch(selectedInputsProvider);

              return SwapSideAmount(
                showInsufficientFunds: showInsufficientFunds,
                defaultCurrencyConversion2: defaultCurrencyConversion,
                focusNode: amountFocusNode,
                availableAssets: assetIds,
                dropdownValue: selectedAssetId,
                swapType: const SwapType.atomic(),
                text: 'Send',
                isMaxVisible: true,
                isInputsVisible: false,
                showAccountsInPopup: true,
                controller: amountController,
                balance: balanceStr,
                onSubmitted: (_) async {
                  final errorMessage = ref
                      .read(paymentHelperProvider)
                      .outputsPaymentSend(selectedInputs: selectedInputs);

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
                        .read(sendAssetIdProvider.notifier)
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
              );
            },
          ),
          // TODO: (malcolmpl): low priority - ui deduct fee from output for mobile
          // const SizedBox(height: 48),
          // Consumer(
          //   builder: (context, ref, child) {
          //     final outputsDataLength = ref.watch(outputsDataLengthProvider);
          //     return switch (outputsDataLength) {
          //       final length when length > 0 => const DeductFeeFromOutput(),
          //       _ => const SizedBox(),
          //     };
          //   },
          // ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: CustomBigButton(
              width: double.infinity,
              height: 54,
              backgroundColor: SideSwapColors.brightTurquoise,
              onPressed: switch (reviewButtonEnabled) {
                AsyncLoading() => null,
                _ => () async {
                  insertOutputsCallback();
                  amountController.text = '';
                  final selectedInputs = ref.read(selectedInputsProvider);

                  final errorMessage = ref
                      .read(paymentHelperProvider)
                      .outputsPaymentSend(selectedInputs: selectedInputs);

                  if (errorMessage != null) {
                    final flushbar = Flushbar<void>(
                      messageText: Text(errorMessage),
                      duration: const Duration(seconds: 5),
                      backgroundColor: SideSwapColors.chathamsBlue,
                    );
                    if (context.mounted) {
                      await flushbar.show(context);
                    }
                  }
                },
              },
              child: Text('Review'.tr().toUpperCase()),
            ),
          ),
        ],
      ),
    );
  }
}
