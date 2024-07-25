// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$parseAssetAmountHash() => r'4755a18a5bf4c0a8a960a8691bde8fe1a5285b11';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [parseAssetAmount].
@ProviderFor(parseAssetAmount)
const parseAssetAmountProvider = ParseAssetAmountFamily();

/// See also [parseAssetAmount].
class ParseAssetAmountFamily extends Family<int?> {
  /// See also [parseAssetAmount].
  const ParseAssetAmountFamily();

  /// See also [parseAssetAmount].
  ParseAssetAmountProvider call({
    required String amount,
    required int precision,
  }) {
    return ParseAssetAmountProvider(
      amount: amount,
      precision: precision,
    );
  }

  @override
  ParseAssetAmountProvider getProviderOverride(
    covariant ParseAssetAmountProvider provider,
  ) {
    return call(
      amount: provider.amount,
      precision: provider.precision,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'parseAssetAmountProvider';
}

/// See also [parseAssetAmount].
class ParseAssetAmountProvider extends AutoDisposeProvider<int?> {
  /// See also [parseAssetAmount].
  ParseAssetAmountProvider({
    required String amount,
    required int precision,
  }) : this._internal(
          (ref) => parseAssetAmount(
            ref as ParseAssetAmountRef,
            amount: amount,
            precision: precision,
          ),
          from: parseAssetAmountProvider,
          name: r'parseAssetAmountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$parseAssetAmountHash,
          dependencies: ParseAssetAmountFamily._dependencies,
          allTransitiveDependencies:
              ParseAssetAmountFamily._allTransitiveDependencies,
          amount: amount,
          precision: precision,
        );

  ParseAssetAmountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.amount,
    required this.precision,
  }) : super.internal();

  final String amount;
  final int precision;

