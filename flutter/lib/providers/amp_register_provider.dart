import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class SecuritiesItem {
  final String? assetId;
  final String token;
  final String icon;

  SecuritiesItem(this.token, this.icon, {this.assetId});
}

final stokrSecuritiesProvider = AutoDisposeProvider((ref) {
  final List<SecuritiesItem> assets = [];
  assets.add(SecuritiesItem('BMN', 'assets/bmn.svg',
      assetId:
          '11f91cb5edd5d0822997ad81f068ed35002daec33986da173461a8427ac857e1'));
  assets.add(SecuritiesItem('EXO', 'assets/tx_icons/unknown.svg',
      assetId:
          "0db21df3ca7d71f0fb9aafb019e67d0a23c3c79a11eb9e8c4e32e1cb5910e2da"));
  assets.add(SecuritiesItem('AQF', '',
      assetId:
          '3caca4d1e7c596d4f59db73d62e514963c098cc327cab550bd460a9927f5fdbe'));
  return assets;
});

final pegxSecuritiesProvider = AutoDisposeProvider((ref) {
  final List<SecuritiesItem> assets = [];
  assets.add(SecuritiesItem('SSWP', 'assets/logo.svg',
      assetId:
          '06d1085d6a3a1328fb8189d106c7a8afbef3d327e34504828c4cac2c74ac0802'));
  return assets;
});

final stokrGaidStateProvider =
    AutoDisposeStateNotifierProvider<StokrGaidNotifier, StokrGaidState>((ref) {
  final ampId = ref.watch(ampIdProvider);
  return StokrGaidNotifier(ref, ampId);
});

class StokrGaidNotifier extends StateNotifier<StokrGaidState> {
  final Ref ref;
  final String ampId;

  StokrGaidNotifier(this.ref, this.ampId)
      : super(const StokrGaidStateLoading()) {
    final assetId = ref
        .read(stokrSecuritiesProvider)
        .where((e) => e.token == 'BMN')
        .first
        .assetId;

    if (ampId.isNotEmpty && assetId != null) {
      ref.read(walletProvider).checkGaidStatus(ampId, assetId);
    }
  }

  void setState(StokrGaidState value) {
    state = value;
  }
}
