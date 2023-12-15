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
  SettingsNetworkType.sideswapChina: 'sideswapChina',
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
    r'a960366514ce7b9981b9b8f78d57561059816e03';

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
String _$networkSettingsNotifierHash() =>
    r'56bbcf6e053b9f33b529653d67ee6e29d3052b72';

/// See also [NetworkSettingsNotifier].
@ProviderFor(NetworkSettingsNotifier)
final networkSettingsNotifierProvider = AutoDisposeNotifierProvider<
    NetworkSettingsNotifier, NetworkSettingsModel>.internal(
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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
