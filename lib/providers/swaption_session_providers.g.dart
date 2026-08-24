// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swaption_session_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SwaptionSession _$SwaptionSessionFromJson(Map json) => _SwaptionSession(
  sessionId: json['sessionId'] as String,
  domain: json['domain'] as String,
  isLocal: json['isLocal'] as bool,
);

Map<String, dynamic> _$SwaptionSessionToJson(_SwaptionSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'domain': instance.domain,
      'isLocal': instance.isLocal,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SwaptionSessionNotifier)
final swaptionSessionProvider = SwaptionSessionNotifierProvider._();

final class SwaptionSessionNotifierProvider
    extends $NotifierProvider<SwaptionSessionNotifier, List<SwaptionSession>> {
  SwaptionSessionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swaptionSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swaptionSessionNotifierHash();

  @$internal
  @override
  SwaptionSessionNotifier create() => SwaptionSessionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SwaptionSession> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SwaptionSession>>(value),
    );
  }
}

String _$swaptionSessionNotifierHash() =>
    r'e0d0605cc4ad6c2f78a14cb48a5049cc56827a98';

abstract class _$SwaptionSessionNotifier
    extends $Notifier<List<SwaptionSession>> {
  List<SwaptionSession> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<SwaptionSession>, List<SwaptionSession>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SwaptionSession>, List<SwaptionSession>>,
              List<SwaptionSession>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
