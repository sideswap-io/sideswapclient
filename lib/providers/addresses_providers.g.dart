// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addresses_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoadAddressesStateNotifier)
const loadAddressesStateProvider = LoadAddressesStateNotifierProvider._();

final class LoadAddressesStateNotifierProvider
    extends $NotifierProvider<LoadAddressesStateNotifier, LoadAddressesState> {
  const LoadAddressesStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadAddressesStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadAddressesStateNotifierHash();

  @$internal
  @override
  LoadAddressesStateNotifier create() => LoadAddressesStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadAddressesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadAddressesState>(value),
    );
  }
}

String _$loadAddressesStateNotifierHash() =>
    r'6c739084ff0a82a38dbb38dcf9f847b5c89ff116';

abstract class _$LoadAddressesStateNotifier
    extends $Notifier<LoadAddressesState> {
  LoadAddressesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LoadAddressesState, LoadAddressesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoadAddressesState, LoadAddressesState>,
              LoadAddressesState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(LoadUtxosStateNotifier)
const loadUtxosStateProvider = LoadUtxosStateNotifierProvider._();

final class LoadUtxosStateNotifierProvider
    extends $NotifierProvider<LoadUtxosStateNotifier, LoadUtxosState> {
  const LoadUtxosStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadUtxosStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadUtxosStateNotifierHash();

  @$internal
  @override
  LoadUtxosStateNotifier create() => LoadUtxosStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadUtxosState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadUtxosState>(value),
    );
  }
}

String _$loadUtxosStateNotifierHash() =>
    r'89a4e95d66be4159dbc39f33e29bf6c756245bec';

abstract class _$LoadUtxosStateNotifier extends $Notifier<LoadUtxosState> {
  LoadUtxosState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LoadUtxosState, LoadUtxosState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoadUtxosState, LoadUtxosState>,
              LoadUtxosState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AddressesAsyncNotifier)
const addressesAsyncProvider = AddressesAsyncNotifierFamily._();

