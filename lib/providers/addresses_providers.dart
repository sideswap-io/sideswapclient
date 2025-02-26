import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/inputs_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'addresses_providers.g.dart';
part 'addresses_providers.freezed.dart';

@freezed
sealed class UtxosItem with _$UtxosItem {
  const factory UtxosItem({
    String? txid,
    int? vout,
    String? assetId,
    int? amount,
    bool? isInternal,
    bool? isConfidential,
    int? account,
  }) = _UtxosItem;
}

@freezed
sealed class AddressesItem with _$AddressesItem {
  const factory AddressesItem({
    int? account,
    String? address,
    String? unconfidentialAddress,
    int? index,
    bool? isInternal,
    List<UtxosItem>? utxos,
  }) = _AddressesItem;
}

@freezed
sealed class AddressesModel with _$AddressesModel {
  const factory AddressesModel({List<AddressesItem>? addresses}) =
      _AddressesModel;
}

@freezed
sealed class LoadAddressesState with _$LoadAddressesState {
  const factory LoadAddressesState.empty() = LoadAddressesStateEmpty;
  const factory LoadAddressesState.loading() = LoadAddressesStateLoading;
  const factory LoadAddressesState.data(From_LoadAddresses loadAddresses) =
      LoadAddressesStateData;
  const factory LoadAddressesState.error(String errorMsg) =
      LoadAddressesStateError;
}

@riverpod
class LoadAddressesStateNotifier extends _$LoadAddressesStateNotifier {
  @override
  LoadAddressesState build() {
    return const LoadAddressesStateEmpty();
  }

  void setLoadAddressesState(LoadAddressesState value) {
    state = value;
  }
}

@freezed
sealed class LoadUtxosState with _$LoadUtxosState {
  const factory LoadUtxosState.empty() = LoadUtxosStateEmpty;
  const factory LoadUtxosState.loading() = LoadUtxosStateLoading;
  const factory LoadUtxosState.data(From_LoadUtxos loadUtxos) =
      LoadUtxosStateData;
  const factory LoadUtxosState.error(String errorMsg) = LoadUtxosStateError;
}

@riverpod
class LoadUtxosStateNotifier extends _$LoadUtxosStateNotifier {
  @override
  LoadUtxosState build() {
    return const LoadUtxosStateEmpty();
  }

  void setLoadUtxosState(LoadUtxosState value) {
    state = value;
  }
}

@riverpod
class AddressesAsyncNotifier extends _$AddressesAsyncNotifier {
  @override
  FutureOr<AddressesModel> build(Account account) {
    final loadAddressesState = ref.watch(loadAddressesStateNotifierProvider);
    final loadUtxosState = ref.watch(loadUtxosStateNotifierProvider);

    if (loadAddressesState is LoadAddressesStateData &&
        loadAddressesState.loadAddresses.account != account) {
      return future;
    }

    if (loadAddressesState is LoadAddressesStateData &&
        loadUtxosState is LoadUtxosStateData) {
      final addresses = loadAddressesState.loadAddresses.addresses;
      final utxos = loadUtxosState.loadUtxos.utxos;

      final addressesItemList = <AddressesItem>[];
      for (final a in addresses) {
        final found = utxos.where((element) => element.address == a.address);
        final utxosItemList = <UtxosItem>[];
        for (final f in found) {
          utxosItemList.add(
            UtxosItem(
              txid: f.txid,
              vout: f.vout,
              assetId: f.assetId,
              amount: f.amount.toInt(),
              isInternal: f.isInternal,
              isConfidential: f.isConfidential,
              account: account.id,
            ),
          );
        }

        addressesItemList.add(
          AddressesItem(
            account: account.id,
            address: a.address,
            unconfidentialAddress: a.unconfidentialAddress,
            index: a.index,
            isInternal: a.isInternal,
            utxos: utxosItemList,
          ),
        );
      }

      return AddressesModel(addresses: addressesItemList);
    }

    if (loadAddressesState is LoadAddressesStateEmpty &&
        loadUtxosState is LoadUtxosStateEmpty) {
      updateData(account);
    }

    return future;
  }

