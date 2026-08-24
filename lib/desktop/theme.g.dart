// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DesktopAppThemeNotifier)
final desktopAppThemeProvider = DesktopAppThemeNotifierProvider._();

final class DesktopAppThemeNotifierProvider
    extends $NotifierProvider<DesktopAppThemeNotifier, DesktopAppTheme> {
  DesktopAppThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopAppThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopAppThemeNotifierHash();

  @$internal
  @override
  DesktopAppThemeNotifier create() => DesktopAppThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DesktopAppTheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DesktopAppTheme>(value),
    );
  }
}

String _$desktopAppThemeNotifierHash() =>
    r'57fdbe798ce5ad4ffe63fbf7d8d0cb2bc4a4f7ab';

abstract class _$DesktopAppThemeNotifier extends $Notifier<DesktopAppTheme> {
  DesktopAppTheme build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DesktopAppTheme, DesktopAppTheme>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DesktopAppTheme, DesktopAppTheme>,
              DesktopAppTheme,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
