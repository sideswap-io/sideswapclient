// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'amount_to_string_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AmountToStringParameters {
  int get amount => throw _privateConstructorUsedError;
  bool get forceSign => throw _privateConstructorUsedError;
  int get precision => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AmountToStringParametersCopyWith<AmountToStringParameters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmountToStringParametersCopyWith<$Res> {
  factory $AmountToStringParametersCopyWith(AmountToStringParameters value,
          $Res Function(AmountToStringParameters) then) =
      _$AmountToStringParametersCopyWithImpl<$Res, AmountToStringParameters>;
  @useResult
  $Res call({int amount, bool forceSign, int precision});
}

/// @nodoc
class _$AmountToStringParametersCopyWithImpl<$Res,
        $Val extends AmountToStringParameters>
    implements $AmountToStringParametersCopyWith<$Res> {
  _$AmountToStringParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? forceSign = null,
    Object? precision = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      forceSign: null == forceSign
          ? _value.forceSign
          : forceSign // ignore: cast_nullable_to_non_nullable
              as bool,
      precision: null == precision
          ? _value.precision
          : precision // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AmountToStringParametersCopyWith<$Res>
    implements $AmountToStringParametersCopyWith<$Res> {
  factory _$$_AmountToStringParametersCopyWith(
          _$_AmountToStringParameters value,
          $Res Function(_$_AmountToStringParameters) then) =
      __$$_AmountToStringParametersCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int amount, bool forceSign, int precision});
}

/// @nodoc
class __$$_AmountToStringParametersCopyWithImpl<$Res>
    extends _$AmountToStringParametersCopyWithImpl<$Res,
        _$_AmountToStringParameters>
    implements _$$_AmountToStringParametersCopyWith<$Res> {
  __$$_AmountToStringParametersCopyWithImpl(_$_AmountToStringParameters _value,
      $Res Function(_$_AmountToStringParameters) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? forceSign = null,
    Object? precision = null,
  }) {
    return _then(_$_AmountToStringParameters(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      forceSign: null == forceSign
          ? _value.forceSign
          : forceSign // ignore: cast_nullable_to_non_nullable
              as bool,
      precision: null == precision
          ? _value.precision
          : precision // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AmountToStringParameters implements _AmountToStringParameters {
  _$_AmountToStringParameters(
      {required this.amount, this.forceSign = false, this.precision = 8});

  @override
  final int amount;
  @override
  @JsonKey()
  final bool forceSign;
  @override
  @JsonKey()
  final int precision;

  @override
  String toString() {
    return 'AmountToStringParameters(amount: $amount, forceSign: $forceSign, precision: $precision)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AmountToStringParameters &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.forceSign, forceSign) ||
                other.forceSign == forceSign) &&
            (identical(other.precision, precision) ||
                other.precision == precision));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, forceSign, precision);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AmountToStringParametersCopyWith<_$_AmountToStringParameters>
      get copyWith => __$$_AmountToStringParametersCopyWithImpl<
          _$_AmountToStringParameters>(this, _$identity);
}

abstract class _AmountToStringParameters implements AmountToStringParameters {
  factory _AmountToStringParameters(
      {required final int amount,
      final bool forceSign,
      final int precision}) = _$_AmountToStringParameters;

