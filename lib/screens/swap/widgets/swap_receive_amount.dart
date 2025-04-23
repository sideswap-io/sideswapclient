import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/providers/server_status_providers.dart';
import 'package:sideswap/providers/subscribe_price_providers.dart';
import 'package:sideswap/providers/swap_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';
import 'package:easy_localization/easy_localization.dart';

class SwapReceiveAmount extends HookConsumerWidget {
  const SwapReceiveAmount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swapRecvAsset = ref.watch(swapReceiveAssetProvider);

    final swapRecvWallet = ref.watch(swapRecvWalletProvider);
    final precision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: swapRecvAsset.asset.assetId);
    final swapRecvAccount = AccountAsset(
      AccountType.reg,
      swapRecvAsset.asset.assetId,
    );
    final balance = ref.watch(balancesNotifierProvider)[swapRecvAccount];
    final amountProvider = ref.watch(amountToStringProvider);
    final balanceStr = amountProvider.amountToString(
      AmountToStringParameters(amount: balance ?? 0, precision: precision),
    );
    final swapType = ref.watch(swapTypeProvider);
    final swapState = ref.watch(swapStateNotifierProvider);

    // Show error in one place only
    final subscribe = ref.watch(swapPriceSubscribeNotifierProvider);
    final serverError =
        subscribe != const SwapPriceSubscribeStateRecv()
            ? ''
            : ref.watch(swapNetworkErrorNotifierProvider);
    final feeRates = ref.watch(bitcoinFeeRatesProvider);
    final addressErrorText = ref.watch(swapAddressErrorProvider);
    final showAddressLabel = ref.watch(showAddressLabelProvider);

    final swapRecvAmountController = useTextEditingController();
    final swapAddressRecvController = useTextEditingController();
    final receiveFocusNode = useFocusNode();

    ref.listen(swapRecvTextAmountNotifierProvider, (previous, next) {
      final oldSelection = swapRecvAmountController.selection;
      swapRecvAmountController.value = TextEditingValue(
        text: next,
        selection: oldSelection,
      );
    });

    ref.listen(swapRecvAddressExternalNotifierProvider, (_, next) {
      if (swapType == SwapType.pegIn()) {
        return;
      }

      if (next.isEmpty) {
        swapAddressRecvController.clear();
        receiveFocusNode.requestFocus();
        return;
      }

      final externalAddress = swapAddressRecvController.text;
      if (externalAddress != next) {
        final oldSelection = swapRecvAmountController.selection;
        swapRecvAmountController.value = TextEditingValue(
          text: next,
          selection: oldSelection,
        );
      }
    });

    return SwapSideAmount(
      text: 'Receive'.tr(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      controller: swapRecvAmountController,
      addressController: swapAddressRecvController,
      isMaxVisible: false,
      readOnly:
          swapType == const SwapType.pegIn() ||
          swapState != const SwapState.idle(),
      hintText: '0.0',
      showHintText: swapType == const SwapType.atomic(),
      dropdownReadOnly:
          swapType == const SwapType.atomic() &&
                  swapRecvAsset.assetList.length > 1
              ? false
              : true,
      onEditingCompleted: () {
        if (ref.read(swapEnabledStateProvider)) {
          ref.read(swapHelperProvider).swapAccept();
        }
      },
      feeRates: feeRates,
      visibleToggles: false,
      balance: balanceStr,
      dropdownValue: swapRecvAsset.asset,
      availableAssets: swapRecvAsset.assetList,
      labelGroupValue: swapRecvWallet,
      addressErrorText: addressErrorText,
      receiveAddressFocusNode: receiveFocusNode,
      isAddressLabelVisible: showAddressLabel,
      swapType: swapType,
      showInsufficientFunds: false,
      errorDescription: serverError,
      onDropdownChanged: ref.read(swapHelperProvider).setReceiveAsset,
      onChanged: (value) {
        ref.invalidate(swapStateNotifierProvider);
        ref.read(swapSendTextAmountNotifierProvider.notifier).setAmount('0');

        ref.read(swapRecvTextAmountNotifierProvider.notifier).setAmount(value);

        ref.read(swapPriceSubscribeNotifierProvider.notifier).setRecv();
        ref
            .read(subscribePriceStreamNotifierProvider.notifier)
            .subscribeToPriceStream();
      },
      onAddressEditingCompleted: () async {
        ref
            .read(swapRecvAddressExternalNotifierProvider.notifier)
            .setState(swapAddressRecvController.text);
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onAddressChanged: (text) {
        ref
            .read(swapRecvAddressExternalNotifierProvider.notifier)
            .setState(text);
      },
      onAddressLabelClose: () {
        ref.invalidate(showAddressLabelProvider);
        ref.invalidate(swapRecvAddressExternalNotifierProvider);
      },
      showAccountsInPopup: true,
    );
  }
}
