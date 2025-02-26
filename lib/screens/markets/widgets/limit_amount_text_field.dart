import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/limit_minimum_fee_error.dart';
import 'package:sideswap/screens/markets/widgets/market_amount_text_field.dart';

class LimitAmountTextField extends HookConsumerWidget {
  const LimitAmountTextField({this.onEditingComplete, super.key});

  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    final amountString = ref.watch(limitOrderAmountControllerNotifierProvider);
    final insufficientAmount = ref.watch(limitInsufficientAmountProvider);
    final minimumFeeAmount = ref.watch(limitMinimumFeeAmountProvider);

    final limitAmountController = useTextEditingController();
    final focusNode = useFocusNode();

    useEffect(() {
      limitAmountController.clear();
      limitAmountController.addListener(() {
        Future.microtask(() {
          ref
              .read(limitOrderAmountControllerNotifierProvider.notifier)
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

    return optionBaseAsset.match(
      () => SizedBox(),
      (baseAsset) => MarketAmountTextField(
        caption: 'Amount'.tr(),
        asset: baseAsset,
        controller: limitAmountController,
        autofocus: true,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        onChanged: (value) {},
        error:
            insufficientAmount
                ? LimitMinimumFeeError(
                  text: 'MINIMUM_FEE'.tr(args: [minimumFeeAmount]),
                )
                : null,
      ),
    );
  }
}
