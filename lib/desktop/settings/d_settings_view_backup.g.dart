// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'd_settings_view_backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IsCopyEnabled)
final isCopyEnabledProvider = IsCopyEnabledProvider._();

final class IsCopyEnabledProvider
    extends $NotifierProvider<IsCopyEnabled, bool> {
  IsCopyEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isCopyEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isCopyEnabledHash();

  @$internal
  @override
  IsCopyEnabled create() => IsCopyEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isCopyEnabledHash() => r'95d79de474a1dbf4d669979b15d48d5cdc5aefd3';

abstract class _$IsCopyEnabled extends $Notifier<bool> {
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