  void updateData(Account account) {
    ref.read(walletProvider).loadAddresses(account);
    ref.read(walletProvider).loadUtxos(account);
  }
}

@riverpod
AsyncValue<AddressesModel> regularAddressesModelAsync(Ref ref) {
  final regularModel = ref.watch(
    addressesAsyncNotifierProvider(Account(id: 0)),
  );

  return switch (regularModel) {
    AsyncValue(hasValue: true, value: AddressesModel addressesModel) =>
      AsyncValue.data(addressesModel),
    _ => const AsyncValue.loading(),
  };
}

@riverpod
AsyncValue<AddressesModel> ampAdressesModelAsync(Ref ref) {
  final ampModel = ref.watch(addressesAsyncNotifierProvider(Account(id: 1)));

  return switch (ampModel) {
    AsyncValue(hasValue: true, value: AddressesModel addressesModel) =>
      AsyncValue.data(addressesModel),
    _ => const AsyncValue.loading(),
  };
}

@riverpod
AsyncValue<AddressesModel> groupedAddressesAsync(Ref ref) {
  final regularAddressesModelAsync = ref.watch(
    regularAddressesModelAsyncProvider,
  );
  final ampAddressesModelAsync = ref.watch(ampAdressesModelAsyncProvider);

  final regularAddressesModel = regularAddressesModelAsync.maybeWhen(
    data: (data) => data,
    orElse: () => null,
  );
  final ampAddressesModel = ampAddressesModelAsync.maybeWhen(
    data: (data) => data,
    orElse: () => null,
  );

  if (regularAddressesModel == null && ampAddressesModel == null) {
    return const AsyncValue.loading();
  }

  final addresses = <AddressesItem>[];
  addresses.addAll(regularAddressesModel?.addresses ?? []);
  addresses.addAll(ampAddressesModel?.addresses ?? []);

  return AsyncValue.data(AddressesModel(addresses: addresses));
}

@riverpod
AsyncValue<AddressesModel> filteredAddressesAsync(Ref ref) {
  final groupedAddresses = ref.watch(groupedAddressesAsyncProvider);

  final addressesModel = switch (groupedAddresses) {
    AsyncValue(hasValue: true, value: AddressesModel addressesModel) =>
      addressesModel,
    _ => null,
  };

  if (addressesModel == null) {
    return const AsyncValue.loading();
  }

  final walletTypeFlag = ref.watch(addressesWalletTypeFlagNotifierProvider);

  var addresses = addressesModel.addresses ?? [];
  addresses =
      switch (walletTypeFlag) {
        AddressesWalletTypeFlagRegular() => addresses.where(
          (element) => element.account == 0,
        ),
        AddressesWalletTypeFlagAmp() => addresses.where(
          (element) => element.account == 1,
        ),
        _ => addresses,
      }.toList();

  final addressTypeFlag = ref.watch(addressesAddressTypeFlagNotifierProvider);

  addresses =
      switch (addressTypeFlag) {
        AddressesAddressTypeFlagInternal() => addresses.where(
          (element) => element.isInternal == true,
        ),
        AddressesAddressTypeFlagExternal() => addresses.where(
          (element) => element.isInternal == false,
        ),
        _ => addresses,
      }.toList();

  final balanceTypeFlag = ref.watch(addressesBalanceTypeFlagNotifierProvider);

  addresses =
      switch (balanceTypeFlag) {
        AddressesBalanceFlagHideEmpty() => addresses.where(
          (element) => element.utxos?.isNotEmpty == true,
        ),
        _ => addresses,
      }.toList();

  return AsyncValue.data(AddressesModel(addresses: addresses));
}

@freezed
sealed class AddressDetailsState with _$AddressDetailsState {
  const factory AddressDetailsState.empty() = AddressDetailsStateEmpty;
  const factory AddressDetailsState.data(AddressesItem addressesItem) =
      AddressDetailsStateData;
}

@Riverpod(keepAlive: true)
class AddressDetailsDialogNotifier extends _$AddressDetailsDialogNotifier {
  @override
  AddressDetailsState build() {
    return const AddressDetailsStateEmpty();
  }

