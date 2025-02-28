// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ServerLoginState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() logout,
    required TResult Function() login,
    required TResult Function(String? message) error,
    required TResult Function() loginProcessing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? logout,
    TResult? Function()? login,
    TResult? Function(String? message)? error,
    TResult? Function()? loginProcessing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? logout,
    TResult Function()? login,
    TResult Function(String? message)? error,
    TResult Function()? loginProcessing,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerLoginStateLogout value) logout,
    required TResult Function(ServerLoginStateLogin value) login,
    required TResult Function(ServerLoginStateError value) error,
    required TResult Function(ServerLoginStateLoginProcessing value)
    loginProcessing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerLoginStateLogout value)? logout,
    TResult? Function(ServerLoginStateLogin value)? login,
    TResult? Function(ServerLoginStateError value)? error,
    TResult? Function(ServerLoginStateLoginProcessing value)? loginProcessing,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerLoginStateLogout value)? logout,
    TResult Function(ServerLoginStateLogin value)? login,
    TResult Function(ServerLoginStateError value)? error,
    TResult Function(ServerLoginStateLoginProcessing value)? loginProcessing,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerLoginStateCopyWith<$Res> {
  factory $ServerLoginStateCopyWith(
    ServerLoginState value,
    $Res Function(ServerLoginState) then,
  ) = _$ServerLoginStateCopyWithImpl<$Res, ServerLoginState>;
}

/// @nodoc
class _$ServerLoginStateCopyWithImpl<$Res, $Val extends ServerLoginState>
    implements $ServerLoginStateCopyWith<$Res> {
  _$ServerLoginStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServerLoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ServerLoginStateLogoutImplCopyWith<$Res> {
  factory _$$ServerLoginStateLogoutImplCopyWith(
    _$ServerLoginStateLogoutImpl value,
    $Res Function(_$ServerLoginStateLogoutImpl) then,
  ) = __$$ServerLoginStateLogoutImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ServerLoginStateLogoutImplCopyWithImpl<$Res>
    extends _$ServerLoginStateCopyWithImpl<$Res, _$ServerLoginStateLogoutImpl>
    implements _$$ServerLoginStateLogoutImplCopyWith<$Res> {
  __$$ServerLoginStateLogoutImplCopyWithImpl(
    _$ServerLoginStateLogoutImpl _value,
    $Res Function(_$ServerLoginStateLogoutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServerLoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ServerLoginStateLogoutImpl implements ServerLoginStateLogout {
  const _$ServerLoginStateLogoutImpl();

  @override
  String toString() {
    return 'ServerLoginState.logout()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerLoginStateLogoutImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() logout,
    required TResult Function() login,
    required TResult Function(String? message) error,
    required TResult Function() loginProcessing,
  }) {
    return logout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? logout,
    TResult? Function()? login,
    TResult? Function(String? message)? error,
    TResult? Function()? loginProcessing,
  }) {
    return logout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? logout,
    TResult Function()? login,
    TResult Function(String? message)? error,
    TResult Function()? loginProcessing,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerLoginStateLogout value) logout,
    required TResult Function(ServerLoginStateLogin value) login,
    required TResult Function(ServerLoginStateError value) error,
    required TResult Function(ServerLoginStateLoginProcessing value)
    loginProcessing,
  }) {
    return logout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerLoginStateLogout value)? logout,
    TResult? Function(ServerLoginStateLogin value)? login,
    TResult? Function(ServerLoginStateError value)? error,
    TResult? Function(ServerLoginStateLoginProcessing value)? loginProcessing,
  }) {
    return logout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerLoginStateLogout value)? logout,
    TResult Function(ServerLoginStateLogin value)? login,
    TResult Function(ServerLoginStateError value)? error,
    TResult Function(ServerLoginStateLoginProcessing value)? loginProcessing,
    required TResult orElse(),
  }) {
    if (logout != null) {
      return logout(this);
    }
    return orElse();
  }
}

abstract class ServerLoginStateLogout implements ServerLoginState {
  const factory ServerLoginStateLogout() = _$ServerLoginStateLogoutImpl;
}

