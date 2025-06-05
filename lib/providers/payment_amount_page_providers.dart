import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'payment_amount_page_providers.g.dart';

@riverpod
class PaymentPageSelectedAssetIdNotifier
    extends _$PaymentPageSelectedAssetIdNotifier {
  @override
  String build() {
    final result = ref.watch(paymentAmountPageArgumentsNotifierProvider).result;
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    // use regular wallet lbtc if assetid is lbtc or is empty
    if (result?.assetId == null || result?.assetId == liquidAssetId) {
      return liquidAssetId;
    }

    // let's check other assets and return it if found and balance is > 0
    final assetBalances = ref.watch(assetBalanceProvider);
    for (final assetId in assetBalances.keys) {
      if (assetId == result?.assetId && assetBalances[assetId] != 0) {
        return assetId;
      }
    }

    // otherwise use regular wallet with given assetId
    return result!.assetId!;
  }

  void setState(String assetid) {
    state = assetid;
  }
}

@riverpod
Option<Asset> paymentPageSelectedAsset(Ref ref) {
  final assetId = ref.watch(paymentPageSelectedAssetIdNotifierProvider);
  final assetsState = ref.watch(assetsStateProvider);
  final asset = assetsState[assetId];

  if (asset != null) {
    return Option.of(asset);
  }

  return Option.none();
}

@riverpod
AbstractPaymentPageRepository paymentPageRepository(Ref ref) {
  final optionAsset = ref.watch(paymentPageSelectedAssetProvider);
  return PaymentPageRepository(optionAsset);
}

abstract class AbstractPaymentPageRepository {
  Future<void> validate(String value);
}

class PaymentPageRepository extends AbstractPaymentPageRepository {
  final Option<Asset> optionAsset;

  PaymentPageRepository(this.optionAsset);

  @override
  Future<void> validate(String value) async {
    // if (value.isEmpty) {
    //   await Future.microtask(
    //     () => ref
    //         .read(paymentInsufficientFundsNotifierProvider.notifier)
    //         .setInsufficientFunds(false),
    //   );
    //   enabled.value = false;
    //   amount.value = '0';
    //   return;
    // }

    // final precision = ref
    //     .read(assetUtilsProvider)
    //     .getPrecisionForAssetId(assetId: accountAsset.assetId);
    // final balance = ref.read(balancesNotifierProvider)[accountAsset];
    // final newValue = value.replaceAll(' ', '');
    // final newAmount = double.tryParse(newValue)?.toDouble();
    // final amountStr = ref
    //     .read(amountToStringProvider)
    //     .amountToString(
    //       AmountToStringParameters(amount: balance ?? 0, precision: precision),
    //     );
    // final realBalance = double.tryParse(amountStr);

    // if (newAmount == null || realBalance == null) {
    //   enabled.value = false;
    //   amount.value = '0';
    //   return;
    // }

    // amount.value = newValue;

    // if (newAmount <= 0) {
    //   enabled.value = false;
    //   return;
    // }

    // if (newAmount <= realBalance) {
    //   enabled.value = true;

    //   await Future.microtask(
    //     () => ref
    //         .read(paymentInsufficientFundsNotifierProvider.notifier)
    //         .setInsufficientFunds(false),
    //   );
    //   return;
    // }

    // enabled.value = false;

    // await Future.microtask(
    //   () => ref
    //       .read(paymentInsufficientFundsNotifierProvider.notifier)
    //       .setInsufficientFunds(true),
    // );
  }
}

@riverpod
Iterable<String> paymentPageSendAssetsWithBalance(Ref ref) {
  final assetBalances = ref.watch(assetBalanceProvider);

  final assetsWithBalance = assetBalances.entries
      .where((e) => e.value > 0)
      .map((e) => e.key);

  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  if (assetsWithBalance.isEmpty) {
    return [liquidAssetId];
  }

  return assetsWithBalance;
}
