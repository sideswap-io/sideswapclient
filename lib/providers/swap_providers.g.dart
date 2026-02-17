// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(swapType)
const swapTypeProvider = SwapTypeProvider._();

final class SwapTypeProvider
    extends $FunctionalProvider<SwapType, SwapType, SwapType>
    with $Provider<SwapType> {
  const SwapTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapTypeHash();

  @$internal
  @override
  $ProviderElement<SwapType> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwapType create(Ref ref) {
    return swapType(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapType>(value),
    );
  }
}

String _$swapTypeHash() => r'59ee6b630e8102d5ff83150c375b4d08d1663775';

@ProviderFor(swapTypeString)
const swapTypeStringProvider = SwapTypeStringProvider._();

final class SwapTypeStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const SwapTypeStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapTypeStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapTypeStringHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return swapTypeString(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapTypeStringHash() => r'60046dd90d0247e5d78a6884065850e80b69d6a5';

@ProviderFor(swapAddrType)
const swapAddrTypeProvider = SwapAddrTypeProvider._();

final class SwapAddrTypeProvider
    extends $FunctionalProvider<AddrType, AddrType, AddrType>
    with $Provider<AddrType> {
  const SwapAddrTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapAddrTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapAddrTypeHash();

  @$internal
  @override
  $ProviderElement<AddrType> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddrType create(Ref ref) {
    return swapAddrType(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddrType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddrType>(value),
    );
  }
}

String _$swapAddrTypeHash() => r'26832a85824a3f5cd10728fa3471802e75d266ad';

@ProviderFor(addrTypeString)
const addrTypeStringProvider = AddrTypeStringProvider._();

final class AddrTypeStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const AddrTypeStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addrTypeStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addrTypeStringHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return addrTypeString(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$addrTypeStringHash() => r'2f0072df5bb36b5d7fe7de00d0967f1ecf069028';

@ProviderFor(SwapSendAssetIdNotifier)
const swapSendAssetIdProvider = SwapSendAssetIdNotifierProvider._();

final class SwapSendAssetIdNotifierProvider
    extends $NotifierProvider<SwapSendAssetIdNotifier, String> {
  const SwapSendAssetIdNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapSendAssetIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapSendAssetIdNotifierHash();

  @$internal
  @override
  SwapSendAssetIdNotifier create() => SwapSendAssetIdNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapSendAssetIdNotifierHash() =>
    r'58b1a61d12e8142a2e17bfea45486a96a4a268d2';

abstract class _$SwapSendAssetIdNotifier extends $Notifier<String> {
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

@ProviderFor(swapDeliverAssetIdList)
const swapDeliverAssetIdListProvider = SwapDeliverAssetIdListProvider._();

final class SwapDeliverAssetIdListProvider
    extends
        $FunctionalProvider<
          Iterable<String>,
          Iterable<String>,
          Iterable<String>
        >
    with $Provider<Iterable<String>> {
  const SwapDeliverAssetIdListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapDeliverAssetIdListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapDeliverAssetIdListHash();

  @$internal
  @override
  $ProviderElement<Iterable<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Iterable<String> create(Ref ref) {
    return swapDeliverAssetIdList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<String>>(value),
    );
  }
}

String _$swapDeliverAssetIdListHash() =>
    r'a95fd8ef75ab60079b615ba15ac3fa92213ad556';

@ProviderFor(swapDeliverAsset)
const swapDeliverAssetProvider = SwapDeliverAssetProvider._();

final class SwapDeliverAssetProvider
    extends $FunctionalProvider<SwapAsset, SwapAsset, SwapAsset>
    with $Provider<SwapAsset> {
  const SwapDeliverAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapDeliverAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapDeliverAssetHash();

  @$internal
  @override
  $ProviderElement<SwapAsset> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwapAsset create(Ref ref) {
    return swapDeliverAsset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapAsset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapAsset>(value),
    );
  }
}

String _$swapDeliverAssetHash() => r'a8abaf47d63cc69f7d03181956e20e1a4bb7e6b0';

@ProviderFor(swapReceiveAssetIdList)
const swapReceiveAssetIdListProvider = SwapReceiveAssetIdListProvider._();

final class SwapReceiveAssetIdListProvider
    extends
        $FunctionalProvider<
          Iterable<String>,
          Iterable<String>,
          Iterable<String>
        >
    with $Provider<Iterable<String>> {
  const SwapReceiveAssetIdListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapReceiveAssetIdListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapReceiveAssetIdListHash();

  @$internal
  @override
  $ProviderElement<Iterable<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Iterable<String> create(Ref ref) {
    return swapReceiveAssetIdList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<String>>(value),
    );
  }
}

String _$swapReceiveAssetIdListHash() =>
    r'f46324466f4566049dbcab2f5fe0203f811122fd';

@ProviderFor(swapReceiveAsset)
const swapReceiveAssetProvider = SwapReceiveAssetProvider._();

final class SwapReceiveAssetProvider
    extends $FunctionalProvider<SwapAsset, SwapAsset, SwapAsset>
    with $Provider<SwapAsset> {
  const SwapReceiveAssetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapReceiveAssetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapReceiveAssetHash();

  @$internal
  @override
  $ProviderElement<SwapAsset> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwapAsset create(Ref ref) {
    return swapReceiveAsset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapAsset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapAsset>(value),
    );
  }
}

