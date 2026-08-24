import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_descriptors.freezed.dart';

/// The two CT wallet descriptors delivered on a successful login, exposed so the
/// user can load a watch-only wallet (see ADR-0002 and CONTEXT.md#wallet-descriptors).
///
/// Held by `walletDescriptorsProvider` as a nullable value: `null` means the
/// descriptors are **not loaded** (no successful login yet, or an invalid
/// payload cleared them). Both fields are non-empty whenever an instance exists.
@freezed
abstract class WalletDescriptors with _$WalletDescriptors {
  const factory WalletDescriptors({
    required String nativeSegwit,
    required String nestedSegwit,
  }) = _WalletDescriptors;
}
