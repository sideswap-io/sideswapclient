// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(encryptionRepository)
final encryptionRepositoryProvider = EncryptionRepositoryProvider._();

final class EncryptionRepositoryProvider
    extends
        $FunctionalProvider<
          AbstractEncryptionRepository,
          AbstractEncryptionRepository,
          AbstractEncryptionRepository
        >
    with $Provider<AbstractEncryptionRepository> {
  EncryptionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'encryptionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$encryptionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AbstractEncryptionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AbstractEncryptionRepository create(Ref ref) {
    return encryptionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractEncryptionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractEncryptionRepository>(value),
    );
  }
}

String _$encryptionRepositoryHash() =>
    r'4ac7b6328ed203206d37c1f9dd86e87a56144693';
