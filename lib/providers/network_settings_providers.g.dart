// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_settings_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NetworkSettingsModelEmptyImpl _$$NetworkSettingsModelEmptyImplFromJson(
        Map json) =>
    _$NetworkSettingsModelEmptyImpl(
      settingsNetworkType: $enumDecodeNullable(
          _$SettingsNetworkTypeEnumMap, json['settingsNetworkType']),
      env: json['env'] as int?,
      host: json['host'] as String?,
      port: json['port'] as int?,
      useTls: json['useTls'] as bool?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NetworkSettingsModelEmptyImplToJson(
        _$NetworkSettingsModelEmptyImpl instance) =>
    <String, dynamic>{
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
};

_$NetworkSettingsModelApplyImpl _$$NetworkSettingsModelApplyImplFromJson(
        Map json) =>
    _$NetworkSettingsModelApplyImpl(
      settingsNetworkType: $enumDecodeNullable(
          _$SettingsNetworkTypeEnumMap, json['settingsNetworkType']),
      env: json['env'] as int?,
      host: json['host'] as String?,
      port: json['port'] as int?,
      useTls: json['useTls'] as bool?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NetworkSettingsModelApplyImplToJson(
        _$NetworkSettingsModelApplyImpl instance) =>
    <String, dynamic>{
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
    r'15f4ef5ba9aec8e71636d4d6c702539ca6b7e816';

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

typedef NetworkSettingsNeedSaveRef = AutoDisposeProviderRef<bool>;
String _$networkSettingsHash() => r'0c2b149b408cdf5c8e49dc9ac57ebbd626a5bde0';

/// See also [NetworkSettings].
@ProviderFor(NetworkSettings)
final networkSettingsProvider =
    AutoDisposeNotifierProvider<NetworkSettings, NetworkSettingsModel>.internal(
  NetworkSettings.new,
  name: r'networkSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NetworkSettings = AutoDisposeNotifier<NetworkSettingsModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
