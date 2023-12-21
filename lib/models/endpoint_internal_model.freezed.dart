// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'endpoint_internal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EICreateTransaction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(
            AccountAsset accountAsset, String address, String amount)
        data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(AccountAsset accountAsset, String address, String amount)?
        data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(AccountAsset accountAsset, String address, String amount)?
        data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EICreateTransactionEmpty value) empty,
    required TResult Function(EICreateTransactionData value) data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EICreateTransactionEmpty value)? empty,
    TResult? Function(EICreateTransactionData value)? data,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EICreateTransactionEmpty value)? empty,
    TResult Function(EICreateTransactionData value)? data,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EICreateTransactionCopyWith<$Res> {
  factory $EICreateTransactionCopyWith(
          EICreateTransaction value, $Res Function(EICreateTransaction) then) =
      _$EICreateTransactionCopyWithImpl<$Res, EICreateTransaction>;
}

/// @nodoc
class _$EICreateTransactionCopyWithImpl<$Res, $Val extends EICreateTransaction>
    implements $EICreateTransactionCopyWith<$Res> {
  _$EICreateTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$EICreateTransactionEmptyImplCopyWith<$Res> {
  factory _$$EICreateTransactionEmptyImplCopyWith(
          _$EICreateTransactionEmptyImpl value,
          $Res Function(_$EICreateTransactionEmptyImpl) then) =
      __$$EICreateTransactionEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EICreateTransactionEmptyImplCopyWithImpl<$Res>
    extends _$EICreateTransactionCopyWithImpl<$Res,
        _$EICreateTransactionEmptyImpl>
    implements _$$EICreateTransactionEmptyImplCopyWith<$Res> {
  __$$EICreateTransactionEmptyImplCopyWithImpl(
      _$EICreateTransactionEmptyImpl _value,
      $Res Function(_$EICreateTransactionEmptyImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$EICreateTransactionEmptyImpl implements EICreateTransactionEmpty {
  _$EICreateTransactionEmptyImpl();

  @override
  String toString() {
    return 'EICreateTransaction.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EICreateTransactionEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(
            AccountAsset accountAsset, String address, String amount)
        data,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(AccountAsset accountAsset, String address, String amount)?
        data,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(AccountAsset accountAsset, String address, String amount)?
        data,
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
    required TResult Function(EICreateTransactionEmpty value) empty,
    required TResult Function(EICreateTransactionData value) data,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EICreateTransactionEmpty value)? empty,
    TResult? Function(EICreateTransactionData value)? data,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EICreateTransactionEmpty value)? empty,
    TResult Function(EICreateTransactionData value)? data,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class EICreateTransactionEmpty implements EICreateTransaction {
  factory EICreateTransactionEmpty() = _$EICreateTransactionEmptyImpl;
}

/// @nodoc
abstract class _$$EICreateTransactionDataImplCopyWith<$Res> {
  factory _$$EICreateTransactionDataImplCopyWith(
          _$EICreateTransactionDataImpl value,
          $Res Function(_$EICreateTransactionDataImpl) then) =
      __$$EICreateTransactionDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AccountAsset accountAsset, String address, String amount});
}

/// @nodoc
class __$$EICreateTransactionDataImplCopyWithImpl<$Res>
    extends _$EICreateTransactionCopyWithImpl<$Res,
        _$EICreateTransactionDataImpl>
    implements _$$EICreateTransactionDataImplCopyWith<$Res> {
  __$$EICreateTransactionDataImplCopyWithImpl(
      _$EICreateTransactionDataImpl _value,
      $Res Function(_$EICreateTransactionDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountAsset = null,
    Object? address = null,
    Object? amount = null,
  }) {
    return _then(_$EICreateTransactionDataImpl(
      accountAsset: null == accountAsset
          ? _value.accountAsset
          : accountAsset // ignore: cast_nullable_to_non_nullable
              as AccountAsset,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EICreateTransactionDataImpl implements EICreateTransactionData {
  _$EICreateTransactionDataImpl(
      {required this.accountAsset,
      required this.address,
      required this.amount});

  @override
  final AccountAsset accountAsset;
  @override
  final String address;
  @override
  final String amount;

  @override
  String toString() {
    return 'EICreateTransaction.data(accountAsset: $accountAsset, address: $address, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EICreateTransactionDataImpl &&
            (identical(other.accountAsset, accountAsset) ||
                other.accountAsset == accountAsset) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, accountAsset, address, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EICreateTransactionDataImplCopyWith<_$EICreateTransactionDataImpl>
      get copyWith => __$$EICreateTransactionDataImplCopyWithImpl<
          _$EICreateTransactionDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(
            AccountAsset accountAsset, String address, String amount)
        data,
  }) {
    return data(accountAsset, address, amount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(AccountAsset accountAsset, String address, String amount)?
        data,
  }) {
    return data?.call(accountAsset, address, amount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(AccountAsset accountAsset, String address, String amount)?
        data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(accountAsset, address, amount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EICreateTransactionEmpty value) empty,
    required TResult Function(EICreateTransactionData value) data,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EICreateTransactionEmpty value)? empty,
    TResult? Function(EICreateTransactionData value)? data,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EICreateTransactionEmpty value)? empty,
    TResult Function(EICreateTransactionData value)? data,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class EICreateTransactionData implements EICreateTransaction {
  factory EICreateTransactionData(
      {required final AccountAsset accountAsset,
      required final String address,
      required final String amount}) = _$EICreateTransactionDataImpl;

  AccountAsset get accountAsset;
  String get address;
  String get amount;
  @JsonKey(ignore: true)
  _$$EICreateTransactionDataImplCopyWith<_$EICreateTransactionDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
