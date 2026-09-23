// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'desktop_window_geometry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DesktopWindowGeometry {

 double get left; double get top; double get width; double get height; bool get maximized; String? get displayId;
/// Create a copy of DesktopWindowGeometry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DesktopWindowGeometryCopyWith<DesktopWindowGeometry> get copyWith => _$DesktopWindowGeometryCopyWithImpl<DesktopWindowGeometry>(this as DesktopWindowGeometry, _$identity);

  /// Serializes this DesktopWindowGeometry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DesktopWindowGeometry&&(identical(other.left, left) || other.left == left)&&(identical(other.top, top) || other.top == top)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.maximized, maximized) || other.maximized == maximized)&&(identical(other.displayId, displayId) || other.displayId == displayId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,left,top,width,height,maximized,displayId);

@override
String toString() {
  return 'DesktopWindowGeometry(left: $left, top: $top, width: $width, height: $height, maximized: $maximized, displayId: $displayId)';
}


}

/// @nodoc
abstract mixin class $DesktopWindowGeometryCopyWith<$Res>  {
  factory $DesktopWindowGeometryCopyWith(DesktopWindowGeometry value, $Res Function(DesktopWindowGeometry) _then) = _$DesktopWindowGeometryCopyWithImpl;
@useResult
$Res call({
 double left, double top, double width, double height, bool maximized, String? displayId
});




}
/// @nodoc
class _$DesktopWindowGeometryCopyWithImpl<$Res>
    implements $DesktopWindowGeometryCopyWith<$Res> {
  _$DesktopWindowGeometryCopyWithImpl(this._self, this._then);

  final DesktopWindowGeometry _self;
  final $Res Function(DesktopWindowGeometry) _then;

/// Create a copy of DesktopWindowGeometry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,Object? maximized = null,Object? displayId = freezed,}) {
  return _then(DesktopWindowGeometry(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,maximized: null == maximized ? _self.maximized : maximized // ignore: cast_nullable_to_non_nullable
as bool,displayId: freezed == displayId ? _self.displayId : displayId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DesktopWindowGeometry].
extension DesktopWindowGeometryPatterns on DesktopWindowGeometry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DesktopWindowGeometry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DesktopWindowGeometry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DesktopWindowGeometry value)  $default,){
final _that = this;
switch (_that) {
case _DesktopWindowGeometry():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DesktopWindowGeometry value)?  $default,){
final _that = this;
switch (_that) {
case _DesktopWindowGeometry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height,  bool maximized,  String? displayId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DesktopWindowGeometry() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height,_that.maximized,_that.displayId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double left,  double top,  double width,  double height,  bool maximized,  String? displayId)  $default,) {final _that = this;
switch (_that) {
case _DesktopWindowGeometry():
return $default(_that.left,_that.top,_that.width,_that.height,_that.maximized,_that.displayId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double left,  double top,  double width,  double height,  bool maximized,  String? displayId)?  $default,) {final _that = this;
switch (_that) {
case _DesktopWindowGeometry() when $default != null:
return $default(_that.left,_that.top,_that.width,_that.height,_that.maximized,_that.displayId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DesktopWindowGeometry implements DesktopWindowGeometry {
  const _DesktopWindowGeometry({required this.left, required this.top, required this.width, required this.height, this.maximized = false, this.displayId});
  factory _DesktopWindowGeometry.fromJson(Map<String, dynamic> json) => _$DesktopWindowGeometryFromJson(json);

@override final  double left;
@override final  double top;
@override final  double width;
@override final  double height;
@override@JsonKey() final  bool maximized;
@override final  String? displayId;

/// Create a copy of DesktopWindowGeometry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DesktopWindowGeometryCopyWith<_DesktopWindowGeometry> get copyWith => __$DesktopWindowGeometryCopyWithImpl<_DesktopWindowGeometry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DesktopWindowGeometryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DesktopWindowGeometry&&(identical(other.left, left) || other.left == left)&&(identical(other.top, top) || other.top == top)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.maximized, maximized) || other.maximized == maximized)&&(identical(other.displayId, displayId) || other.displayId == displayId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,left,top,width,height,maximized,displayId);

@override
String toString() {
  return 'DesktopWindowGeometry(left: $left, top: $top, width: $width, height: $height, maximized: $maximized, displayId: $displayId)';
}


}

/// @nodoc
abstract mixin class _$DesktopWindowGeometryCopyWith<$Res> implements $DesktopWindowGeometryCopyWith<$Res> {
  factory _$DesktopWindowGeometryCopyWith(_DesktopWindowGeometry value, $Res Function(_DesktopWindowGeometry) _then) = __$DesktopWindowGeometryCopyWithImpl;
@override @useResult
$Res call({
 double left, double top, double width, double height, bool maximized, String? displayId
});




}
/// @nodoc
class __$DesktopWindowGeometryCopyWithImpl<$Res>
    implements _$DesktopWindowGeometryCopyWith<$Res> {
  __$DesktopWindowGeometryCopyWithImpl(this._self, this._then);

  final _DesktopWindowGeometry _self;
  final $Res Function(_DesktopWindowGeometry) _then;

/// Create a copy of DesktopWindowGeometry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? left = null,Object? top = null,Object? width = null,Object? height = null,Object? maximized = null,Object? displayId = freezed,}) {
  return _then(_DesktopWindowGeometry(
left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as double,top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as double,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,maximized: null == maximized ? _self.maximized : maximized // ignore: cast_nullable_to_non_nullable
as bool,displayId: freezed == displayId ? _self.displayId : displayId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
