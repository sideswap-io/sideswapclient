// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'1a6250efdc19e86c923ceb598a77ff74d64378e6';

@ProviderFor(Configuration)
final configurationProvider = ConfigurationProvider._();

final class ConfigurationProvider
    extends $NotifierProvider<Configuration, SideswapSettings> {
  ConfigurationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configurationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configurationHash();

  @$internal
  @override
  Configuration create() => Configuration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SideswapSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SideswapSettings>(value),
    );
  }
}

String _$configurationHash() => r'ab3be95104c39a87d94d6517de1cb38b97508b13';

abstract class _$Configuration extends $Notifier<SideswapSettings> {
  SideswapSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SideswapSettings, SideswapSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SideswapSettings, SideswapSettings>,
              SideswapSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
