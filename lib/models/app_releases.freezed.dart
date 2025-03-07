// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_releases.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppReleasesDesktop {

 String? get version; int? get build; String? get changes;
/// Create a copy of AppReleasesDesktop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppReleasesDesktopCopyWith<AppReleasesDesktop> get copyWith => _$AppReleasesDesktopCopyWithImpl<AppReleasesDesktop>(this as AppReleasesDesktop, _$identity);

  /// Serializes this AppReleasesDesktop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppReleasesDesktop&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.changes, changes) || other.changes == changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,build,changes);

@override
String toString() {
  return 'AppReleasesDesktop(version: $version, build: $build, changes: $changes)';
}


}

/// @nodoc
abstract mixin class $AppReleasesDesktopCopyWith<$Res>  {
  factory $AppReleasesDesktopCopyWith(AppReleasesDesktop value, $Res Function(AppReleasesDesktop) _then) = _$AppReleasesDesktopCopyWithImpl;
@useResult
$Res call({
 String? version, int? build, String? changes
});




}
/// @nodoc
class _$AppReleasesDesktopCopyWithImpl<$Res>
    implements $AppReleasesDesktopCopyWith<$Res> {
  _$AppReleasesDesktopCopyWithImpl(this._self, this._then);

  final AppReleasesDesktop _self;
  final $Res Function(AppReleasesDesktop) _then;

/// Create a copy of AppReleasesDesktop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = freezed,Object? build = freezed,Object? changes = freezed,}) {
  return _then(_self.copyWith(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,build: freezed == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as int?,changes: freezed == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AppReleasesDesktop implements AppReleasesDesktop {
  const _AppReleasesDesktop({this.version, this.build, this.changes});
  factory _AppReleasesDesktop.fromJson(Map<String, dynamic> json) => _$AppReleasesDesktopFromJson(json);

@override final  String? version;
@override final  int? build;
@override final  String? changes;

/// Create a copy of AppReleasesDesktop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppReleasesDesktopCopyWith<_AppReleasesDesktop> get copyWith => __$AppReleasesDesktopCopyWithImpl<_AppReleasesDesktop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppReleasesDesktopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppReleasesDesktop&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.changes, changes) || other.changes == changes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,build,changes);

@override
String toString() {
  return 'AppReleasesDesktop(version: $version, build: $build, changes: $changes)';
}


}

/// @nodoc
abstract mixin class _$AppReleasesDesktopCopyWith<$Res> implements $AppReleasesDesktopCopyWith<$Res> {
  factory _$AppReleasesDesktopCopyWith(_AppReleasesDesktop value, $Res Function(_AppReleasesDesktop) _then) = __$AppReleasesDesktopCopyWithImpl;
@override @useResult
$Res call({
 String? version, int? build, String? changes
});




}
/// @nodoc
class __$AppReleasesDesktopCopyWithImpl<$Res>
    implements _$AppReleasesDesktopCopyWith<$Res> {
  __$AppReleasesDesktopCopyWithImpl(this._self, this._then);

  final _AppReleasesDesktop _self;
  final $Res Function(_AppReleasesDesktop) _then;

/// Create a copy of AppReleasesDesktop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = freezed,Object? build = freezed,Object? changes = freezed,}) {
  return _then(_AppReleasesDesktop(
version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,build: freezed == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as int?,changes: freezed == changes ? _self.changes : changes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AppReleasesModel {

 AppReleasesDesktop? get desktop;
/// Create a copy of AppReleasesModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppReleasesModelCopyWith<AppReleasesModel> get copyWith => _$AppReleasesModelCopyWithImpl<AppReleasesModel>(this as AppReleasesModel, _$identity);

  /// Serializes this AppReleasesModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppReleasesModel&&(identical(other.desktop, desktop) || other.desktop == desktop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,desktop);

@override
String toString() {
  return 'AppReleasesModel(desktop: $desktop)';
}


}

/// @nodoc
abstract mixin class $AppReleasesModelCopyWith<$Res>  {
  factory $AppReleasesModelCopyWith(AppReleasesModel value, $Res Function(AppReleasesModel) _then) = _$AppReleasesModelCopyWithImpl;
@useResult
$Res call({
 AppReleasesDesktop? desktop
});


$AppReleasesDesktopCopyWith<$Res>? get desktop;

}
/// @nodoc
class _$AppReleasesModelCopyWithImpl<$Res>
    implements $AppReleasesModelCopyWith<$Res> {
  _$AppReleasesModelCopyWithImpl(this._self, this._then);

  final AppReleasesModel _self;
  final $Res Function(AppReleasesModel) _then;

/// Create a copy of AppReleasesModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? desktop = freezed,}) {
  return _then(_self.copyWith(
desktop: freezed == desktop ? _self.desktop : desktop // ignore: cast_nullable_to_non_nullable
as AppReleasesDesktop?,
  ));
}
/// Create a copy of AppReleasesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppReleasesDesktopCopyWith<$Res>? get desktop {
    if (_self.desktop == null) {
    return null;
  }

  return $AppReleasesDesktopCopyWith<$Res>(_self.desktop!, (value) {
    return _then(_self.copyWith(desktop: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AppReleasesModel implements AppReleasesModel {
  const _AppReleasesModel({this.desktop});
  factory _AppReleasesModel.fromJson(Map<String, dynamic> json) => _$AppReleasesModelFromJson(json);

@override final  AppReleasesDesktop? desktop;

/// Create a copy of AppReleasesModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppReleasesModelCopyWith<_AppReleasesModel> get copyWith => __$AppReleasesModelCopyWithImpl<_AppReleasesModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppReleasesModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppReleasesModel&&(identical(other.desktop, desktop) || other.desktop == desktop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,desktop);

@override
String toString() {
  return 'AppReleasesModel(desktop: $desktop)';
}


}

/// @nodoc
abstract mixin class _$AppReleasesModelCopyWith<$Res> implements $AppReleasesModelCopyWith<$Res> {
  factory _$AppReleasesModelCopyWith(_AppReleasesModel value, $Res Function(_AppReleasesModel) _then) = __$AppReleasesModelCopyWithImpl;
@override @useResult
$Res call({
 AppReleasesDesktop? desktop
});


@override $AppReleasesDesktopCopyWith<$Res>? get desktop;

}
/// @nodoc
class __$AppReleasesModelCopyWithImpl<$Res>
    implements _$AppReleasesModelCopyWith<$Res> {
  __$AppReleasesModelCopyWithImpl(this._self, this._then);

  final _AppReleasesModel _self;
  final $Res Function(_AppReleasesModel) _then;

/// Create a copy of AppReleasesModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? desktop = freezed,}) {
  return _then(_AppReleasesModel(
desktop: freezed == desktop ? _self.desktop : desktop // ignore: cast_nullable_to_non_nullable
as AppReleasesDesktop?,
  ));
}

/// Create a copy of AppReleasesModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppReleasesDesktopCopyWith<$Res>? get desktop {
    if (_self.desktop == null) {
    return null;
  }

  return $AppReleasesDesktopCopyWith<$Res>(_self.desktop!, (value) {
    return _then(_self.copyWith(desktop: value));
  });
}
}

/// @nodoc
mixin _$AppReleasesModelState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppReleasesModelState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppReleasesModelState()';
}


}

/// @nodoc
class $AppReleasesModelStateCopyWith<$Res>  {
$AppReleasesModelStateCopyWith(AppReleasesModelState _, $Res Function(AppReleasesModelState) __);
}


/// @nodoc


class AppReleasesModelStateData implements AppReleasesModelState {
  const AppReleasesModelStateData(this.model);
  

 final  AppReleasesModel model;

/// Create a copy of AppReleasesModelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppReleasesModelStateDataCopyWith<AppReleasesModelStateData> get copyWith => _$AppReleasesModelStateDataCopyWithImpl<AppReleasesModelStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppReleasesModelStateData&&(identical(other.model, model) || other.model == model));
}


@override
int get hashCode => Object.hash(runtimeType,model);

@override
String toString() {
  return 'AppReleasesModelState.data(model: $model)';
}


}

/// @nodoc
abstract mixin class $AppReleasesModelStateDataCopyWith<$Res> implements $AppReleasesModelStateCopyWith<$Res> {
  factory $AppReleasesModelStateDataCopyWith(AppReleasesModelStateData value, $Res Function(AppReleasesModelStateData) _then) = _$AppReleasesModelStateDataCopyWithImpl;
@useResult
$Res call({
 AppReleasesModel model
});


$AppReleasesModelCopyWith<$Res> get model;

}
/// @nodoc
class _$AppReleasesModelStateDataCopyWithImpl<$Res>
    implements $AppReleasesModelStateDataCopyWith<$Res> {
  _$AppReleasesModelStateDataCopyWithImpl(this._self, this._then);

  final AppReleasesModelStateData _self;
  final $Res Function(AppReleasesModelStateData) _then;

/// Create a copy of AppReleasesModelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? model = null,}) {
  return _then(AppReleasesModelStateData(
null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as AppReleasesModel,
  ));
}

/// Create a copy of AppReleasesModelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppReleasesModelCopyWith<$Res> get model {
  
  return $AppReleasesModelCopyWith<$Res>(_self.model, (value) {
    return _then(_self.copyWith(model: value));
  });
}
}

/// @nodoc


class AppReleasesModelStateEmpty implements AppReleasesModelState {
  const AppReleasesModelStateEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppReleasesModelStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppReleasesModelState.empty()';
}


}




// dart format on
