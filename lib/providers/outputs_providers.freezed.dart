// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outputs_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OutputsData {

 String? get type; String? get version; int? get timestamp; List<OutputsReceiver>? get receivers;
/// Create a copy of OutputsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsDataCopyWith<OutputsData> get copyWith => _$OutputsDataCopyWithImpl<OutputsData>(this as OutputsData, _$identity);

  /// Serializes this OutputsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsData&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.receivers, receivers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,version,timestamp,const DeepCollectionEquality().hash(receivers));

@override
String toString() {
  return 'OutputsData(type: $type, version: $version, timestamp: $timestamp, receivers: $receivers)';
}


}

/// @nodoc
abstract mixin class $OutputsDataCopyWith<$Res>  {
  factory $OutputsDataCopyWith(OutputsData value, $Res Function(OutputsData) _then) = _$OutputsDataCopyWithImpl;
@useResult
$Res call({
 String? type, String? version, int? timestamp, List<OutputsReceiver>? receivers
});




}
/// @nodoc
class _$OutputsDataCopyWithImpl<$Res>
    implements $OutputsDataCopyWith<$Res> {
  _$OutputsDataCopyWithImpl(this._self, this._then);

  final OutputsData _self;
  final $Res Function(OutputsData) _then;

/// Create a copy of OutputsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? version = freezed,Object? timestamp = freezed,Object? receivers = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int?,receivers: freezed == receivers ? _self.receivers : receivers // ignore: cast_nullable_to_non_nullable
as List<OutputsReceiver>?,
  ));
}

}


