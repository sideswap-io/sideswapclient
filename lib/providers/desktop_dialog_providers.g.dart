// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_dialog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(desktopDialog)
const desktopDialogProvider = DesktopDialogProvider._();

final class DesktopDialogProvider
    extends $FunctionalProvider<DesktopDialog, DesktopDialog, DesktopDialog>
    with $Provider<DesktopDialog> {
  const DesktopDialogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopDialogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopDialogHash();

  @$internal
  @override
  $ProviderElement<DesktopDialog> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DesktopDialog create(Ref ref) {
    return desktopDialog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DesktopDialog value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DesktopDialog>(value),
    );
  }
}

String _$desktopDialogHash() => r'be97dde1ba7844f6341dfa2d61519df57b29956c';
