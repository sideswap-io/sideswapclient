// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qrcode_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrCodeResultModel {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCodeResultModel);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QrCodeResultModel()';
}


}

/// @nodoc
class $QrCodeResultModelCopyWith<$Res>  {
$QrCodeResultModelCopyWith(QrCodeResultModel _, $Res Function(QrCodeResultModel) __);
}


/// Adds pattern-matching-related methods to [QrCodeResultModel].
extension QrCodeResultModelPatterns on QrCodeResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( QrCodeResultModelEmpty value)?  empty,TResult Function( QrCodeResultModelData value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case QrCodeResultModelEmpty() when empty != null:
return empty(_that);case QrCodeResultModelData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( QrCodeResultModelEmpty value)  empty,required TResult Function( QrCodeResultModelData value)  data,}){
final _that = this;
switch (_that) {
case QrCodeResultModelEmpty():
return empty(_that);case QrCodeResultModelData():
return data(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( QrCodeResultModelEmpty value)?  empty,TResult? Function( QrCodeResultModelData value)?  data,}){
final _that = this;
switch (_that) {
case QrCodeResultModelEmpty() when empty != null:
return empty(_that);case QrCodeResultModelData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( QrCodeResult? result)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case QrCodeResultModelEmpty() when empty != null:
return empty();case QrCodeResultModelData() when data != null:
return data(_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( QrCodeResult? result)  data,}) {final _that = this;
switch (_that) {
case QrCodeResultModelEmpty():
return empty();case QrCodeResultModelData():
return data(_that.result);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( QrCodeResult? result)?  data,}) {final _that = this;
switch (_that) {
case QrCodeResultModelEmpty() when empty != null:
return empty();case QrCodeResultModelData() when data != null:
return data(_that.result);case _:
  return null;

}
}

}

/// @nodoc


class QrCodeResultModelEmpty implements QrCodeResultModel {
  const QrCodeResultModelEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCodeResultModelEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'QrCodeResultModel.empty()';
}


}




/// @nodoc


class QrCodeResultModelData implements QrCodeResultModel {
  const QrCodeResultModelData({this.result});
  

 final  QrCodeResult? result;

/// Create a copy of QrCodeResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrCodeResultModelDataCopyWith<QrCodeResultModelData> get copyWith => _$QrCodeResultModelDataCopyWithImpl<QrCodeResultModelData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrCodeResultModelData&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,result);

@override
String toString() {
  return 'QrCodeResultModel.data(result: $result)';
}


}

/// @nodoc
abstract mixin class $QrCodeResultModelDataCopyWith<$Res> implements $QrCodeResultModelCopyWith<$Res> {
  factory $QrCodeResultModelDataCopyWith(QrCodeResultModelData value, $Res Function(QrCodeResultModelData) _then) = _$QrCodeResultModelDataCopyWithImpl;
@useResult
$Res call({
 QrCodeResult? result
});




}
/// @nodoc
class _$QrCodeResultModelDataCopyWithImpl<$Res>
    implements $QrCodeResultModelDataCopyWith<$Res> {
  _$QrCodeResultModelDataCopyWithImpl(this._self, this._then);

  final QrCodeResultModelData _self;
  final $Res Function(QrCodeResultModelData) _then;

/// Create a copy of QrCodeResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? result = freezed,}) {
  return _then(QrCodeResultModelData(
result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as QrCodeResult?,
  ));
}


}

// dart format on
