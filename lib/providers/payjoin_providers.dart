import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'payjoin_providers.g.dart';

// 1. if lbtc balance > 0 then lbtc is default fee asset
// 2. if max lbtc is sent, then deduct fee is selected
// otherwise
// 3. if payjoin asset is on sending asset list and it's balance > 0
//  then this asset is choosen as fee asset (first which is found on payjoin list)
// 4. if choosen fee asset balance == max sent balance then deduct fee is selected
// 5. in all other cases lbtc is default fee asset without selection of deduct fee
// additionally:
// - deduct fee checkbox is disabled if fee asset balance == 0
// - multiple outputs aren't summed - user must manualy select the fee asset and deduct fee checkbox

@riverpod
class DeductFeeFromOutputEnabledNotifier
    extends _$DeductFeeFromOutputEnabledNotifier {
  @override
  bool build() {
    final eitherOutputsData = ref.watch(outputsCreatorProvider);
    final outputsData = eitherOutputsData.toOption().toNullable();
    if (outputsData == null || outputsData.receivers == null) {
      return false;
    }

    final payjoinFeeAsset = ref.watch(payjoinFeeAssetNotifierProvider);
    if (payjoinFeeAsset == null) {
      return false;
    }

    final selectedInputs = ref.watch(selectedInputsNotifierProvider);

    if (selectedInputs.isNotEmpty) {
      final maxBalance = ref.watch(
        maxAvailableBalanceWithInputsForAssetProvider(payjoinFeeAsset.assetId),
      );
      if (maxBalance > 0) {
        return true;
      }
      return false;
    }

    final maxBalance = ref.watch(
      availableBalanceForAssetIdProvider(payjoinFeeAsset.assetId),
    );
    if (maxBalance > 0) {
      return true;
    }
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}

@riverpod
class PayjoinRadioButtonIndexNotifier
    extends _$PayjoinRadioButtonIndexNotifier {
  @override
  int build() {
    return 0;
  }

  void setState(int value) {
    state = value;
  }
}

@riverpod
class DeductFeeFromOutputNotifier extends _$DeductFeeFromOutputNotifier {
  @override
  bool build() {
    final eitherOutputsData = ref.watch(outputsCreatorProvider);

    final outputsData = eitherOutputsData.toOption().toNullable();
    if (outputsData == null || outputsData.receivers == null) {
      return false;
    }

    final index = ref.watch(payjoinRadioButtonIndexNotifierProvider);

    final assetId = outputsData.receivers![index].assetId!;
    final outputSatoshi = outputsData.receivers![index].satoshi;
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    final selectedInputs = ref.watch(selectedInputsNotifierProvider);

    final payjoinFeeAsset = ref.watch(payjoinFeeAssetNotifierProvider);
    return switch (payjoinFeeAsset) {
      final payjoinFeeAsset when payjoinFeeAsset?.assetId == assetId => () {
        if (selectedInputs.isNotEmpty) {
          final maxBalance = ref.watch(
            maxAvailableBalanceWithInputsForAssetProvider(assetId),
          );
          if (maxBalance == outputSatoshi) {
            return true;
          }

          final liquidMaxBalance = ref.watch(
            maxAvailableBalanceWithInputsForAssetProvider(liquidAssetId),
          );
          // have LBTC
          if (liquidMaxBalance > 0) {
            return false;
          }

          return true;
        }

        final maxBalance = ref.watch(
          availableBalanceForAssetIdProvider(assetId),
        );
        if (maxBalance == outputSatoshi) {
          return true;
        }

        final liquidMaxBalance = ref.watch(
          availableBalanceForAssetIdProvider(liquidAssetId),
        );
        // have LBTC
        if (liquidMaxBalance > 0) {
          return false;
        }

        return true;
      },
      _ => () {
        return false;
      },
    }();
  }

  void setState(bool value) {
    state = value;
  }
}

@riverpod
bool liquidHaveBalance(Ref ref) {
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  if (selectedInputs.isNotEmpty) {
    // balance with inputs
    final maxBalance = ref.watch(
      maxAvailableBalanceWithInputsForAssetProvider(liquidAssetId),
    );
    return maxBalance > 0;
  }

  final maxBalance = ref.watch(
    availableBalanceForAssetIdProvider(liquidAssetId),
  );
  return maxBalance > 0;
}

@riverpod
class PayjoinFeeAssetNotifier extends _$PayjoinFeeAssetNotifier {
  @override
  Asset? build() {
    final payjoinFeeAssets = ref.watch(payjoinFeeAssetsProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    if (payjoinFeeAssets.isEmpty) {
      return null;
    }

    final liquidAsset = payjoinFeeAssets.firstWhere(
      (e) => e.assetId == liquidAssetId,
    );

    // if account have liquid balance then return lbtc
    final liquidHaveBalance = ref.watch(liquidHaveBalanceProvider);
    if (liquidHaveBalance) {
      return liquidAsset;
    }

    final eitherOutputsData = ref.watch(outputsCreatorProvider);
    final outputsData = eitherOutputsData.toOption().toNullable();

    // as default return lbtc
    // or if any output is lbtc then return lbtc too
    if (outputsData == null ||
        outputsData.receivers == null ||
        outputsData.receivers!.any((e) => e.assetId == liquidAssetId)) {
      return liquidAsset;
    }

    // outputs doesn't contain lbtc

    // if payjoin asset is found in outputs then return it
    final payjoinOutputAsset = payjoinFeeAssets.firstWhereOrNull(
      (e) =>
          outputsData.receivers!.any((output) => output.assetId == e.assetId),
    );

    if (payjoinOutputAsset != null) {
      return payjoinOutputAsset;
    }

    final selectedInputs = ref.watch(selectedInputsNotifierProvider);

    // otherwise check any payjoin asset max balance
    // if it have any balance then return it
    // or return liquid asset as default
    if (selectedInputs.isNotEmpty) {
      // balance with inputs
      return payjoinFeeAssets.firstWhere((e) {
        final maxBalance = ref.watch(
          maxAvailableBalanceWithInputsForAssetProvider(e.assetId),
        );
        return maxBalance > 0;
      }, orElse: () => liquidAsset);
    }

    // balance without inputs
    return payjoinFeeAssets.firstWhere((e) {
      final maxBalance = ref.watch(
        availableBalanceForAssetIdProvider(e.assetId),
      );
      return maxBalance > 0;
    }, orElse: () => liquidAsset);
  }

  void setState(Asset? asset) {
    final payjoinFeeAssets = ref.read(payjoinFeeAssetsProvider);
    if (!payjoinFeeAssets.any((item) => item.assetId == asset?.assetId)) {
      return;
    }

    state = asset;
  }
}

@riverpod
List<Asset> payjoinAssets(Ref ref) {
  final assets = ref.watch(assetsStateProvider);
  final payjoinAssets = assets.values.toList();
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  payjoinAssets.removeWhere(
    (item) => (!item.payjoin && item.assetId != liquidAssetId),
  );
  return payjoinAssets;
}

@riverpod
List<Asset> payjoinFeeAssets(Ref ref) {
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
  final allAccountAssets = [...ref.watch(allVisibleAccountAssetsProvider)];
  final payjoinAssets = [...ref.watch(payjoinAssetsProvider)];
  allAccountAssets.removeWhere((item) => item.account != Account.REG);
  payjoinAssets.removeWhere(
    (item) => !allAccountAssets.any(
      (accountAsset) =>
          item.assetId == accountAsset.assetId && item.assetId != liquidAssetId,
    ),
  );
  final assets = ref.watch(assetsStateProvider).values;
  final liquidAsset = assets.firstWhereOrNull(
    (asset) => asset.assetId == liquidAssetId,
  );
  if (liquidAsset != null) {
    payjoinAssets.add(liquidAsset);
  }

  return payjoinAssets;
}
