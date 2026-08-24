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
      'type': ?instance.type,
      'version': ?instance.version,
      'timestamp': ?instance.timestamp,
      'receivers': ?instance.receivers?.map((e) => e.toJson()).toList(),
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

Map<String, dynamic> _$OutputsReceiverToJson(_OutputsReceiver instance) =>
    <String, dynamic>{
      'address': ?instance.address,
      'asset_id': ?instance.assetId,
      'satoshi': ?instance.satoshi,
      'comment': ?instance.comment,
      'account': ?const IntToAccountConverter().toJson(instance.account),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OutputsReaderNotifier)
final outputsReaderProvider = OutputsReaderNotifierProvider._();

final class OutputsReaderNotifierProvider
    extends
        $NotifierProvider<
          OutputsReaderNotifier,
          Either<OutputsError, OutputsData>
        > {
  OutputsReaderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outputsReaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outputsReaderNotifierHash();

  @$internal
  @override
  OutputsReaderNotifier create() => OutputsReaderNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Either<OutputsError, OutputsData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Either<OutputsError, OutputsData>>(
        value,
      ),
    );
  }
}

String _$outputsReaderNotifierHash() =>
    r'3ae7a8456be8e212e7d881c5fce69956682d4759';

abstract class _$OutputsReaderNotifier
    extends $Notifier<Either<OutputsError, OutputsData>> {
  Either<OutputsError, OutputsData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              Either<OutputsError, OutputsData>,
              Either<OutputsError, OutputsData>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Either<OutputsError, OutputsData>,
                Either<OutputsError, OutputsData>
              >,
              Either<OutputsError, OutputsData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(OutputsCreator)
final outputsCreatorProvider = OutputsCreatorProvider._();

final class OutputsCreatorProvider
    extends
        $NotifierProvider<OutputsCreator, Either<OutputsError, OutputsData>> {
  OutputsCreatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outputsCreatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outputsCreatorHash();

  @$internal
  @override
  OutputsCreator create() => OutputsCreator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Either<OutputsError, OutputsData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Either<OutputsError, OutputsData>>(
        value,
      ),
    );
  }
}

String _$outputsCreatorHash() => r'ca25f35d383b0d9c8a132a666c34f25edf7fd819';

abstract class _$OutputsCreator
    extends $Notifier<Either<OutputsError, OutputsData>> {
  Either<OutputsError, OutputsData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              Either<OutputsError, OutputsData>,
              Either<OutputsError, OutputsData>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Either<OutputsError, OutputsData>,
                Either<OutputsError, OutputsData>
              >,
              Either<OutputsError, OutputsData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(outputsDataLength)
final outputsDataLengthProvider = OutputsDataLengthProvider._();

final class OutputsDataLengthProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  OutputsDataLengthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outputsDataLengthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outputsDataLengthHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return outputsDataLength(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$outputsDataLengthHash() => r'21e115eeb2198d6e20188fae4218b6832c39b714';