  @override
  int get amount;
  @override
  bool get forceSign;
  @override
  int get precision;
  @override
  @JsonKey(ignore: true)
  _$$_AmountToStringParametersCopyWith<_$_AmountToStringParameters>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AmountToStringNamedParameters {
  int get amount => throw _privateConstructorUsedError;
  String get ticker => throw _privateConstructorUsedError;
  bool get forceSign => throw _privateConstructorUsedError;
  int get precision => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AmountToStringNamedParametersCopyWith<AmountToStringNamedParameters>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AmountToStringNamedParametersCopyWith<$Res> {
  factory $AmountToStringNamedParametersCopyWith(
          AmountToStringNamedParameters value,
          $Res Function(AmountToStringNamedParameters) then) =
      _$AmountToStringNamedParametersCopyWithImpl<$Res,
          AmountToStringNamedParameters>;
  @useResult
  $Res call({int amount, String ticker, bool forceSign, int precision});
}

/// @nodoc
class _$AmountToStringNamedParametersCopyWithImpl<$Res,
        $Val extends AmountToStringNamedParameters>
    implements $AmountToStringNamedParametersCopyWith<$Res> {
  _$AmountToStringNamedParametersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? ticker = null,
    Object? forceSign = null,
    Object? precision = null,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      ticker: null == ticker
          ? _value.ticker
          : ticker // ignore: cast_nullable_to_non_nullable
              as String,
      forceSign: null == forceSign
          ? _value.forceSign
          : forceSign // ignore: cast_nullable_to_non_nullable
              as bool,
      precision: null == precision
          ? _value.precision
          : precision // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AmountToStringNamedParametersCopyWith<$Res>
    implements $AmountToStringNamedParametersCopyWith<$Res> {
  factory _$$_AmountToStringNamedParametersCopyWith(
          _$_AmountToStringNamedParameters value,
          $Res Function(_$_AmountToStringNamedParameters) then) =
      __$$_AmountToStringNamedParametersCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int amount, String ticker, bool forceSign, int precision});
}

/// @nodoc
class __$$_AmountToStringNamedParametersCopyWithImpl<$Res>
    extends _$AmountToStringNamedParametersCopyWithImpl<$Res,
        _$_AmountToStringNamedParameters>
    implements _$$_AmountToStringNamedParametersCopyWith<$Res> {
  __$$_AmountToStringNamedParametersCopyWithImpl(
      _$_AmountToStringNamedParameters _value,
      $Res Function(_$_AmountToStringNamedParameters) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? ticker = null,
    Object? forceSign = null,
    Object? precision = null,
  }) {
    return _then(_$_AmountToStringNamedParameters(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      ticker: null == ticker
          ? _value.ticker
          : ticker // ignore: cast_nullable_to_non_nullable
              as String,
      forceSign: null == forceSign
          ? _value.forceSign
          : forceSign // ignore: cast_nullable_to_non_nullable
              as bool,
      precision: null == precision
          ? _value.precision
          : precision // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AmountToStringNamedParameters
    implements _AmountToStringNamedParameters {
  _$_AmountToStringNamedParameters(
      {required this.amount,
      required this.ticker,
      this.forceSign = false,
      this.precision = 8});

  @override
  final int amount;
  @override
  final String ticker;
  @override
  @JsonKey()
  final bool forceSign;
  @override
  @JsonKey()
  final int precision;

  @override
  String toString() {
    return 'AmountToStringNamedParameters(amount: $amount, ticker: $ticker, forceSign: $forceSign, precision: $precision)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AmountToStringNamedParameters &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.ticker, ticker) || other.ticker == ticker) &&
            (identical(other.forceSign, forceSign) ||
                other.forceSign == forceSign) &&
            (identical(other.precision, precision) ||
                other.precision == precision));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, amount, ticker, forceSign, precision);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AmountToStringNamedParametersCopyWith<_$_AmountToStringNamedParameters>
      get copyWith => __$$_AmountToStringNamedParametersCopyWithImpl<
          _$_AmountToStringNamedParameters>(this, _$identity);
}

abstract class _AmountToStringNamedParameters
    implements AmountToStringNamedParameters {
  factory _AmountToStringNamedParameters(
      {required final int amount,
      required final String ticker,
      final bool forceSign,
      final int precision}) = _$_AmountToStringNamedParameters;

  @override
  int get amount;
  @override
  String get ticker;
  @override
  bool get forceSign;
  @override
  int get precision;
  @override
  @JsonKey(ignore: true)
  _$$_AmountToStringNamedParametersCopyWith<_$_AmountToStringNamedParameters>
      get copyWith => throw _privateConstructorUsedError;
}
