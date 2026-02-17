// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jade_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JadeBluetoothPermissionStateNotifier)
const jadeBluetoothPermissionStateProvider =
    JadeBluetoothPermissionStateNotifierProvider._();

final class JadeBluetoothPermissionStateNotifierProvider
    extends
        $NotifierProvider<
          JadeBluetoothPermissionStateNotifier,
          JadeBluetoothPermissionState
        > {
  const JadeBluetoothPermissionStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeBluetoothPermissionStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$jadeBluetoothPermissionStateNotifierHash();

  @$internal
  @override
  JadeBluetoothPermissionStateNotifier create() =>
      JadeBluetoothPermissionStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JadeBluetoothPermissionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JadeBluetoothPermissionState>(value),
    );
  }
}

String _$jadeBluetoothPermissionStateNotifierHash() =>
    r'98c161e160010420edc2841205786f6887807ca2';

abstract class _$JadeBluetoothPermissionStateNotifier
    extends $Notifier<JadeBluetoothPermissionState> {
  JadeBluetoothPermissionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<JadeBluetoothPermissionState, JadeBluetoothPermissionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                JadeBluetoothPermissionState,
                JadeBluetoothPermissionState
              >,
              JadeBluetoothPermissionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(jadeRescan)
const jadeRescanProvider = JadeRescanProvider._();

final class JadeRescanProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  const JadeRescanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeRescanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeRescanHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return jadeRescan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$jadeRescanHash() => r'da73b6728860af9534ebff1d6d4c84175bc540f7';

@ProviderFor(JadeDeviceNotifier)
const jadeDeviceProvider = JadeDeviceNotifierProvider._();

final class JadeDeviceNotifierProvider
    extends $NotifierProvider<JadeDeviceNotifier, JadeDevicesState> {
  const JadeDeviceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeDeviceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeDeviceNotifierHash();

  @$internal
  @override
  JadeDeviceNotifier create() => JadeDeviceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JadeDevicesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JadeDevicesState>(value),
    );
  }
}

String _$jadeDeviceNotifierHash() =>
    r'96e9030a83954991084b5909d6e79d4683e8c14c';

abstract class _$JadeDeviceNotifier extends $Notifier<JadeDevicesState> {
  JadeDevicesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<JadeDevicesState, JadeDevicesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JadeDevicesState, JadeDevicesState>,
              JadeDevicesState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JadeStatusNotifier)
const jadeStatusProvider = JadeStatusNotifierProvider._();

final class JadeStatusNotifierProvider
    extends $NotifierProvider<JadeStatusNotifier, JadeStatus> {
  const JadeStatusNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeStatusNotifierHash();

  @$internal
  @override
  JadeStatusNotifier create() => JadeStatusNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JadeStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JadeStatus>(value),
    );
  }
}

String _$jadeStatusNotifierHash() =>
    r'36e6f9a6ecd57bad125de3735efdad7c08732bff';

abstract class _$JadeStatusNotifier extends $Notifier<JadeStatus> {
  JadeStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<JadeStatus, JadeStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JadeStatus, JadeStatus>,
              JadeStatus,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JadeOnboardingRegistrationNotifier)
const jadeOnboardingRegistrationProvider =
    JadeOnboardingRegistrationNotifierProvider._();

final class JadeOnboardingRegistrationNotifierProvider
    extends
        $NotifierProvider<
          JadeOnboardingRegistrationNotifier,
          JadeOnboardingRegistrationState
        > {
  const JadeOnboardingRegistrationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeOnboardingRegistrationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$jadeOnboardingRegistrationNotifierHash();

  @$internal
  @override
  JadeOnboardingRegistrationNotifier create() =>
      JadeOnboardingRegistrationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JadeOnboardingRegistrationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JadeOnboardingRegistrationState>(
        value,
      ),
    );
  }
}

String _$jadeOnboardingRegistrationNotifierHash() =>
    r'a1499b17a130e087de6fdb417cae43bfc480751b';

