// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_select_asset.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaymentAvailableAssets)
const paymentAvailableAssetsProvider = PaymentAvailableAssetsProvider._();

final class PaymentAvailableAssetsProvider
    extends $NotifierProvider<PaymentAvailableAssets, Iterable<String>> {
  const PaymentAvailableAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentAvailableAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentAvailableAssetsHash();

  @$internal
  @override
  PaymentAvailableAssets create() => PaymentAvailableAssets();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<String>>(value),
    );
  }
}

String _$paymentAvailableAssetsHash() =>
    r'd9d253df7ef5df89b3da94edb3df7903dfd22bc2';

abstract class _$PaymentAvailableAssets extends $Notifier<Iterable<String>> {
  Iterable<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Iterable<String>, Iterable<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Iterable<String>, Iterable<String>>,
              Iterable<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PaymentDisabledAssets)
const paymentDisabledAssetsProvider = PaymentDisabledAssetsProvider._();

final class PaymentDisabledAssetsProvider
    extends $NotifierProvider<PaymentDisabledAssets, Iterable<String>> {
  const PaymentDisabledAssetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentDisabledAssetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentDisabledAssetsHash();

  @$internal
  @override
  PaymentDisabledAssets create() => PaymentDisabledAssets();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<String>>(value),
    );
  }
}

String _$paymentDisabledAssetsHash() =>
    r'd5388d815547aad761bec274afe933a027297b53';

abstract class _$PaymentDisabledAssets extends $Notifier<Iterable<String>> {
  Iterable<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Iterable<String>, Iterable<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Iterable<String>, Iterable<String>>,
              Iterable<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(paymentIsAssetDisabled)
const paymentIsAssetDisabledProvider = PaymentIsAssetDisabledFamily._();

final class PaymentIsAssetDisabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const PaymentIsAssetDisabledProvider._({
    required PaymentIsAssetDisabledFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'paymentIsAssetDisabledProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentIsAssetDisabledHash();

  @override
  String toString() {
    return r'paymentIsAssetDisabledProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return paymentIsAssetDisabled(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentIsAssetDisabledProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentIsAssetDisabledHash() =>
    r'a54ec2e37766189b78c6b39cb6bc01f652806716';

final class PaymentIsAssetDisabledFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const PaymentIsAssetDisabledFamily._()
    : super(
        retry: null,
        name: r'paymentIsAssetDisabledProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PaymentIsAssetDisabledProvider call(String assetId) =>
      PaymentIsAssetDisabledProvider._(argument: assetId, from: this);

  @override
  String toString() => r'paymentIsAssetDisabledProvider';
}

@ProviderFor(paymentAvailableAssetsWithInputsFiltered)
const paymentAvailableAssetsWithInputsFilteredProvider =
    PaymentAvailableAssetsWithInputsFilteredProvider._();

final class PaymentAvailableAssetsWithInputsFilteredProvider
    extends
        $FunctionalProvider<
          Iterable<String>,
          Iterable<String>,
          Iterable<String>
        >
    with $Provider<Iterable<String>> {
  const PaymentAvailableAssetsWithInputsFilteredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentAvailableAssetsWithInputsFilteredProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$paymentAvailableAssetsWithInputsFilteredHash();

  @$internal
  @override
  $ProviderElement<Iterable<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Iterable<String> create(Ref ref) {
    return paymentAvailableAssetsWithInputsFiltered(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<String>>(value),
    );
  }
}

String _$paymentAvailableAssetsWithInputsFilteredHash() =>
    r'f6570e02f75f8763f2a1b9811deaf3d8b6fa76fa';
