// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_settings_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkSettingsModelEmpty _$NetworkSettingsModelEmptyFromJson(Map json) =>
    NetworkSettingsModelEmpty(
      settingsNetworkType: $enumDecodeNullable(
        _$SettingsNetworkTypeEnumMap,
        json['settingsNetworkType'],
      ),
      env: (json['env'] as num?)?.toInt(),
      host: json['host'] as String?,
      port: (json['port'] as num?)?.toInt(),
      useTls: json['useTls'] as bool?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$NetworkSettingsModelEmptyToJson(
  NetworkSettingsModelEmpty instance,
) => <String, dynamic>{
  'settingsNetworkType':
      _$SettingsNetworkTypeEnumMap[instance.settingsNetworkType],
  'env': instance.env,
  'host': instance.host,
  'port': instance.port,
  'useTls': instance.useTls,
  'runtimeType': instance.$type,
};

const _$SettingsNetworkTypeEnumMap = {
  SettingsNetworkType.blockstream: 'blockstream',
  SettingsNetworkType.sideswap: 'sideswap',
  SettingsNetworkType.personal: 'personal',
  SettingsNetworkType.sideswapChina: 'sideswapChina',
};

NetworkSettingsModelApply _$NetworkSettingsModelApplyFromJson(Map json) =>
    NetworkSettingsModelApply(
      settingsNetworkType: $enumDecodeNullable(
        _$SettingsNetworkTypeEnumMap,
        json['settingsNetworkType'],
      ),
      env: (json['env'] as num?)?.toInt(),
      host: json['host'] as String?,
      port: (json['port'] as num?)?.toInt(),
      useTls: json['useTls'] as bool?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$NetworkSettingsModelApplyToJson(
  NetworkSettingsModelApply instance,
) => <String, dynamic>{
  'settingsNetworkType':
      _$SettingsNetworkTypeEnumMap[instance.settingsNetworkType],
  'env': instance.env,
  'host': instance.host,
  'port': instance.port,
  'useTls': instance.useTls,
  'runtimeType': instance.$type,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NetworkSettingsNotifier)
const networkSettingsProvider = NetworkSettingsNotifierProvider._();

final class NetworkSettingsNotifierProvider
    extends $NotifierProvider<NetworkSettingsNotifier, NetworkSettingsModel> {
  const NetworkSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkSettingsNotifierHash();

  @$internal
  @override
  NetworkSettingsNotifier create() => NetworkSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkSettingsModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkSettingsModel>(value),
    );
  }
}

String _$networkSettingsNotifierHash() =>
    r'bb968b4af2a3f8480940d3d41bf5c742e12f0076';

abstract class _$NetworkSettingsNotifier
    extends $Notifier<NetworkSettingsModel> {
  NetworkSettingsModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<NetworkSettingsModel, NetworkSettingsModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkSettingsModel, NetworkSettingsModel>,
              NetworkSettingsModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(networkSettingsNeedSave)
const networkSettingsNeedSaveProvider = NetworkSettingsNeedSaveProvider._();

final class NetworkSettingsNeedSaveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const NetworkSettingsNeedSaveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkSettingsNeedSaveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkSettingsNeedSaveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return networkSettingsNeedSave(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$networkSettingsNeedSaveHash() =>
    r'775d14d5cf9195bd4f044266090f058e20b4284b';

@ProviderFor(networkSettingsNeedRestart)
const networkSettingsNeedRestartProvider =
    NetworkSettingsNeedRestartProvider._();

final class NetworkSettingsNeedRestartProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const NetworkSettingsNeedRestartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkSettingsNeedRestartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkSettingsNeedRestartHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return networkSettingsNeedRestart(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$networkSettingsNeedRestartHash() =>
    r'd46ec64fc16b5f80f8f78ccedb22bc791276f291';
