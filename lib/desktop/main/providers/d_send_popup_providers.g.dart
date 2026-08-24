// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'd_send_popup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendPopupAmountNotifier)
final sendPopupAmountProvider = SendPopupAmountNotifierProvider._();

final class SendPopupAmountNotifierProvider
    extends $NotifierProvider<SendPopupAmountNotifier, String> {
  SendPopupAmountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupAmountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupAmountNotifierHash();

  @$internal
  @override
  SendPopupAmountNotifier create() => SendPopupAmountNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$sendPopupAmountNotifierHash() =>
    r'fc04a7624f668ec6ee35f8e2a75e6fb4095489e7';

abstract class _$SendPopupAmountNotifier extends $Notifier<String> {
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

@ProviderFor(sendPopupDecimalAmount)
final sendPopupDecimalAmountProvider = SendPopupDecimalAmountProvider._();

final class SendPopupDecimalAmountProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  SendPopupDecimalAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupDecimalAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupDecimalAmountHash();

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    return sendPopupDecimalAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }
}

String _$sendPopupDecimalAmountHash() =>
    r'a5f436f595681039947d8001faf71bc5b9f4a375';

@ProviderFor(SendPopupAddressNotifier)
final sendPopupAddressProvider = SendPopupAddressNotifierProvider._();

