// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoadTransactionsStateNotifier)
const loadTransactionsStateProvider = LoadTransactionsStateNotifierProvider._();

final class LoadTransactionsStateNotifierProvider
    extends
        $NotifierProvider<
          LoadTransactionsStateNotifier,
          LoadTransactionsState
        > {
  const LoadTransactionsStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadTransactionsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadTransactionsStateNotifierHash();

  @$internal
  @override
  LoadTransactionsStateNotifier create() => LoadTransactionsStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadTransactionsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadTransactionsState>(value),
    );
  }
}

String _$loadTransactionsStateNotifierHash() =>
    r'9fd91d0c39b7a51bd740f7e518949f4cdbeaf082';

abstract class _$LoadTransactionsStateNotifier
    extends $Notifier<LoadTransactionsState> {
  LoadTransactionsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LoadTransactionsState, LoadTransactionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoadTransactionsState, LoadTransactionsState>,
              LoadTransactionsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TxHistoryStateNotifier)
const txHistoryStateProvider = TxHistoryStateNotifierProvider._();

final class TxHistoryStateNotifierProvider
    extends $NotifierProvider<TxHistoryStateNotifier, TxHistoryState> {
  const TxHistoryStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'txHistoryStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$txHistoryStateNotifierHash();

  @$internal
  @override
  TxHistoryStateNotifier create() => TxHistoryStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TxHistoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TxHistoryState>(value),
    );
  }
}

String _$txHistoryStateNotifierHash() =>
    r'dc0fbe31da100e30a398e18c8472871847dac046';

abstract class _$TxHistoryStateNotifier extends $Notifier<TxHistoryState> {
  TxHistoryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TxHistoryState, TxHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TxHistoryState, TxHistoryState>,
              TxHistoryState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(UpdatedTxsNotifier)
const updatedTxsProvider = UpdatedTxsNotifierProvider._();

final class UpdatedTxsNotifierProvider
    extends $NotifierProvider<UpdatedTxsNotifier, List<TransItem>> {
  const UpdatedTxsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updatedTxsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updatedTxsNotifierHash();

  @$internal
  @override
  UpdatedTxsNotifier create() => UpdatedTxsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TransItem>>(value),
    );
  }
}

String _$updatedTxsNotifierHash() =>
    r'4f3506353973575bb4fff89fb8c3c04148b318aa';

abstract class _$UpdatedTxsNotifier extends $Notifier<List<TransItem>> {
  List<TransItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<TransItem>, List<TransItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TransItem>, List<TransItem>>,
              List<TransItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(unconfirmedTxs)
const unconfirmedTxsProvider = UnconfirmedTxsProvider._();

final class UnconfirmedTxsProvider
    extends
        $FunctionalProvider<List<TransItem>, List<TransItem>, List<TransItem>>
    with $Provider<List<TransItem>> {
  const UnconfirmedTxsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unconfirmedTxsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unconfirmedTxsHash();

  @$internal
  @override
  $ProviderElement<List<TransItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TransItem> create(Ref ref) {
    return unconfirmedTxs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TransItem>>(value),
    );
  }
}

String _$unconfirmedTxsHash() => r'bc77ea69daddd9618bc7bf1fa2b14871e9dc82f1';

@ProviderFor(ShowTransactionNotifier)
const showTransactionProvider = ShowTransactionNotifierProvider._();

final class ShowTransactionNotifierProvider
    extends $NotifierProvider<ShowTransactionNotifier, Option<TransItem>> {
  const ShowTransactionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showTransactionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showTransactionNotifierHash();

  @$internal
  @override
  ShowTransactionNotifier create() => ShowTransactionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<TransItem>>(value),
    );
  }
}

String _$showTransactionNotifierHash() =>
    r'28517822ef0fc61252540051ce1836a4dcc272b5';

abstract class _$ShowTransactionNotifier extends $Notifier<Option<TransItem>> {
  Option<TransItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<TransItem>, Option<TransItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<TransItem>, Option<TransItem>>,
              Option<TransItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AllTxsNotifier)
const allTxsProvider = AllTxsNotifierProvider._();

final class AllTxsNotifierProvider
    extends $NotifierProvider<AllTxsNotifier, Map<String, TransItem>> {
  const AllTxsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTxsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTxsNotifierHash();

  @$internal
  @override
  AllTxsNotifier create() => AllTxsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, TransItem>>(value),
    );
  }
}

String _$allTxsNotifierHash() => r'93226d039c5c32315886e8105a132df0b78a43ce';

