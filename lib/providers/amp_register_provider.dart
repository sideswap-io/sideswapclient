import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/connection_state_providers.dart';

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

final stokrGaidNotifierProvider =
    AutoDisposeNotifierProvider<StokrGaidNotifier, StokrGaidState>(
        StokrGaidNotifier.new);

class StokrGaidNotifier extends AutoDisposeNotifier<StokrGaidState> {
  @override
  StokrGaidState build() {
    return const StokrGaidStateEmpty();
  }

  void setState(StokrGaidState value) {
    state = value;
  }
}

final checkAmpStatusProvider =
    AutoDisposeProvider<CheckAmpStatusProvider>((ref) {
  final loginState = ref.watch(serverLoginStateProvider);
  final ampId = ref.watch(ampIdProvider);
  final pegxAssetId = ref
      .watch(pegxSecuritiesProvider)
      .where((e) => e.token == 'SSWP')
      .first
      .assetId;

  final stokrAssetId = ref
      .watch(stokrSecuritiesProvider)
      .where((e) => e.token == 'BMN')
      .first
      .assetId;

  return CheckAmpStatusProvider(
    ref: ref,
    loginState: loginState,
    ampId: ampId,
    pegxAssetId: pegxAssetId,
    stokrAssetId: stokrAssetId,
  );
});

class CheckAmpStatusProvider {
  final Ref ref;
  final ServerLoginState loginState;
  final String ampId;
  final String? pegxAssetId;
  final String? stokrAssetId;

  CheckAmpStatusProvider({
    required this.ref,
    required this.loginState,
    required this.ampId,
    this.pegxAssetId,
    this.stokrAssetId,
  });

  void refreshAmpStatus() {
    Future.microtask(() {
      // cleanup amp states before recheck
      ref
          .read(pegxGaidNotifierProvider.notifier)
          .setState(const PegxGaidStateLoading());
      ref
          .read(stokrGaidNotifierProvider.notifier)
          .setState(const StokrGaidStateLoading());
    }).then((_) {
      if (loginState != const ServerLoginStateLogin()) {
        return;
      }

      // refresh gaid status every time when server is connected
      if (ampId.isNotEmpty && pegxAssetId != null) {
        ref.read(walletProvider).checkGaidStatus(ampId, pegxAssetId!);
      }

      if (ampId.isNotEmpty && stokrAssetId != null) {
        ref.read(walletProvider).checkGaidStatus(ampId, stokrAssetId!);
      }
    });
  }
}
