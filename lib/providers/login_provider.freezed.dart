// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoginState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(String? mnemonic, String? jadeId) login,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(String? mnemonic, String? jadeId)? login,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(String? mnemonic, String? jadeId)? login,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginStateEmpty value) empty,
    required TResult Function(LoginStateLogin value) login,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginStateEmpty value)? empty,
    TResult? Function(LoginStateLogin value)? login,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginStateEmpty value)? empty,
    TResult Function(LoginStateLogin value)? login,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
    LoginState value,
    $Res Function(LoginState) then,
  ) = _$LoginStateCopyWithImpl<$Res, LoginState>;
}

/// @nodoc
class _$LoginStateCopyWithImpl<$Res, $Val extends LoginState>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoginStateEmptyImplCopyWith<$Res> {
  factory _$$LoginStateEmptyImplCopyWith(
    _$LoginStateEmptyImpl value,
    $Res Function(_$LoginStateEmptyImpl) then,
  ) = __$$LoginStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginStateEmptyImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginStateEmptyImpl>
    implements _$$LoginStateEmptyImplCopyWith<$Res> {
  __$$LoginStateEmptyImplCopyWithImpl(
    _$LoginStateEmptyImpl _value,
    $Res Function(_$LoginStateEmptyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoginStateEmptyImpl implements LoginStateEmpty {
  const _$LoginStateEmptyImpl();

  @override
  String toString() {
    return 'LoginState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginStateEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(String? mnemonic, String? jadeId) login,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(String? mnemonic, String? jadeId)? login,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(String? mnemonic, String? jadeId)? login,
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
    required TResult Function(LoginStateEmpty value) empty,
    required TResult Function(LoginStateLogin value) login,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginStateEmpty value)? empty,
    TResult? Function(LoginStateLogin value)? login,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginStateEmpty value)? empty,
    TResult Function(LoginStateLogin value)? login,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class LoginStateEmpty implements LoginState {
  const factory LoginStateEmpty() = _$LoginStateEmptyImpl;
}

/// @nodoc
abstract class _$$LoginStateLoginImplCopyWith<$Res> {
  factory _$$LoginStateLoginImplCopyWith(
    _$LoginStateLoginImpl value,
    $Res Function(_$LoginStateLoginImpl) then,
  ) = __$$LoginStateLoginImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? mnemonic, String? jadeId});
}

/// @nodoc
class __$$LoginStateLoginImplCopyWithImpl<$Res>
    extends _$LoginStateCopyWithImpl<$Res, _$LoginStateLoginImpl>
    implements _$$LoginStateLoginImplCopyWith<$Res> {
  __$$LoginStateLoginImplCopyWithImpl(
    _$LoginStateLoginImpl _value,
    $Res Function(_$LoginStateLoginImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mnemonic = freezed, Object? jadeId = freezed}) {
    return _then(
      _$LoginStateLoginImpl(
        mnemonic:
            freezed == mnemonic
                ? _value.mnemonic
                : mnemonic // ignore: cast_nullable_to_non_nullable
                    as String?,
        jadeId:
            freezed == jadeId
                ? _value.jadeId
                : jadeId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$LoginStateLoginImpl implements LoginStateLogin {
  const _$LoginStateLoginImpl({this.mnemonic, this.jadeId});

  @override
  final String? mnemonic;
  @override
  final String? jadeId;

  @override
  String toString() {
    return 'LoginState.login(mnemonic: $mnemonic, jadeId: $jadeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginStateLoginImpl &&
            (identical(other.mnemonic, mnemonic) ||
                other.mnemonic == mnemonic) &&
            (identical(other.jadeId, jadeId) || other.jadeId == jadeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mnemonic, jadeId);

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginStateLoginImplCopyWith<_$LoginStateLoginImpl> get copyWith =>
      __$$LoginStateLoginImplCopyWithImpl<_$LoginStateLoginImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function(String? mnemonic, String? jadeId) login,
  }) {
    return login(mnemonic, jadeId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function(String? mnemonic, String? jadeId)? login,
  }) {
    return login?.call(mnemonic, jadeId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function(String? mnemonic, String? jadeId)? login,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(mnemonic, jadeId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginStateEmpty value) empty,
    required TResult Function(LoginStateLogin value) login,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginStateEmpty value)? empty,
    TResult? Function(LoginStateLogin value)? login,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginStateEmpty value)? empty,
    TResult Function(LoginStateLogin value)? login,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }
}

abstract class LoginStateLogin implements LoginState {
  const factory LoginStateLogin({
    final String? mnemonic,
    final String? jadeId,
  }) = _$LoginStateLoginImpl;

  String? get mnemonic;
  String? get jadeId;

  /// Create a copy of LoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginStateLoginImplCopyWith<_$LoginStateLoginImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