  void setAddressDetailsItem(AddressesItem addressesItem) {
    state = AddressDetailsStateData(addressesItem);
  }
}

@riverpod
AddressesItemHelper addressesItemHelper(Ref ref, AddressesItem addressesItem) {
  return AddressesItemHelper(ref: ref, addressesItem: addressesItem);
}

class AddressesItemHelper {
  final Ref ref;
  final AddressesItem addressesItem;

  AddressesItemHelper({required this.ref, required this.addressesItem});

  bool isRegular() {
    return addressesItem.account == 0;
  }

  bool isInternal() {
    return addressesItem.isInternal == true;
  }

  int addressIndex() {
    return addressesItem.index ?? 0;
  }

  String address() {
    return addressesItem.address ?? '';
  }

  int utxoCount() {
    return addressesItem.utxos!.length;
  }

  Widget asset() {
    return switch (utxoCount()) {
      1 => ref
          .read(assetImageRepositoryProvider)
          .getCustomImage(
            addressesItem.utxos!.first.assetId,
            width: 24,
            height: 24,
          ),
      _ when utxoCount() > 1 => Text(
        'Multiple'.tr(),
        textAlign: TextAlign.left,
      ),
      _ => const SizedBox(),
    };
  }

  Widget amount() {
    final precision = switch (utxoCount()) {
      1 => ref
          .read(assetUtilsProvider)
          .getPrecisionForAssetId(
            assetId: addressesItem.utxos!.first.assetId ?? '',
          ),
      _ => 0,
    };

    final amountStr = switch (utxoCount()) {
      1 => ref
          .read(amountToStringProvider)
          .amountToString(
            AmountToStringParameters(
              amount: addressesItem.utxos?.first.amount ?? 0,
              precision: precision,
            ),
          ),
      _ => '',
    };

    return switch (utxoCount()) {
      1 => Text(amountStr, textAlign: TextAlign.left),
      _ => const SizedBox(),
    };
  }
}

@freezed
sealed class AddressesWalletTypeFlag with _$AddressesWalletTypeFlag {
  const factory AddressesWalletTypeFlag.all() = AddressesWalletTypeFlagAll;
  const factory AddressesWalletTypeFlag.regular() =
      AddressesWalletTypeFlagRegular;
  const factory AddressesWalletTypeFlag.amp() = AddressesWalletTypeFlagAmp;
}

@riverpod
class AddressesWalletTypeFlagNotifier
    extends _$AddressesWalletTypeFlagNotifier {
  @override
  AddressesWalletTypeFlag build() {
    return const AddressesWalletTypeFlag.all();
  }

  void setFlag(AddressesWalletTypeFlag flag) {
    state = flag;
  }
}

@freezed
sealed class AddressesAddressTypeFlag with _$AddressesAddressTypeFlag {
  const factory AddressesAddressTypeFlag.all() = AddressesAddressTypeFlagAll;
  const factory AddressesAddressTypeFlag.internal() =
      AddressesAddressTypeFlagInternal;
  const factory AddressesAddressTypeFlag.external() =
      AddressesAddressTypeFlagExternal;
}

@riverpod
class AddressesAddressTypeFlagNotifier
    extends _$AddressesAddressTypeFlagNotifier {
  @override
  AddressesAddressTypeFlag build() {
    return const AddressesAddressTypeFlag.all();
  }

  void setFlag(AddressesAddressTypeFlag flag) {
    state = flag;
  }
}

@freezed
sealed class AddressesBalanceFlag with _$AddressesBalanceFlag {
  const factory AddressesBalanceFlag.showAll() = AddressesBalanceFlagShowAll;
  const factory AddressesBalanceFlag.hideEmpty() =
      AddressesBalanceFlagHideEmpty;
}

