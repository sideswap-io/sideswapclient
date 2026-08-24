// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autosign_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Wallet must read [isAutosign] once at sign-request handler entry, not from a stale closure.

@ProviderFor(Autosign)
final autosignProvider = AutosignProvider._();

/// Wallet must read [isAutosign] once at sign-request handler entry, not from a stale closure.
final class AutosignProvider
    extends $NotifierProvider<Autosign, Map<String, bool>> {
  /// Wallet must read [isAutosign] once at sign-request handler entry, not from a stale closure.
  AutosignProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autosignProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autosignHash();

  @$internal
  @override
  Autosign create() => Autosign();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, bool>>(value),
    );
  }
}

String _$autosignHash() => r'5acb065999a98019c3a119ae337822e7d219f745';

/// Wallet must read [isAutosign] once at sign-request handler entry, not from a stale closure.

abstract class _$Autosign extends $Notifier<Map<String, bool>> {
  Map<String, bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, bool>, Map<String, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, bool>, Map<String, bool>>,
              Map<String, bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
