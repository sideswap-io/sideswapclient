// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quoteEventNotifierHash() =>
    r'748758f051f4741c3f3cc112815a48b1c944f358';

/// See also [QuoteEventNotifier].
@ProviderFor(QuoteEventNotifier)
final quoteEventNotifierProvider =
    AutoDisposeNotifierProvider<
      QuoteEventNotifier,
      Option<From_Quote>
    >.internal(
      QuoteEventNotifier.new,
      name: r'quoteEventNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quoteEventNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuoteEventNotifier = AutoDisposeNotifier<Option<From_Quote>>;
String _$acceptQuoteNotifierHash() =>
    r'4b3b428eb9c8990ef76e0b5c38c1683926064f67';

/// Accept quote
///
/// Copied from [AcceptQuoteNotifier].
@ProviderFor(AcceptQuoteNotifier)
final acceptQuoteNotifierProvider =
    AutoDisposeNotifierProvider<
      AcceptQuoteNotifier,
      Option<From_AcceptQuote>
    >.internal(
      AcceptQuoteNotifier.new,
      name: r'acceptQuoteNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$acceptQuoteNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AcceptQuoteNotifier = AutoDisposeNotifier<Option<From_AcceptQuote>>;
String _$previewOrderQuoteSuccessNotifierHash() =>
    r'0323aab63a6513ccb0c4179e13c5f021d224b972';

/// See also [PreviewOrderQuoteSuccessNotifier].
@ProviderFor(PreviewOrderQuoteSuccessNotifier)
final previewOrderQuoteSuccessNotifierProvider =
    NotifierProvider<
      PreviewOrderQuoteSuccessNotifier,
      Option<QuoteSuccess>
    >.internal(
      PreviewOrderQuoteSuccessNotifier.new,
      name: r'previewOrderQuoteSuccessNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$previewOrderQuoteSuccessNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PreviewOrderQuoteSuccessNotifier = Notifier<Option<QuoteSuccess>>;
String _$orderTtlNotifierHash() => r'dcfeae005491543026ae2bad7a58197142d755fa';

/// See also [OrderTtlNotifier].
@ProviderFor(OrderTtlNotifier)
final orderTtlNotifierProvider =
    NotifierProvider<OrderTtlNotifier, OrderTtlState>.internal(
      OrderTtlNotifier.new,
      name: r'orderTtlNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$orderTtlNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OrderTtlNotifier = Notifier<OrderTtlState>;
String _$orderSignTtlHash() => r'6f5d00189ce1ae2194e2187f15e5a9542786d060';

/// See also [OrderSignTtl].
@ProviderFor(OrderSignTtl)
final orderSignTtlProvider =
    AutoDisposeNotifierProvider<OrderSignTtl, int>.internal(
      OrderSignTtl.new,
      name: r'orderSignTtlProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$orderSignTtlHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OrderSignTtl = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