/// @nodoc
abstract class _$$ServerLoginStateLoginImplCopyWith<$Res> {
  factory _$$ServerLoginStateLoginImplCopyWith(
    _$ServerLoginStateLoginImpl value,
    $Res Function(_$ServerLoginStateLoginImpl) then,
  ) = __$$ServerLoginStateLoginImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ServerLoginStateLoginImplCopyWithImpl<$Res>
    extends _$ServerLoginStateCopyWithImpl<$Res, _$ServerLoginStateLoginImpl>
    implements _$$ServerLoginStateLoginImplCopyWith<$Res> {
  __$$ServerLoginStateLoginImplCopyWithImpl(
    _$ServerLoginStateLoginImpl _value,
    $Res Function(_$ServerLoginStateLoginImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServerLoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ServerLoginStateLoginImpl implements ServerLoginStateLogin {
  const _$ServerLoginStateLoginImpl();

  @override
  String toString() {
    return 'ServerLoginState.login()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerLoginStateLoginImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() logout,
    required TResult Function() login,
    required TResult Function(String? message) error,
    required TResult Function() loginProcessing,
  }) {
    return login();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? logout,
    TResult? Function()? login,
    TResult? Function(String? message)? error,
    TResult? Function()? loginProcessing,
  }) {
    return login?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? logout,
    TResult Function()? login,
    TResult Function(String? message)? error,
    TResult Function()? loginProcessing,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerLoginStateLogout value) logout,
    required TResult Function(ServerLoginStateLogin value) login,
    required TResult Function(ServerLoginStateError value) error,
    required TResult Function(ServerLoginStateLoginProcessing value)
    loginProcessing,
  }) {
    return login(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerLoginStateLogout value)? logout,
    TResult? Function(ServerLoginStateLogin value)? login,
    TResult? Function(ServerLoginStateError value)? error,
    TResult? Function(ServerLoginStateLoginProcessing value)? loginProcessing,
  }) {
    return login?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerLoginStateLogout value)? logout,
    TResult Function(ServerLoginStateLogin value)? login,
    TResult Function(ServerLoginStateError value)? error,
    TResult Function(ServerLoginStateLoginProcessing value)? loginProcessing,
    required TResult orElse(),
  }) {
    if (login != null) {
      return login(this);
    }
    return orElse();
  }
}

abstract class ServerLoginStateLogin implements ServerLoginState {
  const factory ServerLoginStateLogin() = _$ServerLoginStateLoginImpl;
}

