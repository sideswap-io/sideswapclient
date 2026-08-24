// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'd_wallet_descriptors.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether descriptor copy is currently permitted -- driven by window focus.
///
/// Mirrors `isCopyEnabledProvider` from the recovery-phrase dialog: the
/// dialog's `WindowListener` flips it to `false` on a `'blur'` event and back
/// to `true` on `'focus'`. Both the visible Copy button and the Ctrl/Cmd+C
/// shortcut action consult it, so a blurred window copies nothing
/// (ADR-0002 decision 4).

@ProviderFor(DescriptorCopyEnabled)
final descriptorCopyEnabledProvider = DescriptorCopyEnabledProvider._();

/// Whether descriptor copy is currently permitted -- driven by window focus.
///
/// Mirrors `isCopyEnabledProvider` from the recovery-phrase dialog: the
/// dialog's `WindowListener` flips it to `false` on a `'blur'` event and back
/// to `true` on `'focus'`. Both the visible Copy button and the Ctrl/Cmd+C
/// shortcut action consult it, so a blurred window copies nothing
/// (ADR-0002 decision 4).
final class DescriptorCopyEnabledProvider
    extends $NotifierProvider<DescriptorCopyEnabled, bool> {
  /// Whether descriptor copy is currently permitted -- driven by window focus.
  ///
  /// Mirrors `isCopyEnabledProvider` from the recovery-phrase dialog: the
  /// dialog's `WindowListener` flips it to `false` on a `'blur'` event and back
  /// to `true` on `'focus'`. Both the visible Copy button and the Ctrl/Cmd+C
  /// shortcut action consult it, so a blurred window copies nothing
  /// (ADR-0002 decision 4).
  DescriptorCopyEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'descriptorCopyEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$descriptorCopyEnabledHash();

  @$internal
  @override
  DescriptorCopyEnabled create() => DescriptorCopyEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$descriptorCopyEnabledHash() =>
    r'309b8275bc03ee95971144679aa2f52bdc8527cf';

/// Whether descriptor copy is currently permitted -- driven by window focus.
///
/// Mirrors `isCopyEnabledProvider` from the recovery-phrase dialog: the
/// dialog's `WindowListener` flips it to `false` on a `'blur'` event and back
/// to `true` on `'focus'`. Both the visible Copy button and the Ctrl/Cmd+C
/// shortcut action consult it, so a blurred window copies nothing
/// (ADR-0002 decision 4).

abstract class _$DescriptorCopyEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
