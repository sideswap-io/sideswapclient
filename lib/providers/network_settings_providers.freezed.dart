// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_settings_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NetworkSettingsModel _$NetworkSettingsModelFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'empty':
      return NetworkSettingsModelEmpty.fromJson(json);
    case 'apply':
      return NetworkSettingsModelApply.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'NetworkSettingsModel',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$NetworkSettingsModel {
  SettingsNetworkType? get settingsNetworkType =>
      throw _privateConstructorUsedError;
  int? get env => throw _privateConstructorUsedError;
  String? get host => throw _privateConstructorUsedError;
  int? get port => throw _privateConstructorUsedError;
  bool? get useTls => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SettingsNetworkType? settingsNetworkType,
            int? env, String? host, int? port, bool? useTls)
        empty,
    required TResult Function(SettingsNetworkType? settingsNetworkType,
            int? env, String? host, int? port, bool? useTls)
        apply,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        empty,
    TResult? Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        apply,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        empty,
    TResult Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        apply,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkSettingsModelEmpty value) empty,
    required TResult Function(NetworkSettingsModelApply value) apply,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkSettingsModelEmpty value)? empty,
    TResult? Function(NetworkSettingsModelApply value)? apply,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkSettingsModelEmpty value)? empty,
    TResult Function(NetworkSettingsModelApply value)? apply,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkSettingsModelCopyWith<NetworkSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkSettingsModelCopyWith<$Res> {
  factory $NetworkSettingsModelCopyWith(NetworkSettingsModel value,
          $Res Function(NetworkSettingsModel) then) =
      _$NetworkSettingsModelCopyWithImpl<$Res, NetworkSettingsModel>;
  @useResult
  $Res call(
      {SettingsNetworkType? settingsNetworkType,
      int? env,
      String? host,
      int? port,
      bool? useTls});
}