/// @nodoc
abstract class _$$ServerLoginStateErrorImplCopyWith<$Res> {
  factory _$$ServerLoginStateErrorImplCopyWith(
    _$ServerLoginStateErrorImpl value,
    $Res Function(_$ServerLoginStateErrorImpl) then,
  ) = __$$ServerLoginStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ServerLoginStateErrorImplCopyWithImpl<$Res>
    extends _$ServerLoginStateCopyWithImpl<$Res, _$ServerLoginStateErrorImpl>
    implements _$$ServerLoginStateErrorImplCopyWith<$Res> {
  __$$ServerLoginStateErrorImplCopyWithImpl(
    _$ServerLoginStateErrorImpl _value,
    $Res Function(_$ServerLoginStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServerLoginState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = freezed}) {
    return _then(
      _$ServerLoginStateErrorImpl(
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$ServerLoginStateErrorImpl implements ServerLoginStateError {
  const _$ServerLoginStateErrorImpl({this.message});

  @override
  final String? message;

  @override
  String toString() {
    return 'ServerLoginState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerLoginStateErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ServerLoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerLoginStateErrorImplCopyWith<_$ServerLoginStateErrorImpl>
  get copyWith =>
      __$$ServerLoginStateErrorImplCopyWithImpl<_$ServerLoginStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() logout,
    required TResult Function() login,
    required TResult Function(String? message) error,
    required TResult Function() loginProcessing,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? logout,
    TResult? Function()? login,
    TResult? Function(String? message)? error,
    TResult? Function()? loginProcessing,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? logout,
    TResult Function()? login,
    TResult Function(String? message)? error,
    TResult Function()? loginProcessing,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerLoginStateLogout value) logout,
    required TResult Function(ServerLoginStateLogin value) login,
    required TResult Function(ServerLoginStateError value) error,
    required TResult Function(ServerLoginStateLoginProcessing value)
    loginProcessing,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerLoginStateLogout value)? logout,
    TResult? Function(ServerLoginStateLogin value)? login,
    TResult? Function(ServerLoginStateError value)? error,
    TResult? Function(ServerLoginStateLoginProcessing value)? loginProcessing,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerLoginStateLogout value)? logout,
    TResult Function(ServerLoginStateLogin value)? login,
    TResult Function(ServerLoginStateError value)? error,
    TResult Function(ServerLoginStateLoginProcessing value)? loginProcessing,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ServerLoginStateError implements ServerLoginState {
  const factory ServerLoginStateError({final String? message}) =
      _$ServerLoginStateErrorImpl;

  String? get message;

  /// Create a copy of ServerLoginState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerLoginStateErrorImplCopyWith<_$ServerLoginStateErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServerLoginStateLoginProcessingImplCopyWith<$Res> {
  factory _$$ServerLoginStateLoginProcessingImplCopyWith(
    _$ServerLoginStateLoginProcessingImpl value,
    $Res Function(_$ServerLoginStateLoginProcessingImpl) then,
  ) = __$$ServerLoginStateLoginProcessingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ServerLoginStateLoginProcessingImplCopyWithImpl<$Res>
    extends
        _$ServerLoginStateCopyWithImpl<
          $Res,
          _$ServerLoginStateLoginProcessingImpl
        >
    implements _$$ServerLoginStateLoginProcessingImplCopyWith<$Res> {
  __$$ServerLoginStateLoginProcessingImplCopyWithImpl(
    _$ServerLoginStateLoginProcessingImpl _value,
    $Res Function(_$ServerLoginStateLoginProcessingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServerLoginState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ServerLoginStateLoginProcessingImpl
    implements ServerLoginStateLoginProcessing {
  const _$ServerLoginStateLoginProcessingImpl();

  @override
  String toString() {
    return 'ServerLoginState.loginProcessing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerLoginStateLoginProcessingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() logout,
    required TResult Function() login,
    required TResult Function(String? message) error,
    required TResult Function() loginProcessing,
  }) {
    return loginProcessing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? logout,
    TResult? Function()? login,
    TResult? Function(String? message)? error,
    TResult? Function()? loginProcessing,
  }) {
    return loginProcessing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? logout,
    TResult Function()? login,
    TResult Function(String? message)? error,
    TResult Function()? loginProcessing,
    required TResult orElse(),
  }) {
    if (loginProcessing != null) {
      return loginProcessing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerLoginStateLogout value) logout,
    required TResult Function(ServerLoginStateLogin value) login,
    required TResult Function(ServerLoginStateError value) error,
    required TResult Function(ServerLoginStateLoginProcessing value)
    loginProcessing,
  }) {
    return loginProcessing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerLoginStateLogout value)? logout,
    TResult? Function(ServerLoginStateLogin value)? login,
    TResult? Function(ServerLoginStateError value)? error,
    TResult? Function(ServerLoginStateLoginProcessing value)? loginProcessing,
  }) {
    return loginProcessing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerLoginStateLogout value)? logout,
    TResult Function(ServerLoginStateLogin value)? login,
    TResult Function(ServerLoginStateError value)? error,
    TResult Function(ServerLoginStateLoginProcessing value)? loginProcessing,
    required TResult orElse(),
  }) {
    if (loginProcessing != null) {
      return loginProcessing(this);
    }
    return orElse();
  }
}

abstract class ServerLoginStateLoginProcessing implements ServerLoginState {
  const factory ServerLoginStateLoginProcessing() =
      _$ServerLoginStateLoginProcessingImpl;
}
