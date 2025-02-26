// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_releases.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppReleasesDesktop _$AppReleasesDesktopFromJson(Map<String, dynamic> json) {
  return _AppReleasesDesktop.fromJson(json);
}

/// @nodoc
mixin _$AppReleasesDesktop {
  String? get version => throw _privateConstructorUsedError;
  int? get build => throw _privateConstructorUsedError;
  String? get changes => throw _privateConstructorUsedError;

  /// Serializes this AppReleasesDesktop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppReleasesDesktop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppReleasesDesktopCopyWith<AppReleasesDesktop> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppReleasesDesktopCopyWith<$Res> {
  factory $AppReleasesDesktopCopyWith(
    AppReleasesDesktop value,
    $Res Function(AppReleasesDesktop) then,
  ) = _$AppReleasesDesktopCopyWithImpl<$Res, AppReleasesDesktop>;
  @useResult
  $Res call({String? version, int? build, String? changes});
}

/// @nodoc
class _$AppReleasesDesktopCopyWithImpl<$Res, $Val extends AppReleasesDesktop>
    implements $AppReleasesDesktopCopyWith<$Res> {
  _$AppReleasesDesktopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppReleasesDesktop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? build = freezed,
    Object? changes = freezed,
  }) {
    return _then(
      _value.copyWith(
            version:
                freezed == version
                    ? _value.version
                    : version // ignore: cast_nullable_to_non_nullable
                        as String?,
            build:
                freezed == build
                    ? _value.build
                    : build // ignore: cast_nullable_to_non_nullable
                        as int?,
            changes:
                freezed == changes
                    ? _value.changes
                    : changes // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppReleasesDesktopImplCopyWith<$Res>
    implements $AppReleasesDesktopCopyWith<$Res> {
  factory _$$AppReleasesDesktopImplCopyWith(
    _$AppReleasesDesktopImpl value,
    $Res Function(_$AppReleasesDesktopImpl) then,
  ) = __$$AppReleasesDesktopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? version, int? build, String? changes});
}

/// @nodoc
class __$$AppReleasesDesktopImplCopyWithImpl<$Res>
    extends _$AppReleasesDesktopCopyWithImpl<$Res, _$AppReleasesDesktopImpl>
    implements _$$AppReleasesDesktopImplCopyWith<$Res> {
  __$$AppReleasesDesktopImplCopyWithImpl(
    _$AppReleasesDesktopImpl _value,
    $Res Function(_$AppReleasesDesktopImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppReleasesDesktop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = freezed,
    Object? build = freezed,
    Object? changes = freezed,
  }) {
    return _then(
      _$AppReleasesDesktopImpl(
        version:
            freezed == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                    as String?,
        build:
            freezed == build
                ? _value.build
                : build // ignore: cast_nullable_to_non_nullable
                    as int?,
        changes:
            freezed == changes
                ? _value.changes
                : changes // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppReleasesDesktopImpl implements _AppReleasesDesktop {
  const _$AppReleasesDesktopImpl({this.version, this.build, this.changes});

  factory _$AppReleasesDesktopImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppReleasesDesktopImplFromJson(json);

  @override
  final String? version;
  @override
  final int? build;
  @override
  final String? changes;

  @override
  String toString() {
    return 'AppReleasesDesktop(version: $version, build: $build, changes: $changes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppReleasesDesktopImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.build, build) || other.build == build) &&
            (identical(other.changes, changes) || other.changes == changes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, build, changes);

  /// Create a copy of AppReleasesDesktop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppReleasesDesktopImplCopyWith<_$AppReleasesDesktopImpl> get copyWith =>
      __$$AppReleasesDesktopImplCopyWithImpl<_$AppReleasesDesktopImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppReleasesDesktopImplToJson(this);
  }
}

abstract class _AppReleasesDesktop implements AppReleasesDesktop {
  const factory _AppReleasesDesktop({
    final String? version,
    final int? build,
    final String? changes,
  }) = _$AppReleasesDesktopImpl;

  factory _AppReleasesDesktop.fromJson(Map<String, dynamic> json) =
      _$AppReleasesDesktopImpl.fromJson;

  @override
  String? get version;
  @override
  int? get build;
  @override
  String? get changes;

  /// Create a copy of AppReleasesDesktop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppReleasesDesktopImplCopyWith<_$AppReleasesDesktopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppReleasesModel _$AppReleasesModelFromJson(Map<String, dynamic> json) {
  return _AppReleasesModel.fromJson(json);
}

/// @nodoc
mixin _$AppReleasesModel {
  AppReleasesDesktop? get desktop => throw _privateConstructorUsedError;

  /// Serializes this AppReleasesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppReleasesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppReleasesModelCopyWith<AppReleasesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppReleasesModelCopyWith<$Res> {
  factory $AppReleasesModelCopyWith(
    AppReleasesModel value,
    $Res Function(AppReleasesModel) then,
  ) = _$AppReleasesModelCopyWithImpl<$Res, AppReleasesModel>;
  @useResult
  $Res call({AppReleasesDesktop? desktop});

  $AppReleasesDesktopCopyWith<$Res>? get desktop;
}

/// @nodoc
class _$AppReleasesModelCopyWithImpl<$Res, $Val extends AppReleasesModel>
    implements $AppReleasesModelCopyWith<$Res> {
  _$AppReleasesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppReleasesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? desktop = freezed}) {
    return _then(
      _value.copyWith(
            desktop:
                freezed == desktop
                    ? _value.desktop
                    : desktop // ignore: cast_nullable_to_non_nullable
                        as AppReleasesDesktop?,
          )
          as $Val,
    );
  }

  /// Create a copy of AppReleasesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppReleasesDesktopCopyWith<$Res>? get desktop {
    if (_value.desktop == null) {
      return null;
    }

    return $AppReleasesDesktopCopyWith<$Res>(_value.desktop!, (value) {
      return _then(_value.copyWith(desktop: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppReleasesModelImplCopyWith<$Res>
    implements $AppReleasesModelCopyWith<$Res> {
  factory _$$AppReleasesModelImplCopyWith(
    _$AppReleasesModelImpl value,
    $Res Function(_$AppReleasesModelImpl) then,
  ) = __$$AppReleasesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppReleasesDesktop? desktop});

  @override
  $AppReleasesDesktopCopyWith<$Res>? get desktop;
}

/// @nodoc
class __$$AppReleasesModelImplCopyWithImpl<$Res>
    extends _$AppReleasesModelCopyWithImpl<$Res, _$AppReleasesModelImpl>
    implements _$$AppReleasesModelImplCopyWith<$Res> {
  __$$AppReleasesModelImplCopyWithImpl(
    _$AppReleasesModelImpl _value,
    $Res Function(_$AppReleasesModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppReleasesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? desktop = freezed}) {
    return _then(
      _$AppReleasesModelImpl(
        desktop:
            freezed == desktop
                ? _value.desktop
                : desktop // ignore: cast_nullable_to_non_nullable
                    as AppReleasesDesktop?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppReleasesModelImpl implements _AppReleasesModel {
  const _$AppReleasesModelImpl({this.desktop});

  factory _$AppReleasesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppReleasesModelImplFromJson(json);

  @override
  final AppReleasesDesktop? desktop;

  @override
  String toString() {
    return 'AppReleasesModel(desktop: $desktop)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppReleasesModelImpl &&
            (identical(other.desktop, desktop) || other.desktop == desktop));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, desktop);

  /// Create a copy of AppReleasesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppReleasesModelImplCopyWith<_$AppReleasesModelImpl> get copyWith =>
      __$$AppReleasesModelImplCopyWithImpl<_$AppReleasesModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AppReleasesModelImplToJson(this);
  }
}

abstract class _AppReleasesModel implements AppReleasesModel {
  const factory _AppReleasesModel({final AppReleasesDesktop? desktop}) =
      _$AppReleasesModelImpl;

  factory _AppReleasesModel.fromJson(Map<String, dynamic> json) =
      _$AppReleasesModelImpl.fromJson;

  @override
  AppReleasesDesktop? get desktop;

  /// Create a copy of AppReleasesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppReleasesModelImplCopyWith<_$AppReleasesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppReleasesModelState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AppReleasesModel model) data,
    required TResult Function() empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AppReleasesModel model)? data,
    TResult? Function()? empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AppReleasesModel model)? data,
    TResult Function()? empty,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppReleasesModelStateData value) data,
    required TResult Function(AppReleasesModelStateEmpty value) empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppReleasesModelStateData value)? data,
    TResult? Function(AppReleasesModelStateEmpty value)? empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppReleasesModelStateData value)? data,
    TResult Function(AppReleasesModelStateEmpty value)? empty,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppReleasesModelStateCopyWith<$Res> {
  factory $AppReleasesModelStateCopyWith(
    AppReleasesModelState value,
    $Res Function(AppReleasesModelState) then,
  ) = _$AppReleasesModelStateCopyWithImpl<$Res, AppReleasesModelState>;
}

/// @nodoc
class _$AppReleasesModelStateCopyWithImpl<
  $Res,
  $Val extends AppReleasesModelState
>
    implements $AppReleasesModelStateCopyWith<$Res> {
  _$AppReleasesModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppReleasesModelState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AppReleasesModelStateDataImplCopyWith<$Res> {
  factory _$$AppReleasesModelStateDataImplCopyWith(
    _$AppReleasesModelStateDataImpl value,
    $Res Function(_$AppReleasesModelStateDataImpl) then,
  ) = __$$AppReleasesModelStateDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AppReleasesModel model});

  $AppReleasesModelCopyWith<$Res> get model;
}

/// @nodoc
class __$$AppReleasesModelStateDataImplCopyWithImpl<$Res>
    extends
        _$AppReleasesModelStateCopyWithImpl<
          $Res,
          _$AppReleasesModelStateDataImpl
        >
    implements _$$AppReleasesModelStateDataImplCopyWith<$Res> {
  __$$AppReleasesModelStateDataImplCopyWithImpl(
    _$AppReleasesModelStateDataImpl _value,
    $Res Function(_$AppReleasesModelStateDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppReleasesModelState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? model = null}) {
    return _then(
      _$AppReleasesModelStateDataImpl(
        null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                as AppReleasesModel,
      ),
    );
  }

  /// Create a copy of AppReleasesModelState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppReleasesModelCopyWith<$Res> get model {
    return $AppReleasesModelCopyWith<$Res>(_value.model, (value) {
      return _then(_value.copyWith(model: value));
    });
  }
}

/// @nodoc

class _$AppReleasesModelStateDataImpl implements AppReleasesModelStateData {
  const _$AppReleasesModelStateDataImpl(this.model);

  @override
  final AppReleasesModel model;

  @override
  String toString() {
    return 'AppReleasesModelState.data(model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppReleasesModelStateDataImpl &&
            (identical(other.model, model) || other.model == model));
  }

  @override
  int get hashCode => Object.hash(runtimeType, model);

  /// Create a copy of AppReleasesModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppReleasesModelStateDataImplCopyWith<_$AppReleasesModelStateDataImpl>
  get copyWith => __$$AppReleasesModelStateDataImplCopyWithImpl<
    _$AppReleasesModelStateDataImpl
  >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AppReleasesModel model) data,
    required TResult Function() empty,
  }) {
    return data(model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AppReleasesModel model)? data,
    TResult? Function()? empty,
  }) {
    return data?.call(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AppReleasesModel model)? data,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AppReleasesModelStateData value) data,
    required TResult Function(AppReleasesModelStateEmpty value) empty,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppReleasesModelStateData value)? data,
    TResult? Function(AppReleasesModelStateEmpty value)? empty,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppReleasesModelStateData value)? data,
    TResult Function(AppReleasesModelStateEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class AppReleasesModelStateData implements AppReleasesModelState {
  const factory AppReleasesModelStateData(final AppReleasesModel model) =
      _$AppReleasesModelStateDataImpl;

  AppReleasesModel get model;

  /// Create a copy of AppReleasesModelState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppReleasesModelStateDataImplCopyWith<_$AppReleasesModelStateDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AppReleasesModelStateEmptyImplCopyWith<$Res> {
  factory _$$AppReleasesModelStateEmptyImplCopyWith(
    _$AppReleasesModelStateEmptyImpl value,
    $Res Function(_$AppReleasesModelStateEmptyImpl) then,
  ) = __$$AppReleasesModelStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AppReleasesModelStateEmptyImplCopyWithImpl<$Res>
    extends
        _$AppReleasesModelStateCopyWithImpl<
          $Res,
          _$AppReleasesModelStateEmptyImpl
        >
    implements _$$AppReleasesModelStateEmptyImplCopyWith<$Res> {
  __$$AppReleasesModelStateEmptyImplCopyWithImpl(
    _$AppReleasesModelStateEmptyImpl _value,
    $Res Function(_$AppReleasesModelStateEmptyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppReleasesModelState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AppReleasesModelStateEmptyImpl implements AppReleasesModelStateEmpty {
  const _$AppReleasesModelStateEmptyImpl();

  @override
  String toString() {
    return 'AppReleasesModelState.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppReleasesModelStateEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AppReleasesModel model) data,
    required TResult Function() empty,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AppReleasesModel model)? data,
    TResult? Function()? empty,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AppReleasesModel model)? data,
    TResult Function()? empty,
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
    required TResult Function(AppReleasesModelStateData value) data,
    required TResult Function(AppReleasesModelStateEmpty value) empty,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AppReleasesModelStateData value)? data,
    TResult? Function(AppReleasesModelStateEmpty value)? empty,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AppReleasesModelStateData value)? data,
    TResult Function(AppReleasesModelStateEmpty value)? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class AppReleasesModelStateEmpty implements AppReleasesModelState {
  const factory AppReleasesModelStateEmpty() = _$AppReleasesModelStateEmptyImpl;
}
