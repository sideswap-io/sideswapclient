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

String _$networkSettingsNeedSaveHash() =>
    r'992800528da6917f5e25d00ace8b518cdb9af455';

/// See also [networkSettingsNeedSave].
@ProviderFor(networkSettingsNeedSave)
final networkSettingsNeedSaveProvider = AutoDisposeProvider<bool>.internal(
  networkSettingsNeedSave,
  name: r'networkSettingsNeedSaveProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkSettingsNeedSaveHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NetworkSettingsNeedSaveRef = AutoDisposeProviderRef<bool>;
String _$networkSettingsNotifierHash() =>
    r'bb968b4af2a3f8480940d3d41bf5c742e12f0076';

/// See also [NetworkSettingsNotifier].
@ProviderFor(NetworkSettingsNotifier)
final networkSettingsNotifierProvider =
    AutoDisposeNotifierProvider<
      NetworkSettingsNotifier,
      NetworkSettingsModel
    >.internal(
      NetworkSettingsNotifier.new,
      name: r'networkSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$networkSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NetworkSettingsNotifier = AutoDisposeNotifier<NetworkSettingsModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
