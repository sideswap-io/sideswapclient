import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'satoshi_providers.g.dart';

@riverpod
AbstractSatoshiRepository satoshiRepository(Ref ref) {
  final assetUtils = ref.watch(assetUtilsProvider);
  return SatoshiRepository(ref: ref, assetUtils: assetUtils);
}

abstract class AbstractSatoshiRepository {
  int? parseAssetAmount({required String amount, required int precision});

  int satoshiForAmount({String? assetId, required String amount});
}

class SatoshiRepository implements AbstractSatoshiRepository {
  final Ref ref;
  final AssetUtils assetUtils;

  SatoshiRepository({required this.ref, required this.assetUtils});

  @override
  int? parseAssetAmount({required String amount, required int precision}) {
    if (precision < 0 || precision > 8) {
      return null;
    }

    final newValue = amount.replaceAll(' ', '');
    final newAmount = Decimal.tryParse(newValue);

    if (newAmount == null) {
      return null;
    }

    // cut to precision if original precision is too big
    final fixedAmount = newAmount.toStringAsFixed(precision);
    final fixedAmountDec = Decimal.tryParse(fixedAmount);

    if (fixedAmountDec == null) {
      return null;
    }

    final amountDec =
        fixedAmountDec * Decimal.fromInt(pow(10, precision).toInt());

    final amountInt = amountDec.toBigInt().toInt();

    if (Decimal.fromInt(amountInt) != amountDec) {
      return null;
    }

    return amountInt;
  }

  @override
  int satoshiForAmount({String? assetId, required String amount}) {
    final precision = assetUtils.getPrecisionForAssetId(assetId: assetId);
    return parseAssetAmount(amount: amount, precision: precision) ?? 0;
  }
}