abstract class _$AllTxsNotifier extends $Notifier<Map<String, TransItem>> {
  Map<String, TransItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<Map<String, TransItem>, Map<String, TransItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, TransItem>, Map<String, TransItem>>,
              Map<String, TransItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(allTxsSorted)
const allTxsSortedProvider = AllTxsSortedProvider._();

final class AllTxsSortedProvider
    extends
        $FunctionalProvider<List<TransItem>, List<TransItem>, List<TransItem>>
    with $Provider<List<TransItem>> {
  const AllTxsSortedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTxsSortedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTxsSortedHash();

  @$internal
  @override
  $ProviderElement<List<TransItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TransItem> create(Ref ref) {
    return allTxsSorted(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TransItem>>(value),
    );
  }
}

String _$allTxsSortedHash() => r'96b84a7d6568fc741203bd372d217722a12916e4';

@ProviderFor(allNewTxsSorted)
const allNewTxsSortedProvider = AllNewTxsSortedProvider._();

final class AllNewTxsSortedProvider
    extends
        $FunctionalProvider<List<TransItem>, List<TransItem>, List<TransItem>>
    with $Provider<List<TransItem>> {
  const AllNewTxsSortedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allNewTxsSortedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allNewTxsSortedHash();

  @$internal
  @override
  $ProviderElement<List<TransItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TransItem> create(Ref ref) {
    return allNewTxsSorted(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TransItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TransItem>>(value),
    );
  }
}

String _$allNewTxsSortedHash() => r'ef0553a60d0973cb7475a27d812df09433ba78d1';

/// Returns map of AccountAsset and list of TxItem.
/// List of TxItem is based on tx balances list. Balances list can include multiple different assets.
/// AccountAsset hold AccountType and assetId information.
/// Each pair of AccountAsset and list of TxItem can hold duplicates of TxItem.

@ProviderFor(accountAssetTransactions)
const accountAssetTransactionsProvider = AccountAssetTransactionsProvider._();

/// Returns map of AccountAsset and list of TxItem.
/// List of TxItem is based on tx balances list. Balances list can include multiple different assets.
/// AccountAsset hold AccountType and assetId information.
/// Each pair of AccountAsset and list of TxItem can hold duplicates of TxItem.

final class AccountAssetTransactionsProvider
    extends
        $FunctionalProvider<
          Map<AccountAsset, List<TxItem>>,
          Map<AccountAsset, List<TxItem>>,
          Map<AccountAsset, List<TxItem>>
        >
    with $Provider<Map<AccountAsset, List<TxItem>>> {
  /// Returns map of AccountAsset and list of TxItem.
  /// List of TxItem is based on tx balances list. Balances list can include multiple different assets.
  /// AccountAsset hold AccountType and assetId information.
  /// Each pair of AccountAsset and list of TxItem can hold duplicates of TxItem.
  const AccountAssetTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountAssetTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountAssetTransactionsHash();

  @$internal
  @override
  $ProviderElement<Map<AccountAsset, List<TxItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<AccountAsset, List<TxItem>> create(Ref ref) {
    return accountAssetTransactions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<AccountAsset, List<TxItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<AccountAsset, List<TxItem>>>(
        value,
      ),
    );
  }
}

String _$accountAssetTransactionsHash() =>
    r'97cada9aa9eb7718f67e3a38a7433a3894b7a19a';

@ProviderFor(assetTransactions)
const assetTransactionsProvider = AssetTransactionsProvider._();

final class AssetTransactionsProvider
    extends
        $FunctionalProvider<
          Map<String, List<TxItem>>,
          Map<String, List<TxItem>>,
          Map<String, List<TxItem>>
        >
    with $Provider<Map<String, List<TxItem>>> {
  const AssetTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetTransactionsHash();

  @$internal
  @override
  $ProviderElement<Map<String, List<TxItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, List<TxItem>> create(Ref ref) {
    return assetTransactions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<TxItem>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<TxItem>>>(value),
    );
  }
}

String _$assetTransactionsHash() => r'5e8d92d4b57e38c0705ba2931c453c9066a52134';

@ProviderFor(distinctTransactionsForAccount)
const distinctTransactionsForAccountProvider =
    DistinctTransactionsForAccountProvider._();

final class DistinctTransactionsForAccountProvider
    extends $FunctionalProvider<List<TxItem>, List<TxItem>, List<TxItem>>
    with $Provider<List<TxItem>> {
  const DistinctTransactionsForAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distinctTransactionsForAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distinctTransactionsForAccountHash();

  @$internal
  @override
  $ProviderElement<List<TxItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<TxItem> create(Ref ref) {
    return distinctTransactionsForAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TxItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TxItem>>(value),
    );
  }
}

String _$distinctTransactionsForAccountHash() =>
    r'c17e3303ea6b759884ab1136bcf41894290a775f';

@ProviderFor(transItemHelper)
const transItemHelperProvider = TransItemHelperFamily._();

final class TransItemHelperProvider
    extends
        $FunctionalProvider<TransItemHelper, TransItemHelper, TransItemHelper>
    with $Provider<TransItemHelper> {
  const TransItemHelperProvider._({
    required TransItemHelperFamily super.from,
    required TransItem super.argument,
  }) : super(
         retry: null,
         name: r'transItemHelperProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transItemHelperHash();

  @override
  String toString() {
    return r'transItemHelperProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<TransItemHelper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TransItemHelper create(Ref ref) {
    final argument = this.argument as TransItem;
    return transItemHelper(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransItemHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransItemHelper>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransItemHelperProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transItemHelperHash() => r'9e2e9051878d75b5c4a464c5c282884e87de544e';

final class TransItemHelperFamily extends $Family
    with $FunctionalFamilyOverride<TransItemHelper, TransItem> {
  const TransItemHelperFamily._()
    : super(
        retry: null,
        name: r'transItemHelperProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransItemHelperProvider call(TransItem transItem) =>
      TransItemHelperProvider._(argument: transItem, from: this);

  @override
  String toString() => r'transItemHelperProvider';
}

@ProviderFor(CurrentTxPopupItemNotifier)
const currentTxPopupItemProvider = CurrentTxPopupItemNotifierProvider._();

final class CurrentTxPopupItemNotifierProvider
    extends $NotifierProvider<CurrentTxPopupItemNotifier, Option<String>> {
  const CurrentTxPopupItemNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTxPopupItemProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTxPopupItemNotifierHash();

  @$internal
  @override
  CurrentTxPopupItemNotifier create() => CurrentTxPopupItemNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<String>>(value),
    );
  }
}

String _$currentTxPopupItemNotifierHash() =>
    r'0c7899d6c1b81e81cc143a60bd7a0acb5590df05';

abstract class _$CurrentTxPopupItemNotifier extends $Notifier<Option<String>> {
  Option<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Option<String>, Option<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<String>, Option<String>>,
              Option<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