final class AddressesAsyncNotifierProvider
    extends $AsyncNotifierProvider<AddressesAsyncNotifier, AddressesModel> {
  const AddressesAsyncNotifierProvider._({
    required AddressesAsyncNotifierFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'addressesAsyncProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addressesAsyncNotifierHash();

  @override
  String toString() {
    return r'addressesAsyncProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AddressesAsyncNotifier create() => AddressesAsyncNotifier();

  @override
  bool operator ==(Object other) {
    return other is AddressesAsyncNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addressesAsyncNotifierHash() =>
    r'dfd57827277dd092b1fff2c2e89b6b4c493fbeee';

final class AddressesAsyncNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AddressesAsyncNotifier,
          AsyncValue<AddressesModel>,
          AddressesModel,
          FutureOr<AddressesModel>,
          Account
        > {
  const AddressesAsyncNotifierFamily._()
    : super(
        retry: null,
        name: r'addressesAsyncProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddressesAsyncNotifierProvider call(Account account) =>
      AddressesAsyncNotifierProvider._(argument: account, from: this);

  @override
  String toString() => r'addressesAsyncProvider';
}

abstract class _$AddressesAsyncNotifier extends $AsyncNotifier<AddressesModel> {
  late final _$args = ref.$arg as Account;
  Account get account => _$args;

  FutureOr<AddressesModel> build(Account account);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<AddressesModel>, AddressesModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AddressesModel>, AddressesModel>,
              AsyncValue<AddressesModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(regularAddressesModelAsync)
const regularAddressesModelAsyncProvider =
    RegularAddressesModelAsyncProvider._();

final class RegularAddressesModelAsyncProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>
        >
    with $Provider<AsyncValue<AddressesModel>> {
  const RegularAddressesModelAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regularAddressesModelAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regularAddressesModelAsyncHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<AddressesModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AddressesModel> create(Ref ref) {
    return regularAddressesModelAsync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AddressesModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AddressesModel>>(value),
    );
  }
}

String _$regularAddressesModelAsyncHash() =>
    r'b190b52de6e870d2e8ba8b44a4542795857aa417';

@ProviderFor(ampAdressesModelAsync)
const ampAdressesModelAsyncProvider = AmpAdressesModelAsyncProvider._();

final class AmpAdressesModelAsyncProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>
        >
    with $Provider<AsyncValue<AddressesModel>> {
  const AmpAdressesModelAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ampAdressesModelAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ampAdressesModelAsyncHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<AddressesModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AddressesModel> create(Ref ref) {
    return ampAdressesModelAsync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AddressesModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AddressesModel>>(value),
    );
  }
}

String _$ampAdressesModelAsyncHash() =>
    r'07845243df46deb80541936ae95bc0cbb4788761';

@ProviderFor(groupedAddressesAsync)
const groupedAddressesAsyncProvider = GroupedAddressesAsyncProvider._();

final class GroupedAddressesAsyncProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>
        >
    with $Provider<AsyncValue<AddressesModel>> {
  const GroupedAddressesAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupedAddressesAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupedAddressesAsyncHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<AddressesModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AddressesModel> create(Ref ref) {
    return groupedAddressesAsync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AddressesModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AddressesModel>>(value),
    );
  }
}

String _$groupedAddressesAsyncHash() =>
    r'661851a01af4ef5af94b33cd57170d0e6be92dce';

@ProviderFor(filteredAddressesAsync)
const filteredAddressesAsyncProvider = FilteredAddressesAsyncProvider._();

final class FilteredAddressesAsyncProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>
        >
    with $Provider<AsyncValue<AddressesModel>> {
  const FilteredAddressesAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredAddressesAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredAddressesAsyncHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<AddressesModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AddressesModel> create(Ref ref) {
    return filteredAddressesAsync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AddressesModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AddressesModel>>(value),
    );
  }
}

String _$filteredAddressesAsyncHash() =>
    r'fe049785862654420cfafd93fc06fe21f3ad78d3';

@ProviderFor(AddressDetailsDialogNotifier)
const addressDetailsDialogProvider = AddressDetailsDialogNotifierProvider._();

final class AddressDetailsDialogNotifierProvider
    extends
        $NotifierProvider<AddressDetailsDialogNotifier, AddressDetailsState> {
  const AddressDetailsDialogNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressDetailsDialogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressDetailsDialogNotifierHash();

  @$internal
  @override
  AddressDetailsDialogNotifier create() => AddressDetailsDialogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressDetailsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressDetailsState>(value),
    );
  }
}

String _$addressDetailsDialogNotifierHash() =>
    r'f5266f4ba5a9d00592f1b5ef82e861a6cb968ad3';

abstract class _$AddressDetailsDialogNotifier
    extends $Notifier<AddressDetailsState> {
  AddressDetailsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AddressDetailsState, AddressDetailsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddressDetailsState, AddressDetailsState>,
              AddressDetailsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(addressesItemHelper)
const addressesItemHelperProvider = AddressesItemHelperFamily._();

final class AddressesItemHelperProvider
    extends
        $FunctionalProvider<
          AddressesItemHelper,
          AddressesItemHelper,
          AddressesItemHelper
        >
    with $Provider<AddressesItemHelper> {
  const AddressesItemHelperProvider._({
    required AddressesItemHelperFamily super.from,
    required AddressesItem super.argument,
  }) : super(
         retry: null,
         name: r'addressesItemHelperProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$addressesItemHelperHash();

  @override
  String toString() {
    return r'addressesItemHelperProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AddressesItemHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddressesItemHelper create(Ref ref) {
    final argument = this.argument as AddressesItem;
    return addressesItemHelper(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressesItemHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressesItemHelper>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AddressesItemHelperProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$addressesItemHelperHash() =>
    r'fbfe778e431413d06c76f54b681be5bb7a74f1cc';

final class AddressesItemHelperFamily extends $Family
    with $FunctionalFamilyOverride<AddressesItemHelper, AddressesItem> {
  const AddressesItemHelperFamily._()
    : super(
        retry: null,
        name: r'addressesItemHelperProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AddressesItemHelperProvider call(AddressesItem addressesItem) =>
      AddressesItemHelperProvider._(argument: addressesItem, from: this);

  @override
  String toString() => r'addressesItemHelperProvider';
}

@ProviderFor(AddressesWalletTypeFlagNotifier)
const addressesWalletTypeFlagProvider =
    AddressesWalletTypeFlagNotifierProvider._();

final class AddressesWalletTypeFlagNotifierProvider
    extends
        $NotifierProvider<
          AddressesWalletTypeFlagNotifier,
          AddressesWalletTypeFlag
        > {
  const AddressesWalletTypeFlagNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesWalletTypeFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesWalletTypeFlagNotifierHash();

  @$internal
  @override
  AddressesWalletTypeFlagNotifier create() => AddressesWalletTypeFlagNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressesWalletTypeFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressesWalletTypeFlag>(value),
    );
  }
}

String _$addressesWalletTypeFlagNotifierHash() =>
    r'0522e0a6fe001a7803f7793e8c3dd91e4a55e0d9';

abstract class _$AddressesWalletTypeFlagNotifier
    extends $Notifier<AddressesWalletTypeFlag> {
  AddressesWalletTypeFlag build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AddressesWalletTypeFlag, AddressesWalletTypeFlag>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddressesWalletTypeFlag, AddressesWalletTypeFlag>,
              AddressesWalletTypeFlag,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AddressesAddressTypeFlagNotifier)
const addressesAddressTypeFlagProvider =
    AddressesAddressTypeFlagNotifierProvider._();

final class AddressesAddressTypeFlagNotifierProvider
    extends
        $NotifierProvider<
          AddressesAddressTypeFlagNotifier,
          AddressesAddressTypeFlag
        > {
  const AddressesAddressTypeFlagNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesAddressTypeFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesAddressTypeFlagNotifierHash();

  @$internal
  @override
  AddressesAddressTypeFlagNotifier create() =>
      AddressesAddressTypeFlagNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressesAddressTypeFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressesAddressTypeFlag>(value),
    );
  }
}

String _$addressesAddressTypeFlagNotifierHash() =>
    r'fe77ad59f15d0e3a9de3162a0943d7b4573a81f8';

abstract class _$AddressesAddressTypeFlagNotifier
    extends $Notifier<AddressesAddressTypeFlag> {
  AddressesAddressTypeFlag build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AddressesAddressTypeFlag, AddressesAddressTypeFlag>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddressesAddressTypeFlag, AddressesAddressTypeFlag>,
              AddressesAddressTypeFlag,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AddressesBalanceTypeFlagNotifier)
const addressesBalanceTypeFlagProvider =
    AddressesBalanceTypeFlagNotifierProvider._();

final class AddressesBalanceTypeFlagNotifierProvider
    extends
        $NotifierProvider<
          AddressesBalanceTypeFlagNotifier,
          AddressesBalanceFlag
        > {
  const AddressesBalanceTypeFlagNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressesBalanceTypeFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressesBalanceTypeFlagNotifierHash();

  @$internal
  @override
  AddressesBalanceTypeFlagNotifier create() =>
      AddressesBalanceTypeFlagNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressesBalanceFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressesBalanceFlag>(value),
    );
  }
}

String _$addressesBalanceTypeFlagNotifierHash() =>
    r'0e13c3bafcdca1fc1c14852d4da8ba4c91bf9aa0';

abstract class _$AddressesBalanceTypeFlagNotifier
    extends $Notifier<AddressesBalanceFlag> {
  AddressesBalanceFlag build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AddressesBalanceFlag, AddressesBalanceFlag>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AddressesBalanceFlag, AddressesBalanceFlag>,
              AddressesBalanceFlag,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(inputsAddressesAsync)
const inputsAddressesAsyncProvider = InputsAddressesAsyncProvider._();

final class InputsAddressesAsyncProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>,
          AsyncValue<AddressesModel>
        >
    with $Provider<AsyncValue<AddressesModel>> {
  const InputsAddressesAsyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputsAddressesAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inputsAddressesAsyncHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<AddressesModel>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AddressesModel> create(Ref ref) {
    return inputsAddressesAsync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AddressesModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AddressesModel>>(value),
    );
  }
}

String _$inputsAddressesAsyncHash() =>
    r'b46c153f2c9554afc2caeaa77aff6fa248d520ff';

@ProviderFor(SelectedInputsNotifier)
const selectedInputsProvider = SelectedInputsNotifierProvider._();

final class SelectedInputsNotifierProvider
    extends $NotifierProvider<SelectedInputsNotifier, List<UtxosItem>> {
  const SelectedInputsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedInputsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedInputsNotifierHash();

  @$internal
  @override
  SelectedInputsNotifier create() => SelectedInputsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UtxosItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UtxosItem>>(value),
    );
  }
}

