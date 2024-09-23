import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/subscribe_price_providers.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:easy_localization/easy_localization.dart';

class SwapDeliverAmount extends HookConsumerWidget {
  const SwapDeliverAmount({super.key, this.deliverFocusNode});

  final FocusNode? deliverFocusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapDeliverAsset = ref.watch(swapDeliverAssetProvider);

    final balance =
        ref.watch(balancesNotifierProvider)[swapDeliverAsset.asset] ?? 0;
    final precision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: swapDeliverAsset.asset.assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final balanceStr = amountProvider.amountToString(
        AmountToStringParameters(amount: balance, precision: precision));
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
      swapSendAmountController.text = next;
    });

    final showDeliverDefaultCurrencyConversion =
        swapType == const SwapType.pegOut();

    final defaultCurrencyConversion2 = showDeliverDefaultCurrencyConversion
        ? ref.watch(defaultCurrencyConversionFromStringProvider(
            swapDeliverAsset.asset.assetId, swapSendAmountController.text))
        : null;

    return SwapSideAmount(
      text: 'Deliver'.tr(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: swapSendAmountController,
      focusNode: deliverFocusNode,
      isMaxVisible: true,
      balance: balanceStr,
      readOnly: swapSendWallet == const SwapWallet.extern() ||
          swapState != const SwapState.idle(),
      onEditingCompleted: () {
        if (ref.read(swapEnabledStateProvider)) {
          ref.read(swapHelperProvider).swapAccept();
        }
      },
      hintText: '0.0',
      showHintText: true,
      visibleToggles: false,
      dropdownValue: swapDeliverAsset.asset,
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
        ref
            .read(subscribePriceStreamNotifierProvider.notifier)
            .subscribeToPriceStream();
      },
      onMaxPressed: ref.read(swapHelperProvider).onMaxSendPressed,
      showAccountsInPopup: true,
    );
  }
}
