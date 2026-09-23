// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_setup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The one record that a setup attempt is in flight. ADR-0013 decisions 4
/// and 14.
///
/// It is `keepAlive` and watches nothing on purpose. `_clearStates()`, leaving
/// the screen and re-entering it must all leave an outstanding attempt
/// outstanding, so that a reply can only belong to the attempt that is still
/// held. Only a reply, or a send that never left, gives it back.

@ProviderFor(PinSetupAttempt)
final pinSetupAttemptProvider = PinSetupAttemptProvider._();

/// The one record that a setup attempt is in flight. ADR-0013 decisions 4
/// and 14.
///
/// It is `keepAlive` and watches nothing on purpose. `_clearStates()`, leaving
/// the screen and re-entering it must all leave an outstanding attempt
/// outstanding, so that a reply can only belong to the attempt that is still
/// held. Only a reply, or a send that never left, gives it back.
final class PinSetupAttemptProvider
    extends $NotifierProvider<PinSetupAttempt, PinSetupAttemptState> {
  /// The one record that a setup attempt is in flight. ADR-0013 decisions 4
  /// and 14.
  ///
  /// It is `keepAlive` and watches nothing on purpose. `_clearStates()`, leaving
  /// the screen and re-entering it must all leave an outstanding attempt
  /// outstanding, so that a reply can only belong to the attempt that is still
  /// held. Only a reply, or a send that never left, gives it back.
  PinSetupAttemptProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinSetupAttemptProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinSetupAttemptHash();

  @$internal
  @override
  PinSetupAttempt create() => PinSetupAttempt();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinSetupAttemptState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinSetupAttemptState>(value),
    );
  }
}

String _$pinSetupAttemptHash() => r'eb08c978198319ab882bc3c9d2092b75132b8e06';

/// The one record that a setup attempt is in flight. ADR-0013 decisions 4
/// and 14.
///
/// It is `keepAlive` and watches nothing on purpose. `_clearStates()`, leaving
/// the screen and re-entering it must all leave an outstanding attempt
/// outstanding, so that a reply can only belong to the attempt that is still
/// held. Only a reply, or a send that never left, gives it back.

abstract class _$PinSetupAttempt extends $Notifier<PinSetupAttemptState> {
  PinSetupAttemptState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinSetupAttemptState, PinSetupAttemptState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinSetupAttemptState, PinSetupAttemptState>,
              PinSetupAttemptState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinDataNotifier)
final pinDataProvider = PinDataNotifierProvider._();

final class PinDataNotifierProvider
    extends $NotifierProvider<PinDataNotifier, PinDataState> {
  PinDataNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinDataNotifierHash();

  @$internal
  @override
  PinDataNotifier create() => PinDataNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinDataState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinDataState>(value),
    );
  }
}

String _$pinDataNotifierHash() => r'a65aa52d7434d09f2c22482397836dc3cc633cb6';

abstract class _$PinDataNotifier extends $Notifier<PinDataState> {
  PinDataState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinDataState, PinDataState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinDataState, PinDataState>,
              PinDataState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinSetupCallerNotifier)
final pinSetupCallerProvider = PinSetupCallerNotifierProvider._();

final class PinSetupCallerNotifierProvider
    extends $NotifierProvider<PinSetupCallerNotifier, PinSetupCallerState> {
  PinSetupCallerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinSetupCallerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinSetupCallerNotifierHash();

  @$internal
  @override
  PinSetupCallerNotifier create() => PinSetupCallerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinSetupCallerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinSetupCallerState>(value),
    );
  }
}

String _$pinSetupCallerNotifierHash() =>
    r'43bcaae2a911638e96195258f409982a5700fa23';

abstract class _$PinSetupCallerNotifier extends $Notifier<PinSetupCallerState> {
  PinSetupCallerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinSetupCallerState, PinSetupCallerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinSetupCallerState, PinSetupCallerState>,
              PinSetupCallerState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinSetupExitNotifier)
final pinSetupExitProvider = PinSetupExitNotifierProvider._();

final class PinSetupExitNotifierProvider
    extends $NotifierProvider<PinSetupExitNotifier, PinSetupExitState> {
  PinSetupExitNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinSetupExitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinSetupExitNotifierHash();

  @$internal
  @override
  PinSetupExitNotifier create() => PinSetupExitNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinSetupExitState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinSetupExitState>(value),
    );
  }
}

String _$pinSetupExitNotifierHash() =>
    r'a652a54ce5113b0078a30cd9e1d5b6d6551041bb';

abstract class _$PinSetupExitNotifier extends $Notifier<PinSetupExitState> {
  PinSetupExitState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinSetupExitState, PinSetupExitState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinSetupExitState, PinSetupExitState>,
              PinSetupExitState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinFieldStateNotifier)
final pinFieldStateProvider = PinFieldStateNotifierProvider._();

final class PinFieldStateNotifierProvider
    extends $NotifierProvider<PinFieldStateNotifier, PinFieldState> {
  PinFieldStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinFieldStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinFieldStateNotifierHash();

  @$internal
  @override
  PinFieldStateNotifier create() => PinFieldStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinFieldState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinFieldState>(value),
    );
  }
}