@riverpod
class AddressesBalanceTypeFlagNotifier
    extends _$AddressesBalanceTypeFlagNotifier {
  @override
  AddressesBalanceFlag build() {
    final groupedAddresses = ref.watch(groupedAddressesAsyncProvider);

    final addressesModel = switch (groupedAddresses) {
      AsyncValue(hasValue: true, value: AddressesModel addressesModel) =>
        addressesModel,
      _ => null,
    };
    if (addressesModel != null) {
      final foundTxs =
          addressesModel.addresses?.any(
            (element) => element.utxos?.isNotEmpty == true,
          ) ??
          false;

      if (foundTxs) {
        return const AddressesBalanceFlag.hideEmpty();
      }
    }
    return const AddressesBalanceFlag.hideEmpty();
  }

  void setFlag(AddressesBalanceFlag flag) {
    state = flag;
  }
}

@riverpod
AsyncValue<AddressesModel> inputsAddressesAsync(Ref ref) {
  final groupedAddresses = ref.watch(groupedAddressesAsyncProvider);

  final addressesModel = switch (groupedAddresses) {
    AsyncValue(hasValue: true, value: AddressesModel addressesModel) =>
      addressesModel,
    _ => null,
  };

  if (addressesModel == null) {
    return const AsyncValue.loading();
  }

  final walletTypeFlag = ref.watch(inputsWalletTypeFlagNotifierProvider);

  final accountId = switch (walletTypeFlag) {
    InputsWalletTypeFlagRegular() => 0,
    _ => 1,
  };

  final newAddresses =
      addressesModel.addresses
          ?.where(
            (element) =>
                element.utxos?.isNotEmpty == true &&
                element.account == accountId,
          )
          .toList();

  return AsyncValue.data(AddressesModel(addresses: newAddresses));
}

@riverpod
class SelectedInputsNotifier extends _$SelectedInputsNotifier {
  @override
  List<UtxosItem> build() {
    ref.watch(inputsWalletTypeFlagNotifierProvider);
    return [];
  }

  void addItem(UtxosItem? item) {
    if (item == null) {
      return;
    }

    if (_contains(item)) {
      return;
    }

    final utxos = [...state];
    utxos.add(item);
    state = utxos;
  }

  void addAllItems(List<UtxosItem>? items) {
    if (items == null) {
      return;
    }

    for (final utxo in items) {
      if (_contains(utxo)) {
        continue;
      }

      addItem(utxo);
    }
  }

  void addAllItemsFromModel(AddressesModel addressesModel) {
    if (addressesModel.addresses == null) {
      return;
    }

    for (final addressesItem in addressesModel.addresses!) {
      addAllItems(addressesItem.utxos);
    }
  }

  void removeAll() {
    state = <UtxosItem>[];
  }

  void removeAllItems(List<UtxosItem>? items) {
    if (items == null) {
      return;
    }

    for (final utxo in items) {
      removeItem(utxo);
    }
  }

  void removeItem(UtxosItem? item) {
    if (item == null) {
      return;
    }

    final utxos = [...state];
    utxos.removeWhere((element) => element == item);
    state = utxos;
  }

  bool _contains(UtxosItem? item) {
    if (item == null) {
      return false;
    }

    final utxos = [...state];
    return utxos.any((element) => element == item);
  }
}

@riverpod
SelectedInputsHelper selectedInputsHelper(Ref ref) {
  final selectedInputs = ref.watch(selectedInputsNotifierProvider);
  return SelectedInputsHelper(ref: ref, utxos: selectedInputs);
}

class SelectedInputsHelper {
  final Ref ref;
  final List<UtxosItem> utxos;

  SelectedInputsHelper({required this.ref, required this.utxos});

  bool contains(UtxosItem? item) {
    if (item == null) {
      return false;
    }

    return utxos.any((element) => element == item);
  }

  bool containsAll(List<UtxosItem>? items) {
    if (items == null) {
      return false;
    }

    for (final utxo in items) {
      if (!contains(utxo)) {
        return false;
      }
    }

    return true;
  }

  bool containsModel(AddressesModel addressesModel) {
    if (addressesModel.addresses == null) {
      return false;
    }

    for (final addressesItem in addressesModel.addresses!) {
      if (!containsAll(addressesItem.utxos)) {
        return false;
      }
    }

    return true;
  }

