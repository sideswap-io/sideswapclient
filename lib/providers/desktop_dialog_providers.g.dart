// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_dialog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(desktopDialog)
final desktopDialogProvider = DesktopDialogProvider._();

final class DesktopDialogProvider
    extends $FunctionalProvider<DesktopDialog, DesktopDialog, DesktopDialog>
    with $Provider<DesktopDialog> {
  DesktopDialogProvider._()
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

String _$desktopDialogHash() => r'e8207c0f6d7127dc5cae1863ef302aaecb31e685';
