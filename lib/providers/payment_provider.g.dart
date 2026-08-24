// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateTxStateNotifier)
final createTxStateProvider = CreateTxStateNotifierProvider._();

final class CreateTxStateNotifierProvider
    extends $NotifierProvider<CreateTxStateNotifier, CreateTxState> {
  CreateTxStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createTxStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createTxStateNotifierHash();

  @$internal
  @override
  CreateTxStateNotifier create() => CreateTxStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateTxState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateTxState>(value),
    );
  }
}

String _$createTxStateNotifierHash() =>
    r'f68ff9d72afd9357f14098b35b191bf05516def6';

abstract class _$CreateTxStateNotifier extends $Notifier<CreateTxState> {
  CreateTxState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CreateTxState, CreateTxState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateTxState, CreateTxState>,
              CreateTxState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SendTxStateNotifier)
final sendTxStateProvider = SendTxStateNotifierProvider._();

final class SendTxStateNotifierProvider
    extends $NotifierProvider<SendTxStateNotifier, SendTxState> {
  SendTxStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendTxStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendTxStateNotifierHash();

  @$internal
  @override
  SendTxStateNotifier create() => SendTxStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendTxState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendTxState>(value),
    );
  }
}

String _$sendTxStateNotifierHash() =>
    r'7b11dadb3ef928c6288c75715fb42578d5727c4a';

abstract class _$SendTxStateNotifier extends $Notifier<SendTxState> {
  SendTxState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SendTxState, SendTxState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SendTxState, SendTxState>,
              SendTxState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PaymentSendAddressParsedNotifier)
final paymentSendAddressParsedProvider =
    PaymentSendAddressParsedNotifierProvider._();

final class PaymentSendAddressParsedNotifierProvider
    extends $NotifierProvider<PaymentSendAddressParsedNotifier, String> {
  PaymentSendAddressParsedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentSendAddressParsedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentSendAddressParsedNotifierHash();

  @$internal
  @override
  PaymentSendAddressParsedNotifier create() =>
      PaymentSendAddressParsedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$paymentSendAddressParsedNotifierHash() =>
    r'be1489a2c423e3450c337caf92f1dc4a29a8f076';

abstract class _$PaymentSendAddressParsedNotifier extends $Notifier<String> {
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

@ProviderFor(PaymentSendAmountParsedNotifier)
final paymentSendAmountParsedProvider =
    PaymentSendAmountParsedNotifierProvider._();

final class PaymentSendAmountParsedNotifierProvider
    extends $NotifierProvider<PaymentSendAmountParsedNotifier, int> {
  PaymentSendAmountParsedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentSendAmountParsedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentSendAmountParsedNotifierHash();

  @$internal
  @override
  PaymentSendAmountParsedNotifier create() => PaymentSendAmountParsedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$paymentSendAmountParsedNotifierHash() =>
    r'88f0e9bf9c76bd8b4722af5837dd868f8205ece4';

abstract class _$PaymentSendAmountParsedNotifier extends $Notifier<int> {
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

@ProviderFor(PaymentAmountPageArgumentsNotifier)
final paymentAmountPageArgumentsProvider =
    PaymentAmountPageArgumentsNotifierProvider._();

final class PaymentAmountPageArgumentsNotifierProvider
    extends
        $NotifierProvider<
          PaymentAmountPageArgumentsNotifier,
          PaymentAmountPageArguments
        > {
  PaymentAmountPageArgumentsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentAmountPageArgumentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$paymentAmountPageArgumentsNotifierHash();

  @$internal
  @override
  PaymentAmountPageArgumentsNotifier create() =>
      PaymentAmountPageArgumentsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentAmountPageArguments value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentAmountPageArguments>(value),
    );
  }
}

String _$paymentAmountPageArgumentsNotifierHash() =>
    r'99532cee5f9d8d3be6192e57450df28e2809a3b7';

abstract class _$PaymentAmountPageArgumentsNotifier
    extends $Notifier<PaymentAmountPageArguments> {
  PaymentAmountPageArguments build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<PaymentAmountPageArguments, PaymentAmountPageArguments>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PaymentAmountPageArguments,
                PaymentAmountPageArguments
              >,
              PaymentAmountPageArguments,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(paymentHelper)
final paymentHelperProvider = PaymentHelperProvider._();

final class PaymentHelperProvider
    extends $FunctionalProvider<PaymentHelper, PaymentHelper, PaymentHelper>
    with $Provider<PaymentHelper> {
  PaymentHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentHelperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentHelperHash();

  @$internal
  @override
  $ProviderElement<PaymentHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaymentHelper create(Ref ref) {
    return paymentHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentHelper>(value),
    );
  }
}

String _$paymentHelperHash() => r'426240d4f895aeb427c51ffcc193d2d434cfb336';

@ProviderFor(createdTxHelper)
final createdTxHelperProvider = CreatedTxHelperFamily._();

final class CreatedTxHelperProvider
    extends
        $FunctionalProvider<CreatedTxHelper, CreatedTxHelper, CreatedTxHelper>
    with $Provider<CreatedTxHelper> {
  CreatedTxHelperProvider._({
    required CreatedTxHelperFamily super.from,
    required CreatedTx? super.argument,
  }) : super(
         retry: null,
         name: r'createdTxHelperProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createdTxHelperHash();

  @override
  String toString() {
    return r'createdTxHelperProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<CreatedTxHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreatedTxHelper create(Ref ref) {
    final argument = this.argument as CreatedTx?;
    return createdTxHelper(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreatedTxHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreatedTxHelper>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CreatedTxHelperProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createdTxHelperHash() => r'5e1957359493ac06e1d97fbf503ccab68712494f';

final class CreatedTxHelperFamily extends $Family
    with $FunctionalFamilyOverride<CreatedTxHelper, CreatedTx?> {
  CreatedTxHelperFamily._()
    : super(
        retry: null,
        name: r'createdTxHelperProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreatedTxHelperProvider call(CreatedTx? createdTx) =>
      CreatedTxHelperProvider._(argument: createdTx, from: this);

  @override
  String toString() => r'createdTxHelperProvider';
}