String _$swapReceiveAssetHash() => r'80af010b47256cf370a11a57c9051320b185096a';

@ProviderFor(SwapRecvAssetIdNotifier)
const swapRecvAssetIdProvider = SwapRecvAssetIdNotifierProvider._();

final class SwapRecvAssetIdNotifierProvider
    extends $NotifierProvider<SwapRecvAssetIdNotifier, String> {
  const SwapRecvAssetIdNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapRecvAssetIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapRecvAssetIdNotifierHash();

  @$internal
  @override
  SwapRecvAssetIdNotifier create() => SwapRecvAssetIdNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapRecvAssetIdNotifierHash() =>
    r'db1828f96ff73080fdec699514571b5f3e6dc784';

abstract class _$SwapRecvAssetIdNotifier extends $Notifier<String> {
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

@ProviderFor(SwapPegNotifier)
const swapPegProvider = SwapPegNotifierProvider._();

final class SwapPegNotifierProvider
    extends $NotifierProvider<SwapPegNotifier, bool> {
  const SwapPegNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapPegProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapPegNotifierHash();

  @$internal
  @override
  SwapPegNotifier create() => SwapPegNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$swapPegNotifierHash() => r'd1af7d71a915248da446d150d4eb99e4cc09d6ed';

abstract class _$SwapPegNotifier extends $Notifier<bool> {
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

@ProviderFor(swapSendWallet)
const swapSendWalletProvider = SwapSendWalletProvider._();

final class SwapSendWalletProvider
    extends $FunctionalProvider<SwapWallet, SwapWallet, SwapWallet>
    with $Provider<SwapWallet> {
  const SwapSendWalletProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapSendWalletProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapSendWalletHash();

  @$internal
  @override
  $ProviderElement<SwapWallet> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwapWallet create(Ref ref) {
    return swapSendWallet(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapWallet value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapWallet>(value),
    );
  }
}

String _$swapSendWalletHash() => r'cf582d33f771960232dbb8bd41f031659c674395';

@ProviderFor(swapRecvWallet)
const swapRecvWalletProvider = SwapRecvWalletProvider._();

final class SwapRecvWalletProvider
    extends $FunctionalProvider<SwapWallet, SwapWallet, SwapWallet>
    with $Provider<SwapWallet> {
  const SwapRecvWalletProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapRecvWalletProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapRecvWalletHash();

  @$internal
  @override
  $ProviderElement<SwapWallet> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwapWallet create(Ref ref) {
    return swapRecvWallet(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapWallet value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapWallet>(value),
    );
  }
}

String _$swapRecvWalletHash() => r'feb95d04ef6fb308bd25a432732d215943bcfd46';

@ProviderFor(SwapRecvAddressExternalNotifier)
const swapRecvAddressExternalProvider =
    SwapRecvAddressExternalNotifierProvider._();

final class SwapRecvAddressExternalNotifierProvider
    extends $NotifierProvider<SwapRecvAddressExternalNotifier, String> {
  const SwapRecvAddressExternalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapRecvAddressExternalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapRecvAddressExternalNotifierHash();

  @$internal
  @override
  SwapRecvAddressExternalNotifier create() => SwapRecvAddressExternalNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapRecvAddressExternalNotifierHash() =>
    r'0c5ca135f403ce54c196e20becbdfca92d5b4166';

abstract class _$SwapRecvAddressExternalNotifier extends $Notifier<String> {
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

@ProviderFor(SwapPegAddressServerNotifier)
const swapPegAddressServerProvider = SwapPegAddressServerNotifierProvider._();

final class SwapPegAddressServerNotifierProvider
    extends $NotifierProvider<SwapPegAddressServerNotifier, String?> {
  const SwapPegAddressServerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapPegAddressServerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapPegAddressServerNotifierHash();

  @$internal
  @override
  SwapPegAddressServerNotifier create() => SwapPegAddressServerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$swapPegAddressServerNotifierHash() =>
    r'86cf41af367375da768c074785d465fb97841974';

abstract class _$SwapPegAddressServerNotifier extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(swapPriceString)
const swapPriceStringProvider = SwapPriceStringProvider._();

final class SwapPriceStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const SwapPriceStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapPriceStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapPriceStringHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return swapPriceString(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapPriceStringHash() => r'99d46247fc3b405e4c71391af00b1e3d254e349b';

@ProviderFor(SwapPriceSubscribeNotifier)
const swapPriceSubscribeProvider = SwapPriceSubscribeNotifierProvider._();

final class SwapPriceSubscribeNotifierProvider
    extends
        $NotifierProvider<SwapPriceSubscribeNotifier, SwapPriceSubscribeState> {
  const SwapPriceSubscribeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapPriceSubscribeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapPriceSubscribeNotifierHash();

  @$internal
  @override
  SwapPriceSubscribeNotifier create() => SwapPriceSubscribeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapPriceSubscribeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapPriceSubscribeState>(value),
    );
  }
}

String _$swapPriceSubscribeNotifierHash() =>
    r'55197568525f906857bcdcbf20c01e82ae82ac68';

abstract class _$SwapPriceSubscribeNotifier
    extends $Notifier<SwapPriceSubscribeState> {
  SwapPriceSubscribeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<SwapPriceSubscribeState, SwapPriceSubscribeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SwapPriceSubscribeState, SwapPriceSubscribeState>,
              SwapPriceSubscribeState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BitcoinCurrentFeeRateNotifier)
const bitcoinCurrentFeeRateProvider = BitcoinCurrentFeeRateNotifierProvider._();

final class BitcoinCurrentFeeRateNotifierProvider
    extends $NotifierProvider<BitcoinCurrentFeeRateNotifier, Option<double>> {
  const BitcoinCurrentFeeRateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bitcoinCurrentFeeRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bitcoinCurrentFeeRateNotifierHash();

  @$internal
  @override
  BitcoinCurrentFeeRateNotifier create() => BitcoinCurrentFeeRateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<double>>(value),
    );
  }
}

String _$bitcoinCurrentFeeRateNotifierHash() =>
    r'3f661cbe8464b174e3a381b6c2b72c953c424c40';

abstract class _$BitcoinCurrentFeeRateNotifier
    extends $Notifier<Option<double>> {
  Option<double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<double>, Option<double>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<double>, Option<double>>,
              Option<double>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SwapSendTextAmountNotifier)
const swapSendTextAmountProvider = SwapSendTextAmountNotifierProvider._();

final class SwapSendTextAmountNotifierProvider
    extends $NotifierProvider<SwapSendTextAmountNotifier, String> {
  const SwapSendTextAmountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapSendTextAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapSendTextAmountNotifierHash();

  @$internal
  @override
  SwapSendTextAmountNotifier create() => SwapSendTextAmountNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapSendTextAmountNotifierHash() =>
    r'dc601c3bdf1b81b556cba0360e026e3eb34a207e';

abstract class _$SwapSendTextAmountNotifier extends $Notifier<String> {
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

@ProviderFor(swapSendSatoshiAmount)
const swapSendSatoshiAmountProvider = SwapSendSatoshiAmountProvider._();

final class SwapSendSatoshiAmountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const SwapSendSatoshiAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapSendSatoshiAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapSendSatoshiAmountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return swapSendSatoshiAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$swapSendSatoshiAmountHash() =>
    r'84a3998c2f379356a0d23fe2cb5f89c404552ec5';

@ProviderFor(SwapRecvTextAmountNotifier)
const swapRecvTextAmountProvider = SwapRecvTextAmountNotifierProvider._();

final class SwapRecvTextAmountNotifierProvider
    extends $NotifierProvider<SwapRecvTextAmountNotifier, String> {
  const SwapRecvTextAmountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapRecvTextAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapRecvTextAmountNotifierHash();

  @$internal
  @override
  SwapRecvTextAmountNotifier create() => SwapRecvTextAmountNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapRecvTextAmountNotifierHash() =>
    r'a63c20a30c029b2946a76c1298c9c5ffb682c5cf';

abstract class _$SwapRecvTextAmountNotifier extends $Notifier<String> {
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

@ProviderFor(swapRecvSatoshiAmount)
const swapRecvSatoshiAmountProvider = SwapRecvSatoshiAmountProvider._();

final class SwapRecvSatoshiAmountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const SwapRecvSatoshiAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapRecvSatoshiAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapRecvSatoshiAmountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return swapRecvSatoshiAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$swapRecvSatoshiAmountHash() =>
    r'00ee722e01ef9aeb03c3b71143bc4be9ca0ad962';

@ProviderFor(showInsufficientFunds)
const showInsufficientFundsProvider = ShowInsufficientFundsProvider._();

final class ShowInsufficientFundsProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const ShowInsufficientFundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showInsufficientFundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showInsufficientFundsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return showInsufficientFunds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showInsufficientFundsHash() =>
    r'e396d66ba7ea6b4eaf819cf3a6c6ec182489bda6';

@ProviderFor(SatoshiRecvAmountStateNotifier)
const satoshiRecvAmountStateProvider =
    SatoshiRecvAmountStateNotifierProvider._();

final class SatoshiRecvAmountStateNotifierProvider
    extends $NotifierProvider<SatoshiRecvAmountStateNotifier, int> {
  const SatoshiRecvAmountStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'satoshiRecvAmountStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$satoshiRecvAmountStateNotifierHash();

  @$internal
  @override
  SatoshiRecvAmountStateNotifier create() => SatoshiRecvAmountStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$satoshiRecvAmountStateNotifierHash() =>
    r'4375dee1177a6fdda0dee5b949d82a555bed44ea';

abstract class _$SatoshiRecvAmountStateNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SatoshiSendAmountStateNotifier)
const satoshiSendAmountStateProvider =
    SatoshiSendAmountStateNotifierProvider._();

final class SatoshiSendAmountStateNotifierProvider
    extends $NotifierProvider<SatoshiSendAmountStateNotifier, int> {
  const SatoshiSendAmountStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'satoshiSendAmountStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$satoshiSendAmountStateNotifierHash();

  @$internal
  @override
  SatoshiSendAmountStateNotifier create() => SatoshiSendAmountStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$satoshiSendAmountStateNotifierHash() =>
    r'0d503cedcd4c7029f798c924ed1047ffdbbaa467';

abstract class _$SatoshiSendAmountStateNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(recvAmountPriceStreamWatcher)
const recvAmountPriceStreamWatcherProvider =
    RecvAmountPriceStreamWatcherProvider._();

final class RecvAmountPriceStreamWatcherProvider
    extends
        $FunctionalProvider<
          SwapRecvAmountPriceStream,
          SwapRecvAmountPriceStream,
          SwapRecvAmountPriceStream
        >
    with $Provider<SwapRecvAmountPriceStream> {
  const RecvAmountPriceStreamWatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recvAmountPriceStreamWatcherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recvAmountPriceStreamWatcherHash();

  @$internal
  @override
  $ProviderElement<SwapRecvAmountPriceStream> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SwapRecvAmountPriceStream create(Ref ref) {
    return recvAmountPriceStreamWatcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapRecvAmountPriceStream value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapRecvAmountPriceStream>(value),
    );
  }
}

String _$recvAmountPriceStreamWatcherHash() =>
    r'6e1991392b4a844e63f8125fbd76bcfbe7c3e68f';

@ProviderFor(sendAmountPriceStreamWatcher)
const sendAmountPriceStreamWatcherProvider =
    SendAmountPriceStreamWatcherProvider._();

final class SendAmountPriceStreamWatcherProvider
    extends
        $FunctionalProvider<
          SwapSendAmountPriceStream,
          SwapSendAmountPriceStream,
          SwapSendAmountPriceStream
        >
    with $Provider<SwapSendAmountPriceStream> {
  const SendAmountPriceStreamWatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendAmountPriceStreamWatcherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendAmountPriceStreamWatcherHash();

  @$internal
  @override
  $ProviderElement<SwapSendAmountPriceStream> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SwapSendAmountPriceStream create(Ref ref) {
    return sendAmountPriceStreamWatcher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapSendAmountPriceStream value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapSendAmountPriceStream>(value),
    );
  }
}

String _$sendAmountPriceStreamWatcherHash() =>
    r'da4946a0f1dfa4cc50ebda4d29e4e36854315f74';

@ProviderFor(SwapStateNotifier)
const swapStateProvider = SwapStateNotifierProvider._();

final class SwapStateNotifierProvider
    extends $NotifierProvider<SwapStateNotifier, SwapState> {
  const SwapStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapStateNotifierHash();

  @$internal
  @override
  SwapStateNotifier create() => SwapStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapState>(value),
    );
  }
}

String _$swapStateNotifierHash() => r'2e5ae3a33fe36b939152d6a9c841e723513a4214';

abstract class _$SwapStateNotifier extends $Notifier<SwapState> {
  SwapState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SwapState, SwapState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SwapState, SwapState>,
              SwapState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(SwapNetworkErrorNotifier)
const swapNetworkErrorProvider = SwapNetworkErrorNotifierProvider._();

final class SwapNetworkErrorNotifierProvider
    extends $NotifierProvider<SwapNetworkErrorNotifier, String> {
  const SwapNetworkErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapNetworkErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapNetworkErrorNotifierHash();

  @$internal
  @override
  SwapNetworkErrorNotifier create() => SwapNetworkErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$swapNetworkErrorNotifierHash() =>
    r'26c54c618e931cbde57c2a7d2b4a64a83a5daec5';

abstract class _$SwapNetworkErrorNotifier extends $Notifier<String> {
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

@ProviderFor(swapPriceText)
const swapPriceTextProvider = SwapPriceTextProvider._();

final class SwapPriceTextProvider
    extends $FunctionalProvider<Option<String>, Option<String>, Option<String>>
    with $Provider<Option<String>> {
  const SwapPriceTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapPriceTextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapPriceTextHash();

  @$internal
  @override
  $ProviderElement<Option<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Option<String> create(Ref ref) {
    return swapPriceText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$swapPriceTextHash() => r'4b9ada8c71d564820c19ac1383935bf7f1ea30b9';

@ProviderFor(swapAddressError)
const swapAddressErrorProvider = SwapAddressErrorProvider._();

final class SwapAddressErrorProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  const SwapAddressErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapAddressErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapAddressErrorHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return swapAddressError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$swapAddressErrorHash() => r'69daf425b47a6293528af8f3e17e48a382ae578c';

@ProviderFor(showAddressLabel)
const showAddressLabelProvider = ShowAddressLabelProvider._();

final class ShowAddressLabelProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const ShowAddressLabelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showAddressLabelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showAddressLabelHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return showAddressLabel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showAddressLabelHash() => r'aec8e3a1cb4ba761df5cd9ea0f0a6bc03d3d47b8';

@ProviderFor(swapEnabledState)
const swapEnabledStateProvider = SwapEnabledStateProvider._();

final class SwapEnabledStateProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const SwapEnabledStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapEnabledStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapEnabledStateHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return swapEnabledState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$swapEnabledStateHash() => r'f31c2d4a370c9da157885f3e9d4e8f7a9dcfd160';

@ProviderFor(swapHelper)
const swapHelperProvider = SwapHelperProvider._();

final class SwapHelperProvider
    extends $FunctionalProvider<SwapHelper, SwapHelper, SwapHelper>
    with $Provider<SwapHelper> {
  const SwapHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'swapHelperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$swapHelperHash();

  @$internal
  @override
  $ProviderElement<SwapHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SwapHelper create(Ref ref) {
    return swapHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SwapHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SwapHelper>(value),
    );
  }
}

String _$swapHelperHash() => r'9ab2c52427f4dc44f2f1791818dd4df9bd93570e';
