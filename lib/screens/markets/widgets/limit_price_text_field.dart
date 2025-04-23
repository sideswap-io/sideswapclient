import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/markets/widgets/limit_minimum_fee_error.dart';
import 'package:sideswap/screens/markets/widgets/market_amount_text_field.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class LimitPriceTextField extends HookConsumerWidget {
  const LimitPriceTextField({
    this.showConversion = false,
    this.showBalance = false,
    this.onEditingComplete,
    super.key,
  });

  final VoidCallback? onEditingComplete;
  final bool showConversion;
  final bool showBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final priceString = ref.watch(limitOrderPriceControllerNotifierProvider);
    final insufficientPrice = ref.watch(limitInsufficientPriceProvider);
    final minimumFeeAmount = ref.watch(limitMinimumFeeAmountProvider);

    final limitPriceController = useTextEditingController();
    final focusNode = useFocusNode();

    useEffect(() {
      limitPriceController.clear();
      limitPriceController.addListener(() {
        Future.microtask(() {
          ref
              .read(limitOrderPriceControllerNotifierProvider.notifier)
              .setState(limitPriceController.text);
        });
      });

      return;
    }, const []);

    useEffect(() {
      if (limitPriceController.text != priceString) {
        limitPriceController.text = priceString;
      }

      return;
    }, [priceString]);

    final indexPriceAsync = ref.watch(indexPriceButtonAsyncNotifierProvider);

    useEffect(() {
      indexPriceAsync.maybeWhen(
        data: (price) {
          limitPriceController.text = price;

          Future.microtask(() {
            ref.invalidate(indexPriceButtonAsyncNotifierProvider);
          });
        },
        orElse: () {},
      );

      return;
    }, [indexPriceAsync]);

    return optionQuoteAsset.match(
      () => SizedBox(),
      (quoteAsset) => MarketAmountTextField(
        caption:
            tradeDirState == TradeDir.SELL
                ? 'Offer price per unit'.tr()
                : 'Bid price per unit'.tr(),
        asset: quoteAsset,
        controller: limitPriceController,
        autofocus: true,
        focusNode: focusNode,
        onEditingComplete: () {},
        onChanged: (value) {},
        showConversion: showConversion,
        showBalance: showBalance,
        showAggregate: true,
        error:
            insufficientPrice
                ? LimitMinimumFeeError(
                  text: 'MINIMUM_MUL_FEE'.tr(args: [minimumFeeAmount]),
                )
                : null,
      ),
    );
  }
}