/// Adds pattern-matching-related methods to [OutputsData].
extension OutputsDataPatterns on OutputsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutputsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutputsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutputsData value)  $default,){
final _that = this;
switch (_that) {
case _OutputsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutputsData value)?  $default,){
final _that = this;
switch (_that) {
case _OutputsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  String? version,  int? timestamp,  List<OutputsReceiver>? receivers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutputsData() when $default != null:
return $default(_that.type,_that.version,_that.timestamp,_that.receivers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  String? version,  int? timestamp,  List<OutputsReceiver>? receivers)  $default,) {final _that = this;
switch (_that) {
case _OutputsData():
return $default(_that.type,_that.version,_that.timestamp,_that.receivers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  String? version,  int? timestamp,  List<OutputsReceiver>? receivers)?  $default,) {final _that = this;
switch (_that) {
case _OutputsData() when $default != null:
return $default(_that.type,_that.version,_that.timestamp,_that.receivers);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _OutputsData implements OutputsData {
  const _OutputsData({this.type, this.version, this.timestamp, final  List<OutputsReceiver>? receivers}): _receivers = receivers;
  factory _OutputsData.fromJson(Map<String, dynamic> json) => _$OutputsDataFromJson(json);

@override final  String? type;
@override final  String? version;
@override final  int? timestamp;
 final  List<OutputsReceiver>? _receivers;
@override List<OutputsReceiver>? get receivers {
  final value = _receivers;
  if (value == null) return null;
  if (_receivers is EqualUnmodifiableListView) return _receivers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of OutputsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutputsDataCopyWith<_OutputsData> get copyWith => __$OutputsDataCopyWithImpl<_OutputsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutputsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutputsData&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._receivers, _receivers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,version,timestamp,const DeepCollectionEquality().hash(_receivers));

@override
String toString() {
  return 'OutputsData(type: $type, version: $version, timestamp: $timestamp, receivers: $receivers)';
}


}

/// @nodoc
abstract mixin class _$OutputsDataCopyWith<$Res> implements $OutputsDataCopyWith<$Res> {
  factory _$OutputsDataCopyWith(_OutputsData value, $Res Function(_OutputsData) _then) = __$OutputsDataCopyWithImpl;
@override @useResult
$Res call({
 String? type, String? version, int? timestamp, List<OutputsReceiver>? receivers
});




}
/// @nodoc
class __$OutputsDataCopyWithImpl<$Res>
    implements _$OutputsDataCopyWith<$Res> {
  __$OutputsDataCopyWithImpl(this._self, this._then);

  final _OutputsData _self;
  final $Res Function(_OutputsData) _then;

/// Create a copy of OutputsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? version = freezed,Object? timestamp = freezed,Object? receivers = freezed,}) {
  return _then(_OutputsData(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int?,receivers: freezed == receivers ? _self._receivers : receivers // ignore: cast_nullable_to_non_nullable
as List<OutputsReceiver>?,
  ));
}


}


/// @nodoc
mixin _$OutputsReceiver {

 String? get address; String? get assetId; int? get satoshi; String? get comment;@IntToAccountConverter() Account? get account;
/// Create a copy of OutputsReceiver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsReceiverCopyWith<OutputsReceiver> get copyWith => _$OutputsReceiverCopyWithImpl<OutputsReceiver>(this as OutputsReceiver, _$identity);

  /// Serializes this OutputsReceiver to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsReceiver&&(identical(other.address, address) || other.address == address)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.satoshi, satoshi) || other.satoshi == satoshi)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.account, account) || other.account == account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,assetId,satoshi,comment,account);

@override
String toString() {
  return 'OutputsReceiver(address: $address, assetId: $assetId, satoshi: $satoshi, comment: $comment, account: $account)';
}


}

/// @nodoc
abstract mixin class $OutputsReceiverCopyWith<$Res>  {
  factory $OutputsReceiverCopyWith(OutputsReceiver value, $Res Function(OutputsReceiver) _then) = _$OutputsReceiverCopyWithImpl;
@useResult
$Res call({
 String? address, String? assetId, int? satoshi, String? comment,@IntToAccountConverter() Account? account
});




}
/// @nodoc
class _$OutputsReceiverCopyWithImpl<$Res>
    implements $OutputsReceiverCopyWith<$Res> {
  _$OutputsReceiverCopyWithImpl(this._self, this._then);

  final OutputsReceiver _self;
  final $Res Function(OutputsReceiver) _then;

/// Create a copy of OutputsReceiver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = freezed,Object? assetId = freezed,Object? satoshi = freezed,Object? comment = freezed,Object? account = freezed,}) {
  return _then(_self.copyWith(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,satoshi: freezed == satoshi ? _self.satoshi : satoshi // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account?,
  ));
}

}


/// Adds pattern-matching-related methods to [OutputsReceiver].
extension OutputsReceiverPatterns on OutputsReceiver {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutputsReceiver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutputsReceiver() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutputsReceiver value)  $default,){
final _that = this;
switch (_that) {
case _OutputsReceiver():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutputsReceiver value)?  $default,){
final _that = this;
switch (_that) {
case _OutputsReceiver() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? address,  String? assetId,  int? satoshi,  String? comment, @IntToAccountConverter()  Account? account)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutputsReceiver() when $default != null:
return $default(_that.address,_that.assetId,_that.satoshi,_that.comment,_that.account);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? address,  String? assetId,  int? satoshi,  String? comment, @IntToAccountConverter()  Account? account)  $default,) {final _that = this;
switch (_that) {
case _OutputsReceiver():
return $default(_that.address,_that.assetId,_that.satoshi,_that.comment,_that.account);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? address,  String? assetId,  int? satoshi,  String? comment, @IntToAccountConverter()  Account? account)?  $default,) {final _that = this;
switch (_that) {
case _OutputsReceiver() when $default != null:
return $default(_that.address,_that.assetId,_that.satoshi,_that.comment,_that.account);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false, fieldRename: FieldRename.snake)
class _OutputsReceiver implements OutputsReceiver {
  const _OutputsReceiver({this.address, this.assetId, this.satoshi, this.comment, @IntToAccountConverter() this.account});
  factory _OutputsReceiver.fromJson(Map<String, dynamic> json) => _$OutputsReceiverFromJson(json);

@override final  String? address;
@override final  String? assetId;
@override final  int? satoshi;
@override final  String? comment;
@override@IntToAccountConverter() final  Account? account;

/// Create a copy of OutputsReceiver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutputsReceiverCopyWith<_OutputsReceiver> get copyWith => __$OutputsReceiverCopyWithImpl<_OutputsReceiver>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutputsReceiverToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutputsReceiver&&(identical(other.address, address) || other.address == address)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.satoshi, satoshi) || other.satoshi == satoshi)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.account, account) || other.account == account));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,assetId,satoshi,comment,account);

@override
String toString() {
  return 'OutputsReceiver(address: $address, assetId: $assetId, satoshi: $satoshi, comment: $comment, account: $account)';
}


}

/// @nodoc
abstract mixin class _$OutputsReceiverCopyWith<$Res> implements $OutputsReceiverCopyWith<$Res> {
  factory _$OutputsReceiverCopyWith(_OutputsReceiver value, $Res Function(_OutputsReceiver) _then) = __$OutputsReceiverCopyWithImpl;
@override @useResult
$Res call({
 String? address, String? assetId, int? satoshi, String? comment,@IntToAccountConverter() Account? account
});




}
/// @nodoc
class __$OutputsReceiverCopyWithImpl<$Res>
    implements _$OutputsReceiverCopyWith<$Res> {
  __$OutputsReceiverCopyWithImpl(this._self, this._then);

  final _OutputsReceiver _self;
  final $Res Function(_OutputsReceiver) _then;

/// Create a copy of OutputsReceiver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = freezed,Object? assetId = freezed,Object? satoshi = freezed,Object? comment = freezed,Object? account = freezed,}) {
  return _then(_OutputsReceiver(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,assetId: freezed == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String?,satoshi: freezed == satoshi ? _self.satoshi : satoshi // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as Account?,
  ));
}


}

