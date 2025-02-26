// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_ffi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LibClientState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() initialized,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? initialized,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? initialized,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LibClientStateEmpty value) empty,
    required TResult Function(LibClientStateInitialized value) initialized,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibClientStateEmpty value)? empty,
    TResult? Function(LibClientStateInitialized value)? initialized,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibClientStateEmpty value)? empty,
    TResult Function(LibClientStateInitialized value)? initialized,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibClientStateCopyWith<$Res> {
  factory $LibClientStateCopyWith(
    LibClientState value,
    $Res Function(LibClientState) then,
  ) = _$LibClientStateCopyWithImpl<$Res, LibClientState>;
}

/// @nodoc
class _$LibClientStateCopyWithImpl<$Res, $Val extends LibClientState>
    implements $LibClientStateCopyWith<$Res> {
  _$LibClientStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LibClientState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LibClientStateEmptyImplCopyWith<$Res> {
  factory _$$LibClientStateEmptyImplCopyWith(
    _$LibClientStateEmptyImpl value,
    $Res Function(_$LibClientStateEmptyImpl) then,
  ) = __$$LibClientStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LibClientStateEmptyImplCopyWithImpl<$Res>
    extends _$LibClientStateCopyWithImpl<$Res, _$LibClientStateEmptyImpl>
    implements _$$LibClientStateEmptyImplCopyWith<$Res> {
  __$$LibClientStateEmptyImplCopyWithImpl(
    _$LibClientStateEmptyImpl _value,
    $Res Function(_$LibClientStateEmptyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LibClientState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LibClientStateEmptyImpl implements LibClientStateEmpty {
  const _$LibClientStateEmptyImpl();

  @override
  String toString() {
    return 'LibClientState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibClientStateEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() initialized,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? initialized,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? initialized,
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
    required TResult Function(LibClientStateEmpty value) empty,
    required TResult Function(LibClientStateInitialized value) initialized,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibClientStateEmpty value)? empty,
    TResult? Function(LibClientStateInitialized value)? initialized,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibClientStateEmpty value)? empty,
    TResult Function(LibClientStateInitialized value)? initialized,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class LibClientStateEmpty implements LibClientState {
  const factory LibClientStateEmpty() = _$LibClientStateEmptyImpl;
}

/// @nodoc
abstract class _$$LibClientStateInitializedImplCopyWith<$Res> {
  factory _$$LibClientStateInitializedImplCopyWith(
    _$LibClientStateInitializedImpl value,
    $Res Function(_$LibClientStateInitializedImpl) then,
  ) = __$$LibClientStateInitializedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LibClientStateInitializedImplCopyWithImpl<$Res>
    extends _$LibClientStateCopyWithImpl<$Res, _$LibClientStateInitializedImpl>
    implements _$$LibClientStateInitializedImplCopyWith<$Res> {
  __$$LibClientStateInitializedImplCopyWithImpl(
    _$LibClientStateInitializedImpl _value,
    $Res Function(_$LibClientStateInitializedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LibClientState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LibClientStateInitializedImpl implements LibClientStateInitialized {
  const _$LibClientStateInitializedImpl();

  @override
  String toString() {
    return 'LibClientState.initialized()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibClientStateInitializedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() initialized,
  }) {
    return initialized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? initialized,
  }) {
    return initialized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? initialized,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LibClientStateEmpty value) empty,
    required TResult Function(LibClientStateInitialized value) initialized,
  }) {
    return initialized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibClientStateEmpty value)? empty,
    TResult? Function(LibClientStateInitialized value)? initialized,
  }) {
    return initialized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibClientStateEmpty value)? empty,
    TResult Function(LibClientStateInitialized value)? initialized,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized(this);
    }
    return orElse();
  }
}

abstract class LibClientStateInitialized implements LibClientState {
  const factory LibClientStateInitialized() = _$LibClientStateInitializedImpl;
}