final class SendPopupAddressNotifierProvider
    extends $NotifierProvider<SendPopupAddressNotifier, String> {
  SendPopupAddressNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupAddressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupAddressNotifierHash();

  @$internal
  @override
  SendPopupAddressNotifier create() => SendPopupAddressNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$sendPopupAddressNotifierHash() =>
    r'd19b4480407c0c9dad14df36f484daea8e7ad031';

abstract class _$SendPopupAddressNotifier extends $Notifier<String> {
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

@ProviderFor(SendPopupSelectedAssetIdNotifier)
final sendPopupSelectedAssetIdProvider =
    SendPopupSelectedAssetIdNotifierProvider._();

final class SendPopupSelectedAssetIdNotifierProvider
    extends $NotifierProvider<SendPopupSelectedAssetIdNotifier, String> {
  SendPopupSelectedAssetIdNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupSelectedAssetIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupSelectedAssetIdNotifierHash();

  @$internal
  @override
  SendPopupSelectedAssetIdNotifier create() =>
      SendPopupSelectedAssetIdNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$sendPopupSelectedAssetIdNotifierHash() =>
    r'2fccfca0a5ae61177849004516f831fab35f1bc5';

abstract class _$SendPopupSelectedAssetIdNotifier extends $Notifier<String> {
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

@ProviderFor(SendPopupReceiveConversionNotifier)
final sendPopupReceiveConversionProvider =
    SendPopupReceiveConversionNotifierProvider._();

final class SendPopupReceiveConversionNotifierProvider
    extends $NotifierProvider<SendPopupReceiveConversionNotifier, String> {
  SendPopupReceiveConversionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupReceiveConversionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$sendPopupReceiveConversionNotifierHash();

  @$internal
  @override
  SendPopupReceiveConversionNotifier create() =>
      SendPopupReceiveConversionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$sendPopupReceiveConversionNotifierHash() =>
    r'77ba1fe2c2a5817daa98ec4f25a43784b17edc6b';

abstract class _$SendPopupReceiveConversionNotifier extends $Notifier<String> {
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

@ProviderFor(SendPopupValidDataInserted)
final sendPopupValidDataInsertedProvider =
    SendPopupValidDataInsertedProvider._();

final class SendPopupValidDataInsertedProvider
    extends $AsyncNotifierProvider<SendPopupValidDataInserted, bool> {
  SendPopupValidDataInsertedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupValidDataInsertedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupValidDataInsertedHash();

  @$internal
  @override
  SendPopupValidDataInserted create() => SendPopupValidDataInserted();
}

String _$sendPopupValidDataInsertedHash() =>
    r'a37e8eacb2914f8d53fd398245a6772c5328d2f4';

abstract class _$SendPopupValidDataInserted extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SendPopupAddMoreOutputsButtonEnabled)
final sendPopupAddMoreOutputsButtonEnabledProvider =
    SendPopupAddMoreOutputsButtonEnabledProvider._();

final class SendPopupAddMoreOutputsButtonEnabledProvider
    extends $AsyncNotifierProvider<SendPopupAddMoreOutputsButtonEnabled, bool> {
  SendPopupAddMoreOutputsButtonEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupAddMoreOutputsButtonEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$sendPopupAddMoreOutputsButtonEnabledHash();

  @$internal
  @override
  SendPopupAddMoreOutputsButtonEnabled create() =>
      SendPopupAddMoreOutputsButtonEnabled();
}

String _$sendPopupAddMoreOutputsButtonEnabledHash() =>
    r'def221c981f1c06085806545932f99440fee8530';

abstract class _$SendPopupAddMoreOutputsButtonEnabled
    extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Accept only liquidnetwork or elements address type

@ProviderFor(SendPopupReviewButtonEnabled)
final sendPopupReviewButtonEnabledProvider =
    SendPopupReviewButtonEnabledProvider._();

/// Accept only liquidnetwork or elements address type
final class SendPopupReviewButtonEnabledProvider
    extends $AsyncNotifierProvider<SendPopupReviewButtonEnabled, bool> {
  /// Accept only liquidnetwork or elements address type
  SendPopupReviewButtonEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupReviewButtonEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupReviewButtonEnabledHash();

  @$internal
  @override
  SendPopupReviewButtonEnabled create() => SendPopupReviewButtonEnabled();
}

String _$sendPopupReviewButtonEnabledHash() =>
    r'f751e4bde69fdbd395384820b80513da37952673';

/// Accept only liquidnetwork or elements address type

abstract class _$SendPopupReviewButtonEnabled extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(sendPopupShowInsufficientFunds)
final sendPopupShowInsufficientFundsProvider =
    SendPopupShowInsufficientFundsProvider._();

final class SendPopupShowInsufficientFundsProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  SendPopupShowInsufficientFundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupShowInsufficientFundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupShowInsufficientFundsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return sendPopupShowInsufficientFunds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sendPopupShowInsufficientFundsHash() =>
    r'58bbd47af1e922d7872a1b74efb835f9ebb0a44e';

@ProviderFor(sendPopupDefaultCurrencyConversion)
final sendPopupDefaultCurrencyConversionProvider =
    SendPopupDefaultCurrencyConversionProvider._();

final class SendPopupDefaultCurrencyConversionProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  SendPopupDefaultCurrencyConversionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupDefaultCurrencyConversionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$sendPopupDefaultCurrencyConversionHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return sendPopupDefaultCurrencyConversion(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$sendPopupDefaultCurrencyConversionHash() =>
    r'bf4e614908269bf8031cd4523e162a230e0b9ddc';

@ProviderFor(sendPopupParseAddress)
final sendPopupParseAddressProvider = SendPopupParseAddressProvider._();

final class SendPopupParseAddressProvider
    extends
        $FunctionalProvider<
          Either<Exception, SendPopupAddressResult>,
          Either<Exception, SendPopupAddressResult>,
          Either<Exception, SendPopupAddressResult>
        >
    with $Provider<Either<Exception, SendPopupAddressResult>> {
  SendPopupParseAddressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendPopupParseAddressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendPopupParseAddressHash();

  @$internal
  @override
  $ProviderElement<Either<Exception, SendPopupAddressResult>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Either<Exception, SendPopupAddressResult> create(Ref ref) {
    return sendPopupParseAddress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Either<Exception, SendPopupAddressResult> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Either<Exception, SendPopupAddressResult>>(value),
    );
  }
}

String _$sendPopupParseAddressHash() =>
    r'2e76a587ed887b799c87bd35753156a043aaacc5';