abstract class _$JadeOnboardingRegistrationNotifier
    extends $Notifier<JadeOnboardingRegistrationState> {
  JadeOnboardingRegistrationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              JadeOnboardingRegistrationState,
              JadeOnboardingRegistrationState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                JadeOnboardingRegistrationState,
                JadeOnboardingRegistrationState
              >,
              JadeOnboardingRegistrationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(jadeRegistrationButtonEnabled)
const jadeRegistrationButtonEnabledProvider =
    JadeRegistrationButtonEnabledProvider._();

final class JadeRegistrationButtonEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const JadeRegistrationButtonEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeRegistrationButtonEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeRegistrationButtonEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return jadeRegistrationButtonEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$jadeRegistrationButtonEnabledHash() =>
    r'5c31319cc46077842c10d85c0772b3d866f5d74e';

@ProviderFor(isJadeWallet)
const isJadeWalletProvider = IsJadeWalletProvider._();

final class IsJadeWalletProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsJadeWalletProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isJadeWalletProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isJadeWalletHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isJadeWallet(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isJadeWalletHash() => r'f365756b4bcbe7b3823f16f1a733052aaaad5aaa';

@ProviderFor(JadeInfoDialogNotifier)
const jadeInfoDialogProvider = JadeInfoDialogNotifierProvider._();

final class JadeInfoDialogNotifierProvider
    extends $NotifierProvider<JadeInfoDialogNotifier, DialogRoute<dynamic>?> {
  const JadeInfoDialogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeInfoDialogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeInfoDialogNotifierHash();

  @$internal
  @override
  JadeInfoDialogNotifier create() => JadeInfoDialogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DialogRoute<dynamic>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DialogRoute<dynamic>?>(value),
    );
  }
}

String _$jadeInfoDialogNotifierHash() =>
    r'86a9b2a0cf42f150c717eaaa522baa101b4533d3';

abstract class _$JadeInfoDialogNotifier
    extends $Notifier<DialogRoute<dynamic>?> {
  DialogRoute<dynamic>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DialogRoute<dynamic>?, DialogRoute<dynamic>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DialogRoute<dynamic>?, DialogRoute<dynamic>?>,
              DialogRoute<dynamic>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JadeSelectedDevice)
const jadeSelectedDeviceProvider = JadeSelectedDeviceProvider._();

final class JadeSelectedDeviceProvider
    extends $NotifierProvider<JadeSelectedDevice, From_JadePorts_Port?> {
  const JadeSelectedDeviceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeSelectedDeviceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeSelectedDeviceHash();

  @$internal
  @override
  JadeSelectedDevice create() => JadeSelectedDevice();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(From_JadePorts_Port? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<From_JadePorts_Port?>(value),
    );
  }
}

String _$jadeSelectedDeviceHash() =>
    r'516c0840d06f45f78a903fc43c47e7719492b30f';

abstract class _$JadeSelectedDevice extends $Notifier<From_JadePorts_Port?> {
  From_JadePorts_Port? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<From_JadePorts_Port?, From_JadePorts_Port?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<From_JadePorts_Port?, From_JadePorts_Port?>,
              From_JadePorts_Port?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JadeLockStateTimerNotifier)
const jadeLockStateTimerProvider = JadeLockStateTimerNotifierProvider._();

final class JadeLockStateTimerNotifierProvider
    extends $NotifierProvider<JadeLockStateTimerNotifier, void> {
  const JadeLockStateTimerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeLockStateTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeLockStateTimerNotifierHash();

  @$internal
  @override
  JadeLockStateTimerNotifier create() => JadeLockStateTimerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$jadeLockStateTimerNotifierHash() =>
    r'c884c8539bf3bbe3989005ecb35924a351e2a5e9';

abstract class _$JadeLockStateTimerNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(JadeLockStateNotifier)
const jadeLockStateProvider = JadeLockStateNotifierProvider._();

final class JadeLockStateNotifierProvider
    extends $NotifierProvider<JadeLockStateNotifier, JadeLockState> {
  const JadeLockStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeLockStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeLockStateNotifierHash();

  @$internal
  @override
  JadeLockStateNotifier create() => JadeLockStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JadeLockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JadeLockState>(value),
    );
  }
}

