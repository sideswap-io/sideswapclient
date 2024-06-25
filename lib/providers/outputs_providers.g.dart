// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputs_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OutputsDataImpl _$$OutputsDataImplFromJson(Map json) => _$OutputsDataImpl(
      type: json['type'] as String?,
      version: json['version'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      receivers: (json['receivers'] as List<dynamic>?)
          ?.map((e) =>
              OutputsReceiver.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$OutputsDataImplToJson(_$OutputsDataImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('type', instance.type);
  writeNotNull('version', instance.version);
  writeNotNull('timestamp', instance.timestamp);
  writeNotNull(
      'receivers', instance.receivers?.map((e) => e.toJson()).toList());
  return val;
}

_$OutputsReceiverImpl _$$OutputsReceiverImplFromJson(Map json) =>
    _$OutputsReceiverImpl(
      address: json['address'] as String?,
      assetId: json['asset_id'] as String?,
      satoshi: (json['satoshi'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      account: (json['account'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OutputsReceiverImplToJson(
    _$OutputsReceiverImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('address', instance.address);
  writeNotNull('asset_id', instance.assetId);
  writeNotNull('satoshi', instance.satoshi);
  writeNotNull('comment', instance.comment);
  writeNotNull('account', instance.account);
  return val;
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outputsReaderNotifierHash() =>
    r'075221eb374fdf681a678714f1efd1c2edd7ee62';

/// See also [OutputsReaderNotifier].
@ProviderFor(OutputsReaderNotifier)
final outputsReaderNotifierProvider = NotifierProvider<OutputsReaderNotifier,
    Either<OutputsError, OutputsData>>.internal(
  OutputsReaderNotifier.new,
  name: r'outputsReaderNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outputsReaderNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OutputsReaderNotifier = Notifier<Either<OutputsError, OutputsData>>;
String _$outputsCreatorHash() => r'a0a1e635d977c7413b20f712c1f85e6758239630';

/// See also [OutputsCreator].
@ProviderFor(OutputsCreator)
final outputsCreatorProvider = AutoDisposeNotifierProvider<OutputsCreator,
    Either<OutputsError, OutputsData>>.internal(
  OutputsCreator.new,
  name: r'outputsCreatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outputsCreatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OutputsCreator
    = AutoDisposeNotifier<Either<OutputsError, OutputsData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
