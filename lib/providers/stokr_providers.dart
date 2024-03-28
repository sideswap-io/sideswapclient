import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/config_provider.dart';

part 'stokr_providers.g.dart';
part 'stokr_providers.freezed.dart';

@freezed
sealed class StokrSettingsModel with _$StokrSettingsModel {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory StokrSettingsModel({
    @Default(true) bool? firstRun,
  }) = _StokrSettingsModel;

  factory StokrSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$StokrSettingsModelFromJson(json);
}

@riverpod
class StokrSettingsNotifier extends _$StokrSettingsNotifier {
  @override
  StokrSettingsModel build() {
    final stokrSettingsModel =
        ref.watch(configurationProvider).stokrSettingsModel;
    return stokrSettingsModel ?? const StokrSettingsModel();
  }

  void setStokrSettings(StokrSettingsModel stokrSettingsModel) {
    state = stokrSettingsModel;
  }

  void save() {
    ref.read(configurationProvider.notifier).setStokrSettingsModel(state);
  }
}

@freezed
sealed class StokrAllowedCountry with _$StokrAllowedCountry {
  const factory StokrAllowedCountry({
    required String name,
    @Default(false) bool isAllowed,
  }) = _StokrAllowedCountry;

  factory StokrAllowedCountry.fromJson(Map<String, dynamic> json) =>
      _$StokrAllowedCountryFromJson(json);
}

@freezed
sealed class StokrAllowedCountryList with _$StokrAllowedCountryList {
  const factory StokrAllowedCountryList({
    List<StokrAllowedCountry>? countries,
  }) = _StokrAllowedCountryList;

  factory StokrAllowedCountryList.fromJson(Map<String, dynamic> json) =>
      _$StokrAllowedCountryListFromJson(json);
}

@riverpod
class StokrBlockedCountries extends _$StokrBlockedCountries {
  @override
  FutureOr<List<StokrAllowedCountry>> build() async {
    try {
      String jsonFile =
          await rootBundle.loadString('assets/stokr/smstr_countries.json');
      final json = jsonDecode(jsonFile) as Map<String, dynamic>;
      final stokrCountries = StokrAllowedCountryList.fromJson(json);
      final countries = <StokrAllowedCountry>[];
      countries.addAll(stokrCountries.countries ?? []);
      countries.sort((a, b) => a.name.compareTo(b.name));
      return countries.where((element) => !element.isAllowed).toList();
    } catch (e) {
      logger.e(e);
    }

    return future;
  }
}

@riverpod
FutureOr<List<StokrAllowedCountry>> stokrCountryBlacklistSearch(
    StokrCountryBlacklistSearchRef ref, String value) async {
  final stokrCountryBlacklist =
      await ref.watch(stokrBlockedCountriesProvider.future);
  final newList = stokrCountryBlacklist
      .where((element) => element.name.toLowerCase().startsWith(value))
      .toList();
  return newList;
}

@Riverpod(keepAlive: true)
class StokrLastSelectedAccountAssetNotifier
    extends _$StokrLastSelectedAccountAssetNotifier {
  @override
  AccountAsset? build() {
    return null;
  }

  void setLastSelectedAccountAsset(AccountAsset accountAsset) {
    state = accountAsset;
  }
}
