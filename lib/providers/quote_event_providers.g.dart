// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuoteEventNotifier)
const quoteEventProvider = QuoteEventNotifierProvider._();

final class QuoteEventNotifierProvider
    extends $NotifierProvider<QuoteEventNotifier, Option<From_Quote>> {
  const QuoteEventNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quoteEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quoteEventNotifierHash();

  @$internal
  @override
  QuoteEventNotifier create() => QuoteEventNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_Quote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_Quote>>(value),
    );
  }
}

String _$quoteEventNotifierHash() =>
    r'b47d1b3b0b5421ccfaa7545144aa5f6afc0ab170';

abstract class _$QuoteEventNotifier extends $Notifier<Option<From_Quote>> {
  Option<From_Quote> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<From_Quote>, Option<From_Quote>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<From_Quote>, Option<From_Quote>>,
              Option<From_Quote>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Accept quote

@ProviderFor(AcceptQuoteNotifier)
const acceptQuoteProvider = AcceptQuoteNotifierProvider._();

/// Accept quote
final class AcceptQuoteNotifierProvider
    extends $NotifierProvider<AcceptQuoteNotifier, Option<From_AcceptQuote>> {
  /// Accept quote
  const AcceptQuoteNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceptQuoteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceptQuoteNotifierHash();

  @$internal
  @override
  AcceptQuoteNotifier create() => AcceptQuoteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<From_AcceptQuote> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<From_AcceptQuote>>(value),
    );
  }
}

String _$acceptQuoteNotifierHash() =>
    r'4b3b428eb9c8990ef76e0b5c38c1683926064f67';

/// Accept quote

abstract class _$AcceptQuoteNotifier
    extends $Notifier<Option<From_AcceptQuote>> {
  Option<From_AcceptQuote> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Option<From_AcceptQuote>, Option<From_AcceptQuote>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<From_AcceptQuote>, Option<From_AcceptQuote>>,
              Option<From_AcceptQuote>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PreviewOrderQuoteSuccessNotifier)
const previewOrderQuoteSuccessProvider =
    PreviewOrderQuoteSuccessNotifierProvider._();

final class PreviewOrderQuoteSuccessNotifierProvider
    extends
        $NotifierProvider<
          PreviewOrderQuoteSuccessNotifier,
          Option<QuoteSuccess>
        > {
  const PreviewOrderQuoteSuccessNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previewOrderQuoteSuccessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$previewOrderQuoteSuccessNotifierHash();

  @$internal
  @override
  PreviewOrderQuoteSuccessNotifier create() =>
      PreviewOrderQuoteSuccessNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<QuoteSuccess> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<QuoteSuccess>>(value),
    );
  }
}

String _$previewOrderQuoteSuccessNotifierHash() =>
    r'0323aab63a6513ccb0c4179e13c5f021d224b972';

abstract class _$PreviewOrderQuoteSuccessNotifier
    extends $Notifier<Option<QuoteSuccess>> {
  Option<QuoteSuccess> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<QuoteSuccess>, Option<QuoteSuccess>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<QuoteSuccess>, Option<QuoteSuccess>>,
              Option<QuoteSuccess>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrderTtlNotifier)
const orderTtlProvider = OrderTtlNotifierProvider._();

final class OrderTtlNotifierProvider
    extends $NotifierProvider<OrderTtlNotifier, OrderTtlState> {
  const OrderTtlNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderTtlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderTtlNotifierHash();

  @$internal
  @override
  OrderTtlNotifier create() => OrderTtlNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderTtlState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderTtlState>(value),
    );
  }
}

String _$orderTtlNotifierHash() => r'afba9c7aa8e5629dfa4923e931c216921c5f1e17';

abstract class _$OrderTtlNotifier extends $Notifier<OrderTtlState> {
  OrderTtlState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OrderTtlState, OrderTtlState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OrderTtlState, OrderTtlState>,
              OrderTtlState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OrderSignTtl)
const orderSignTtlProvider = OrderSignTtlProvider._();

final class OrderSignTtlProvider extends $NotifierProvider<OrderSignTtl, int> {
  const OrderSignTtlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderSignTtlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderSignTtlHash();

  @$internal
  @override
  OrderSignTtl create() => OrderSignTtl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$orderSignTtlHash() => r'e146678d2d7ce8ed39cb0b402a47bbbe93e1dba0';

abstract class _$OrderSignTtl extends $Notifier<int> {
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
