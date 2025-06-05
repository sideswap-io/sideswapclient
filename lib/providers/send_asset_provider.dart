import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/endpoint_internal_model.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/endpoint_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'send_asset_provider.g.dart';

@Riverpod(keepAlive: true)
class SendAssetIdNotifier extends _$SendAssetIdNotifier {
  @override
  String build() {
    ref.listen(eiCreateTransactionNotifierProvider, (_, next) {
      if (next is EICreateTransactionData) {
        setSendAsset(next.assetId);
      }
    });

    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    return liquidAssetId;
  }

  void setSendAsset(String value) {
    final balances = ref.read(assetBalanceProvider);
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);

    (switch (balances[value]) {
      final assetBalance? when assetBalance != 0 => state = value,
      _ => state = liquidAssetId,
    });
  }
}
