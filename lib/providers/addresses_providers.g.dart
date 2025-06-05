// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addresses_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$regularAddressesModelAsyncHash() =>
    r'cc5714e646bed4933ebb2b9ba867879b4198f5da';

/// See also [regularAddressesModelAsync].
@ProviderFor(regularAddressesModelAsync)
final regularAddressesModelAsyncProvider =
    AutoDisposeProvider<AsyncValue<AddressesModel>>.internal(
      regularAddressesModelAsync,
      name: r'regularAddressesModelAsyncProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$regularAddressesModelAsyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegularAddressesModelAsyncRef =
    AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$ampAdressesModelAsyncHash() =>
    r'30d6573621ebd931043cd3a9e1bc1b99eabdb1e6';

/// See also [ampAdressesModelAsync].
@ProviderFor(ampAdressesModelAsync)
final ampAdressesModelAsyncProvider =
    AutoDisposeProvider<AsyncValue<AddressesModel>>.internal(
      ampAdressesModelAsync,
      name: r'ampAdressesModelAsyncProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ampAdressesModelAsyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AmpAdressesModelAsyncRef =
    AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$groupedAddressesAsyncHash() =>
    r'661851a01af4ef5af94b33cd57170d0e6be92dce';

/// See also [groupedAddressesAsync].
@ProviderFor(groupedAddressesAsync)
final groupedAddressesAsyncProvider =
    AutoDisposeProvider<AsyncValue<AddressesModel>>.internal(
      groupedAddressesAsync,
      name: r'groupedAddressesAsyncProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupedAddressesAsyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupedAddressesAsyncRef =
    AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$filteredAddressesAsyncHash() =>
    r'4f512aebba2a6ea1b49894bcf1589ab429c9e228';

/// See also [filteredAddressesAsync].
@ProviderFor(filteredAddressesAsync)
final filteredAddressesAsyncProvider =
    AutoDisposeProvider<AsyncValue<AddressesModel>>.internal(
      filteredAddressesAsync,
      name: r'filteredAddressesAsyncProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredAddressesAsyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredAddressesAsyncRef =
    AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$addressesItemHelperHash() =>
    r'fbfe778e431413d06c76f54b681be5bb7a74f1cc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [addressesItemHelper].
@ProviderFor(addressesItemHelper)
const addressesItemHelperProvider = AddressesItemHelperFamily();

/// See also [addressesItemHelper].
class AddressesItemHelperFamily extends Family<AddressesItemHelper> {
  /// See also [addressesItemHelper].
  const AddressesItemHelperFamily();

  /// See also [addressesItemHelper].
  AddressesItemHelperProvider call(AddressesItem addressesItem) {
    return AddressesItemHelperProvider(addressesItem);
  }

  @override
  AddressesItemHelperProvider getProviderOverride(
    covariant AddressesItemHelperProvider provider,
  ) {
    return call(provider.addressesItem);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addressesItemHelperProvider';
}

/// See also [addressesItemHelper].
class AddressesItemHelperProvider
    extends AutoDisposeProvider<AddressesItemHelper> {
  /// See also [addressesItemHelper].
  AddressesItemHelperProvider(AddressesItem addressesItem)
    : this._internal(
        (ref) =>
            addressesItemHelper(ref as AddressesItemHelperRef, addressesItem),
        from: addressesItemHelperProvider,
        name: r'addressesItemHelperProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$addressesItemHelperHash,
        dependencies: AddressesItemHelperFamily._dependencies,
        allTransitiveDependencies:
            AddressesItemHelperFamily._allTransitiveDependencies,
        addressesItem: addressesItem,
      );

  AddressesItemHelperProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.addressesItem,
  }) : super.internal();

  final AddressesItem addressesItem;

  @override
  Override overrideWith(
    AddressesItemHelper Function(AddressesItemHelperRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddressesItemHelperProvider._internal(
        (ref) => create(ref as AddressesItemHelperRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        addressesItem: addressesItem,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AddressesItemHelper> createElement() {
    return _AddressesItemHelperProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddressesItemHelperProvider &&
        other.addressesItem == addressesItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, addressesItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddressesItemHelperRef on AutoDisposeProviderRef<AddressesItemHelper> {
  /// The parameter `addressesItem` of this provider.
  AddressesItem get addressesItem;
}

class _AddressesItemHelperProviderElement
    extends AutoDisposeProviderElement<AddressesItemHelper>
    with AddressesItemHelperRef {
  _AddressesItemHelperProviderElement(super.provider);

  @override
  AddressesItem get addressesItem =>
      (origin as AddressesItemHelperProvider).addressesItem;
}

String _$inputsAddressesAsyncHash() =>
    r'bc0965f3bdd75b0d65288c0ad026c9f2c0b60148';

/// See also [inputsAddressesAsync].
@ProviderFor(inputsAddressesAsync)
final inputsAddressesAsyncProvider =
    AutoDisposeProvider<AsyncValue<AddressesModel>>.internal(
      inputsAddressesAsync,
      name: r'inputsAddressesAsyncProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inputsAddressesAsyncHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InputsAddressesAsyncRef =
    AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$selectedInputsHelperHash() =>
    r'130b5c6f1cca20859c8344626ca61c4e96936cde';

/// See also [selectedInputsHelper].
@ProviderFor(selectedInputsHelper)
final selectedInputsHelperProvider =
    AutoDisposeProvider<SelectedInputsHelper>.internal(
      selectedInputsHelper,
      name: r'selectedInputsHelperProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedInputsHelperHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedInputsHelperRef = AutoDisposeProviderRef<SelectedInputsHelper>;
String _$inputListItemExpandedStateHash() =>
    r'b50cdba94e012b1ef92a557bc1afad45a59eecf5';

/// See also [inputListItemExpandedState].
@ProviderFor(inputListItemExpandedState)
const inputListItemExpandedStateProvider = InputListItemExpandedStateFamily();

/// See also [inputListItemExpandedState].
class InputListItemExpandedStateFamily extends Family<bool> {
  /// See also [inputListItemExpandedState].
  const InputListItemExpandedStateFamily();

  /// See also [inputListItemExpandedState].
  InputListItemExpandedStateProvider call(int hash) {
    return InputListItemExpandedStateProvider(hash);
  }

  @override
  InputListItemExpandedStateProvider getProviderOverride(
    covariant InputListItemExpandedStateProvider provider,
  ) {
    return call(provider.hash);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'inputListItemExpandedStateProvider';
}

/// See also [inputListItemExpandedState].
class InputListItemExpandedStateProvider extends AutoDisposeProvider<bool> {
  /// See also [inputListItemExpandedState].
  InputListItemExpandedStateProvider(int hash)
    : this._internal(
        (ref) => inputListItemExpandedState(
          ref as InputListItemExpandedStateRef,
          hash,
        ),
        from: inputListItemExpandedStateProvider,
        name: r'inputListItemExpandedStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$inputListItemExpandedStateHash,
        dependencies: InputListItemExpandedStateFamily._dependencies,
        allTransitiveDependencies:
            InputListItemExpandedStateFamily._allTransitiveDependencies,
        hash: hash,
      );

  InputListItemExpandedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hash,
  }) : super.internal();

  final int hash;

  @override
  Override overrideWith(
    bool Function(InputListItemExpandedStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InputListItemExpandedStateProvider._internal(
        (ref) => create(ref as InputListItemExpandedStateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hash: hash,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _InputListItemExpandedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InputListItemExpandedStateProvider && other.hash == hash;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hash.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InputListItemExpandedStateRef on AutoDisposeProviderRef<bool> {
  /// The parameter `hash` of this provider.
  int get hash;
}

class _InputListItemExpandedStateProviderElement
    extends AutoDisposeProviderElement<bool>
    with InputListItemExpandedStateRef {
  _InputListItemExpandedStateProviderElement(super.provider);

  @override
  int get hash => (origin as InputListItemExpandedStateProvider).hash;
}

String _$loadAddressesStateNotifierHash() =>
    r'6c739084ff0a82a38dbb38dcf9f847b5c89ff116';

/// See also [LoadAddressesStateNotifier].
@ProviderFor(LoadAddressesStateNotifier)
final loadAddressesStateNotifierProvider =
    AutoDisposeNotifierProvider<
      LoadAddressesStateNotifier,
      LoadAddressesState
    >.internal(
      LoadAddressesStateNotifier.new,
      name: r'loadAddressesStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loadAddressesStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoadAddressesStateNotifier = AutoDisposeNotifier<LoadAddressesState>;
String _$loadUtxosStateNotifierHash() =>
    r'89a4e95d66be4159dbc39f33e29bf6c756245bec';

/// See also [LoadUtxosStateNotifier].
@ProviderFor(LoadUtxosStateNotifier)
final loadUtxosStateNotifierProvider =
    AutoDisposeNotifierProvider<
      LoadUtxosStateNotifier,
      LoadUtxosState
    >.internal(
      LoadUtxosStateNotifier.new,
      name: r'loadUtxosStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loadUtxosStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoadUtxosStateNotifier = AutoDisposeNotifier<LoadUtxosState>;
String _$addressesAsyncNotifierHash() =>
    r'f7f36c390730df058031cced46bbe919afaef343';

abstract class _$AddressesAsyncNotifier
    extends BuildlessAutoDisposeAsyncNotifier<AddressesModel> {
  late final Account account;

  FutureOr<AddressesModel> build(Account account);
}

/// See also [AddressesAsyncNotifier].
@ProviderFor(AddressesAsyncNotifier)
const addressesAsyncNotifierProvider = AddressesAsyncNotifierFamily();

/// See also [AddressesAsyncNotifier].
class AddressesAsyncNotifierFamily extends Family<AsyncValue<AddressesModel>> {
  /// See also [AddressesAsyncNotifier].
  const AddressesAsyncNotifierFamily();

  /// See also [AddressesAsyncNotifier].
  AddressesAsyncNotifierProvider call(Account account) {
    return AddressesAsyncNotifierProvider(account);
  }

  @override
  AddressesAsyncNotifierProvider getProviderOverride(
    covariant AddressesAsyncNotifierProvider provider,
  ) {
    return call(provider.account);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addressesAsyncNotifierProvider';
}

/// See also [AddressesAsyncNotifier].
class AddressesAsyncNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          AddressesAsyncNotifier,
          AddressesModel
        > {
  /// See also [AddressesAsyncNotifier].
  AddressesAsyncNotifierProvider(Account account)
    : this._internal(
        () => AddressesAsyncNotifier()..account = account,
        from: addressesAsyncNotifierProvider,
        name: r'addressesAsyncNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$addressesAsyncNotifierHash,
        dependencies: AddressesAsyncNotifierFamily._dependencies,
        allTransitiveDependencies:
            AddressesAsyncNotifierFamily._allTransitiveDependencies,
        account: account,
      );

  AddressesAsyncNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final Account account;

  @override
  FutureOr<AddressesModel> runNotifierBuild(
    covariant AddressesAsyncNotifier notifier,
  ) {
    return notifier.build(account);
  }

  @override
  Override overrideWith(AddressesAsyncNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AddressesAsyncNotifierProvider._internal(
        () => create()..account = account,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    AddressesAsyncNotifier,
    AddressesModel
  >
  createElement() {
    return _AddressesAsyncNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddressesAsyncNotifierProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddressesAsyncNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<AddressesModel> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _AddressesAsyncNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          AddressesAsyncNotifier,
          AddressesModel
        >
    with AddressesAsyncNotifierRef {
  _AddressesAsyncNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as AddressesAsyncNotifierProvider).account;
}

String _$addressDetailsDialogNotifierHash() =>
    r'f5266f4ba5a9d00592f1b5ef82e861a6cb968ad3';

/// See also [AddressDetailsDialogNotifier].
@ProviderFor(AddressDetailsDialogNotifier)
final addressDetailsDialogNotifierProvider =
    NotifierProvider<
      AddressDetailsDialogNotifier,
      AddressDetailsState
    >.internal(
      AddressDetailsDialogNotifier.new,
      name: r'addressDetailsDialogNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressDetailsDialogNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddressDetailsDialogNotifier = Notifier<AddressDetailsState>;
String _$addressesWalletTypeFlagNotifierHash() =>
    r'0522e0a6fe001a7803f7793e8c3dd91e4a55e0d9';

/// See also [AddressesWalletTypeFlagNotifier].
@ProviderFor(AddressesWalletTypeFlagNotifier)
final addressesWalletTypeFlagNotifierProvider =
    AutoDisposeNotifierProvider<
      AddressesWalletTypeFlagNotifier,
      AddressesWalletTypeFlag
    >.internal(
      AddressesWalletTypeFlagNotifier.new,
      name: r'addressesWalletTypeFlagNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressesWalletTypeFlagNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddressesWalletTypeFlagNotifier =
    AutoDisposeNotifier<AddressesWalletTypeFlag>;
String _$addressesAddressTypeFlagNotifierHash() =>
    r'fe77ad59f15d0e3a9de3162a0943d7b4573a81f8';

/// See also [AddressesAddressTypeFlagNotifier].
@ProviderFor(AddressesAddressTypeFlagNotifier)
final addressesAddressTypeFlagNotifierProvider =
    AutoDisposeNotifierProvider<
      AddressesAddressTypeFlagNotifier,
      AddressesAddressTypeFlag
    >.internal(
      AddressesAddressTypeFlagNotifier.new,
      name: r'addressesAddressTypeFlagNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressesAddressTypeFlagNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddressesAddressTypeFlagNotifier =
    AutoDisposeNotifier<AddressesAddressTypeFlag>;
String _$addressesBalanceTypeFlagNotifierHash() =>
    r'0e13c3bafcdca1fc1c14852d4da8ba4c91bf9aa0';

/// See also [AddressesBalanceTypeFlagNotifier].
@ProviderFor(AddressesBalanceTypeFlagNotifier)
final addressesBalanceTypeFlagNotifierProvider =
    AutoDisposeNotifierProvider<
      AddressesBalanceTypeFlagNotifier,
      AddressesBalanceFlag
    >.internal(
      AddressesBalanceTypeFlagNotifier.new,
      name: r'addressesBalanceTypeFlagNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressesBalanceTypeFlagNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddressesBalanceTypeFlagNotifier =
    AutoDisposeNotifier<AddressesBalanceFlag>;
String _$selectedInputsNotifierHash() =>
    r'552487d0df3dae807434e94c71b3795964ab2b47';

/// See also [SelectedInputsNotifier].
@ProviderFor(SelectedInputsNotifier)
final selectedInputsNotifierProvider =
    AutoDisposeNotifierProvider<
      SelectedInputsNotifier,
      List<UtxosItem>
    >.internal(
      SelectedInputsNotifier.new,
      name: r'selectedInputsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedInputsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedInputsNotifier = AutoDisposeNotifier<List<UtxosItem>>;
String _$inputListItemExpandedStatesNotifierHash() =>
    r'9f2a1a47e13d00e71dcf871b9500b0249324a859';

/// See also [InputListItemExpandedStatesNotifier].
@ProviderFor(InputListItemExpandedStatesNotifier)
final inputListItemExpandedStatesNotifierProvider =
    AutoDisposeNotifierProvider<
      InputListItemExpandedStatesNotifier,
      List<InputListItemExpandedState>
    >.internal(
      InputListItemExpandedStatesNotifier.new,
      name: r'inputListItemExpandedStatesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inputListItemExpandedStatesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$InputListItemExpandedStatesNotifier =
    AutoDisposeNotifier<List<InputListItemExpandedState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
