// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addresses_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UtxosItem {
  String? get txid => throw _privateConstructorUsedError;
  int? get vout => throw _privateConstructorUsedError;
  String? get assetId => throw _privateConstructorUsedError;
  int? get amount => throw _privateConstructorUsedError;
  bool? get isInternal => throw _privateConstructorUsedError;
  bool? get isConfidential => throw _privateConstructorUsedError;
  int? get account => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UtxosItemCopyWith<UtxosItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UtxosItemCopyWith<$Res> {
  factory $UtxosItemCopyWith(UtxosItem value, $Res Function(UtxosItem) then) =
      _$UtxosItemCopyWithImpl<$Res, UtxosItem>;
  @useResult
  $Res call(
      {String? txid,
      int? vout,
      String? assetId,
      int? amount,
      bool? isInternal,
      bool? isConfidential,
      int? account});
}

/// @nodoc
class _$UtxosItemCopyWithImpl<$Res, $Val extends UtxosItem>
    implements $UtxosItemCopyWith<$Res> {
  _$UtxosItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = freezed,
    Object? vout = freezed,
    Object? assetId = freezed,
    Object? amount = freezed,
    Object? isInternal = freezed,
    Object? isConfidential = freezed,
    Object? account = freezed,
  }) {
    return _then(_value.copyWith(
      txid: freezed == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String?,
      vout: freezed == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int?,
      assetId: freezed == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      isConfidential: freezed == isConfidential
          ? _value.isConfidential
          : isConfidential // ignore: cast_nullable_to_non_nullable
              as bool?,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UtxosItemImplCopyWith<$Res>
    implements $UtxosItemCopyWith<$Res> {
  factory _$$UtxosItemImplCopyWith(
          _$UtxosItemImpl value, $Res Function(_$UtxosItemImpl) then) =
      __$$UtxosItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? txid,
      int? vout,
      String? assetId,
      int? amount,
      bool? isInternal,
      bool? isConfidential,
      int? account});
}

/// @nodoc
class __$$UtxosItemImplCopyWithImpl<$Res>
    extends _$UtxosItemCopyWithImpl<$Res, _$UtxosItemImpl>
    implements _$$UtxosItemImplCopyWith<$Res> {
  __$$UtxosItemImplCopyWithImpl(
      _$UtxosItemImpl _value, $Res Function(_$UtxosItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txid = freezed,
    Object? vout = freezed,
    Object? assetId = freezed,
    Object? amount = freezed,
    Object? isInternal = freezed,
    Object? isConfidential = freezed,
    Object? account = freezed,
  }) {
    return _then(_$UtxosItemImpl(
      txid: freezed == txid
          ? _value.txid
          : txid // ignore: cast_nullable_to_non_nullable
              as String?,
      vout: freezed == vout
          ? _value.vout
          : vout // ignore: cast_nullable_to_non_nullable
              as int?,
      assetId: freezed == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      isConfidential: freezed == isConfidential
          ? _value.isConfidential
          : isConfidential // ignore: cast_nullable_to_non_nullable
              as bool?,
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$UtxosItemImpl implements _UtxosItem {
  const _$UtxosItemImpl(
      {this.txid,
      this.vout,
      this.assetId,
      this.amount,
      this.isInternal,
      this.isConfidential,
      this.account});

  @override
  final String? txid;
  @override
  final int? vout;
  @override
  final String? assetId;
  @override
  final int? amount;
  @override
  final bool? isInternal;
  @override
  final bool? isConfidential;
  @override
  final int? account;

  @override
  String toString() {
    return 'UtxosItem(txid: $txid, vout: $vout, assetId: $assetId, amount: $amount, isInternal: $isInternal, isConfidential: $isConfidential, account: $account)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UtxosItemImpl &&
            (identical(other.txid, txid) || other.txid == txid) &&
            (identical(other.vout, vout) || other.vout == vout) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            (identical(other.isConfidential, isConfidential) ||
                other.isConfidential == isConfidential) &&
            (identical(other.account, account) || other.account == account));
  }

  @override
  int get hashCode => Object.hash(runtimeType, txid, vout, assetId, amount,
      isInternal, isConfidential, account);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UtxosItemImplCopyWith<_$UtxosItemImpl> get copyWith =>
      __$$UtxosItemImplCopyWithImpl<_$UtxosItemImpl>(this, _$identity);
}

abstract class _UtxosItem implements UtxosItem {
  const factory _UtxosItem(
      {final String? txid,
      final int? vout,
      final String? assetId,
      final int? amount,
      final bool? isInternal,
      final bool? isConfidential,
      final int? account}) = _$UtxosItemImpl;

  @override
  String? get txid;
  @override
  int? get vout;
  @override
  String? get assetId;
  @override
  int? get amount;
  @override
  bool? get isInternal;
  @override
  bool? get isConfidential;
  @override
  int? get account;
  @override
  @JsonKey(ignore: true)
  _$$UtxosItemImplCopyWith<_$UtxosItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AddressesItem {
  int? get account => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get unconfidentialAddress => throw _privateConstructorUsedError;
  int? get index => throw _privateConstructorUsedError;
  bool? get isInternal => throw _privateConstructorUsedError;
  List<UtxosItem>? get utxos => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddressesItemCopyWith<AddressesItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressesItemCopyWith<$Res> {
  factory $AddressesItemCopyWith(
          AddressesItem value, $Res Function(AddressesItem) then) =
      _$AddressesItemCopyWithImpl<$Res, AddressesItem>;
  @useResult
  $Res call(
      {int? account,
      String? address,
      String? unconfidentialAddress,
      int? index,
      bool? isInternal,
      List<UtxosItem>? utxos});
}

/// @nodoc
class _$AddressesItemCopyWithImpl<$Res, $Val extends AddressesItem>
    implements $AddressesItemCopyWith<$Res> {
  _$AddressesItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = freezed,
    Object? address = freezed,
    Object? unconfidentialAddress = freezed,
    Object? index = freezed,
    Object? isInternal = freezed,
    Object? utxos = freezed,
  }) {
    return _then(_value.copyWith(
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as int?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      unconfidentialAddress: freezed == unconfidentialAddress
          ? _value.unconfidentialAddress
          : unconfidentialAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      index: freezed == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int?,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      utxos: freezed == utxos
          ? _value.utxos
          : utxos // ignore: cast_nullable_to_non_nullable
              as List<UtxosItem>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressesItemImplCopyWith<$Res>
    implements $AddressesItemCopyWith<$Res> {
  factory _$$AddressesItemImplCopyWith(
          _$AddressesItemImpl value, $Res Function(_$AddressesItemImpl) then) =
      __$$AddressesItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? account,
      String? address,
      String? unconfidentialAddress,
      int? index,
      bool? isInternal,
      List<UtxosItem>? utxos});
}

/// @nodoc
class __$$AddressesItemImplCopyWithImpl<$Res>
    extends _$AddressesItemCopyWithImpl<$Res, _$AddressesItemImpl>
    implements _$$AddressesItemImplCopyWith<$Res> {
  __$$AddressesItemImplCopyWithImpl(
      _$AddressesItemImpl _value, $Res Function(_$AddressesItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = freezed,
    Object? address = freezed,
    Object? unconfidentialAddress = freezed,
    Object? index = freezed,
    Object? isInternal = freezed,
    Object? utxos = freezed,
  }) {
    return _then(_$AddressesItemImpl(
      account: freezed == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as int?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      unconfidentialAddress: freezed == unconfidentialAddress
          ? _value.unconfidentialAddress
          : unconfidentialAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      index: freezed == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int?,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      utxos: freezed == utxos
          ? _value._utxos
          : utxos // ignore: cast_nullable_to_non_nullable
              as List<UtxosItem>?,
    ));
  }
}

/// @nodoc

class _$AddressesItemImpl implements _AddressesItem {
  const _$AddressesItemImpl(
      {this.account,
      this.address,
      this.unconfidentialAddress,
      this.index,
      this.isInternal,
      final List<UtxosItem>? utxos})
      : _utxos = utxos;

  @override
  final int? account;
  @override
  final String? address;
  @override
  final String? unconfidentialAddress;
  @override
  final int? index;
  @override
  final bool? isInternal;
  final List<UtxosItem>? _utxos;
  @override
  List<UtxosItem>? get utxos {
    final value = _utxos;
    if (value == null) return null;
    if (_utxos is EqualUnmodifiableListView) return _utxos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AddressesItem(account: $account, address: $address, unconfidentialAddress: $unconfidentialAddress, index: $index, isInternal: $isInternal, utxos: $utxos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesItemImpl &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.unconfidentialAddress, unconfidentialAddress) ||
                other.unconfidentialAddress == unconfidentialAddress) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            const DeepCollectionEquality().equals(other._utxos, _utxos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      account,
      address,
      unconfidentialAddress,
      index,
      isInternal,
      const DeepCollectionEquality().hash(_utxos));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressesItemImplCopyWith<_$AddressesItemImpl> get copyWith =>
      __$$AddressesItemImplCopyWithImpl<_$AddressesItemImpl>(this, _$identity);
}

abstract class _AddressesItem implements AddressesItem {
  const factory _AddressesItem(
      {final int? account,
      final String? address,
      final String? unconfidentialAddress,
      final int? index,
      final bool? isInternal,
      final List<UtxosItem>? utxos}) = _$AddressesItemImpl;

  @override
  int? get account;
  @override
  String? get address;
  @override
  String? get unconfidentialAddress;
  @override
  int? get index;
  @override
  bool? get isInternal;
  @override
  List<UtxosItem>? get utxos;
  @override
  @JsonKey(ignore: true)
  _$$AddressesItemImplCopyWith<_$AddressesItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AddressesModel {
  List<AddressesItem>? get addresses => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddressesModelCopyWith<AddressesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressesModelCopyWith<$Res> {
  factory $AddressesModelCopyWith(
          AddressesModel value, $Res Function(AddressesModel) then) =
      _$AddressesModelCopyWithImpl<$Res, AddressesModel>;
  @useResult
  $Res call({List<AddressesItem>? addresses});
}

/// @nodoc
class _$AddressesModelCopyWithImpl<$Res, $Val extends AddressesModel>
    implements $AddressesModelCopyWith<$Res> {
  _$AddressesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addresses = freezed,
  }) {
    return _then(_value.copyWith(
      addresses: freezed == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<AddressesItem>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressesModelImplCopyWith<$Res>
    implements $AddressesModelCopyWith<$Res> {
  factory _$$AddressesModelImplCopyWith(_$AddressesModelImpl value,
          $Res Function(_$AddressesModelImpl) then) =
      __$$AddressesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AddressesItem>? addresses});
}

/// @nodoc
class __$$AddressesModelImplCopyWithImpl<$Res>
    extends _$AddressesModelCopyWithImpl<$Res, _$AddressesModelImpl>
    implements _$$AddressesModelImplCopyWith<$Res> {
  __$$AddressesModelImplCopyWithImpl(
      _$AddressesModelImpl _value, $Res Function(_$AddressesModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addresses = freezed,
  }) {
    return _then(_$AddressesModelImpl(
      addresses: freezed == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<AddressesItem>?,
    ));
  }
}

/// @nodoc

class _$AddressesModelImpl implements _AddressesModel {
  const _$AddressesModelImpl({final List<AddressesItem>? addresses})
      : _addresses = addresses;

  final List<AddressesItem>? _addresses;
  @override
  List<AddressesItem>? get addresses {
    final value = _addresses;
    if (value == null) return null;
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AddressesModel(addresses: $addresses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesModelImpl &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_addresses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressesModelImplCopyWith<_$AddressesModelImpl> get copyWith =>
      __$$AddressesModelImplCopyWithImpl<_$AddressesModelImpl>(
          this, _$identity);
}

abstract class _AddressesModel implements AddressesModel {
  const factory _AddressesModel({final List<AddressesItem>? addresses}) =
      _$AddressesModelImpl;

  @override
  List<AddressesItem>? get addresses;
  @override
  @JsonKey(ignore: true)
  _$$AddressesModelImplCopyWith<_$AddressesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LoadAddressesState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadAddresses loadAddresses) data,
    required TResult Function(String errorMsg) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadAddresses loadAddresses)? data,
    TResult? Function(String errorMsg)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadAddresses loadAddresses)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadAddressesStateEmpty value) empty,
    required TResult Function(LoadAddressesStateLoading value) loading,
    required TResult Function(LoadAddressesStateData value) data,
    required TResult Function(LoadAddressesStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadAddressesStateEmpty value)? empty,
    TResult? Function(LoadAddressesStateLoading value)? loading,
    TResult? Function(LoadAddressesStateData value)? data,
    TResult? Function(LoadAddressesStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadAddressesStateEmpty value)? empty,
    TResult Function(LoadAddressesStateLoading value)? loading,
    TResult Function(LoadAddressesStateData value)? data,
    TResult Function(LoadAddressesStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadAddressesStateCopyWith<$Res> {
  factory $LoadAddressesStateCopyWith(
          LoadAddressesState value, $Res Function(LoadAddressesState) then) =
      _$LoadAddressesStateCopyWithImpl<$Res, LoadAddressesState>;
}

/// @nodoc
class _$LoadAddressesStateCopyWithImpl<$Res, $Val extends LoadAddressesState>
    implements $LoadAddressesStateCopyWith<$Res> {
  _$LoadAddressesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadAddressesStateEmptyImplCopyWith<$Res> {
  factory _$$LoadAddressesStateEmptyImplCopyWith(
          _$LoadAddressesStateEmptyImpl value,
          $Res Function(_$LoadAddressesStateEmptyImpl) then) =
      __$$LoadAddressesStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadAddressesStateEmptyImplCopyWithImpl<$Res>
    extends _$LoadAddressesStateCopyWithImpl<$Res,
        _$LoadAddressesStateEmptyImpl>
    implements _$$LoadAddressesStateEmptyImplCopyWith<$Res> {
  __$$LoadAddressesStateEmptyImplCopyWithImpl(
      _$LoadAddressesStateEmptyImpl _value,
      $Res Function(_$LoadAddressesStateEmptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadAddressesStateEmptyImpl implements LoadAddressesStateEmpty {
  const _$LoadAddressesStateEmptyImpl();

  @override
  String toString() {
    return 'LoadAddressesState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadAddressesStateEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadAddresses loadAddresses) data,
    required TResult Function(String errorMsg) error,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadAddresses loadAddresses)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadAddresses loadAddresses)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadAddressesStateEmpty value) empty,
    required TResult Function(LoadAddressesStateLoading value) loading,
    required TResult Function(LoadAddressesStateData value) data,
    required TResult Function(LoadAddressesStateError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadAddressesStateEmpty value)? empty,
    TResult? Function(LoadAddressesStateLoading value)? loading,
    TResult? Function(LoadAddressesStateData value)? data,
    TResult? Function(LoadAddressesStateError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadAddressesStateEmpty value)? empty,
    TResult Function(LoadAddressesStateLoading value)? loading,
    TResult Function(LoadAddressesStateData value)? data,
    TResult Function(LoadAddressesStateError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class LoadAddressesStateEmpty implements LoadAddressesState {
  const factory LoadAddressesStateEmpty() = _$LoadAddressesStateEmptyImpl;
}

/// @nodoc
abstract class _$$LoadAddressesStateLoadingImplCopyWith<$Res> {
  factory _$$LoadAddressesStateLoadingImplCopyWith(
          _$LoadAddressesStateLoadingImpl value,
          $Res Function(_$LoadAddressesStateLoadingImpl) then) =
      __$$LoadAddressesStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadAddressesStateLoadingImplCopyWithImpl<$Res>
    extends _$LoadAddressesStateCopyWithImpl<$Res,
        _$LoadAddressesStateLoadingImpl>
    implements _$$LoadAddressesStateLoadingImplCopyWith<$Res> {
  __$$LoadAddressesStateLoadingImplCopyWithImpl(
      _$LoadAddressesStateLoadingImpl _value,
      $Res Function(_$LoadAddressesStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadAddressesStateLoadingImpl implements LoadAddressesStateLoading {
  const _$LoadAddressesStateLoadingImpl();

  @override
  String toString() {
    return 'LoadAddressesState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadAddressesStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadAddresses loadAddresses) data,
    required TResult Function(String errorMsg) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadAddresses loadAddresses)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadAddresses loadAddresses)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadAddressesStateEmpty value) empty,
    required TResult Function(LoadAddressesStateLoading value) loading,
    required TResult Function(LoadAddressesStateData value) data,
    required TResult Function(LoadAddressesStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadAddressesStateEmpty value)? empty,
    TResult? Function(LoadAddressesStateLoading value)? loading,
    TResult? Function(LoadAddressesStateData value)? data,
    TResult? Function(LoadAddressesStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadAddressesStateEmpty value)? empty,
    TResult Function(LoadAddressesStateLoading value)? loading,
    TResult Function(LoadAddressesStateData value)? data,
    TResult Function(LoadAddressesStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoadAddressesStateLoading implements LoadAddressesState {
  const factory LoadAddressesStateLoading() = _$LoadAddressesStateLoadingImpl;
}

/// @nodoc
abstract class _$$LoadAddressesStateDataImplCopyWith<$Res> {
  factory _$$LoadAddressesStateDataImplCopyWith(
          _$LoadAddressesStateDataImpl value,
          $Res Function(_$LoadAddressesStateDataImpl) then) =
      __$$LoadAddressesStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({From_LoadAddresses loadAddresses});
}

/// @nodoc
class __$$LoadAddressesStateDataImplCopyWithImpl<$Res>
    extends _$LoadAddressesStateCopyWithImpl<$Res, _$LoadAddressesStateDataImpl>
    implements _$$LoadAddressesStateDataImplCopyWith<$Res> {
  __$$LoadAddressesStateDataImplCopyWithImpl(
      _$LoadAddressesStateDataImpl _value,
      $Res Function(_$LoadAddressesStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadAddresses = null,
  }) {
    return _then(_$LoadAddressesStateDataImpl(
      null == loadAddresses
          ? _value.loadAddresses
          : loadAddresses // ignore: cast_nullable_to_non_nullable
              as From_LoadAddresses,
    ));
  }
}

/// @nodoc

class _$LoadAddressesStateDataImpl implements LoadAddressesStateData {
  const _$LoadAddressesStateDataImpl(this.loadAddresses);

  @override
  final From_LoadAddresses loadAddresses;

  @override
  String toString() {
    return 'LoadAddressesState.data(loadAddresses: $loadAddresses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadAddressesStateDataImpl &&
            (identical(other.loadAddresses, loadAddresses) ||
                other.loadAddresses == loadAddresses));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadAddresses);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadAddressesStateDataImplCopyWith<_$LoadAddressesStateDataImpl>
      get copyWith => __$$LoadAddressesStateDataImplCopyWithImpl<
          _$LoadAddressesStateDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadAddresses loadAddresses) data,
    required TResult Function(String errorMsg) error,
  }) {
    return data(loadAddresses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadAddresses loadAddresses)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return data?.call(loadAddresses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadAddresses loadAddresses)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(loadAddresses);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadAddressesStateEmpty value) empty,
    required TResult Function(LoadAddressesStateLoading value) loading,
    required TResult Function(LoadAddressesStateData value) data,
    required TResult Function(LoadAddressesStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadAddressesStateEmpty value)? empty,
    TResult? Function(LoadAddressesStateLoading value)? loading,
    TResult? Function(LoadAddressesStateData value)? data,
    TResult? Function(LoadAddressesStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadAddressesStateEmpty value)? empty,
    TResult Function(LoadAddressesStateLoading value)? loading,
    TResult Function(LoadAddressesStateData value)? data,
    TResult Function(LoadAddressesStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class LoadAddressesStateData implements LoadAddressesState {
  const factory LoadAddressesStateData(final From_LoadAddresses loadAddresses) =
      _$LoadAddressesStateDataImpl;

  From_LoadAddresses get loadAddresses;
  @JsonKey(ignore: true)
  _$$LoadAddressesStateDataImplCopyWith<_$LoadAddressesStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadAddressesStateErrorImplCopyWith<$Res> {
  factory _$$LoadAddressesStateErrorImplCopyWith(
          _$LoadAddressesStateErrorImpl value,
          $Res Function(_$LoadAddressesStateErrorImpl) then) =
      __$$LoadAddressesStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMsg});
}

/// @nodoc
class __$$LoadAddressesStateErrorImplCopyWithImpl<$Res>
    extends _$LoadAddressesStateCopyWithImpl<$Res,
        _$LoadAddressesStateErrorImpl>
    implements _$$LoadAddressesStateErrorImplCopyWith<$Res> {
  __$$LoadAddressesStateErrorImplCopyWithImpl(
      _$LoadAddressesStateErrorImpl _value,
      $Res Function(_$LoadAddressesStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMsg = null,
  }) {
    return _then(_$LoadAddressesStateErrorImpl(
      null == errorMsg
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadAddressesStateErrorImpl implements LoadAddressesStateError {
  const _$LoadAddressesStateErrorImpl(this.errorMsg);

  @override
  final String errorMsg;

  @override
  String toString() {
    return 'LoadAddressesState.error(errorMsg: $errorMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadAddressesStateErrorImpl &&
            (identical(other.errorMsg, errorMsg) ||
                other.errorMsg == errorMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadAddressesStateErrorImplCopyWith<_$LoadAddressesStateErrorImpl>
      get copyWith => __$$LoadAddressesStateErrorImplCopyWithImpl<
          _$LoadAddressesStateErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadAddresses loadAddresses) data,
    required TResult Function(String errorMsg) error,
  }) {
    return error(errorMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadAddresses loadAddresses)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return error?.call(errorMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadAddresses loadAddresses)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadAddressesStateEmpty value) empty,
    required TResult Function(LoadAddressesStateLoading value) loading,
    required TResult Function(LoadAddressesStateData value) data,
    required TResult Function(LoadAddressesStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadAddressesStateEmpty value)? empty,
    TResult? Function(LoadAddressesStateLoading value)? loading,
    TResult? Function(LoadAddressesStateData value)? data,
    TResult? Function(LoadAddressesStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadAddressesStateEmpty value)? empty,
    TResult Function(LoadAddressesStateLoading value)? loading,
    TResult Function(LoadAddressesStateData value)? data,
    TResult Function(LoadAddressesStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LoadAddressesStateError implements LoadAddressesState {
  const factory LoadAddressesStateError(final String errorMsg) =
      _$LoadAddressesStateErrorImpl;

  String get errorMsg;
  @JsonKey(ignore: true)
  _$$LoadAddressesStateErrorImplCopyWith<_$LoadAddressesStateErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LoadUtxosState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadUtxos loadUtxos) data,
    required TResult Function(String errorMsg) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadUtxos loadUtxos)? data,
    TResult? Function(String errorMsg)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadUtxos loadUtxos)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUtxosStateEmpty value) empty,
    required TResult Function(LoadUtxosStateLoading value) loading,
    required TResult Function(LoadUtxosStateData value) data,
    required TResult Function(LoadUtxosStateError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUtxosStateEmpty value)? empty,
    TResult? Function(LoadUtxosStateLoading value)? loading,
    TResult? Function(LoadUtxosStateData value)? data,
    TResult? Function(LoadUtxosStateError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUtxosStateEmpty value)? empty,
    TResult Function(LoadUtxosStateLoading value)? loading,
    TResult Function(LoadUtxosStateData value)? data,
    TResult Function(LoadUtxosStateError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadUtxosStateCopyWith<$Res> {
  factory $LoadUtxosStateCopyWith(
          LoadUtxosState value, $Res Function(LoadUtxosState) then) =
      _$LoadUtxosStateCopyWithImpl<$Res, LoadUtxosState>;
}

/// @nodoc
class _$LoadUtxosStateCopyWithImpl<$Res, $Val extends LoadUtxosState>
    implements $LoadUtxosStateCopyWith<$Res> {
  _$LoadUtxosStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadUtxosStateEmptyImplCopyWith<$Res> {
  factory _$$LoadUtxosStateEmptyImplCopyWith(_$LoadUtxosStateEmptyImpl value,
          $Res Function(_$LoadUtxosStateEmptyImpl) then) =
      __$$LoadUtxosStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadUtxosStateEmptyImplCopyWithImpl<$Res>
    extends _$LoadUtxosStateCopyWithImpl<$Res, _$LoadUtxosStateEmptyImpl>
    implements _$$LoadUtxosStateEmptyImplCopyWith<$Res> {
  __$$LoadUtxosStateEmptyImplCopyWithImpl(_$LoadUtxosStateEmptyImpl _value,
      $Res Function(_$LoadUtxosStateEmptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadUtxosStateEmptyImpl implements LoadUtxosStateEmpty {
  const _$LoadUtxosStateEmptyImpl();

  @override
  String toString() {
    return 'LoadUtxosState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadUtxosStateEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadUtxos loadUtxos) data,
    required TResult Function(String errorMsg) error,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadUtxos loadUtxos)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadUtxos loadUtxos)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUtxosStateEmpty value) empty,
    required TResult Function(LoadUtxosStateLoading value) loading,
    required TResult Function(LoadUtxosStateData value) data,
    required TResult Function(LoadUtxosStateError value) error,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUtxosStateEmpty value)? empty,
    TResult? Function(LoadUtxosStateLoading value)? loading,
    TResult? Function(LoadUtxosStateData value)? data,
    TResult? Function(LoadUtxosStateError value)? error,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUtxosStateEmpty value)? empty,
    TResult Function(LoadUtxosStateLoading value)? loading,
    TResult Function(LoadUtxosStateData value)? data,
    TResult Function(LoadUtxosStateError value)? error,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class LoadUtxosStateEmpty implements LoadUtxosState {
  const factory LoadUtxosStateEmpty() = _$LoadUtxosStateEmptyImpl;
}

/// @nodoc
abstract class _$$LoadUtxosStateLoadingImplCopyWith<$Res> {
  factory _$$LoadUtxosStateLoadingImplCopyWith(
          _$LoadUtxosStateLoadingImpl value,
          $Res Function(_$LoadUtxosStateLoadingImpl) then) =
      __$$LoadUtxosStateLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadUtxosStateLoadingImplCopyWithImpl<$Res>
    extends _$LoadUtxosStateCopyWithImpl<$Res, _$LoadUtxosStateLoadingImpl>
    implements _$$LoadUtxosStateLoadingImplCopyWith<$Res> {
  __$$LoadUtxosStateLoadingImplCopyWithImpl(_$LoadUtxosStateLoadingImpl _value,
      $Res Function(_$LoadUtxosStateLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadUtxosStateLoadingImpl implements LoadUtxosStateLoading {
  const _$LoadUtxosStateLoadingImpl();

  @override
  String toString() {
    return 'LoadUtxosState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadUtxosStateLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadUtxos loadUtxos) data,
    required TResult Function(String errorMsg) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadUtxos loadUtxos)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadUtxos loadUtxos)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUtxosStateEmpty value) empty,
    required TResult Function(LoadUtxosStateLoading value) loading,
    required TResult Function(LoadUtxosStateData value) data,
    required TResult Function(LoadUtxosStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUtxosStateEmpty value)? empty,
    TResult? Function(LoadUtxosStateLoading value)? loading,
    TResult? Function(LoadUtxosStateData value)? data,
    TResult? Function(LoadUtxosStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUtxosStateEmpty value)? empty,
    TResult Function(LoadUtxosStateLoading value)? loading,
    TResult Function(LoadUtxosStateData value)? data,
    TResult Function(LoadUtxosStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoadUtxosStateLoading implements LoadUtxosState {
  const factory LoadUtxosStateLoading() = _$LoadUtxosStateLoadingImpl;
}

/// @nodoc
abstract class _$$LoadUtxosStateDataImplCopyWith<$Res> {
  factory _$$LoadUtxosStateDataImplCopyWith(_$LoadUtxosStateDataImpl value,
          $Res Function(_$LoadUtxosStateDataImpl) then) =
      __$$LoadUtxosStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({From_LoadUtxos loadUtxos});
}

/// @nodoc
class __$$LoadUtxosStateDataImplCopyWithImpl<$Res>
    extends _$LoadUtxosStateCopyWithImpl<$Res, _$LoadUtxosStateDataImpl>
    implements _$$LoadUtxosStateDataImplCopyWith<$Res> {
  __$$LoadUtxosStateDataImplCopyWithImpl(_$LoadUtxosStateDataImpl _value,
      $Res Function(_$LoadUtxosStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadUtxos = null,
  }) {
    return _then(_$LoadUtxosStateDataImpl(
      null == loadUtxos
          ? _value.loadUtxos
          : loadUtxos // ignore: cast_nullable_to_non_nullable
              as From_LoadUtxos,
    ));
  }
}

/// @nodoc

class _$LoadUtxosStateDataImpl implements LoadUtxosStateData {
  const _$LoadUtxosStateDataImpl(this.loadUtxos);

  @override
  final From_LoadUtxos loadUtxos;

  @override
  String toString() {
    return 'LoadUtxosState.data(loadUtxos: $loadUtxos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadUtxosStateDataImpl &&
            (identical(other.loadUtxos, loadUtxos) ||
                other.loadUtxos == loadUtxos));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadUtxos);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadUtxosStateDataImplCopyWith<_$LoadUtxosStateDataImpl> get copyWith =>
      __$$LoadUtxosStateDataImplCopyWithImpl<_$LoadUtxosStateDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadUtxos loadUtxos) data,
    required TResult Function(String errorMsg) error,
  }) {
    return data(loadUtxos);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadUtxos loadUtxos)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return data?.call(loadUtxos);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadUtxos loadUtxos)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(loadUtxos);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUtxosStateEmpty value) empty,
    required TResult Function(LoadUtxosStateLoading value) loading,
    required TResult Function(LoadUtxosStateData value) data,
    required TResult Function(LoadUtxosStateError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUtxosStateEmpty value)? empty,
    TResult? Function(LoadUtxosStateLoading value)? loading,
    TResult? Function(LoadUtxosStateData value)? data,
    TResult? Function(LoadUtxosStateError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUtxosStateEmpty value)? empty,
    TResult Function(LoadUtxosStateLoading value)? loading,
    TResult Function(LoadUtxosStateData value)? data,
    TResult Function(LoadUtxosStateError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class LoadUtxosStateData implements LoadUtxosState {
  const factory LoadUtxosStateData(final From_LoadUtxos loadUtxos) =
      _$LoadUtxosStateDataImpl;

  From_LoadUtxos get loadUtxos;
  @JsonKey(ignore: true)
  _$$LoadUtxosStateDataImplCopyWith<_$LoadUtxosStateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadUtxosStateErrorImplCopyWith<$Res> {
  factory _$$LoadUtxosStateErrorImplCopyWith(_$LoadUtxosStateErrorImpl value,
          $Res Function(_$LoadUtxosStateErrorImpl) then) =
      __$$LoadUtxosStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMsg});
}

/// @nodoc
class __$$LoadUtxosStateErrorImplCopyWithImpl<$Res>
    extends _$LoadUtxosStateCopyWithImpl<$Res, _$LoadUtxosStateErrorImpl>
    implements _$$LoadUtxosStateErrorImplCopyWith<$Res> {
  __$$LoadUtxosStateErrorImplCopyWithImpl(_$LoadUtxosStateErrorImpl _value,
      $Res Function(_$LoadUtxosStateErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMsg = null,
  }) {
    return _then(_$LoadUtxosStateErrorImpl(
      null == errorMsg
          ? _value.errorMsg
          : errorMsg // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadUtxosStateErrorImpl implements LoadUtxosStateError {
  const _$LoadUtxosStateErrorImpl(this.errorMsg);

  @override
  final String errorMsg;

  @override
  String toString() {
    return 'LoadUtxosState.error(errorMsg: $errorMsg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadUtxosStateErrorImpl &&
            (identical(other.errorMsg, errorMsg) ||
                other.errorMsg == errorMsg));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMsg);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadUtxosStateErrorImplCopyWith<_$LoadUtxosStateErrorImpl> get copyWith =>
      __$$LoadUtxosStateErrorImplCopyWithImpl<_$LoadUtxosStateErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() loading,
    required TResult Function(From_LoadUtxos loadUtxos) data,
    required TResult Function(String errorMsg) error,
  }) {
    return error(errorMsg);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? loading,
    TResult? Function(From_LoadUtxos loadUtxos)? data,
    TResult? Function(String errorMsg)? error,
  }) {
    return error?.call(errorMsg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? loading,
    TResult Function(From_LoadUtxos loadUtxos)? data,
    TResult Function(String errorMsg)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMsg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadUtxosStateEmpty value) empty,
    required TResult Function(LoadUtxosStateLoading value) loading,
    required TResult Function(LoadUtxosStateData value) data,
    required TResult Function(LoadUtxosStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadUtxosStateEmpty value)? empty,
    TResult? Function(LoadUtxosStateLoading value)? loading,
    TResult? Function(LoadUtxosStateData value)? data,
    TResult? Function(LoadUtxosStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadUtxosStateEmpty value)? empty,
    TResult Function(LoadUtxosStateLoading value)? loading,
    TResult Function(LoadUtxosStateData value)? data,
    TResult Function(LoadUtxosStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LoadUtxosStateError implements LoadUtxosState {
  const factory LoadUtxosStateError(final String errorMsg) =
      _$LoadUtxosStateErrorImpl;

  String get errorMsg;
  @JsonKey(ignore: true)
  _$$LoadUtxosStateErrorImplCopyWith<_$LoadUtxosStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AddressDetailsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(AddressesItem addressesItem) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(AddressesItem addressesItem)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(AddressesItem addressesItem)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressDetailsStateEmpty value) empty,
    required TResult Function(AddressDetailsStateData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressDetailsStateEmpty value)? empty,
    TResult? Function(AddressDetailsStateData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressDetailsStateEmpty value)? empty,
    TResult Function(AddressDetailsStateData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressDetailsStateCopyWith<$Res> {
  factory $AddressDetailsStateCopyWith(
          AddressDetailsState value, $Res Function(AddressDetailsState) then) =
      _$AddressDetailsStateCopyWithImpl<$Res, AddressDetailsState>;
}

/// @nodoc
class _$AddressDetailsStateCopyWithImpl<$Res, $Val extends AddressDetailsState>
    implements $AddressDetailsStateCopyWith<$Res> {
  _$AddressDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AddressDetailsStateEmptyImplCopyWith<$Res> {
  factory _$$AddressDetailsStateEmptyImplCopyWith(
          _$AddressDetailsStateEmptyImpl value,
          $Res Function(_$AddressDetailsStateEmptyImpl) then) =
      __$$AddressDetailsStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressDetailsStateEmptyImplCopyWithImpl<$Res>
    extends _$AddressDetailsStateCopyWithImpl<$Res,
        _$AddressDetailsStateEmptyImpl>
    implements _$$AddressDetailsStateEmptyImplCopyWith<$Res> {
  __$$AddressDetailsStateEmptyImplCopyWithImpl(
      _$AddressDetailsStateEmptyImpl _value,
      $Res Function(_$AddressDetailsStateEmptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressDetailsStateEmptyImpl implements AddressDetailsStateEmpty {
  const _$AddressDetailsStateEmptyImpl();

  @override
  String toString() {
    return 'AddressDetailsState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressDetailsStateEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(AddressesItem addressesItem) data,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(AddressesItem addressesItem)? data,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(AddressesItem addressesItem)? data,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressDetailsStateEmpty value) empty,
    required TResult Function(AddressDetailsStateData value) data,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressDetailsStateEmpty value)? empty,
    TResult? Function(AddressDetailsStateData value)? data,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressDetailsStateEmpty value)? empty,
    TResult Function(AddressDetailsStateData value)? data,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class AddressDetailsStateEmpty implements AddressDetailsState {
  const factory AddressDetailsStateEmpty() = _$AddressDetailsStateEmptyImpl;
}

/// @nodoc
abstract class _$$AddressDetailsStateDataImplCopyWith<$Res> {
  factory _$$AddressDetailsStateDataImplCopyWith(
          _$AddressDetailsStateDataImpl value,
          $Res Function(_$AddressDetailsStateDataImpl) then) =
      __$$AddressDetailsStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AddressesItem addressesItem});

  $AddressesItemCopyWith<$Res> get addressesItem;
}

/// @nodoc
class __$$AddressDetailsStateDataImplCopyWithImpl<$Res>
    extends _$AddressDetailsStateCopyWithImpl<$Res,
        _$AddressDetailsStateDataImpl>
    implements _$$AddressDetailsStateDataImplCopyWith<$Res> {
  __$$AddressDetailsStateDataImplCopyWithImpl(
      _$AddressDetailsStateDataImpl _value,
      $Res Function(_$AddressDetailsStateDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressesItem = null,
  }) {
    return _then(_$AddressDetailsStateDataImpl(
      null == addressesItem
          ? _value.addressesItem
          : addressesItem // ignore: cast_nullable_to_non_nullable
              as AddressesItem,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressesItemCopyWith<$Res> get addressesItem {
    return $AddressesItemCopyWith<$Res>(_value.addressesItem, (value) {
      return _then(_value.copyWith(addressesItem: value));
    });
  }
}

/// @nodoc

class _$AddressDetailsStateDataImpl implements AddressDetailsStateData {
  const _$AddressDetailsStateDataImpl(this.addressesItem);

  @override
  final AddressesItem addressesItem;

  @override
  String toString() {
    return 'AddressDetailsState.data(addressesItem: $addressesItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressDetailsStateDataImpl &&
            (identical(other.addressesItem, addressesItem) ||
                other.addressesItem == addressesItem));
  }

  @override
  int get hashCode => Object.hash(runtimeType, addressesItem);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressDetailsStateDataImplCopyWith<_$AddressDetailsStateDataImpl>
      get copyWith => __$$AddressDetailsStateDataImplCopyWithImpl<
          _$AddressDetailsStateDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(AddressesItem addressesItem) data,
  }) {
    return data(addressesItem);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(AddressesItem addressesItem)? data,
  }) {
    return data?.call(addressesItem);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(AddressesItem addressesItem)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(addressesItem);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressDetailsStateEmpty value) empty,
    required TResult Function(AddressDetailsStateData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressDetailsStateEmpty value)? empty,
    TResult? Function(AddressDetailsStateData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressDetailsStateEmpty value)? empty,
    TResult Function(AddressDetailsStateData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class AddressDetailsStateData implements AddressDetailsState {
  const factory AddressDetailsStateData(final AddressesItem addressesItem) =
      _$AddressDetailsStateDataImpl;

  AddressesItem get addressesItem;
  @JsonKey(ignore: true)
  _$$AddressDetailsStateDataImplCopyWith<_$AddressDetailsStateDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AddressesWalletTypeFlag {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() regular,
    required TResult Function() amp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? regular,
    TResult? Function()? amp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? regular,
    TResult Function()? amp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesWalletTypeFlagAll value) all,
    required TResult Function(AddressesWalletTypeFlagRegular value) regular,
    required TResult Function(AddressesWalletTypeFlagAmp value) amp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesWalletTypeFlagAll value)? all,
    TResult? Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult? Function(AddressesWalletTypeFlagAmp value)? amp,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesWalletTypeFlagAll value)? all,
    TResult Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult Function(AddressesWalletTypeFlagAmp value)? amp,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressesWalletTypeFlagCopyWith<$Res> {
  factory $AddressesWalletTypeFlagCopyWith(AddressesWalletTypeFlag value,
          $Res Function(AddressesWalletTypeFlag) then) =
      _$AddressesWalletTypeFlagCopyWithImpl<$Res, AddressesWalletTypeFlag>;
}

/// @nodoc
class _$AddressesWalletTypeFlagCopyWithImpl<$Res,
        $Val extends AddressesWalletTypeFlag>
    implements $AddressesWalletTypeFlagCopyWith<$Res> {
  _$AddressesWalletTypeFlagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AddressesWalletTypeFlagAllImplCopyWith<$Res> {
  factory _$$AddressesWalletTypeFlagAllImplCopyWith(
          _$AddressesWalletTypeFlagAllImpl value,
          $Res Function(_$AddressesWalletTypeFlagAllImpl) then) =
      __$$AddressesWalletTypeFlagAllImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesWalletTypeFlagAllImplCopyWithImpl<$Res>
    extends _$AddressesWalletTypeFlagCopyWithImpl<$Res,
        _$AddressesWalletTypeFlagAllImpl>
    implements _$$AddressesWalletTypeFlagAllImplCopyWith<$Res> {
  __$$AddressesWalletTypeFlagAllImplCopyWithImpl(
      _$AddressesWalletTypeFlagAllImpl _value,
      $Res Function(_$AddressesWalletTypeFlagAllImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesWalletTypeFlagAllImpl implements AddressesWalletTypeFlagAll {
  const _$AddressesWalletTypeFlagAllImpl();

  @override
  String toString() {
    return 'AddressesWalletTypeFlag.all()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesWalletTypeFlagAllImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() regular,
    required TResult Function() amp,
  }) {
    return all();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? regular,
    TResult? Function()? amp,
  }) {
    return all?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? regular,
    TResult Function()? amp,
    required TResult orElse(),
  }) {
    if (all != null) {
      return all();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesWalletTypeFlagAll value) all,
    required TResult Function(AddressesWalletTypeFlagRegular value) regular,
    required TResult Function(AddressesWalletTypeFlagAmp value) amp,
  }) {
    return all(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesWalletTypeFlagAll value)? all,
    TResult? Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult? Function(AddressesWalletTypeFlagAmp value)? amp,
  }) {
    return all?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesWalletTypeFlagAll value)? all,
    TResult Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult Function(AddressesWalletTypeFlagAmp value)? amp,
    required TResult orElse(),
  }) {
    if (all != null) {
      return all(this);
    }
    return orElse();
  }
}

abstract class AddressesWalletTypeFlagAll implements AddressesWalletTypeFlag {
  const factory AddressesWalletTypeFlagAll() = _$AddressesWalletTypeFlagAllImpl;
}

/// @nodoc
abstract class _$$AddressesWalletTypeFlagRegularImplCopyWith<$Res> {
  factory _$$AddressesWalletTypeFlagRegularImplCopyWith(
          _$AddressesWalletTypeFlagRegularImpl value,
          $Res Function(_$AddressesWalletTypeFlagRegularImpl) then) =
      __$$AddressesWalletTypeFlagRegularImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesWalletTypeFlagRegularImplCopyWithImpl<$Res>
    extends _$AddressesWalletTypeFlagCopyWithImpl<$Res,
        _$AddressesWalletTypeFlagRegularImpl>
    implements _$$AddressesWalletTypeFlagRegularImplCopyWith<$Res> {
  __$$AddressesWalletTypeFlagRegularImplCopyWithImpl(
      _$AddressesWalletTypeFlagRegularImpl _value,
      $Res Function(_$AddressesWalletTypeFlagRegularImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesWalletTypeFlagRegularImpl
    implements AddressesWalletTypeFlagRegular {
  const _$AddressesWalletTypeFlagRegularImpl();

  @override
  String toString() {
    return 'AddressesWalletTypeFlag.regular()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesWalletTypeFlagRegularImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() regular,
    required TResult Function() amp,
  }) {
    return regular();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? regular,
    TResult? Function()? amp,
  }) {
    return regular?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? regular,
    TResult Function()? amp,
    required TResult orElse(),
  }) {
    if (regular != null) {
      return regular();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesWalletTypeFlagAll value) all,
    required TResult Function(AddressesWalletTypeFlagRegular value) regular,
    required TResult Function(AddressesWalletTypeFlagAmp value) amp,
  }) {
    return regular(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesWalletTypeFlagAll value)? all,
    TResult? Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult? Function(AddressesWalletTypeFlagAmp value)? amp,
  }) {
    return regular?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesWalletTypeFlagAll value)? all,
    TResult Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult Function(AddressesWalletTypeFlagAmp value)? amp,
    required TResult orElse(),
  }) {
    if (regular != null) {
      return regular(this);
    }
    return orElse();
  }
}

abstract class AddressesWalletTypeFlagRegular
    implements AddressesWalletTypeFlag {
  const factory AddressesWalletTypeFlagRegular() =
      _$AddressesWalletTypeFlagRegularImpl;
}

/// @nodoc
abstract class _$$AddressesWalletTypeFlagAmpImplCopyWith<$Res> {
  factory _$$AddressesWalletTypeFlagAmpImplCopyWith(
          _$AddressesWalletTypeFlagAmpImpl value,
          $Res Function(_$AddressesWalletTypeFlagAmpImpl) then) =
      __$$AddressesWalletTypeFlagAmpImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesWalletTypeFlagAmpImplCopyWithImpl<$Res>
    extends _$AddressesWalletTypeFlagCopyWithImpl<$Res,
        _$AddressesWalletTypeFlagAmpImpl>
    implements _$$AddressesWalletTypeFlagAmpImplCopyWith<$Res> {
  __$$AddressesWalletTypeFlagAmpImplCopyWithImpl(
      _$AddressesWalletTypeFlagAmpImpl _value,
      $Res Function(_$AddressesWalletTypeFlagAmpImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesWalletTypeFlagAmpImpl implements AddressesWalletTypeFlagAmp {
  const _$AddressesWalletTypeFlagAmpImpl();

  @override
  String toString() {
    return 'AddressesWalletTypeFlag.amp()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesWalletTypeFlagAmpImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() regular,
    required TResult Function() amp,
  }) {
    return amp();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? regular,
    TResult? Function()? amp,
  }) {
    return amp?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? regular,
    TResult Function()? amp,
    required TResult orElse(),
  }) {
    if (amp != null) {
      return amp();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesWalletTypeFlagAll value) all,
    required TResult Function(AddressesWalletTypeFlagRegular value) regular,
    required TResult Function(AddressesWalletTypeFlagAmp value) amp,
  }) {
    return amp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesWalletTypeFlagAll value)? all,
    TResult? Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult? Function(AddressesWalletTypeFlagAmp value)? amp,
  }) {
    return amp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesWalletTypeFlagAll value)? all,
    TResult Function(AddressesWalletTypeFlagRegular value)? regular,
    TResult Function(AddressesWalletTypeFlagAmp value)? amp,
    required TResult orElse(),
  }) {
    if (amp != null) {
      return amp(this);
    }
    return orElse();
  }
}

abstract class AddressesWalletTypeFlagAmp implements AddressesWalletTypeFlag {
  const factory AddressesWalletTypeFlagAmp() = _$AddressesWalletTypeFlagAmpImpl;
}

/// @nodoc
mixin _$AddressesAddressTypeFlag {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() internal,
    required TResult Function() external,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? internal,
    TResult? Function()? external,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? internal,
    TResult Function()? external,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesAddressTypeFlagAll value) all,
    required TResult Function(AddressesAddressTypeFlagInternal value) internal,
    required TResult Function(AddressesAddressTypeFlagExternal value) external,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesAddressTypeFlagAll value)? all,
    TResult? Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult? Function(AddressesAddressTypeFlagExternal value)? external,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesAddressTypeFlagAll value)? all,
    TResult Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult Function(AddressesAddressTypeFlagExternal value)? external,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressesAddressTypeFlagCopyWith<$Res> {
  factory $AddressesAddressTypeFlagCopyWith(AddressesAddressTypeFlag value,
          $Res Function(AddressesAddressTypeFlag) then) =
      _$AddressesAddressTypeFlagCopyWithImpl<$Res, AddressesAddressTypeFlag>;
}

/// @nodoc
class _$AddressesAddressTypeFlagCopyWithImpl<$Res,
        $Val extends AddressesAddressTypeFlag>
    implements $AddressesAddressTypeFlagCopyWith<$Res> {
  _$AddressesAddressTypeFlagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AddressesAddressTypeFlagAllImplCopyWith<$Res> {
  factory _$$AddressesAddressTypeFlagAllImplCopyWith(
          _$AddressesAddressTypeFlagAllImpl value,
          $Res Function(_$AddressesAddressTypeFlagAllImpl) then) =
      __$$AddressesAddressTypeFlagAllImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesAddressTypeFlagAllImplCopyWithImpl<$Res>
    extends _$AddressesAddressTypeFlagCopyWithImpl<$Res,
        _$AddressesAddressTypeFlagAllImpl>
    implements _$$AddressesAddressTypeFlagAllImplCopyWith<$Res> {
  __$$AddressesAddressTypeFlagAllImplCopyWithImpl(
      _$AddressesAddressTypeFlagAllImpl _value,
      $Res Function(_$AddressesAddressTypeFlagAllImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesAddressTypeFlagAllImpl implements AddressesAddressTypeFlagAll {
  const _$AddressesAddressTypeFlagAllImpl();

  @override
  String toString() {
    return 'AddressesAddressTypeFlag.all()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesAddressTypeFlagAllImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() internal,
    required TResult Function() external,
  }) {
    return all();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? internal,
    TResult? Function()? external,
  }) {
    return all?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? internal,
    TResult Function()? external,
    required TResult orElse(),
  }) {
    if (all != null) {
      return all();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesAddressTypeFlagAll value) all,
    required TResult Function(AddressesAddressTypeFlagInternal value) internal,
    required TResult Function(AddressesAddressTypeFlagExternal value) external,
  }) {
    return all(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesAddressTypeFlagAll value)? all,
    TResult? Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult? Function(AddressesAddressTypeFlagExternal value)? external,
  }) {
    return all?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesAddressTypeFlagAll value)? all,
    TResult Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult Function(AddressesAddressTypeFlagExternal value)? external,
    required TResult orElse(),
  }) {
    if (all != null) {
      return all(this);
    }
    return orElse();
  }
}

abstract class AddressesAddressTypeFlagAll implements AddressesAddressTypeFlag {
  const factory AddressesAddressTypeFlagAll() =
      _$AddressesAddressTypeFlagAllImpl;
}

/// @nodoc
abstract class _$$AddressesAddressTypeFlagInternalImplCopyWith<$Res> {
  factory _$$AddressesAddressTypeFlagInternalImplCopyWith(
          _$AddressesAddressTypeFlagInternalImpl value,
          $Res Function(_$AddressesAddressTypeFlagInternalImpl) then) =
      __$$AddressesAddressTypeFlagInternalImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesAddressTypeFlagInternalImplCopyWithImpl<$Res>
    extends _$AddressesAddressTypeFlagCopyWithImpl<$Res,
        _$AddressesAddressTypeFlagInternalImpl>
    implements _$$AddressesAddressTypeFlagInternalImplCopyWith<$Res> {
  __$$AddressesAddressTypeFlagInternalImplCopyWithImpl(
      _$AddressesAddressTypeFlagInternalImpl _value,
      $Res Function(_$AddressesAddressTypeFlagInternalImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesAddressTypeFlagInternalImpl
    implements AddressesAddressTypeFlagInternal {
  const _$AddressesAddressTypeFlagInternalImpl();

  @override
  String toString() {
    return 'AddressesAddressTypeFlag.internal()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesAddressTypeFlagInternalImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() internal,
    required TResult Function() external,
  }) {
    return internal();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? internal,
    TResult? Function()? external,
  }) {
    return internal?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? internal,
    TResult Function()? external,
    required TResult orElse(),
  }) {
    if (internal != null) {
      return internal();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesAddressTypeFlagAll value) all,
    required TResult Function(AddressesAddressTypeFlagInternal value) internal,
    required TResult Function(AddressesAddressTypeFlagExternal value) external,
  }) {
    return internal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesAddressTypeFlagAll value)? all,
    TResult? Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult? Function(AddressesAddressTypeFlagExternal value)? external,
  }) {
    return internal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesAddressTypeFlagAll value)? all,
    TResult Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult Function(AddressesAddressTypeFlagExternal value)? external,
    required TResult orElse(),
  }) {
    if (internal != null) {
      return internal(this);
    }
    return orElse();
  }
}

abstract class AddressesAddressTypeFlagInternal
    implements AddressesAddressTypeFlag {
  const factory AddressesAddressTypeFlagInternal() =
      _$AddressesAddressTypeFlagInternalImpl;
}

/// @nodoc
abstract class _$$AddressesAddressTypeFlagExternalImplCopyWith<$Res> {
  factory _$$AddressesAddressTypeFlagExternalImplCopyWith(
          _$AddressesAddressTypeFlagExternalImpl value,
          $Res Function(_$AddressesAddressTypeFlagExternalImpl) then) =
      __$$AddressesAddressTypeFlagExternalImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesAddressTypeFlagExternalImplCopyWithImpl<$Res>
    extends _$AddressesAddressTypeFlagCopyWithImpl<$Res,
        _$AddressesAddressTypeFlagExternalImpl>
    implements _$$AddressesAddressTypeFlagExternalImplCopyWith<$Res> {
  __$$AddressesAddressTypeFlagExternalImplCopyWithImpl(
      _$AddressesAddressTypeFlagExternalImpl _value,
      $Res Function(_$AddressesAddressTypeFlagExternalImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesAddressTypeFlagExternalImpl
    implements AddressesAddressTypeFlagExternal {
  const _$AddressesAddressTypeFlagExternalImpl();

  @override
  String toString() {
    return 'AddressesAddressTypeFlag.external()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesAddressTypeFlagExternalImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() all,
    required TResult Function() internal,
    required TResult Function() external,
  }) {
    return external();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? all,
    TResult? Function()? internal,
    TResult? Function()? external,
  }) {
    return external?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? all,
    TResult Function()? internal,
    TResult Function()? external,
    required TResult orElse(),
  }) {
    if (external != null) {
      return external();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesAddressTypeFlagAll value) all,
    required TResult Function(AddressesAddressTypeFlagInternal value) internal,
    required TResult Function(AddressesAddressTypeFlagExternal value) external,
  }) {
    return external(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesAddressTypeFlagAll value)? all,
    TResult? Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult? Function(AddressesAddressTypeFlagExternal value)? external,
  }) {
    return external?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesAddressTypeFlagAll value)? all,
    TResult Function(AddressesAddressTypeFlagInternal value)? internal,
    TResult Function(AddressesAddressTypeFlagExternal value)? external,
    required TResult orElse(),
  }) {
    if (external != null) {
      return external(this);
    }
    return orElse();
  }
}

abstract class AddressesAddressTypeFlagExternal
    implements AddressesAddressTypeFlag {
  const factory AddressesAddressTypeFlagExternal() =
      _$AddressesAddressTypeFlagExternalImpl;
}

/// @nodoc
mixin _$AddressesBalanceFlag {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() showAll,
    required TResult Function() hideEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? showAll,
    TResult? Function()? hideEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? showAll,
    TResult Function()? hideEmpty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesBalanceFlagShowAll value) showAll,
    required TResult Function(AddressesBalanceFlagHideEmpty value) hideEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesBalanceFlagShowAll value)? showAll,
    TResult? Function(AddressesBalanceFlagHideEmpty value)? hideEmpty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesBalanceFlagShowAll value)? showAll,
    TResult Function(AddressesBalanceFlagHideEmpty value)? hideEmpty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressesBalanceFlagCopyWith<$Res> {
  factory $AddressesBalanceFlagCopyWith(AddressesBalanceFlag value,
          $Res Function(AddressesBalanceFlag) then) =
      _$AddressesBalanceFlagCopyWithImpl<$Res, AddressesBalanceFlag>;
}

/// @nodoc
class _$AddressesBalanceFlagCopyWithImpl<$Res,
        $Val extends AddressesBalanceFlag>
    implements $AddressesBalanceFlagCopyWith<$Res> {
  _$AddressesBalanceFlagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AddressesBalanceFlagShowAllImplCopyWith<$Res> {
  factory _$$AddressesBalanceFlagShowAllImplCopyWith(
          _$AddressesBalanceFlagShowAllImpl value,
          $Res Function(_$AddressesBalanceFlagShowAllImpl) then) =
      __$$AddressesBalanceFlagShowAllImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesBalanceFlagShowAllImplCopyWithImpl<$Res>
    extends _$AddressesBalanceFlagCopyWithImpl<$Res,
        _$AddressesBalanceFlagShowAllImpl>
    implements _$$AddressesBalanceFlagShowAllImplCopyWith<$Res> {
  __$$AddressesBalanceFlagShowAllImplCopyWithImpl(
      _$AddressesBalanceFlagShowAllImpl _value,
      $Res Function(_$AddressesBalanceFlagShowAllImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesBalanceFlagShowAllImpl implements AddressesBalanceFlagShowAll {
  const _$AddressesBalanceFlagShowAllImpl();

  @override
  String toString() {
    return 'AddressesBalanceFlag.showAll()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesBalanceFlagShowAllImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() showAll,
    required TResult Function() hideEmpty,
  }) {
    return showAll();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? showAll,
    TResult? Function()? hideEmpty,
  }) {
    return showAll?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? showAll,
    TResult Function()? hideEmpty,
    required TResult orElse(),
  }) {
    if (showAll != null) {
      return showAll();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesBalanceFlagShowAll value) showAll,
    required TResult Function(AddressesBalanceFlagHideEmpty value) hideEmpty,
  }) {
    return showAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesBalanceFlagShowAll value)? showAll,
    TResult? Function(AddressesBalanceFlagHideEmpty value)? hideEmpty,
  }) {
    return showAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesBalanceFlagShowAll value)? showAll,
    TResult Function(AddressesBalanceFlagHideEmpty value)? hideEmpty,
    required TResult orElse(),
  }) {
    if (showAll != null) {
      return showAll(this);
    }
    return orElse();
  }
}

