// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_env_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectEnvDialog)
final selectEnvDialogProvider = SelectEnvDialogProvider._();

final class SelectEnvDialogProvider
    extends $NotifierProvider<SelectEnvDialog, bool> {
  SelectEnvDialogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectEnvDialogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectEnvDialogHash();

  @$internal
  @override
  SelectEnvDialog create() => SelectEnvDialog();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$selectEnvDialogHash() => r'e13838c6841dd6fc41a1adde43195c81d3cfbf6b';

abstract class _$SelectEnvDialog extends $Notifier<bool> {
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

@ProviderFor(SelectedEnv)
final selectedEnvProvider = SelectedEnvProvider._();

final class SelectedEnvProvider extends $NotifierProvider<SelectedEnv, int> {
  SelectedEnvProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedEnvProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedEnvHash();

  @$internal
  @override
  SelectedEnv create() => SelectedEnv();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedEnvHash() => r'b9853271a4f111da4e98af40ddc4a4185881a752';

abstract class _$SelectedEnv extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectEnvTap)
final selectEnvTapProvider = SelectEnvTapProvider._();

final class SelectEnvTapProvider extends $NotifierProvider<SelectEnvTap, int> {
  SelectEnvTapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectEnvTapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectEnvTapHash();

  @$internal
  @override
  SelectEnvTap create() => SelectEnvTap();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectEnvTapHash() => r'c462f87777d463d525987199fce13f310a91eca1';

abstract class _$SelectEnvTap extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