/// @nodoc
class _$NetworkSettingsModelCopyWithImpl<$Res,
        $Val extends NetworkSettingsModel>
    implements $NetworkSettingsModelCopyWith<$Res> {
  _$NetworkSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settingsNetworkType = freezed,
    Object? env = freezed,
    Object? host = freezed,
    Object? port = freezed,
    Object? useTls = freezed,
  }) {
    return _then(_value.copyWith(
      settingsNetworkType: freezed == settingsNetworkType
          ? _value.settingsNetworkType
          : settingsNetworkType // ignore: cast_nullable_to_non_nullable
              as SettingsNetworkType?,
      env: freezed == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as int?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      port: freezed == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int?,
      useTls: freezed == useTls
          ? _value.useTls
          : useTls // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkSettingsModelEmptyImplCopyWith<$Res>
    implements $NetworkSettingsModelCopyWith<$Res> {
  factory _$$NetworkSettingsModelEmptyImplCopyWith(
          _$NetworkSettingsModelEmptyImpl value,
          $Res Function(_$NetworkSettingsModelEmptyImpl) then) =
      __$$NetworkSettingsModelEmptyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SettingsNetworkType? settingsNetworkType,
      int? env,
      String? host,
      int? port,
      bool? useTls});
}

/// @nodoc
class __$$NetworkSettingsModelEmptyImplCopyWithImpl<$Res>
    extends _$NetworkSettingsModelCopyWithImpl<$Res,
        _$NetworkSettingsModelEmptyImpl>
    implements _$$NetworkSettingsModelEmptyImplCopyWith<$Res> {
  __$$NetworkSettingsModelEmptyImplCopyWithImpl(
      _$NetworkSettingsModelEmptyImpl _value,
      $Res Function(_$NetworkSettingsModelEmptyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settingsNetworkType = freezed,
    Object? env = freezed,
    Object? host = freezed,
    Object? port = freezed,
    Object? useTls = freezed,
  }) {
    return _then(_$NetworkSettingsModelEmptyImpl(
      settingsNetworkType: freezed == settingsNetworkType
          ? _value.settingsNetworkType
          : settingsNetworkType // ignore: cast_nullable_to_non_nullable
              as SettingsNetworkType?,
      env: freezed == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as int?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      port: freezed == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int?,
      useTls: freezed == useTls
          ? _value.useTls
          : useTls // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkSettingsModelEmptyImpl implements NetworkSettingsModelEmpty {
  const _$NetworkSettingsModelEmptyImpl(
      {this.settingsNetworkType,
      this.env,
      this.host,
      this.port,
      this.useTls,
      final String? $type})
      : $type = $type ?? 'empty';

  factory _$NetworkSettingsModelEmptyImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkSettingsModelEmptyImplFromJson(json);

  @override
  final SettingsNetworkType? settingsNetworkType;
  @override
  final int? env;
  @override
  final String? host;
  @override
  final int? port;
  @override
  final bool? useTls;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'NetworkSettingsModel.empty(settingsNetworkType: $settingsNetworkType, env: $env, host: $host, port: $port, useTls: $useTls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkSettingsModelEmptyImpl &&
            (identical(other.settingsNetworkType, settingsNetworkType) ||
                other.settingsNetworkType == settingsNetworkType) &&
            (identical(other.env, env) || other.env == env) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.useTls, useTls) || other.useTls == useTls));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, settingsNetworkType, env, host, port, useTls);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkSettingsModelEmptyImplCopyWith<_$NetworkSettingsModelEmptyImpl>
      get copyWith => __$$NetworkSettingsModelEmptyImplCopyWithImpl<
          _$NetworkSettingsModelEmptyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SettingsNetworkType? settingsNetworkType,
            int? env, String? host, int? port, bool? useTls)
        empty,
    required TResult Function(SettingsNetworkType? settingsNetworkType,
            int? env, String? host, int? port, bool? useTls)
        apply,
  }) {
    return empty(settingsNetworkType, env, host, port, useTls);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        empty,
    TResult? Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        apply,
  }) {
    return empty?.call(settingsNetworkType, env, host, port, useTls);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        empty,
    TResult Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        apply,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(settingsNetworkType, env, host, port, useTls);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkSettingsModelEmpty value) empty,
    required TResult Function(NetworkSettingsModelApply value) apply,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkSettingsModelEmpty value)? empty,
    TResult? Function(NetworkSettingsModelApply value)? apply,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkSettingsModelEmpty value)? empty,
    TResult Function(NetworkSettingsModelApply value)? apply,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkSettingsModelEmptyImplToJson(
      this,
    );
  }
}

abstract class NetworkSettingsModelEmpty implements NetworkSettingsModel {
  const factory NetworkSettingsModelEmpty(
      {final SettingsNetworkType? settingsNetworkType,
      final int? env,
      final String? host,
      final int? port,
      final bool? useTls}) = _$NetworkSettingsModelEmptyImpl;

  factory NetworkSettingsModelEmpty.fromJson(Map<String, dynamic> json) =
      _$NetworkSettingsModelEmptyImpl.fromJson;

  @override
  SettingsNetworkType? get settingsNetworkType;
  @override
  int? get env;
  @override
  String? get host;
  @override
  int? get port;
  @override
  bool? get useTls;
  @override
  @JsonKey(ignore: true)
  _$$NetworkSettingsModelEmptyImplCopyWith<_$NetworkSettingsModelEmptyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkSettingsModelApplyImplCopyWith<$Res>
    implements $NetworkSettingsModelCopyWith<$Res> {
  factory _$$NetworkSettingsModelApplyImplCopyWith(
          _$NetworkSettingsModelApplyImpl value,
          $Res Function(_$NetworkSettingsModelApplyImpl) then) =
      __$$NetworkSettingsModelApplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SettingsNetworkType? settingsNetworkType,
      int? env,
      String? host,
      int? port,
      bool? useTls});
}

