// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locales_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalesNotifier)
final localesProvider = LocalesNotifierProvider._();

final class LocalesNotifierProvider
    extends $NotifierProvider<LocalesNotifier, String> {
  LocalesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localesProvider',
        isAutoDispose: false,
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

String _$localesNotifierHash() => r'ca5282de0405c226f64c1ea03ed21cd447596cd6';

abstract class _$LocalesNotifier extends $Notifier<String> {
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