String _$selectedInputsNotifierHash() =>
    r'264a90162e7d770a3c708f9c7c31c8781e6f4146';

abstract class _$SelectedInputsNotifier extends $Notifier<List<UtxosItem>> {
  List<UtxosItem> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<UtxosItem>, List<UtxosItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<UtxosItem>, List<UtxosItem>>,
              List<UtxosItem>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(selectedInputsHelper)
const selectedInputsHelperProvider = SelectedInputsHelperProvider._();

final class SelectedInputsHelperProvider
    extends
        $FunctionalProvider<
          SelectedInputsHelper,
          SelectedInputsHelper,
          SelectedInputsHelper
        >
    with $Provider<SelectedInputsHelper> {
  const SelectedInputsHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedInputsHelperProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedInputsHelperHash();

  @$internal
  @override
  $ProviderElement<SelectedInputsHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SelectedInputsHelper create(Ref ref) {
    return selectedInputsHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectedInputsHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectedInputsHelper>(value),
    );
  }
}

String _$selectedInputsHelperHash() =>
    r'00f9e6826360f87d21ef6ed4805e04f9ae79b9d4';

@ProviderFor(InputListItemExpandedStatesNotifier)
const inputListItemExpandedStatesProvider =
    InputListItemExpandedStatesNotifierProvider._();

