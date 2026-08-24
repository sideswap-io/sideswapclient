import 'dart:math' show pow;

import 'package:fixnum/fixnum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'autosign_provider.g.dart';

/// Wallet must read [isAutosign] once at sign-request handler entry, not from a stale closure.
@riverpod
class Autosign extends _$Autosign {
  @override
  Map<String, bool> build() {
    return ref.watch(configurationProvider).autosignDomains;
  }

  bool isAutosign(String domain) => state[domain] == true;

  void setAutosign(String domain, bool value) {
    ref.read(configurationProvider.notifier).setAutosignForDomain(domain, value);
  }

  void removeAutosign(String domain) {
    ref.read(configurationProvider.notifier).setAutosignForDomain(domain, false);
  }
}

// ── USD threshold check ───────────────────────────────────────────────────────

/// Reason why a sign request is ineligible for autosign.
/// Null return from [isSignRequestWithinAutosignUsdLimit] means eligible.
enum AutosignFallthrough {
  emptyPayload,   // no balances, recipients, or networkFee
  unknownAsset,   // assetId empty or not in assets map
  zeroQuantity,   // reserved — currently unreachable (abs() used for outgoing amounts)
  missingPrice,   // assetId not in pricesUsd map
  overLimit;      // component USD notional exceeds 100 USDT cap

  String get description => switch (this) {
    emptyPayload  => 'degenerate empty payload',
    unknownAsset  => 'unknown or unrecognised asset',
    zeroQuantity  => 'zero or negative quantity component',
    missingPrice  => 'missing price for asset',
    overLimit     => 'component exceeds 100 USDT cap',
  };
}

const _kAutosignUsdCap = 100.0;

/// Returns null when every value component of [sign] is within the 100 USDT cap
/// (eligible for autosign), or the [AutosignFallthrough] reason otherwise.
/// Caller is responsible for logger.w on non-null result (FR-012c).
///
/// Call from wallet._handleSignerRequest after reading the providers:
/// ```dart
/// isSignRequestWithinAutosignUsdLimit(
///   pricesUsd:     ref.read(portfolioPricesProvider),
///   assets:        ref.read(assetUtilsProvider).assets,
///   liquidAssetId: ref.read(liquidAssetIdStateProvider),
///   sign:          signerRequest.sign,
/// )
/// ```
AutosignFallthrough? isSignRequestWithinAutosignUsdLimit({
  required Map<String, double> pricesUsd,
  required Map<String, Asset> assets,
  required String liquidAssetId,
  required From_SignerRequest_Sign sign,
}) {
  AutosignFallthrough? withinCap(String assetId, Int64 amount) {
    if (assetId.isEmpty || !assets.containsKey(assetId)) {
      return AutosignFallthrough.unknownAsset;
    }
    if (amount == Int64.ZERO) return null; // zero contributes $0 — within cap
    final unitPrice = pricesUsd[assetId];
    if (unitPrice == null) return AutosignFallthrough.missingPrice;
    final precision = assets[assetId]?.precision ?? 8;
    // Use abs(): negative amounts represent outgoing value (what we pay) — still
    // has a USD notional that must be within cap. Double arithmetic is fine here.
    final quantity = amount.abs().toDouble() / pow(10, precision);
    final usdNotional = quantity * unitPrice;
    return usdNotional.isFinite && usdNotional <= _kAutosignUsdCap
        ? null
        : AutosignFallthrough.overLimit;
  }

  // Degenerate: no monetary components — treat as ineligible.
  if (sign.balances.isEmpty && sign.recipients.isEmpty && !sign.hasNetworkFee()) {
    return AutosignFallthrough.emptyPayload;
  }

  // balances[] = NET wallet change for the user (negative = outgoing risk).
  // abs() applied — only the magnitude matters for the cap.
  // recipients[] excluded — contains change-to-self, other parties' outputs, etc.
  for (final balance in sign.balances) {
    final reason = withinCap(balance.assetId, balance.amount);
    if (reason != null) return reason;
  }
  if (sign.hasNetworkFee()) {
    final reason = withinCap(liquidAssetId, sign.networkFee);
    if (reason != null) return reason;
  }

  return null;
}
