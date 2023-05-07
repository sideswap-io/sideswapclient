import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';

final sendAssetProvider =
    AutoDisposeStateNotifierProvider<SendAssetNotifier, AccountAsset>((ref) {
  ref.keepAlive();
  final liquidAssetId = ref.watch(liquidAssetIdProvider);
  return SendAssetNotifier(ref, liquidAssetId);
});

class SendAssetNotifier extends StateNotifier<AccountAsset> {
  final Ref ref;
  final String liquidAssetId;

  SendAssetNotifier(this.ref, this.liquidAssetId)
      : super(AccountAsset(AccountType.reg, liquidAssetId));

  void setSendAsset(AccountAsset value) {
    final balances = ref.read(balancesProvider);
    if ((balances.balances[value] ?? 0) != 0) {
      state = value;
    } else {
      state = AccountAsset(AccountType.reg, liquidAssetId);
    }
  }
}