abstract class AddressesBalanceFlagShowAll implements AddressesBalanceFlag {
  const factory AddressesBalanceFlagShowAll() =
      _$AddressesBalanceFlagShowAllImpl;
}

/// @nodoc
abstract class _$$AddressesBalanceFlagHideEmptyImplCopyWith<$Res> {
  factory _$$AddressesBalanceFlagHideEmptyImplCopyWith(
          _$AddressesBalanceFlagHideEmptyImpl value,
          $Res Function(_$AddressesBalanceFlagHideEmptyImpl) then) =
      __$$AddressesBalanceFlagHideEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressesBalanceFlagHideEmptyImplCopyWithImpl<$Res>
    extends _$AddressesBalanceFlagCopyWithImpl<$Res,
        _$AddressesBalanceFlagHideEmptyImpl>
    implements _$$AddressesBalanceFlagHideEmptyImplCopyWith<$Res> {
  __$$AddressesBalanceFlagHideEmptyImplCopyWithImpl(
      _$AddressesBalanceFlagHideEmptyImpl _value,
      $Res Function(_$AddressesBalanceFlagHideEmptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AddressesBalanceFlagHideEmptyImpl
    implements AddressesBalanceFlagHideEmpty {
  const _$AddressesBalanceFlagHideEmptyImpl();

  @override
  String toString() {
    return 'AddressesBalanceFlag.hideEmpty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressesBalanceFlagHideEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() showAll,
    required TResult Function() hideEmpty,
  }) {
    return hideEmpty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? showAll,
    TResult? Function()? hideEmpty,
  }) {
    return hideEmpty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? showAll,
    TResult Function()? hideEmpty,
    required TResult orElse(),
  }) {
    if (hideEmpty != null) {
      return hideEmpty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressesBalanceFlagShowAll value) showAll,
    required TResult Function(AddressesBalanceFlagHideEmpty value) hideEmpty,
  }) {
    return hideEmpty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressesBalanceFlagShowAll value)? showAll,
    TResult? Function(AddressesBalanceFlagHideEmpty value)? hideEmpty,
  }) {
    return hideEmpty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressesBalanceFlagShowAll value)? showAll,
    TResult Function(AddressesBalanceFlagHideEmpty value)? hideEmpty,
    required TResult orElse(),
  }) {
    if (hideEmpty != null) {
      return hideEmpty(this);
    }
    return orElse();
  }
}