final class InputListItemExpandedStatesNotifierProvider
    extends
        $NotifierProvider<
          InputListItemExpandedStatesNotifier,
          List<InputListItemExpandedState>
        > {
  const InputListItemExpandedStatesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inputListItemExpandedStatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$inputListItemExpandedStatesNotifierHash();

  @$internal
  @override
  InputListItemExpandedStatesNotifier create() =>
      InputListItemExpandedStatesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<InputListItemExpandedState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<InputListItemExpandedState>>(
        value,
      ),
    );
  }
}

String _$inputListItemExpandedStatesNotifierHash() =>
    r'9f2a1a47e13d00e71dcf871b9500b0249324a859';

abstract class _$InputListItemExpandedStatesNotifier
    extends $Notifier<List<InputListItemExpandedState>> {
  List<InputListItemExpandedState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              List<InputListItemExpandedState>,
              List<InputListItemExpandedState>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<InputListItemExpandedState>,
                List<InputListItemExpandedState>
              >,
              List<InputListItemExpandedState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(inputListItemExpandedState)
const inputListItemExpandedStateProvider = InputListItemExpandedStateFamily._();

final class InputListItemExpandedStateProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const InputListItemExpandedStateProvider._({
    required InputListItemExpandedStateFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'inputListItemExpandedStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inputListItemExpandedStateHash();

  @override
  String toString() {
    return r'inputListItemExpandedStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as int;
    return inputListItemExpandedState(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is InputListItemExpandedStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inputListItemExpandedStateHash() =>
    r'5150a1806086c045aa3b88ebbfe503a6b6536fcd';

final class InputListItemExpandedStateFamily extends $Family
    with $FunctionalFamilyOverride<bool, int> {
  const InputListItemExpandedStateFamily._()
    : super(
        retry: null,
        name: r'inputListItemExpandedStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  InputListItemExpandedStateProvider call(int hash) =>
      InputListItemExpandedStateProvider._(argument: hash, from: this);

  @override
  String toString() => r'inputListItemExpandedStateProvider';
}
