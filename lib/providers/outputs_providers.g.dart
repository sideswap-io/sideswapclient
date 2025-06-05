// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outputs_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OutputsData _$OutputsDataFromJson(Map json) => _OutputsData(
  type: json['type'] as String?,
  version: json['version'] as String?,
  timestamp: (json['timestamp'] as num?)?.toInt(),
  receivers: (json['receivers'] as List<dynamic>?)
      ?.map(
        (e) => OutputsReceiver.fromJson(Map<String, dynamic>.from(e as Map)),
      )
      .toList(),
);

Map<String, dynamic> _$OutputsDataToJson(_OutputsData instance) =>
    <String, dynamic>{
      if (instance.type case final value?) 'type': value,
      if (instance.version case final value?) 'version': value,
      if (instance.timestamp case final value?) 'timestamp': value,
      if (instance.receivers?.map((e) => e.toJson()).toList() case final value?)
        'receivers': value,
    };

_OutputsReceiver _$OutputsReceiverFromJson(Map json) => _OutputsReceiver(
  address: json['address'] as String?,
  assetId: json['asset_id'] as String?,
  satoshi: (json['satoshi'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  account: const IntToAccountConverter().fromJson(
    (json['account'] as num?)?.toInt(),
  ),
);

Map<String, dynamic> _$OutputsReceiverToJson(
  _OutputsReceiver instance,
) => <String, dynamic>{
  if (instance.address case final value?) 'address': value,
  if (instance.assetId case final value?) 'asset_id': value,
  if (instance.satoshi case final value?) 'satoshi': value,
  if (instance.comment case final value?) 'comment': value,
  if (const IntToAccountConverter().toJson(instance.account) case final value?)
    'account': value,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outputsDataLengthHash() => r'21e115eeb2198d6e20188fae4218b6832c39b714';

/// See also [outputsDataLength].
@ProviderFor(outputsDataLength)
final outputsDataLengthProvider = AutoDisposeProvider<int>.internal(
  outputsDataLength,
  name: r'outputsDataLengthProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outputsDataLengthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OutputsDataLengthRef = AutoDisposeProviderRef<int>;
String _$outputsReaderNotifierHash() =>
    r'3ae7a8456be8e212e7d881c5fce69956682d4759';

/// See also [OutputsReaderNotifier].
@ProviderFor(OutputsReaderNotifier)
final outputsReaderNotifierProvider =
    NotifierProvider<
      OutputsReaderNotifier,
      Either<OutputsError, OutputsData>
    >.internal(
      OutputsReaderNotifier.new,
      name: r'outputsReaderNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$outputsReaderNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OutputsReaderNotifier = Notifier<Either<OutputsError, OutputsData>>;
String _$outputsCreatorHash() => r'660f6714019866830af3af3e4d49963269320d62';

/// See also [OutputsCreator].
@ProviderFor(OutputsCreator)
final outputsCreatorProvider =
    NotifierProvider<
      OutputsCreator,
      Either<OutputsError, OutputsData>
    >.internal(
      OutputsCreator.new,
      name: r'outputsCreatorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$outputsCreatorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OutputsCreator = Notifier<Either<OutputsError, OutputsData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
