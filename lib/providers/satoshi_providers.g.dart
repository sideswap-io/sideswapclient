// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'satoshi_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(satoshiRepository)
final satoshiRepositoryProvider = SatoshiRepositoryProvider._();

final class SatoshiRepositoryProvider
    extends
        $FunctionalProvider<
          AbstractSatoshiRepository,
          AbstractSatoshiRepository,
          AbstractSatoshiRepository
        >
    with $Provider<AbstractSatoshiRepository> {
  SatoshiRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'satoshiRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$satoshiRepositoryHash();

  @$internal
  @override
  $ProviderElement<AbstractSatoshiRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AbstractSatoshiRepository create(Ref ref) {
    return satoshiRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractSatoshiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractSatoshiRepository>(value),
    );
  }
}

String _$satoshiRepositoryHash() => r'2f1f31cbcc01800e858ed7ddfbac8efe8530a03d';
