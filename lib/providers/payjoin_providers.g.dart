// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payjoin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeductFeeFromOutputEnabledNotifier)
final deductFeeFromOutputEnabledProvider =
    DeductFeeFromOutputEnabledNotifierProvider._();

final class DeductFeeFromOutputEnabledNotifierProvider
    extends $NotifierProvider<DeductFeeFromOutputEnabledNotifier, bool> {
  DeductFeeFromOutputEnabledNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deductFeeFromOutputEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$deductFeeFromOutputEnabledNotifierHash();

  @$internal
  @override
  DeductFeeFromOutputEnabledNotifier create() =>
      DeductFeeFromOutputEnabledNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$deductFeeFromOutputEnabledNotifierHash() =>
    r'96e762d7b8b44b7e989db74fef59baf54ba5acf7';

abstract class _$DeductFeeFromOutputEnabledNotifier extends $Notifier<bool> {
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

@ProviderFor(PayjoinRadioButtonIndexNotifier)
final payjoinRadioButtonIndexProvider =
    PayjoinRadioButtonIndexNotifierProvider._();

final class PayjoinRadioButtonIndexNotifierProvider
    extends $NotifierProvider<PayjoinRadioButtonIndexNotifier, int> {
  PayjoinRadioButtonIndexNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payjoinRadioButtonIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payjoinRadioButtonIndexNotifierHash();

  @$internal
  @override
  PayjoinRadioButtonIndexNotifier create() => PayjoinRadioButtonIndexNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$payjoinRadioButtonIndexNotifierHash() =>
    r'568bf888979538d58fe4ec0b8f24db9667426458';

abstract class _$PayjoinRadioButtonIndexNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(DeductFeeFromOutputNotifier)
final deductFeeFromOutputProvider = DeductFeeFromOutputNotifierProvider._();

final class DeductFeeFromOutputNotifierProvider
    extends $NotifierProvider<DeductFeeFromOutputNotifier, bool> {
  DeductFeeFromOutputNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deductFeeFromOutputProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deductFeeFromOutputNotifierHash();

  @$internal
  @override
  DeductFeeFromOutputNotifier create() => DeductFeeFromOutputNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$deductFeeFromOutputNotifierHash() =>
    r'5fc0f3946cdda1dcd09fe0b4252f9546b6ad9d70';

abstract class _$DeductFeeFromOutputNotifier extends $Notifier<bool> {
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

@ProviderFor(liquidHaveBalance)
final liquidHaveBalanceProvider = LiquidHaveBalanceProvider._();

final class LiquidHaveBalanceProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  LiquidHaveBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liquidHaveBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liquidHaveBalanceHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return liquidHaveBalance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$liquidHaveBalanceHash() => r'9605783c040969471fb26c50e1f58be54018d356';

@ProviderFor(PayjoinFeeAssetNotifier)
final payjoinFeeAssetProvider = PayjoinFeeAssetNotifierProvider._();

final class PayjoinFeeAssetNotifierProvider
    extends $NotifierProvider<PayjoinFeeAssetNotifier, Asset?> {
  PayjoinFeeAssetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payjoinFeeAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payjoinFeeAssetNotifierHash();

  @$internal
  @override
  PayjoinFeeAssetNotifier create() => PayjoinFeeAssetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Asset? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Asset?>(value),
    );
  }
}

String _$payjoinFeeAssetNotifierHash() =>
    r'810e82b891abcce12e9bf9f88973b4ff916da5dd';

abstract class _$PayjoinFeeAssetNotifier extends $Notifier<Asset?> {
  Asset? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Asset?, Asset?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Asset?, Asset?>,
              Asset?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(payjoinAssets)
final payjoinAssetsProvider = PayjoinAssetsProvider._();

final class PayjoinAssetsProvider
    extends $FunctionalProvider<List<Asset>, List<Asset>, List<Asset>>
    with $Provider<List<Asset>> {
  PayjoinAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payjoinAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payjoinAssetsHash();

  @$internal
  @override
  $ProviderElement<List<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Asset> create(Ref ref) {
    return payjoinAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Asset>>(value),
    );
  }
}

String _$payjoinAssetsHash() => r'e201d5b4ce34359125ba05422d8603892018f9bb';

@ProviderFor(payjoinFeeAssets)
final payjoinFeeAssetsProvider = PayjoinFeeAssetsProvider._();

final class PayjoinFeeAssetsProvider
    extends $FunctionalProvider<List<Asset>, List<Asset>, List<Asset>>
    with $Provider<List<Asset>> {
  PayjoinFeeAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'payjoinFeeAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$payjoinFeeAssetsHash();

  @$internal
  @override
  $ProviderElement<List<Asset>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Asset> create(Ref ref) {
    return payjoinFeeAssets(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Asset> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Asset>>(value),
    );
  }
}

String _$payjoinFeeAssetsHash() => r'959d304430a9500e6ee867d98b3c2ed7744652b3';