String _$jadeLockStateNotifierHash() =>
    r'f1a3f40e2d6ea48739dd3c0597319fd0b3cbaee5';

abstract class _$JadeLockStateNotifier extends $Notifier<JadeLockState> {
  JadeLockState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<JadeLockState, JadeLockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JadeLockState, JadeLockState>,
              JadeLockState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(jadeLockRepository)
const jadeLockRepositoryProvider = JadeLockRepositoryProvider._();

final class JadeLockRepositoryProvider
    extends
        $FunctionalProvider<
          AbstractJadeLockRepository,
          AbstractJadeLockRepository,
          AbstractJadeLockRepository
        >
    with $Provider<AbstractJadeLockRepository> {
  const JadeLockRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeLockRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeLockRepositoryHash();

  @$internal
  @override
  $ProviderElement<AbstractJadeLockRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AbstractJadeLockRepository create(Ref ref) {
    return jadeLockRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractJadeLockRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractJadeLockRepository>(value),
    );
  }
}

String _$jadeLockRepositoryHash() =>
    r'de50940524641a7147fa9830f9b4037781cb7c69';

@ProviderFor(JadeOneTimeAuthorization)
const jadeOneTimeAuthorizationProvider = JadeOneTimeAuthorizationProvider._();

final class JadeOneTimeAuthorizationProvider
    extends $NotifierProvider<JadeOneTimeAuthorization, bool> {
  const JadeOneTimeAuthorizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeOneTimeAuthorizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeOneTimeAuthorizationHash();

  @$internal
  @override
  JadeOneTimeAuthorization create() => JadeOneTimeAuthorization();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$jadeOneTimeAuthorizationHash() =>
    r'd0bc6d16a997a07afa408f78434adaca1f906c7a';

abstract class _$JadeOneTimeAuthorization extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JadeAuthInProgressStateNotifier)
const jadeAuthInProgressStateProvider =
    JadeAuthInProgressStateNotifierProvider._();

final class JadeAuthInProgressStateNotifierProvider
    extends $NotifierProvider<JadeAuthInProgressStateNotifier, bool> {
  const JadeAuthInProgressStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeAuthInProgressStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeAuthInProgressStateNotifierHash();

  @$internal
  @override
  JadeAuthInProgressStateNotifier create() => JadeAuthInProgressStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$jadeAuthInProgressStateNotifierHash() =>
    r'a79ff7240cf37e122b0d2cd25e96ad694202a03a';

abstract class _$JadeAuthInProgressStateNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(JadeVerifyAddressStateNotifier)
const jadeVerifyAddressStateProvider =
    JadeVerifyAddressStateNotifierProvider._();

final class JadeVerifyAddressStateNotifierProvider
    extends
        $NotifierProvider<
          JadeVerifyAddressStateNotifier,
          JadeVerifyAddressState
        > {
  const JadeVerifyAddressStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jadeVerifyAddressStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jadeVerifyAddressStateNotifierHash();

  @$internal
  @override
  JadeVerifyAddressStateNotifier create() => JadeVerifyAddressStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JadeVerifyAddressState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JadeVerifyAddressState>(value),
    );
  }
}

String _$jadeVerifyAddressStateNotifierHash() =>
    r'a34f06b997d5a0630a4b36fc4688f30ce99b20b8';

abstract class _$JadeVerifyAddressStateNotifier
    extends $Notifier<JadeVerifyAddressState> {
  JadeVerifyAddressState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<JadeVerifyAddressState, JadeVerifyAddressState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JadeVerifyAddressState, JadeVerifyAddressState>,
              JadeVerifyAddressState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
