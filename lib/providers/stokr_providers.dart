import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/countries_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

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

@riverpod
class StokrBlockedCountries extends _$StokrBlockedCountries {
  @override
  FutureOr<List<CountryCode>> build() async {
    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);
    final asset = ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];

    if (asset == null || !asset.hasAmpAssetRestrictions()) {
      return future;
    }

    final allowedCountries = asset.ampAssetRestrictions.allowedCountries;
    final countries = ref.watch(countriesFutureProvider);

    return switch (countries) {
      AsyncValue(hasValue: true, value: List<CountryCode> countryList) => () {
          final newList = [...countryList];
          newList.retainWhere((element) =>
              !allowedCountries.any((allowed) => element.iso3Code == allowed));
          newList.sort((a, b) => a.english?.compareTo(b.english ?? '') ?? 0);
          return Future<List<CountryCode>>.value(newList);
        }(),
      _ => future,
    };
  }
}

@riverpod
FutureOr<List<CountryCode>> stokrCountryBlacklistSearch(
    StokrCountryBlacklistSearchRef ref, String value) async {
  final stokrCountryBlacklist = ref.watch(stokrBlockedCountriesProvider);

  return switch (stokrCountryBlacklist) {
    AsyncValue(hasValue: true, value: List<CountryCode> countries) => countries
        .where((element) =>
            (element.english?.toLowerCase().contains(value.toLowerCase()) ??
                false) ||
            (element.name?.toLowerCase().contains(value.toLowerCase()) ??
                false))
        .toList(),
    _ => [],
  };
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
