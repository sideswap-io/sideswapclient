// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_keyboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pinKeyboardHelper)
const pinKeyboardHelperProvider = PinKeyboardHelperProvider._();

final class PinKeyboardHelperProvider
    extends
        $FunctionalProvider<
          PinKeyboardHelper,
          PinKeyboardHelper,
          PinKeyboardHelper
        >
    with $Provider<PinKeyboardHelper> {
  const PinKeyboardHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinKeyboardHelperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinKeyboardHelperHash();

  @$internal
  @override
  $ProviderElement<PinKeyboardHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PinKeyboardHelper create(Ref ref) {
    return pinKeyboardHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinKeyboardHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinKeyboardHelper>(value),
    );
  }
}

String _$pinKeyboardHelperHash() => r'bfd490d387791c7338dbd16a40af567ccd6d15d6';
