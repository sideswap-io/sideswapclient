import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/exchange_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';

class SwapDeliverAmount extends HookConsumerWidget {
  const SwapDeliverAmount({super.key, this.deliverFocusNode});

  final FocusNode? deliverFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(bitcoinCurrentFeeRateNotifierProvider, (_, next) {
      // request peg out amount when fee rate changes
      final pegRepository = ref.read(pegRepositoryProvider);
      pegRepository.getPegOutAmount();
    });

    final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);

    final assetBalance =
        ref.watch(assetBalanceProvider)[swapDeliverAsset.assetId] ?? 0;
    final precision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: swapDeliverAsset.assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final balanceStr = amountProvider.amountToString(
      AmountToStringParameters(amount: assetBalance, precision: precision),
    );
    final swapSendWallet = ref.watch(swapSendWalletProvider);
    final swapState = ref.watch(swapStateNotifierProvider);
    final swapType = ref.watch(swapTypeProvider);
    final subscribe = ref.watch(swapPriceSubscribeNotifierProvider);
    final serverError = subscribe == const SwapPriceSubscribeState.recv()
        ? ''
        : ref.watch(swapNetworkErrorNotifierProvider);
    final showInsufficientFunds = ref.watch(showInsufficientFundsProvider);

    final swapSendAmountController = useTextEditingController();

    ref.listen(swapSendTextAmountNotifierProvider, (previous, next) {
      final oldSelection = swapSendAmountController.selection;
      swapSendAmountController.value = TextEditingValue(
        text: next,
        selection: oldSelection,
      );
    });

    final showDeliverDefaultCurrencyConversion =
        swapType == const SwapType.pegOut();

    final defaultCurrencyConversion2 = showDeliverDefaultCurrencyConversion
        ? ref.watch(
            defaultCurrencyConversionFromStringProvider(
              swapDeliverAsset.assetId,
              swapSendAmountController.text,
            ),
          )
        : null;

    final disabledAmount = ref.watch(instantSwapDisabledAmountProvider);

    return SwapSideAmount(
      text: 'Deliver'.tr(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: swapSendAmountController,
      focusNode: deliverFocusNode,
      isMaxVisible: true,
      balance: balanceStr,
      readOnly:
          swapSendWallet == const SwapWallet.extern() ||
          swapState != const SwapState.idle() ||
          disabledAmount,
      onEditingCompleted: () {
        if (ref.read(swapEnabledStateProvider)) {
          ref.read(swapHelperProvider).swapAccept();
        }
      },
      hintText: '0.0',
      showHintText: true,
      visibleToggles: false,
      dropdownValue: swapDeliverAsset.assetId,
      availableAssets: swapDeliverAsset.assetList,
      labelGroupValue: swapSendWallet,
      defaultCurrencyConversion2: defaultCurrencyConversion2,
      swapType: swapType,
      showInsufficientFunds: showInsufficientFunds,
      errorDescription: serverError,
      onDropdownChanged: ref.read(swapHelperProvider).setDeliverAsset,
      onChanged: (value) {
        ref.invalidate(swapStateNotifierProvider);
        ref.read(swapRecvTextAmountNotifierProvider.notifier).setAmount('0');

        ref.read(swapSendTextAmountNotifierProvider.notifier).setAmount(value);

        ref.read(swapPriceSubscribeNotifierProvider.notifier).setSend();
        final pegRepository = ref.read(pegRepositoryProvider);
        pegRepository.getPegOutAmount();
      },
      onMaxPressed: ref.read(swapHelperProvider).onMaxSendPressed,
      showAccountsInPopup: true,
    );
  }
}
