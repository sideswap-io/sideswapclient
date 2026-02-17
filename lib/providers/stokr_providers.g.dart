// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokr_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StokrSettingsModel _$StokrSettingsModelFromJson(Map json) =>
    _StokrSettingsModel(firstRun: json['firstRun'] as bool? ?? true);

Map<String, dynamic> _$StokrSettingsModelToJson(_StokrSettingsModel instance) =>
    <String, dynamic>{'firstRun': ?instance.firstRun};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StokrSettingsNotifier)
const stokrSettingsProvider = StokrSettingsNotifierProvider._();

final class StokrSettingsNotifierProvider
    extends $NotifierProvider<StokrSettingsNotifier, StokrSettingsModel> {
  const StokrSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokrSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokrSettingsNotifierHash();

  @$internal
  @override
  StokrSettingsNotifier create() => StokrSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StokrSettingsModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StokrSettingsModel>(value),
    );
  }
}

String _$stokrSettingsNotifierHash() =>
    r'4cd6e962e26aafad9fc2dee6af2fc7c05e579e08';

abstract class _$StokrSettingsNotifier extends $Notifier<StokrSettingsModel> {
  StokrSettingsModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StokrSettingsModel, StokrSettingsModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StokrSettingsModel, StokrSettingsModel>,
              StokrSettingsModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(StokrBlockedCountries)
const stokrBlockedCountriesProvider = StokrBlockedCountriesProvider._();

final class StokrBlockedCountriesProvider
    extends $AsyncNotifierProvider<StokrBlockedCountries, List<CountryCode>> {
  const StokrBlockedCountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokrBlockedCountriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokrBlockedCountriesHash();

  @$internal
  @override
  StokrBlockedCountries create() => StokrBlockedCountries();
}

String _$stokrBlockedCountriesHash() =>
    r'773a1bc3f808be7fc84a12dfcafc01282b5c3f8e';

abstract class _$StokrBlockedCountries
    extends $AsyncNotifier<List<CountryCode>> {
  FutureOr<List<CountryCode>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<CountryCode>>, List<CountryCode>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CountryCode>>, List<CountryCode>>,
              AsyncValue<List<CountryCode>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(stokrCountryBlacklistSearch)
const stokrCountryBlacklistSearchProvider =
    StokrCountryBlacklistSearchFamily._();

final class StokrCountryBlacklistSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CountryCode>>,
          List<CountryCode>,
          FutureOr<List<CountryCode>>
        >
    with
        $FutureModifier<List<CountryCode>>,
        $FutureProvider<List<CountryCode>> {
  const StokrCountryBlacklistSearchProvider._({
    required StokrCountryBlacklistSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stokrCountryBlacklistSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stokrCountryBlacklistSearchHash();

  @override
  String toString() {
    return r'stokrCountryBlacklistSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CountryCode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CountryCode>> create(Ref ref) {
    final argument = this.argument as String;
    return stokrCountryBlacklistSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StokrCountryBlacklistSearchProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stokrCountryBlacklistSearchHash() =>
    r'5df96682b522959e1398c9637f01414d4b5d4e73';

final class StokrCountryBlacklistSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CountryCode>>, String> {
  const StokrCountryBlacklistSearchFamily._()
    : super(
        retry: null,
        name: r'stokrCountryBlacklistSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StokrCountryBlacklistSearchProvider call(String value) =>
      StokrCountryBlacklistSearchProvider._(argument: value, from: this);

  @override
  String toString() => r'stokrCountryBlacklistSearchProvider';
}

@ProviderFor(StokrLastSelectedAssetNotifier)
const stokrLastSelectedAssetProvider =
    StokrLastSelectedAssetNotifierProvider._();

final class StokrLastSelectedAssetNotifierProvider
    extends $NotifierProvider<StokrLastSelectedAssetNotifier, Option<Asset>> {
  const StokrLastSelectedAssetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokrLastSelectedAssetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokrLastSelectedAssetNotifierHash();

  @$internal
  @override
  StokrLastSelectedAssetNotifier create() => StokrLastSelectedAssetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<Asset>>(value),
    );
  }
}

String _$stokrLastSelectedAssetNotifierHash() =>
    r'ce88939d4b6b336495ed2dcc50a1ddb3243139dc';

abstract class _$StokrLastSelectedAssetNotifier
    extends $Notifier<Option<Asset>> {
  Option<Asset> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<Asset>, Option<Asset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<Asset>, Option<Asset>>,
              Option<Asset>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
