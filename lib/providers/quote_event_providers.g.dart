// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_event_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quoteEventNotifierHash() =>
    r'65d43ffaa52219214d5fc6095f3ea0ba1ff5b35b';

/// See also [QuoteEventNotifier].
@ProviderFor(QuoteEventNotifier)
final quoteEventNotifierProvider = AutoDisposeNotifierProvider<
  QuoteEventNotifier,
  Option<From_Quote>
>.internal(
  QuoteEventNotifier.new,
  name: r'quoteEventNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
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
final acceptQuoteNotifierProvider = AutoDisposeNotifierProvider<
  AcceptQuoteNotifier,
  Option<From_AcceptQuote>
>.internal(
  AcceptQuoteNotifier.new,
  name: r'acceptQuoteNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
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
final previewOrderQuoteSuccessNotifierProvider = NotifierProvider<
  PreviewOrderQuoteSuccessNotifier,
  Option<QuoteSuccess>
>.internal(
  PreviewOrderQuoteSuccessNotifier.new,
  name: r'previewOrderQuoteSuccessNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$previewOrderQuoteSuccessNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PreviewOrderQuoteSuccessNotifier = Notifier<Option<QuoteSuccess>>;
String _$previewOrderQuoteSuccessTtlHash() =>
    r'ad45bbabb616d5e18aa206040914b0d0a0f41668';

/// See also [PreviewOrderQuoteSuccessTtl].
@ProviderFor(PreviewOrderQuoteSuccessTtl)
final previewOrderQuoteSuccessTtlProvider =
    AutoDisposeNotifierProvider<PreviewOrderQuoteSuccessTtl, int>.internal(
      PreviewOrderQuoteSuccessTtl.new,
      name: r'previewOrderQuoteSuccessTtlProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$previewOrderQuoteSuccessTtlHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PreviewOrderQuoteSuccessTtl = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
