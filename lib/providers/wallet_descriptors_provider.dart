import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/models/wallet_descriptors.dart';

part 'wallet_descriptors_provider.g.dart';

/// Holds the wallet descriptors delivered on login. `null` = **not loaded**.
///
/// Written only from the login-success handler (`_handleLogin` in
/// `wallet.dart`) and invalidated on app-state cleanup. A payload with either
/// descriptor empty actively clears any previously held value back to `null`
/// (ADR-0002, decisions 1 and 6).
@Riverpod(keepAlive: true)
class WalletDescriptorsNotifier extends _$WalletDescriptorsNotifier {
  @override
  WalletDescriptors? build() {
    return null;
  }

  void setDescriptors(String nativeSegwit, String nestedSegwit) {
    state = (nativeSegwit.isNotEmpty && nestedSegwit.isNotEmpty)
        ? WalletDescriptors(
            nativeSegwit: nativeSegwit,
            nestedSegwit: nestedSegwit,
          )
        : null;
  }
}
