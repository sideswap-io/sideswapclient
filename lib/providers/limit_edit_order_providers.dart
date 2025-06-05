import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/limit_review_order_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'limit_edit_order_providers.g.dart';

@riverpod
OrderAmount limitEditOrderPrice(Ref ref) {
  final optionOrder = ref.watch(marketEditDetailsOrderNotifierProvider);

  final trackingValue = ref.watch(
    marketLimitTrackIndexPriceValueNotifierProvider,
  );

  final optionDecimalIndexPrice = ref.watch(marketDecimalIndexPriceProvider);
  final optionDecimalLastPrice = ref.watch(marketDecimalLastPriceProvider);

  final emptyOrderAmount = OrderAmount(
    amount: Decimal.zero,
    satoshi: 0,
    assetId: '',
    assetPair: AssetPair(),
  );

  return optionOrder.match(() => emptyOrderAmount, (order) {
    final optionQuoteAsset = order.quoteAsset;
    return optionQuoteAsset.match(() => emptyOrderAmount, (quoteAsset) {
      if (order.amountDecimal == Decimal.zero || quoteAsset.assetId.isEmpty) {
        return emptyOrderAmount;
      }

      if (order.isPriceTracking) {
        final decimalIndexPrice = optionDecimalIndexPrice.match(
          () => optionDecimalLastPrice.match(
            () => Decimal.zero,
            (indexPrice) => indexPrice.decimalLastPrice,
          ),
          (indexPrice) => indexPrice.decimalIndexPrice,
        );

        final decimalPrice =
            decimalIndexPrice * trackingValue.asDecimalPercent();

        final satoshiRepository = ref.watch(satoshiRepositoryProvider);

        final amountSatoshi = satoshiRepository.satoshiForAmount(
          amount: decimalPrice.toString(),
          assetId: quoteAsset.assetId,
        );

        return OrderAmount(
          amount: decimalPrice,
          satoshi: amountSatoshi,
          assetId: quoteAsset.assetId,
          assetPair: order.assetPair,
        );
      }

      return emptyOrderAmount;
    });
  });
}
