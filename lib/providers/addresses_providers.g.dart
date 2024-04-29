// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addresses_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$regularAddressesModelAsyncHash() =>
    r'f42308dac7afa0bd04d9017c22fb5b1ba3599923';

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

typedef RegularAddressesModelAsyncRef
    = AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$ampAdressesModelAsyncHash() =>
    r'422c12ad9000eb767a5d22199f9efc066ef6ed43';

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

typedef AmpAdressesModelAsyncRef
    = AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$groupedAddressesAsyncHash() =>
    r'41f9a69c441b0ce89d4b2e86f2db90ddb9ef4799';

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

typedef GroupedAddressesAsyncRef
    = AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$filteredAddressesAsyncHash() =>
    r'958d77f8d0c5161b18868cf2aed03d2d79350281';

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

typedef FilteredAddressesAsyncRef
    = AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$addressesItemHelperHash() =>
    r'89ba48c4c858faef70c485f6f37679bcf95950ed';

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
  AddressesItemHelperProvider call(
    AddressesItem addressesItem,
  ) {
    return AddressesItemHelperProvider(
      addressesItem,
    );
  }

  @override
  AddressesItemHelperProvider getProviderOverride(
    covariant AddressesItemHelperProvider provider,
  ) {
    return call(
      provider.addressesItem,
    );
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
  AddressesItemHelperProvider(
    AddressesItem addressesItem,
  ) : this._internal(
          (ref) => addressesItemHelper(
            ref as AddressesItemHelperRef,
            addressesItem,
          ),
          from: addressesItemHelperProvider,
          name: r'addressesItemHelperProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
    r'852973f931fee3d5d964bd2bce939fc7d9f5f4a3';

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

typedef InputsAddressesAsyncRef
    = AutoDisposeProviderRef<AsyncValue<AddressesModel>>;
String _$selectedInputsHelperHash() =>
    r'0265000b09b78314b8597f35b13b87efab6995ef';

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

typedef SelectedInputsHelperRef = AutoDisposeProviderRef<SelectedInputsHelper>;
String _$inputListItemExpandedStateHash() =>
    r'08214c865ca8bba73ad786ef7881c7b80be2dd69';

/// See also [inputListItemExpandedState].
@ProviderFor(inputListItemExpandedState)
const inputListItemExpandedStateProvider = InputListItemExpandedStateFamily();

/// See also [inputListItemExpandedState].
class InputListItemExpandedStateFamily extends Family<bool> {
  /// See also [inputListItemExpandedState].
  const InputListItemExpandedStateFamily();

  /// See also [inputListItemExpandedState].
  InputListItemExpandedStateProvider call(
    int hash,
  ) {
    return InputListItemExpandedStateProvider(
      hash,
    );
  }

  @override
  InputListItemExpandedStateProvider getProviderOverride(
    covariant InputListItemExpandedStateProvider provider,
  ) {
    return call(
      provider.hash,
    );
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
  InputListItemExpandedStateProvider(
    int hash,
  ) : this._internal(
          (ref) => inputListItemExpandedState(
            ref as InputListItemExpandedStateRef,
            hash,
          ),
          from: inputListItemExpandedStateProvider,
          name: r'inputListItemExpandedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
final loadAddressesStateNotifierProvider = AutoDisposeNotifierProvider<
    LoadAddressesStateNotifier, LoadAddressesState>.internal(
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
final loadUtxosStateNotifierProvider = AutoDisposeNotifierProvider<
    LoadUtxosStateNotifier, LoadUtxosState>.internal(
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
    r'6fc355de5a34502ee4edbd6b505fcd32a5dfc8ca';

abstract class _$AddressesAsyncNotifier
    extends BuildlessAutoDisposeAsyncNotifier<AddressesModel> {
  late final Account account;

  FutureOr<AddressesModel> build(
    Account account,
  );
}

/// See also [AddressesAsyncNotifier].
@ProviderFor(AddressesAsyncNotifier)
const addressesAsyncNotifierProvider = AddressesAsyncNotifierFamily();

/// See also [AddressesAsyncNotifier].
class AddressesAsyncNotifierFamily extends Family<AsyncValue<AddressesModel>> {
  /// See also [AddressesAsyncNotifier].
  const AddressesAsyncNotifierFamily();

  /// See also [AddressesAsyncNotifier].
  AddressesAsyncNotifierProvider call(
    Account account,
  ) {
    return AddressesAsyncNotifierProvider(
      account,
    );
  }

  @override
  AddressesAsyncNotifierProvider getProviderOverride(
    covariant AddressesAsyncNotifierProvider provider,
  ) {
    return call(
      provider.account,
    );
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
    extends AutoDisposeAsyncNotifierProviderImpl<AddressesAsyncNotifier,
        AddressesModel> {
  /// See also [AddressesAsyncNotifier].
  AddressesAsyncNotifierProvider(
    Account account,
  ) : this._internal(
          () => AddressesAsyncNotifier()..account = account,
          from: addressesAsyncNotifierProvider,
          name: r'addressesAsyncNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
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
    return notifier.build(
      account,
    );
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
  AutoDisposeAsyncNotifierProviderElement<AddressesAsyncNotifier,
      AddressesModel> createElement() {
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

mixin AddressesAsyncNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<AddressesModel> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _AddressesAsyncNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AddressesAsyncNotifier,
        AddressesModel> with AddressesAsyncNotifierRef {
  _AddressesAsyncNotifierProviderElement(super.provider);

  @override
  Account get account => (origin as AddressesAsyncNotifierProvider).account;
}

String _$addressDetailsDialogNotifierHash() =>
    r'f5266f4ba5a9d00592f1b5ef82e861a6cb968ad3';

/// See also [AddressDetailsDialogNotifier].
@ProviderFor(AddressDetailsDialogNotifier)
final addressDetailsDialogNotifierProvider = NotifierProvider<
    AddressDetailsDialogNotifier, AddressDetailsState>.internal(
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
final addressesWalletTypeFlagNotifierProvider = AutoDisposeNotifierProvider<
    AddressesWalletTypeFlagNotifier, AddressesWalletTypeFlag>.internal(
  AddressesWalletTypeFlagNotifier.new,
  name: r'addressesWalletTypeFlagNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addressesWalletTypeFlagNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddressesWalletTypeFlagNotifier
    = AutoDisposeNotifier<AddressesWalletTypeFlag>;
String _$addressesAddressTypeFlagNotifierHash() =>
    r'fe77ad59f15d0e3a9de3162a0943d7b4573a81f8';

/// See also [AddressesAddressTypeFlagNotifier].
@ProviderFor(AddressesAddressTypeFlagNotifier)
final addressesAddressTypeFlagNotifierProvider = AutoDisposeNotifierProvider<
    AddressesAddressTypeFlagNotifier, AddressesAddressTypeFlag>.internal(
  AddressesAddressTypeFlagNotifier.new,
  name: r'addressesAddressTypeFlagNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addressesAddressTypeFlagNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddressesAddressTypeFlagNotifier
    = AutoDisposeNotifier<AddressesAddressTypeFlag>;
String _$addressesBalanceTypeFlagNotifierHash() =>
    r'75e79e0eb62513b93d67c5638d773e42c16b4c98';

/// See also [AddressesBalanceTypeFlagNotifier].
@ProviderFor(AddressesBalanceTypeFlagNotifier)
final addressesBalanceTypeFlagNotifierProvider = AutoDisposeNotifierProvider<
    AddressesBalanceTypeFlagNotifier, AddressesBalanceFlag>.internal(
  AddressesBalanceTypeFlagNotifier.new,
  name: r'addressesBalanceTypeFlagNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addressesBalanceTypeFlagNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddressesBalanceTypeFlagNotifier
    = AutoDisposeNotifier<AddressesBalanceFlag>;
String _$selectedInputsNotifierHash() =>
    r'552487d0df3dae807434e94c71b3795964ab2b47';

/// See also [SelectedInputsNotifier].
@ProviderFor(SelectedInputsNotifier)
final selectedInputsNotifierProvider = AutoDisposeNotifierProvider<
    SelectedInputsNotifier, List<UtxosItem>>.internal(
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
final inputListItemExpandedStatesNotifierProvider = AutoDisposeNotifierProvider<
    InputListItemExpandedStatesNotifier,
    List<InputListItemExpandedState>>.internal(
  InputListItemExpandedStatesNotifier.new,
  name: r'inputListItemExpandedStatesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inputListItemExpandedStatesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InputListItemExpandedStatesNotifier
    = AutoDisposeNotifier<List<InputListItemExpandedState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
