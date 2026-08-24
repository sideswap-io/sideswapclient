// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amp_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AmpIdNotifier)
final ampIdProvider = AmpIdNotifierProvider._();

final class AmpIdNotifierProvider
    extends $NotifierProvider<AmpIdNotifier, String> {
  AmpIdNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ampIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ampIdNotifierHash();

  @$internal
  @override
  AmpIdNotifier create() => AmpIdNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$ampIdNotifierHash() => r'71de7a3a49d0703f23d60618a0744306a1026e99';

abstract class _$AmpIdNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