/// @nodoc
class __$$NetworkSettingsModelApplyImplCopyWithImpl<$Res>
    extends _$NetworkSettingsModelCopyWithImpl<$Res,
        _$NetworkSettingsModelApplyImpl>
    implements _$$NetworkSettingsModelApplyImplCopyWith<$Res> {
  __$$NetworkSettingsModelApplyImplCopyWithImpl(
      _$NetworkSettingsModelApplyImpl _value,
      $Res Function(_$NetworkSettingsModelApplyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settingsNetworkType = freezed,
    Object? env = freezed,
    Object? host = freezed,
    Object? port = freezed,
    Object? useTls = freezed,
  }) {
    return _then(_$NetworkSettingsModelApplyImpl(
      settingsNetworkType: freezed == settingsNetworkType
          ? _value.settingsNetworkType
          : settingsNetworkType // ignore: cast_nullable_to_non_nullable
              as SettingsNetworkType?,
      env: freezed == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as int?,
      host: freezed == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String?,
      port: freezed == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int?,
      useTls: freezed == useTls
          ? _value.useTls
          : useTls // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkSettingsModelApplyImpl implements NetworkSettingsModelApply {
  const _$NetworkSettingsModelApplyImpl(
      {this.settingsNetworkType,
      this.env,
      this.host,
      this.port,
      this.useTls,
      final String? $type})
      : $type = $type ?? 'apply';

  factory _$NetworkSettingsModelApplyImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkSettingsModelApplyImplFromJson(json);

  @override
  final SettingsNetworkType? settingsNetworkType;
  @override
  final int? env;
  @override
  final String? host;
  @override
  final int? port;
  @override
  final bool? useTls;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'NetworkSettingsModel.apply(settingsNetworkType: $settingsNetworkType, env: $env, host: $host, port: $port, useTls: $useTls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkSettingsModelApplyImpl &&
            (identical(other.settingsNetworkType, settingsNetworkType) ||
                other.settingsNetworkType == settingsNetworkType) &&
            (identical(other.env, env) || other.env == env) &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.useTls, useTls) || other.useTls == useTls));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, settingsNetworkType, env, host, port, useTls);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkSettingsModelApplyImplCopyWith<_$NetworkSettingsModelApplyImpl>
      get copyWith => __$$NetworkSettingsModelApplyImplCopyWithImpl<
          _$NetworkSettingsModelApplyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(SettingsNetworkType? settingsNetworkType,
            int? env, String? host, int? port, bool? useTls)
        empty,
    required TResult Function(SettingsNetworkType? settingsNetworkType,
            int? env, String? host, int? port, bool? useTls)
        apply,
  }) {
    return apply(settingsNetworkType, env, host, port, useTls);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        empty,
    TResult? Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        apply,
  }) {
    return apply?.call(settingsNetworkType, env, host, port, useTls);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        empty,
    TResult Function(SettingsNetworkType? settingsNetworkType, int? env,
            String? host, int? port, bool? useTls)?
        apply,
    required TResult orElse(),
  }) {
    if (apply != null) {
      return apply(settingsNetworkType, env, host, port, useTls);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkSettingsModelEmpty value) empty,
    required TResult Function(NetworkSettingsModelApply value) apply,
  }) {
    return apply(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkSettingsModelEmpty value)? empty,
    TResult? Function(NetworkSettingsModelApply value)? apply,
  }) {
    return apply?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkSettingsModelEmpty value)? empty,
    TResult Function(NetworkSettingsModelApply value)? apply,
    required TResult orElse(),
  }) {
    if (apply != null) {
      return apply(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkSettingsModelApplyImplToJson(
      this,
    );
  }
}

abstract class NetworkSettingsModelApply implements NetworkSettingsModel {
  const factory NetworkSettingsModelApply(
      {final SettingsNetworkType? settingsNetworkType,
      final int? env,
      final String? host,
      final int? port,
      final bool? useTls}) = _$NetworkSettingsModelApplyImpl;

  factory NetworkSettingsModelApply.fromJson(Map<String, dynamic> json) =
      _$NetworkSettingsModelApplyImpl.fromJson;

  @override
  SettingsNetworkType? get settingsNetworkType;
  @override
  int? get env;
  @override
  String? get host;
  @override
  int? get port;
  @override
  bool? get useTls;
  @override
  @JsonKey(ignore: true)
  _$$NetworkSettingsModelApplyImplCopyWith<_$NetworkSettingsModelApplyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
