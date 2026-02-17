// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'math_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mathHelper)
const mathHelperProvider = MathHelperProvider._();

final class MathHelperProvider
    extends $FunctionalProvider<MathHelper, MathHelper, MathHelper>
    with $Provider<MathHelper> {
  const MathHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mathHelperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mathHelperHash();

  @$internal
  @override
  $ProviderElement<MathHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MathHelper create(Ref ref) {
    return mathHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MathHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MathHelper>(value),
    );
  }
}

String _$mathHelperHash() => r'3e0cdf540376f1182c99347955323897517d160f';