abstract class AddressesBalanceFlagHideEmpty implements AddressesBalanceFlag {
  const factory AddressesBalanceFlagHideEmpty() =
      _$AddressesBalanceFlagHideEmptyImpl;
}

/// @nodoc
mixin _$InputListItemExpandedState {
  int? get hash => throw _privateConstructorUsedError;
  bool get expanded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InputListItemExpandedStateCopyWith<InputListItemExpandedState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InputListItemExpandedStateCopyWith<$Res> {
  factory $InputListItemExpandedStateCopyWith(InputListItemExpandedState value,
          $Res Function(InputListItemExpandedState) then) =
      _$InputListItemExpandedStateCopyWithImpl<$Res,
          InputListItemExpandedState>;
  @useResult
  $Res call({int? hash, bool expanded});
}

/// @nodoc
class _$InputListItemExpandedStateCopyWithImpl<$Res,
        $Val extends InputListItemExpandedState>
    implements $InputListItemExpandedStateCopyWith<$Res> {
  _$InputListItemExpandedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hash = freezed,
    Object? expanded = null,
  }) {
    return _then(_value.copyWith(
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as int?,
      expanded: null == expanded
          ? _value.expanded
          : expanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InputListItemExpandedStateImplCopyWith<$Res>
    implements $InputListItemExpandedStateCopyWith<$Res> {
  factory _$$InputListItemExpandedStateImplCopyWith(
          _$InputListItemExpandedStateImpl value,
          $Res Function(_$InputListItemExpandedStateImpl) then) =
      __$$InputListItemExpandedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? hash, bool expanded});
}

/// @nodoc
class __$$InputListItemExpandedStateImplCopyWithImpl<$Res>
    extends _$InputListItemExpandedStateCopyWithImpl<$Res,
        _$InputListItemExpandedStateImpl>
    implements _$$InputListItemExpandedStateImplCopyWith<$Res> {
  __$$InputListItemExpandedStateImplCopyWithImpl(
      _$InputListItemExpandedStateImpl _value,
      $Res Function(_$InputListItemExpandedStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hash = freezed,
    Object? expanded = null,
  }) {
    return _then(_$InputListItemExpandedStateImpl(
      hash: freezed == hash
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as int?,
      expanded: null == expanded
          ? _value.expanded
          : expanded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$InputListItemExpandedStateImpl implements _InputListItemExpandedState {
  const _$InputListItemExpandedStateImpl({this.hash, this.expanded = true});

  @override
  final int? hash;
  @override
  @JsonKey()
  final bool expanded;

  @override
  String toString() {
    return 'InputListItemExpandedState(hash: $hash, expanded: $expanded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputListItemExpandedStateImpl &&
            (identical(other.hash, hash) || other.hash == hash) &&
            (identical(other.expanded, expanded) ||
                other.expanded == expanded));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hash, expanded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InputListItemExpandedStateImplCopyWith<_$InputListItemExpandedStateImpl>
      get copyWith => __$$InputListItemExpandedStateImplCopyWithImpl<
          _$InputListItemExpandedStateImpl>(this, _$identity);
}

abstract class _InputListItemExpandedState
    implements InputListItemExpandedState {
  const factory _InputListItemExpandedState(
      {final int? hash,
      final bool expanded}) = _$InputListItemExpandedStateImpl;

  @override
  int? get hash;
  @override
  bool get expanded;
  @override
  @JsonKey(ignore: true)
  _$$InputListItemExpandedStateImplCopyWith<_$InputListItemExpandedStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