  @override
  Override overrideWith(
    int? Function(ParseAssetAmountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ParseAssetAmountProvider._internal(
        (ref) => create(ref as ParseAssetAmountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        amount: amount,
        precision: precision,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int?> createElement() {
    return _ParseAssetAmountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParseAssetAmountProvider &&
        other.amount == amount &&
        other.precision == precision;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);
    hash = _SystemHash.combine(hash, precision.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ParseAssetAmountRef on AutoDisposeProviderRef<int?> {
  /// The parameter `amount` of this provider.
  String get amount;

  /// The parameter `precision` of this provider.
  int get precision;
}

class _ParseAssetAmountProviderElement extends AutoDisposeProviderElement<int?>
    with ParseAssetAmountRef {
  _ParseAssetAmountProviderElement(super.provider);

  @override
  String get amount => (origin as ParseAssetAmountProvider).amount;
  @override
  int get precision => (origin as ParseAssetAmountProvider).precision;
}

String _$satoshiForAmountHash() => r'74316e59d81dd6c98ad98555777ecd604fbe89dc';

/// See also [satoshiForAmount].
@ProviderFor(satoshiForAmount)
const satoshiForAmountProvider = SatoshiForAmountFamily();

/// See also [satoshiForAmount].
class SatoshiForAmountFamily extends Family<int> {
  /// See also [satoshiForAmount].
  const SatoshiForAmountFamily();

  /// See also [satoshiForAmount].
  SatoshiForAmountProvider call({
    required String assetId,
    required String amount,
  }) {
    return SatoshiForAmountProvider(
      assetId: assetId,
      amount: amount,
    );
  }

  @override
  SatoshiForAmountProvider getProviderOverride(
    covariant SatoshiForAmountProvider provider,
  ) {
    return call(
      assetId: provider.assetId,
      amount: provider.amount,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'satoshiForAmountProvider';
}

/// See also [satoshiForAmount].
class SatoshiForAmountProvider extends AutoDisposeProvider<int> {
  /// See also [satoshiForAmount].
  SatoshiForAmountProvider({
    required String assetId,
    required String amount,
  }) : this._internal(
          (ref) => satoshiForAmount(
            ref as SatoshiForAmountRef,
            assetId: assetId,
            amount: amount,
          ),
          from: satoshiForAmountProvider,
          name: r'satoshiForAmountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$satoshiForAmountHash,
          dependencies: SatoshiForAmountFamily._dependencies,
          allTransitiveDependencies:
              SatoshiForAmountFamily._allTransitiveDependencies,
          assetId: assetId,
          amount: amount,
        );

  SatoshiForAmountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
    required this.amount,
  }) : super.internal();

  final String assetId;
  final String amount;

  @override
  Override overrideWith(
    int Function(SatoshiForAmountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SatoshiForAmountProvider._internal(
        (ref) => create(ref as SatoshiForAmountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _SatoshiForAmountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SatoshiForAmountProvider &&
        other.assetId == assetId &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SatoshiForAmountRef on AutoDisposeProviderRef<int> {
  /// The parameter `assetId` of this provider.
  String get assetId;

  /// The parameter `amount` of this provider.
  String get amount;
}

class _SatoshiForAmountProviderElement extends AutoDisposeProviderElement<int>
    with SatoshiForAmountRef {
  _SatoshiForAmountProviderElement(super.provider);

  @override
  String get assetId => (origin as SatoshiForAmountProvider).assetId;
  @override
  String get amount => (origin as SatoshiForAmountProvider).amount;
}

String _$paymentHelperHash() => r'5b3ef574b9c22c3b56325aecbb49eadcfe6c788d';

/// See also [paymentHelper].
@ProviderFor(paymentHelper)
final paymentHelperProvider = AutoDisposeProvider<PaymentHelper>.internal(
  paymentHelper,
  name: r'paymentHelperProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentHelperHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PaymentHelperRef = AutoDisposeProviderRef<PaymentHelper>;
String _$createTxStateNotifierHash() =>
    r'f68ff9d72afd9357f14098b35b191bf05516def6';

/// See also [CreateTxStateNotifier].
@ProviderFor(CreateTxStateNotifier)
final createTxStateNotifierProvider =
    NotifierProvider<CreateTxStateNotifier, CreateTxState>.internal(
  CreateTxStateNotifier.new,
  name: r'createTxStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createTxStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateTxStateNotifier = Notifier<CreateTxState>;
String _$sendTxStateNotifierHash() =>
    r'7b11dadb3ef928c6288c75715fb42578d5727c4a';

/// See also [SendTxStateNotifier].
@ProviderFor(SendTxStateNotifier)
final sendTxStateNotifierProvider =
    NotifierProvider<SendTxStateNotifier, SendTxState>.internal(
  SendTxStateNotifier.new,
  name: r'sendTxStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sendTxStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SendTxStateNotifier = Notifier<SendTxState>;
String _$paymentInsufficientFundsNotifierHash() =>
    r'2f7cb58452f78885860c288d3b7dcc44ae928cac';

/// See also [PaymentInsufficientFundsNotifier].
@ProviderFor(PaymentInsufficientFundsNotifier)
final paymentInsufficientFundsNotifierProvider =
    NotifierProvider<PaymentInsufficientFundsNotifier, bool>.internal(
  PaymentInsufficientFundsNotifier.new,
  name: r'paymentInsufficientFundsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentInsufficientFundsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentInsufficientFundsNotifier = Notifier<bool>;
String _$paymentSendAddressParsedNotifierHash() =>
    r'be1489a2c423e3450c337caf92f1dc4a29a8f076';

/// See also [PaymentSendAddressParsedNotifier].
@ProviderFor(PaymentSendAddressParsedNotifier)
final paymentSendAddressParsedNotifierProvider =
    NotifierProvider<PaymentSendAddressParsedNotifier, String>.internal(
  PaymentSendAddressParsedNotifier.new,
  name: r'paymentSendAddressParsedNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentSendAddressParsedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentSendAddressParsedNotifier = Notifier<String>;
String _$paymentSendAmountParsedNotifierHash() =>
    r'88f0e9bf9c76bd8b4722af5837dd868f8205ece4';

/// See also [PaymentSendAmountParsedNotifier].
@ProviderFor(PaymentSendAmountParsedNotifier)
final paymentSendAmountParsedNotifierProvider =
    NotifierProvider<PaymentSendAmountParsedNotifier, int>.internal(
  PaymentSendAmountParsedNotifier.new,
  name: r'paymentSendAmountParsedNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentSendAmountParsedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentSendAmountParsedNotifier = Notifier<int>;
String _$paymentAmountPageArgumentsNotifierHash() =>
    r'99532cee5f9d8d3be6192e57450df28e2809a3b7';

/// See also [PaymentAmountPageArgumentsNotifier].
@ProviderFor(PaymentAmountPageArgumentsNotifier)
final paymentAmountPageArgumentsNotifierProvider = NotifierProvider<
    PaymentAmountPageArgumentsNotifier, PaymentAmountPageArguments>.internal(
  PaymentAmountPageArgumentsNotifier.new,
  name: r'paymentAmountPageArgumentsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentAmountPageArgumentsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentAmountPageArgumentsNotifier
    = Notifier<PaymentAmountPageArguments>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