/// @nodoc
mixin _$OutputsError {

 String? get message;
/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorCopyWith<OutputsError> get copyWith => _$OutputsErrorCopyWithImpl<OutputsError>(this as OutputsError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorCopyWith<$Res>  {
  factory $OutputsErrorCopyWith(OutputsError value, $Res Function(OutputsError) _then) = _$OutputsErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorCopyWithImpl<$Res>
    implements $OutputsErrorCopyWith<$Res> {
  _$OutputsErrorCopyWithImpl(this._self, this._then);

  final OutputsError _self;
  final $Res Function(OutputsError) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OutputsError].
extension OutputsErrorPatterns on OutputsError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OutputsErrorWrongTypeOfFile value)?  wrongTypeOfFile,TResult Function( OutputsErrorWrongVersionOfFile value)?  wrongVersionOfFile,TResult Function( OutputsErrorJsonFileSyntaxError value)?  jsonFileSyntaxError,TResult Function( OutputsErrorFileStructureError value)?  fileStructureError,TResult Function( OutputsErrorOperationCancelled value)?  operationCancelled,TResult Function( OutputsErrorRequiredDataIsEmpty value)?  requiredDataIsEmpty,TResult Function( OutputsErrorOutputsDataIsEmpty value)?  outputsDataIsEmpty,TResult Function( OutputsErrorAssetNotFound value)?  assetNotFound,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OutputsErrorWrongTypeOfFile() when wrongTypeOfFile != null:
return wrongTypeOfFile(_that);case OutputsErrorWrongVersionOfFile() when wrongVersionOfFile != null:
return wrongVersionOfFile(_that);case OutputsErrorJsonFileSyntaxError() when jsonFileSyntaxError != null:
return jsonFileSyntaxError(_that);case OutputsErrorFileStructureError() when fileStructureError != null:
return fileStructureError(_that);case OutputsErrorOperationCancelled() when operationCancelled != null:
return operationCancelled(_that);case OutputsErrorRequiredDataIsEmpty() when requiredDataIsEmpty != null:
return requiredDataIsEmpty(_that);case OutputsErrorOutputsDataIsEmpty() when outputsDataIsEmpty != null:
return outputsDataIsEmpty(_that);case OutputsErrorAssetNotFound() when assetNotFound != null:
return assetNotFound(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OutputsErrorWrongTypeOfFile value)  wrongTypeOfFile,required TResult Function( OutputsErrorWrongVersionOfFile value)  wrongVersionOfFile,required TResult Function( OutputsErrorJsonFileSyntaxError value)  jsonFileSyntaxError,required TResult Function( OutputsErrorFileStructureError value)  fileStructureError,required TResult Function( OutputsErrorOperationCancelled value)  operationCancelled,required TResult Function( OutputsErrorRequiredDataIsEmpty value)  requiredDataIsEmpty,required TResult Function( OutputsErrorOutputsDataIsEmpty value)  outputsDataIsEmpty,required TResult Function( OutputsErrorAssetNotFound value)  assetNotFound,}){
final _that = this;
switch (_that) {
case OutputsErrorWrongTypeOfFile():
return wrongTypeOfFile(_that);case OutputsErrorWrongVersionOfFile():
return wrongVersionOfFile(_that);case OutputsErrorJsonFileSyntaxError():
return jsonFileSyntaxError(_that);case OutputsErrorFileStructureError():
return fileStructureError(_that);case OutputsErrorOperationCancelled():
return operationCancelled(_that);case OutputsErrorRequiredDataIsEmpty():
return requiredDataIsEmpty(_that);case OutputsErrorOutputsDataIsEmpty():
return outputsDataIsEmpty(_that);case OutputsErrorAssetNotFound():
return assetNotFound(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OutputsErrorWrongTypeOfFile value)?  wrongTypeOfFile,TResult? Function( OutputsErrorWrongVersionOfFile value)?  wrongVersionOfFile,TResult? Function( OutputsErrorJsonFileSyntaxError value)?  jsonFileSyntaxError,TResult? Function( OutputsErrorFileStructureError value)?  fileStructureError,TResult? Function( OutputsErrorOperationCancelled value)?  operationCancelled,TResult? Function( OutputsErrorRequiredDataIsEmpty value)?  requiredDataIsEmpty,TResult? Function( OutputsErrorOutputsDataIsEmpty value)?  outputsDataIsEmpty,TResult? Function( OutputsErrorAssetNotFound value)?  assetNotFound,}){
final _that = this;
switch (_that) {
case OutputsErrorWrongTypeOfFile() when wrongTypeOfFile != null:
return wrongTypeOfFile(_that);case OutputsErrorWrongVersionOfFile() when wrongVersionOfFile != null:
return wrongVersionOfFile(_that);case OutputsErrorJsonFileSyntaxError() when jsonFileSyntaxError != null:
return jsonFileSyntaxError(_that);case OutputsErrorFileStructureError() when fileStructureError != null:
return fileStructureError(_that);case OutputsErrorOperationCancelled() when operationCancelled != null:
return operationCancelled(_that);case OutputsErrorRequiredDataIsEmpty() when requiredDataIsEmpty != null:
return requiredDataIsEmpty(_that);case OutputsErrorOutputsDataIsEmpty() when outputsDataIsEmpty != null:
return outputsDataIsEmpty(_that);case OutputsErrorAssetNotFound() when assetNotFound != null:
return assetNotFound(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message)?  wrongTypeOfFile,TResult Function( String? message)?  wrongVersionOfFile,TResult Function( String? message)?  jsonFileSyntaxError,TResult Function( String? message)?  fileStructureError,TResult Function( String? message)?  operationCancelled,TResult Function( String? message)?  requiredDataIsEmpty,TResult Function( String? message)?  outputsDataIsEmpty,TResult Function( String? message)?  assetNotFound,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OutputsErrorWrongTypeOfFile() when wrongTypeOfFile != null:
return wrongTypeOfFile(_that.message);case OutputsErrorWrongVersionOfFile() when wrongVersionOfFile != null:
return wrongVersionOfFile(_that.message);case OutputsErrorJsonFileSyntaxError() when jsonFileSyntaxError != null:
return jsonFileSyntaxError(_that.message);case OutputsErrorFileStructureError() when fileStructureError != null:
return fileStructureError(_that.message);case OutputsErrorOperationCancelled() when operationCancelled != null:
return operationCancelled(_that.message);case OutputsErrorRequiredDataIsEmpty() when requiredDataIsEmpty != null:
return requiredDataIsEmpty(_that.message);case OutputsErrorOutputsDataIsEmpty() when outputsDataIsEmpty != null:
return outputsDataIsEmpty(_that.message);case OutputsErrorAssetNotFound() when assetNotFound != null:
return assetNotFound(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message)  wrongTypeOfFile,required TResult Function( String? message)  wrongVersionOfFile,required TResult Function( String? message)  jsonFileSyntaxError,required TResult Function( String? message)  fileStructureError,required TResult Function( String? message)  operationCancelled,required TResult Function( String? message)  requiredDataIsEmpty,required TResult Function( String? message)  outputsDataIsEmpty,required TResult Function( String? message)  assetNotFound,}) {final _that = this;
switch (_that) {
case OutputsErrorWrongTypeOfFile():
return wrongTypeOfFile(_that.message);case OutputsErrorWrongVersionOfFile():
return wrongVersionOfFile(_that.message);case OutputsErrorJsonFileSyntaxError():
return jsonFileSyntaxError(_that.message);case OutputsErrorFileStructureError():
return fileStructureError(_that.message);case OutputsErrorOperationCancelled():
return operationCancelled(_that.message);case OutputsErrorRequiredDataIsEmpty():
return requiredDataIsEmpty(_that.message);case OutputsErrorOutputsDataIsEmpty():
return outputsDataIsEmpty(_that.message);case OutputsErrorAssetNotFound():
return assetNotFound(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message)?  wrongTypeOfFile,TResult? Function( String? message)?  wrongVersionOfFile,TResult? Function( String? message)?  jsonFileSyntaxError,TResult? Function( String? message)?  fileStructureError,TResult? Function( String? message)?  operationCancelled,TResult? Function( String? message)?  requiredDataIsEmpty,TResult? Function( String? message)?  outputsDataIsEmpty,TResult? Function( String? message)?  assetNotFound,}) {final _that = this;
switch (_that) {
case OutputsErrorWrongTypeOfFile() when wrongTypeOfFile != null:
return wrongTypeOfFile(_that.message);case OutputsErrorWrongVersionOfFile() when wrongVersionOfFile != null:
return wrongVersionOfFile(_that.message);case OutputsErrorJsonFileSyntaxError() when jsonFileSyntaxError != null:
return jsonFileSyntaxError(_that.message);case OutputsErrorFileStructureError() when fileStructureError != null:
return fileStructureError(_that.message);case OutputsErrorOperationCancelled() when operationCancelled != null:
return operationCancelled(_that.message);case OutputsErrorRequiredDataIsEmpty() when requiredDataIsEmpty != null:
return requiredDataIsEmpty(_that.message);case OutputsErrorOutputsDataIsEmpty() when outputsDataIsEmpty != null:
return outputsDataIsEmpty(_that.message);case OutputsErrorAssetNotFound() when assetNotFound != null:
return assetNotFound(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class OutputsErrorWrongTypeOfFile implements OutputsError {
  const OutputsErrorWrongTypeOfFile([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorWrongTypeOfFileCopyWith<OutputsErrorWrongTypeOfFile> get copyWith => _$OutputsErrorWrongTypeOfFileCopyWithImpl<OutputsErrorWrongTypeOfFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorWrongTypeOfFile&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.wrongTypeOfFile(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorWrongTypeOfFileCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorWrongTypeOfFileCopyWith(OutputsErrorWrongTypeOfFile value, $Res Function(OutputsErrorWrongTypeOfFile) _then) = _$OutputsErrorWrongTypeOfFileCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorWrongTypeOfFileCopyWithImpl<$Res>
    implements $OutputsErrorWrongTypeOfFileCopyWith<$Res> {
  _$OutputsErrorWrongTypeOfFileCopyWithImpl(this._self, this._then);

  final OutputsErrorWrongTypeOfFile _self;
  final $Res Function(OutputsErrorWrongTypeOfFile) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorWrongTypeOfFile(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OutputsErrorWrongVersionOfFile implements OutputsError {
  const OutputsErrorWrongVersionOfFile([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorWrongVersionOfFileCopyWith<OutputsErrorWrongVersionOfFile> get copyWith => _$OutputsErrorWrongVersionOfFileCopyWithImpl<OutputsErrorWrongVersionOfFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorWrongVersionOfFile&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.wrongVersionOfFile(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorWrongVersionOfFileCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorWrongVersionOfFileCopyWith(OutputsErrorWrongVersionOfFile value, $Res Function(OutputsErrorWrongVersionOfFile) _then) = _$OutputsErrorWrongVersionOfFileCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorWrongVersionOfFileCopyWithImpl<$Res>
    implements $OutputsErrorWrongVersionOfFileCopyWith<$Res> {
  _$OutputsErrorWrongVersionOfFileCopyWithImpl(this._self, this._then);

  final OutputsErrorWrongVersionOfFile _self;
  final $Res Function(OutputsErrorWrongVersionOfFile) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorWrongVersionOfFile(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OutputsErrorJsonFileSyntaxError implements OutputsError {
  const OutputsErrorJsonFileSyntaxError([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorJsonFileSyntaxErrorCopyWith<OutputsErrorJsonFileSyntaxError> get copyWith => _$OutputsErrorJsonFileSyntaxErrorCopyWithImpl<OutputsErrorJsonFileSyntaxError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorJsonFileSyntaxError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.jsonFileSyntaxError(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorJsonFileSyntaxErrorCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorJsonFileSyntaxErrorCopyWith(OutputsErrorJsonFileSyntaxError value, $Res Function(OutputsErrorJsonFileSyntaxError) _then) = _$OutputsErrorJsonFileSyntaxErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorJsonFileSyntaxErrorCopyWithImpl<$Res>
    implements $OutputsErrorJsonFileSyntaxErrorCopyWith<$Res> {
  _$OutputsErrorJsonFileSyntaxErrorCopyWithImpl(this._self, this._then);

  final OutputsErrorJsonFileSyntaxError _self;
  final $Res Function(OutputsErrorJsonFileSyntaxError) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorJsonFileSyntaxError(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OutputsErrorFileStructureError implements OutputsError {
  const OutputsErrorFileStructureError([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorFileStructureErrorCopyWith<OutputsErrorFileStructureError> get copyWith => _$OutputsErrorFileStructureErrorCopyWithImpl<OutputsErrorFileStructureError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorFileStructureError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.fileStructureError(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorFileStructureErrorCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorFileStructureErrorCopyWith(OutputsErrorFileStructureError value, $Res Function(OutputsErrorFileStructureError) _then) = _$OutputsErrorFileStructureErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorFileStructureErrorCopyWithImpl<$Res>
    implements $OutputsErrorFileStructureErrorCopyWith<$Res> {
  _$OutputsErrorFileStructureErrorCopyWithImpl(this._self, this._then);

  final OutputsErrorFileStructureError _self;
  final $Res Function(OutputsErrorFileStructureError) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorFileStructureError(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OutputsErrorOperationCancelled implements OutputsError {
  const OutputsErrorOperationCancelled([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorOperationCancelledCopyWith<OutputsErrorOperationCancelled> get copyWith => _$OutputsErrorOperationCancelledCopyWithImpl<OutputsErrorOperationCancelled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorOperationCancelled&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.operationCancelled(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorOperationCancelledCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorOperationCancelledCopyWith(OutputsErrorOperationCancelled value, $Res Function(OutputsErrorOperationCancelled) _then) = _$OutputsErrorOperationCancelledCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorOperationCancelledCopyWithImpl<$Res>
    implements $OutputsErrorOperationCancelledCopyWith<$Res> {
  _$OutputsErrorOperationCancelledCopyWithImpl(this._self, this._then);

  final OutputsErrorOperationCancelled _self;
  final $Res Function(OutputsErrorOperationCancelled) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorOperationCancelled(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OutputsErrorRequiredDataIsEmpty implements OutputsError {
  const OutputsErrorRequiredDataIsEmpty([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorRequiredDataIsEmptyCopyWith<OutputsErrorRequiredDataIsEmpty> get copyWith => _$OutputsErrorRequiredDataIsEmptyCopyWithImpl<OutputsErrorRequiredDataIsEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorRequiredDataIsEmpty&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.requiredDataIsEmpty(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorRequiredDataIsEmptyCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorRequiredDataIsEmptyCopyWith(OutputsErrorRequiredDataIsEmpty value, $Res Function(OutputsErrorRequiredDataIsEmpty) _then) = _$OutputsErrorRequiredDataIsEmptyCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorRequiredDataIsEmptyCopyWithImpl<$Res>
    implements $OutputsErrorRequiredDataIsEmptyCopyWith<$Res> {
  _$OutputsErrorRequiredDataIsEmptyCopyWithImpl(this._self, this._then);

  final OutputsErrorRequiredDataIsEmpty _self;
  final $Res Function(OutputsErrorRequiredDataIsEmpty) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorRequiredDataIsEmpty(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OutputsErrorOutputsDataIsEmpty implements OutputsError {
  const OutputsErrorOutputsDataIsEmpty([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorOutputsDataIsEmptyCopyWith<OutputsErrorOutputsDataIsEmpty> get copyWith => _$OutputsErrorOutputsDataIsEmptyCopyWithImpl<OutputsErrorOutputsDataIsEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorOutputsDataIsEmpty&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.outputsDataIsEmpty(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorOutputsDataIsEmptyCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorOutputsDataIsEmptyCopyWith(OutputsErrorOutputsDataIsEmpty value, $Res Function(OutputsErrorOutputsDataIsEmpty) _then) = _$OutputsErrorOutputsDataIsEmptyCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorOutputsDataIsEmptyCopyWithImpl<$Res>
    implements $OutputsErrorOutputsDataIsEmptyCopyWith<$Res> {
  _$OutputsErrorOutputsDataIsEmptyCopyWithImpl(this._self, this._then);

  final OutputsErrorOutputsDataIsEmpty _self;
  final $Res Function(OutputsErrorOutputsDataIsEmpty) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorOutputsDataIsEmpty(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class OutputsErrorAssetNotFound implements OutputsError {
  const OutputsErrorAssetNotFound([this.message]);
  

@override final  String? message;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutputsErrorAssetNotFoundCopyWith<OutputsErrorAssetNotFound> get copyWith => _$OutputsErrorAssetNotFoundCopyWithImpl<OutputsErrorAssetNotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutputsErrorAssetNotFound&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OutputsError.assetNotFound(message: $message)';
}


}

/// @nodoc
abstract mixin class $OutputsErrorAssetNotFoundCopyWith<$Res> implements $OutputsErrorCopyWith<$Res> {
  factory $OutputsErrorAssetNotFoundCopyWith(OutputsErrorAssetNotFound value, $Res Function(OutputsErrorAssetNotFound) _then) = _$OutputsErrorAssetNotFoundCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$OutputsErrorAssetNotFoundCopyWithImpl<$Res>
    implements $OutputsErrorAssetNotFoundCopyWith<$Res> {
  _$OutputsErrorAssetNotFoundCopyWithImpl(this._self, this._then);

  final OutputsErrorAssetNotFound _self;
  final $Res Function(OutputsErrorAssetNotFound) _then;

/// Create a copy of OutputsError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(OutputsErrorAssetNotFound(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
