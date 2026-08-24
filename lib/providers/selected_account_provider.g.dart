// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedAccountTypeNotifier)
final selectedAccountTypeProvider = SelectedAccountTypeNotifierProvider._();

final class SelectedAccountTypeNotifierProvider
    extends $NotifierProvider<SelectedAccountTypeNotifier, Account> {
  SelectedAccountTypeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedAccountTypeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedAccountTypeNotifierHash();

  @$internal
  @override
  SelectedAccountTypeNotifier create() => SelectedAccountTypeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Account value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Account>(value),
    );
  }
}

String _$selectedAccountTypeNotifierHash() =>
    r'5feefea6032e02c469c6da239befaadcdd911b86';

abstract class _$SelectedAccountTypeNotifier extends $Notifier<Account> {
  Account build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Account, Account>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Account, Account>,
              Account,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
