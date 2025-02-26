// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentHelperHash() => r'8af8c56ffeb270d46e4eead279c6163f1d84719f';

/// See also [paymentHelper].
@ProviderFor(paymentHelper)
final paymentHelperProvider = AutoDisposeProvider<PaymentHelper>.internal(
  paymentHelper,
  name: r'paymentHelperProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentHelperHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentHelperRef = AutoDisposeProviderRef<PaymentHelper>;
String _$createTxStateNotifierHash() =>
    r'f68ff9d72afd9357f14098b35b191bf05516def6';

/// See also [CreateTxStateNotifier].
@ProviderFor(CreateTxStateNotifier)
final createTxStateNotifierProvider =
    NotifierProvider<CreateTxStateNotifier, CreateTxState>.internal(
      CreateTxStateNotifier.new,
      name: r'createTxStateNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
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
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
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
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
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
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
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
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
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
  PaymentAmountPageArgumentsNotifier,
  PaymentAmountPageArguments
>.internal(
  PaymentAmountPageArgumentsNotifier.new,
  name: r'paymentAmountPageArgumentsNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentAmountPageArgumentsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentAmountPageArgumentsNotifier =
    Notifier<PaymentAmountPageArguments>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
