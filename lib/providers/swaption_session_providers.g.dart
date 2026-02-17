// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swaption_session_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SwaptionSession _$SwaptionSessionFromJson(Map json) => _SwaptionSession(
  sessionId: json['sessionId'] as String,
  domain: json['domain'] as String,
);

Map<String, dynamic> _$SwaptionSessionToJson(_SwaptionSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'domain': instance.domain,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SwaptionSessionNotifier)
const swaptionSessionProvider = SwaptionSessionNotifierProvider._();

final class SwaptionSessionNotifierProvider
    extends $NotifierProvider<SwaptionSessionNotifier, List<SwaptionSession>> {
  const SwaptionSessionNotifierProvider._()
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
    r'de286fb6d34a46f0d9eb98f9c29e30b017e4d220';

abstract class _$SwaptionSessionNotifier
    extends $Notifier<List<SwaptionSession>> {
  List<SwaptionSession> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<SwaptionSession>, List<SwaptionSession>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<SwaptionSession>, List<SwaptionSession>>,
              List<SwaptionSession>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
