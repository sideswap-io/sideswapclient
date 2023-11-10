import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

final sendAssetProvider =
    AutoDisposeNotifierProvider<SendAssetNotifier, AccountAsset>(
        SendAssetNotifier.new);

class SendAssetNotifier extends AutoDisposeNotifier<AccountAsset> {
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
    final balances = ref.read(balancesProvider);
    if ((balances.balances[value] ?? 0) != 0) {
      state = value;
    } else {
      final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
      state = AccountAsset(AccountType.reg, liquidAssetId);
    }
  }
}