  int count() {
    return utxos.length;
  }

  String lbtcTotalAmount() {
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);

    var satoshiSum = 0;
    for (final utxo in utxos) {
      if (utxo.assetId == liquidAssetId) {
        satoshiSum += utxo.amount ?? 0;
      }
    }

    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: liquidAssetId);
    final amountStr = ref
        .read(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(amount: satoshiSum, precision: precision),
        );
    0;

    return amountStr;
  }

  String utxoAmount({required UtxosItem? utxo}) {
    if (utxo == null) {
      return '0.0';
    }

    final precision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: utxo.assetId);
    final amountStr = ref
        .read(amountToStringProvider)
        .amountToString(
          AmountToStringParameters(
            amount: utxo.amount ?? 0,
            precision: precision,
          ),
        );
    0;

    return amountStr;
  }

  Widget utxoAsset({required UtxosItem? utxo}) {
    return switch (utxo) {
      UtxosItem() => ref
          .read(assetImageRepositoryProvider)
          .getCustomImage(utxo.assetId, width: 24, height: 24),
      _ => const SizedBox(),
    };
  }

  String utxoTicker({required UtxosItem? utxo}) {
    return switch (utxo) {
      UtxosItem() => ref
          .read(assetUtilsProvider)
          .tickerForAssetId(utxo.assetId),
      _ => '',
    };
  }

  List<({Widget asset, String ticker, String amount})> totalAmounts() {
    final assetIds = utxos.map((e) => e.assetId).toSet();
    final totalAmounts = <({Widget asset, String ticker, String amount})>[];

    for (final assetId in assetIds) {
      final utxoList = utxos.where((element) => element.assetId == assetId);
      int amount = utxoList.fold(
        0,
        (previousValue, element) => previousValue + (element.amount ?? 0),
      );

      final precision = ref
          .read(assetUtilsProvider)
          .getPrecisionForAssetId(assetId: assetId);
      final amountStr = ref
          .read(amountToStringProvider)
          .amountToString(
            AmountToStringParameters(amount: amount, precision: precision),
          );
      0;
      final ticker = ref.read(assetUtilsProvider).tickerForAssetId(assetId);
      final asset = ref
          .read(assetImageRepositoryProvider)
          .getCustomImage(assetId, width: 24, height: 24);

      totalAmounts.add((asset: asset, ticker: ticker, amount: amountStr));
    }

    return totalAmounts;
  }

  Widget utxoAccount({required UtxosItem? utxo}) {
    if (utxo?.account == null) {
      return const SizedBox();
    }

    if (utxo!.account! > 1) {
      logger.e('Unhandled account type in select inputs!');
    }

    return switch (utxo.account) {
      1 => const AmpFlag(),
      _ => const SizedBox(),
    };
  }

  bool containsLbtc() {
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);
    return utxos.any((element) => element.assetId == liquidAssetId);
  }
}

@freezed
sealed class InputListItemExpandedState with _$InputListItemExpandedState {
  const factory InputListItemExpandedState({
    int? hash,
    @Default(true) bool expanded,
  }) = _InputListItemExpandedState;
}

@riverpod
class InputListItemExpandedStatesNotifier
    extends _$InputListItemExpandedStatesNotifier {
  @override
  List<InputListItemExpandedState> build() {
    return [];
  }

  void updateState(int hash, bool expandedState) {
    final values = [...state];
    final index = values.indexWhere((element) => element.hash == hash);
    if (index == -1 && expandedState) {
      return;
    }

    // expanded == true
    if (expandedState) {
      values.remove(values[index]);
      state = values;
      return;
    }

    // expanded == false
    values.add(InputListItemExpandedState(expanded: expandedState, hash: hash));
    state = values;
  }
}

@riverpod
bool inputListItemExpandedState(Ref ref, int hash) {
  final expandedStateList = ref.watch(
    inputListItemExpandedStatesNotifierProvider,
  );
  final index = expandedStateList.indexWhere((element) => element.hash == hash);
  if (index == -1) {
    return true; //default expanded state
  }

  return expandedStateList[index].expanded;
}
