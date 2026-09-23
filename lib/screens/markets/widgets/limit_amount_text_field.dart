import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/limit_minimum_fee_error.dart';
import 'package:sideswap/screens/markets/widgets/market_amount_text_field.dart';

class LimitAmountTextField extends HookConsumerWidget {
  const LimitAmountTextField({
    this.showConversion = false,
    this.showBalance = false,
    this.showMaxButton = false,
    this.onEditingComplete,
    super.key,
  });

  final VoidCallback? onEditingComplete;
  final bool showConversion;
  final bool showBalance;
  final bool showMaxButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final tradeDirState = ref.watch(tradeDirStateProvider);
    final amountString = ref.watch(limitOrderAmountControllerProvider);
    final insufficientAmount = ref.watch(limitInsufficientAmountProvider);
    final minimumFeeAmount = ref.watch(limitMinimumFeeAmountProvider);

    final limitAmountController = useTextEditingController();
    final focusNode = useFocusNode();

    useEffect(() {
      limitAmountController.clear();
      limitAmountController.addListener(() {
        Future.microtask(() {
          ref
              .read(limitOrderAmountControllerProvider.notifier)
              .setState(limitAmountController.text);
        });
      });

      return;
    }, const []);

    useEffect(() {
      if (limitAmountController.text != amountString) {
        limitAmountController.text = amountString;
      }

      return;
    }, [amountString]);

    // On desktop a pointer-down outside a text field unfocuses it, so clicking
    // the BUY/SELL switch drops the caret. `autofocus` only fires when the node
    // first attaches, and the flip rebuilds this widget instead of remounting
    // it, so the field asks for focus back itself. `MarketAmountPanel` does the
    // same at `market_order_panel.dart`, except that it also clears its
    // controller. This one does not: the flip changes the side of the trade,
    // not the size of it, and `limitOrderAmountControllerProvider` does not
    // reset on `tradeDirStateProvider` either, so clearing here would be the
    // new behaviour rather than the kept one.
    // Keyed on the node as well as the direction, per ADR-0011 decision 7.
    useEffect(() {
      focusNode.requestFocus();

      return;
    }, [focusNode, tradeDirState]);

    return optionBaseAsset.match(
      () => SizedBox(),
      (baseAsset) => MarketAmountTextField(
        caption: 'Amount'.tr(),
        asset: baseAsset,
        controller: limitAmountController,
        autofocus: true,
        focusNode: focusNode,
        // The refocus below is an *external* focus change, and a desktop
        // `TextField` selects all of its text on those. That would put the
        // typed amount one keystroke from gone, so this field opts out.
        // A click and an autofocus are flagged internal by Flutter and never
        // selected all, so those paths are unaffected. Tab traversal into the
        // field is external and does lose its select-all: accepted, because
        // the panel autofocuses this field on entry, so traversal reaches it
        // rarely, and losing a typed amount is the worse outcome.
        selectAllOnFocus: false,
        onEditingComplete: onEditingComplete,
        onChanged: (value) {},
        showConversion: showConversion,
        showBalance: showBalance,
        showAggregate: true,
        error: insufficientAmount
            ? LimitMinimumFeeError(
                text: 'MINIMUM_FEE'.tr(args: [minimumFeeAmount]),
              )
            : null,
        showMaxButton: showMaxButton,
        onMaxPressed: () {
          final totalBalance = ref.watch(
            availableBalanceForAssetIdAsStringProvider(baseAsset.assetId),
          );

          ref
              .read(limitOrderAmountControllerProvider.notifier)
              .setState(totalBalance);
        },
      ),
    );
  }
}
