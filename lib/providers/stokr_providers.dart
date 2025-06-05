import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/countries_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'stokr_providers.g.dart';
part 'stokr_providers.freezed.dart';

@freezed
sealed class StokrSettingsModel with _$StokrSettingsModel {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory StokrSettingsModel({@Default(true) bool? firstRun}) =
      _StokrSettingsModel;

  factory StokrSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$StokrSettingsModelFromJson(json);
}

@riverpod
class StokrSettingsNotifier extends _$StokrSettingsNotifier {
  @override
  StokrSettingsModel build() {
    final stokrSettingsModel = ref
        .watch(configurationProvider)
        .stokrSettingsModel;
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
  FutureOr<List<CountryCode>> build() {
    final baseAsset = ref.watch(marketSubscribedBaseAssetProvider);
    return baseAsset.match(
      () {
        return future;
      },
      (asset) {
        if (!asset.hasAmpAssetRestrictions()) {
          return future;
        }

        final allowedCountries = asset.ampAssetRestrictions.allowedCountries;
        final countries = ref.watch(countriesFutureProvider);

        return switch (countries) {
          AsyncValue(hasValue: true, value: List<CountryCode> countryList) =>
            () {
              final newList = [...countryList];
              newList.retainWhere(
                (element) => !allowedCountries.any(
                  (allowed) => element.iso3Code == allowed,
                ),
              );
              newList.sort(
                (a, b) => a.english?.compareTo(b.english ?? '') ?? 0,
              );
              return Future<List<CountryCode>>.value(newList);
            }(),
          _ => future,
        };
      },
    );
  }
}

@riverpod
FutureOr<List<CountryCode>> stokrCountryBlacklistSearch(Ref ref, String value) {
  final stokrCountryBlacklist = ref.watch(stokrBlockedCountriesProvider);

  return switch (stokrCountryBlacklist) {
    AsyncValue(hasValue: true, value: List<CountryCode> countries) =>
      countries
          .where(
            (element) =>
                (element.english?.toLowerCase().contains(value.toLowerCase()) ??
                    false) ||
                (element.name?.toLowerCase().contains(value.toLowerCase()) ??
                    false),
          )
          .toList(),
    _ => [],
  };
}

@Riverpod(keepAlive: true)
class StokrLastSelectedAssetNotifier extends _$StokrLastSelectedAssetNotifier {
  @override
  Option<Asset> build() {
    return Option.none();
  }

  void setLastSelectedAsset(Asset asset) {
    state = Option.of(asset);
  }
}