String _$pinFieldStateNotifierHash() =>
    r'82c1e3f94e3789fb4125d8fa4273c190942a1ca6';

abstract class _$PinFieldStateNotifier extends $Notifier<PinFieldState> {
  PinFieldState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinFieldState, PinFieldState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinFieldState, PinFieldState>,
              PinFieldState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PinSetupStateNotifier)
final pinSetupStateProvider = PinSetupStateNotifierProvider._();

final class PinSetupStateNotifierProvider
    extends $NotifierProvider<PinSetupStateNotifier, PinSetupState> {
  PinSetupStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinSetupStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinSetupStateNotifierHash();

  @$internal
  @override
  PinSetupStateNotifier create() => PinSetupStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinSetupState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinSetupState>(value),
    );
  }
}

String _$pinSetupStateNotifierHash() =>
    r'7b2efb15040edce22da7ffafca2440cf5c7c23c3';

abstract class _$PinSetupStateNotifier extends $Notifier<PinSetupState> {
  PinSetupState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PinSetupState, PinSetupState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinSetupState, PinSetupState>,
              PinSetupState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(FirstPinNotifier)
final firstPinProvider = FirstPinNotifierProvider._();

final class FirstPinNotifierProvider
    extends $NotifierProvider<FirstPinNotifier, String> {
  FirstPinNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstPinProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstPinNotifierHash();

  @$internal
  @override
  FirstPinNotifier create() => FirstPinNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$firstPinNotifierHash() => r'3da3be147bf78b2809fc7ad0f0dc0150dde7c551';

abstract class _$FirstPinNotifier extends $Notifier<String> {
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

@ProviderFor(SecondPinNotifier)
final secondPinProvider = SecondPinNotifierProvider._();

final class SecondPinNotifierProvider
    extends $NotifierProvider<SecondPinNotifier, String> {
  SecondPinNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secondPinProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secondPinNotifierHash();

  @$internal
  @override
  SecondPinNotifier create() => SecondPinNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$secondPinNotifierHash() => r'66003587006d24106b280889e7fe388af8f7851a';

abstract class _$SecondPinNotifier extends $Notifier<String> {
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

/// Derived, with no setter. The field is open exactly while no setup attempt is
/// outstanding. ADR-0013 decision 1.

@ProviderFor(FirstPinEnabled)
final firstPinEnabledProvider = FirstPinEnabledProvider._();

/// Derived, with no setter. The field is open exactly while no setup attempt is
/// outstanding. ADR-0013 decision 1.
final class FirstPinEnabledProvider
    extends $NotifierProvider<FirstPinEnabled, bool> {
  /// Derived, with no setter. The field is open exactly while no setup attempt is
  /// outstanding. ADR-0013 decision 1.
  FirstPinEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstPinEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstPinEnabledHash();

  @$internal
  @override
  FirstPinEnabled create() => FirstPinEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$firstPinEnabledHash() => r'67f292b76266707b17020f7e0a03a12b7b8c58ca';

/// Derived, with no setter. The field is open exactly while no setup attempt is
/// outstanding. ADR-0013 decision 1.

abstract class _$FirstPinEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Derived, with no setter. The confirm field is open while the first PIN is
/// long enough for confirming it to mean anything, and no attempt is
/// outstanding. ADR-0013 decisions 1 and 2.

@ProviderFor(SecondPinEnabled)
final secondPinEnabledProvider = SecondPinEnabledProvider._();

/// Derived, with no setter. The confirm field is open while the first PIN is
/// long enough for confirming it to mean anything, and no attempt is
/// outstanding. ADR-0013 decisions 1 and 2.
final class SecondPinEnabledProvider
    extends $NotifierProvider<SecondPinEnabled, bool> {
  /// Derived, with no setter. The confirm field is open while the first PIN is
  /// long enough for confirming it to mean anything, and no attempt is
  /// outstanding. ADR-0013 decisions 1 and 2.
  SecondPinEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secondPinEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secondPinEnabledHash();

  @$internal
  @override
  SecondPinEnabled create() => SecondPinEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$secondPinEnabledHash() => r'7ec2c965bdf33d329bba202e1aeb42511b276c75';

/// Derived, with no setter. The confirm field is open while the first PIN is
/// long enough for confirming it to mean anything, and no attempt is
/// outstanding. ADR-0013 decisions 1 and 2.

abstract class _$SecondPinEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(pinHelper)
final pinHelperProvider = PinHelperProvider._();

final class PinHelperProvider
    extends $FunctionalProvider<PinHelper, PinHelper, PinHelper>
    with $Provider<PinHelper> {
  PinHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinHelperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinHelperHash();

  @$internal
  @override
  $ProviderElement<PinHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinHelper create(Ref ref) {
    return pinHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinHelper>(value),
    );
  }
}

String _$pinHelperHash() => r'2173b7e267ee787b1d244e724a2b6f6abac0f519';
