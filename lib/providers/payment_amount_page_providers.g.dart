// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_amount_page_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentPageSelectedAssetHash() =>
    r'118a174aedd4adc1677ac41882b6d9c735e28094';

/// See also [paymentPageSelectedAsset].
@ProviderFor(paymentPageSelectedAsset)
final paymentPageSelectedAssetProvider =
    AutoDisposeProvider<Option<Asset>>.internal(
      paymentPageSelectedAsset,
      name: r'paymentPageSelectedAssetProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentPageSelectedAssetHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentPageSelectedAssetRef = AutoDisposeProviderRef<Option<Asset>>;
String _$paymentPageRepositoryHash() =>
    r'ca323cb141f0fa3772719aa57fa15d0fad7938e2';

/// See also [paymentPageRepository].
@ProviderFor(paymentPageRepository)
final paymentPageRepositoryProvider =
    AutoDisposeProvider<AbstractPaymentPageRepository>.internal(
      paymentPageRepository,
      name: r'paymentPageRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentPageRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentPageRepositoryRef =
    AutoDisposeProviderRef<AbstractPaymentPageRepository>;
String _$paymentPageSendAssetsWithBalanceHash() =>
    r'05cc5df828b03c6bdf03cbaaca7bff06b6cb9cc3';

/// See also [paymentPageSendAssetsWithBalance].
@ProviderFor(paymentPageSendAssetsWithBalance)
final paymentPageSendAssetsWithBalanceProvider =
    AutoDisposeProvider<Iterable<String>>.internal(
      paymentPageSendAssetsWithBalance,
      name: r'paymentPageSendAssetsWithBalanceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentPageSendAssetsWithBalanceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaymentPageSendAssetsWithBalanceRef =
    AutoDisposeProviderRef<Iterable<String>>;
String _$paymentPageSelectedAssetIdNotifierHash() =>
    r'b2166f2e7ccd3856617c0f26b0f69786c292c456';

/// See also [PaymentPageSelectedAssetIdNotifier].
@ProviderFor(PaymentPageSelectedAssetIdNotifier)
final paymentPageSelectedAssetIdNotifierProvider =
    AutoDisposeNotifierProvider<
      PaymentPageSelectedAssetIdNotifier,
      String
    >.internal(
      PaymentPageSelectedAssetIdNotifier.new,
      name: r'paymentPageSelectedAssetIdNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paymentPageSelectedAssetIdNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PaymentPageSelectedAssetIdNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
