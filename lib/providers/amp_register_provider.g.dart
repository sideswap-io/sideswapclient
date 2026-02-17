// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amp_register_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stokrSecurities)
const stokrSecuritiesProvider = StokrSecuritiesProvider._();

final class StokrSecuritiesProvider
    extends
        $FunctionalProvider<
          List<SecuritiesItem>,
          List<SecuritiesItem>,
          List<SecuritiesItem>
        >
    with $Provider<List<SecuritiesItem>> {
  const StokrSecuritiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokrSecuritiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokrSecuritiesHash();

  @$internal
  @override
  $ProviderElement<List<SecuritiesItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<SecuritiesItem> create(Ref ref) {
    return stokrSecurities(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SecuritiesItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SecuritiesItem>>(value),
    );
  }
}

String _$stokrSecuritiesHash() => r'f665b6c3afe8d60222d9fb1663cc0f07cf09d2a0';

@ProviderFor(pegxSecurities)
const pegxSecuritiesProvider = PegxSecuritiesProvider._();

final class PegxSecuritiesProvider
    extends
        $FunctionalProvider<
          List<SecuritiesItem>,
          List<SecuritiesItem>,
          List<SecuritiesItem>
        >
    with $Provider<List<SecuritiesItem>> {
  const PegxSecuritiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pegxSecuritiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pegxSecuritiesHash();

  @$internal
  @override
  $ProviderElement<List<SecuritiesItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<SecuritiesItem> create(Ref ref) {
    return pegxSecurities(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SecuritiesItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SecuritiesItem>>(value),
    );
  }
}

String _$pegxSecuritiesHash() => r'd31158c95ccd1b16afa223db032b4cc3a9f23c87';

@ProviderFor(StokrGaidNotifier)
const stokrGaidProvider = StokrGaidNotifierProvider._();

final class StokrGaidNotifierProvider
    extends $NotifierProvider<StokrGaidNotifier, StokrGaidState> {
  const StokrGaidNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stokrGaidProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stokrGaidNotifierHash();

  @$internal
  @override
  StokrGaidNotifier create() => StokrGaidNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StokrGaidState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StokrGaidState>(value),
    );
  }
}

String _$stokrGaidNotifierHash() => r'8673920fa61f49de33d9cfeefdfd63d3d3602706';

abstract class _$StokrGaidNotifier extends $Notifier<StokrGaidState> {
  StokrGaidState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StokrGaidState, StokrGaidState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StokrGaidState, StokrGaidState>,
              StokrGaidState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(checkAmpStatus)
const checkAmpStatusProvider = CheckAmpStatusProvider._();

final class CheckAmpStatusProvider
    extends
        $FunctionalProvider<
          CheckAmpStatusImpl,
          CheckAmpStatusImpl,
          CheckAmpStatusImpl
        >
    with $Provider<CheckAmpStatusImpl> {
  const CheckAmpStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkAmpStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkAmpStatusHash();

  @$internal
  @override
  $ProviderElement<CheckAmpStatusImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CheckAmpStatusImpl create(Ref ref) {
    return checkAmpStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CheckAmpStatusImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CheckAmpStatusImpl>(value),
    );
  }
}

String _$checkAmpStatusHash() => r'f9dfbeeaf49c6883154cd228e23bb67ae7786094';
