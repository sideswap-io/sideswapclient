// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stokr_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StokrSettingsModelImpl _$$StokrSettingsModelImplFromJson(Map json) =>
    _$StokrSettingsModelImpl(firstRun: json['firstRun'] as bool? ?? true);

Map<String, dynamic> _$$StokrSettingsModelImplToJson(
  _$StokrSettingsModelImpl instance,
) => <String, dynamic>{
  if (instance.firstRun case final value?) 'firstRun': value,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stokrCountryBlacklistSearchHash() =>
    r'2d7c3fa7b40d68a42fee449a01ec799a079ff980';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [stokrCountryBlacklistSearch].
@ProviderFor(stokrCountryBlacklistSearch)
const stokrCountryBlacklistSearchProvider = StokrCountryBlacklistSearchFamily();

/// See also [stokrCountryBlacklistSearch].
class StokrCountryBlacklistSearchFamily
    extends Family<AsyncValue<List<CountryCode>>> {
  /// See also [stokrCountryBlacklistSearch].
  const StokrCountryBlacklistSearchFamily();

  /// See also [stokrCountryBlacklistSearch].
  StokrCountryBlacklistSearchProvider call(String value) {
    return StokrCountryBlacklistSearchProvider(value);
  }

  @override
  StokrCountryBlacklistSearchProvider getProviderOverride(
    covariant StokrCountryBlacklistSearchProvider provider,
  ) {
    return call(provider.value);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stokrCountryBlacklistSearchProvider';
}

/// See also [stokrCountryBlacklistSearch].
class StokrCountryBlacklistSearchProvider
    extends AutoDisposeFutureProvider<List<CountryCode>> {
  /// See also [stokrCountryBlacklistSearch].
  StokrCountryBlacklistSearchProvider(String value)
    : this._internal(
        (ref) => stokrCountryBlacklistSearch(
          ref as StokrCountryBlacklistSearchRef,
          value,
        ),
        from: stokrCountryBlacklistSearchProvider,
        name: r'stokrCountryBlacklistSearchProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$stokrCountryBlacklistSearchHash,
        dependencies: StokrCountryBlacklistSearchFamily._dependencies,
        allTransitiveDependencies:
            StokrCountryBlacklistSearchFamily._allTransitiveDependencies,
        value: value,
      );

  StokrCountryBlacklistSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.value,
  }) : super.internal();

  final String value;

  @override
  Override overrideWith(
    FutureOr<List<CountryCode>> Function(
      StokrCountryBlacklistSearchRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StokrCountryBlacklistSearchProvider._internal(
        (ref) => create(ref as StokrCountryBlacklistSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        value: value,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CountryCode>> createElement() {
    return _StokrCountryBlacklistSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StokrCountryBlacklistSearchProvider && other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StokrCountryBlacklistSearchRef
    on AutoDisposeFutureProviderRef<List<CountryCode>> {
  /// The parameter `value` of this provider.
  String get value;
}

class _StokrCountryBlacklistSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<CountryCode>>
    with StokrCountryBlacklistSearchRef {
  _StokrCountryBlacklistSearchProviderElement(super.provider);

  @override
  String get value => (origin as StokrCountryBlacklistSearchProvider).value;
}

String _$stokrSettingsNotifierHash() =>
    r'4cd6e962e26aafad9fc2dee6af2fc7c05e579e08';

/// See also [StokrSettingsNotifier].
@ProviderFor(StokrSettingsNotifier)
final stokrSettingsNotifierProvider = AutoDisposeNotifierProvider<
  StokrSettingsNotifier,
  StokrSettingsModel
>.internal(
  StokrSettingsNotifier.new,
  name: r'stokrSettingsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stokrSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StokrSettingsNotifier = AutoDisposeNotifier<StokrSettingsModel>;
String _$stokrBlockedCountriesHash() =>
    r'0abee5718d749587a715a5a4d11d4502f26bbb35';

/// See also [StokrBlockedCountries].
@ProviderFor(StokrBlockedCountries)
final stokrBlockedCountriesProvider = AutoDisposeAsyncNotifierProvider<
  StokrBlockedCountries,
  List<CountryCode>
>.internal(
  StokrBlockedCountries.new,
  name: r'stokrBlockedCountriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stokrBlockedCountriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StokrBlockedCountries = AutoDisposeAsyncNotifier<List<CountryCode>>;
String _$stokrLastSelectedAssetNotifierHash() =>
    r'ce88939d4b6b336495ed2dcc50a1ddb3243139dc';

/// See also [StokrLastSelectedAssetNotifier].
@ProviderFor(StokrLastSelectedAssetNotifier)
final stokrLastSelectedAssetNotifierProvider =
    NotifierProvider<StokrLastSelectedAssetNotifier, Option<Asset>>.internal(
      StokrLastSelectedAssetNotifier.new,
      name: r'stokrLastSelectedAssetNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$stokrLastSelectedAssetNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StokrLastSelectedAssetNotifier = Notifier<Option<Asset>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
