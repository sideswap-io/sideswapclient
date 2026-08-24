// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'd_pin_keyboard.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pinKeyboardIndex)
final pinKeyboardIndexProvider = PinKeyboardIndexProvider._();

final class PinKeyboardIndexProvider
    extends
        $FunctionalProvider<
          PinKeyboardIndexHelper,
          PinKeyboardIndexHelper,
          PinKeyboardIndexHelper
        >
    with $Provider<PinKeyboardIndexHelper> {
  PinKeyboardIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinKeyboardIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinKeyboardIndexHash();

  @$internal
  @override
  $ProviderElement<PinKeyboardIndexHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PinKeyboardIndexHelper create(Ref ref) {
    return pinKeyboardIndex(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinKeyboardIndexHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinKeyboardIndexHelper>(value),
    );
  }
}

String _$pinKeyboardIndexHash() => r'10bfd1e122e3de4eb99a70058309a3caf3ea120d';
