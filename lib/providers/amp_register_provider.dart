import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

part 'amp_register_provider.g.dart';

class SecuritiesItem {
  final String token;
  final String icon;
  final String? assetId;
  SecuritiesItem({
    required this.token,
    required this.icon,
    this.assetId,
  });

  SecuritiesItem copyWith({
    String? token,
    String? icon,
    String? assetId,
  }) {
    return SecuritiesItem(
      token: token ?? this.token,
      icon: icon ?? this.icon,
      assetId: assetId ?? this.assetId,
    );
  }

  @override
  String toString() =>
      'SecuritiesItem(token: $token, icon: $icon, assetId: $assetId)';

  (String, String, String?) _equality() => (token, icon, assetId);

  @override
  bool operator ==(covariant SecuritiesItem other) {
    if (identical(this, other)) return true;

    return other._equality() == _equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}

@riverpod
List<SecuritiesItem> stokrSecurities(StokrSecuritiesRef ref) {
  final assets = ref.watch(assetsStateProvider);
  return assets.values
      .where((element) =>
          element.hasDomainAgent() && element.domainAgent.contains('stokr.io'))
      .map((e) => SecuritiesItem(token: e.ticker, assetId: e.assetId, icon: ''))
      .toList();
}

@riverpod
List<SecuritiesItem> pegxSecurities(PegxSecuritiesRef ref) {
  final assets = ref.watch(assetsStateProvider);
  return assets.values
      .where((element) =>
          element.hasDomainAgent() && element.domainAgent.contains('pegx.io'))
      .map((e) => SecuritiesItem(token: e.ticker, assetId: e.assetId, icon: ''))
      .toList();
}

// (malcolmpl): it must maintain state for the entire life of the application!
@Riverpod(keepAlive: true)
class StokrGaidNotifier extends _$StokrGaidNotifier {
  @override
  StokrGaidState build() {
    return const StokrGaidStateEmpty();
  }

  void setStokrGaidState(StokrGaidState value) {
    state = value;
  }
}

@riverpod
CheckAmpStatusProvider checkAmpStatus(CheckAmpStatusRef ref) {
  final loginState = ref.watch(serverLoginNotifierProvider);
  final ampId = ref.watch(ampIdNotifierProvider);
  final pegxAssetId = ref
      .watch(pegxSecuritiesProvider)
      .where((e) => e.token == 'SSWP')
      .first
      .assetId;

  final stokrSecurities = ref.watch(stokrSecuritiesProvider);

  return CheckAmpStatusProvider(
    ref: ref,
    loginState: loginState,
    ampId: ampId,
    pegxAssetId: pegxAssetId,
    stokrAssetId:
        stokrSecurities.isNotEmpty ? stokrSecurities.first.assetId : null,
  );
}

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
          .setStokrGaidState(const StokrGaidStateLoading());
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
