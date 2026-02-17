// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locales_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalesNotifier)
const localesProvider = LocalesNotifierProvider._();

final class LocalesNotifierProvider
    extends $NotifierProvider<LocalesNotifier, String> {
  const LocalesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localesNotifierHash();

  @$internal
  @override
  LocalesNotifier create() => LocalesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$localesNotifierHash() => r'1018e1e0d353a2858e1010e7d2fd665844009c3a';

abstract class _$LocalesNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
