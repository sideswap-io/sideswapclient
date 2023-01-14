import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:easy_localization/easy_localization.dart';

class SwapDeliverAmount extends HookConsumerWidget {
  const SwapDeliverAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapSendAsset =
        ref.watch(swapProvider.select((p) => p.swapSendAsset!));
    final balance = ref
        .watch(balancesProvider.select((p) => p.balances[swapSendAsset] ?? 0));
    final precision = ref
        .watch(walletProvider)
        .getPrecisionForAssetId(assetId: swapSendAsset.asset);
    final balanceStr = amountStr(balance, precision: precision);
    final swapSendAssets = ref.watch(swapProvider).swapSendAssets().toList();
    final swapSendWallet =
        ref.watch(swapProvider.select((p) => p.swapSendWallet));
    final swapState = ref.watch(swapStateProvider);
    final swapType = ref.watch(swapProvider).swapType();
    final subscribe = ref.watch(swapPriceSubscribeStateNotifierProvider);
    final serverError = subscribe == const SwapPriceSubscribeState.recv()
        ? ''
        : ref.watch(swapNetworkErrorStateProvider);
    final showInsufficientFunds = ref.watch(showInsufficientFundsProvider);

    final swapSendAmountController = useTextEditingController();
    final deliverFocusNode = useFocusNode();

    useEffect(() {
      deliverFocusNode.requestFocus();

      return;
    }, [deliverFocusNode]);

    ref.listen<SwapSendAmountProvider>(swapSendAmountChangeNotifierProvider,
        (previous, next) {
      final newValue = replaceCharacterOnPosition(
        input: next.amount,
      );
      swapSendAmountController.value = fixCursorPosition(
          controller: swapSendAmountController, newValue: newValue);
    });

    final showDeliverDollarConversion = swapType == SwapType.pegOut;
    final dollarConversion2 = showDeliverDollarConversion
        ? ref.read(requestOrderProvider).dollarConversionFromString(
            ref.read(swapProvider).swapSendAsset!.asset,
            swapSendAmountController.text)
        : null;

    return SwapSideAmount(
      text: 'Deliver'.tr(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: swapSendAmountController,
      focusNode: deliverFocusNode,
      isMaxVisible: true,
      balance: balanceStr,
      readOnly:
          swapSendWallet == SwapWallet.extern || swapState != SwapState.idle,
      onEditingCompleted: () {
        if (ref.read(swapEnabledStateProvider)) {
          ref.read(swapProvider).swapAccept();
        }
      },
      hintText: '0.0',
      showHintText: true,
      visibleToggles: false,
      dropdownValue: swapSendAsset,
      availableAssets: swapSendAssets,
      labelGroupValue: swapSendWallet,
      dollarConversion2: dollarConversion2,
      swapType: swapType,
      showInsufficientFunds: showInsufficientFunds,
      errorDescription: serverError,
      localLabelOnChanged: (value) =>
          ref.read(swapProvider).setSendRadioCb(SwapWallet.local),
      externalLabelOnChanged: (value) =>
          ref.read(swapProvider).setSendRadioCb(SwapWallet.extern),
      onDropdownChanged: ref.read(swapProvider).setDeliverAsset,
      onChanged: (value) {
        ref.read(swapStateProvider.notifier).state = SwapState.idle;
        ref.read(swapRecvAmountChangeNotifierProvider.notifier).setAmount('0');

        ref
            .read(swapSendAmountChangeNotifierProvider.notifier)
            .setAmount(value);

        ref.read(swapPriceSubscribeStateNotifierProvider.notifier).setSend();
        ref
            .read(priceStreamSubscribeChangeNotifierProvider)
            .subscribeToPriceStream();
      },
      onMaxPressed: ref.read(swapProvider).onMaxSendPressed,
      showAccountsInPopup: true,
    );
  }
}