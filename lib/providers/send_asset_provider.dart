import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'send_asset_provider.g.dart';

@Riverpod(keepAlive: true)
class SendAssetNotifier extends _$SendAssetNotifier {
  @override
  AccountAsset build() {
    final eiCreateTransaction = ref.watch(eiCreateTransactionNotifierProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    return switch (eiCreateTransaction) {
      EICreateTransactionData() => eiCreateTransaction.accountAsset,
      _ => AccountAsset(AccountType.reg, liquidAssetId),
    };
  }

  void setSendAsset(AccountAsset value) {
    final balances = ref.read(balancesNotifierProvider);
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);

    (switch (balances[value]) {
      final assetBalance? when assetBalance != 0 => state = value,
      _ => state = AccountAsset(AccountType.reg, liquidAssetId),
    });
  }
}
