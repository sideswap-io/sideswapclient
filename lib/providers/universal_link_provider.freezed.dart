// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'universal_link_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LinkResultDetails implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultDetails'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultDetails);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultDetails()';
}


}

/// @nodoc
class $LinkResultDetailsCopyWith<$Res>  {
$LinkResultDetailsCopyWith(LinkResultDetails _, $Res Function(LinkResultDetails) __);
}


/// Adds pattern-matching-related methods to [LinkResultDetails].
extension LinkResultDetailsPatterns on LinkResultDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LinkResultDetailsSwap value)?  swap,TResult Function( LinkResultDetailsSwaption value)?  swaption,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LinkResultDetailsSwap() when swap != null:
return swap(_that);case LinkResultDetailsSwaption() when swaption != null:
return swaption(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LinkResultDetailsSwap value)  swap,required TResult Function( LinkResultDetailsSwaption value)  swaption,}){
final _that = this;
switch (_that) {
case LinkResultDetailsSwap():
return swap(_that);case LinkResultDetailsSwaption():
return swaption(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LinkResultDetailsSwap value)?  swap,TResult? Function( LinkResultDetailsSwaption value)?  swaption,}){
final _that = this;
switch (_that) {
case LinkResultDetailsSwap() when swap != null:
return swap(_that);case LinkResultDetailsSwaption() when swaption != null:
return swaption(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? orderId,  String? privateId)?  swap,TResult Function( Uri? uri)?  swaption,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LinkResultDetailsSwap() when swap != null:
return swap(_that.orderId,_that.privateId);case LinkResultDetailsSwaption() when swaption != null:
return swaption(_that.uri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? orderId,  String? privateId)  swap,required TResult Function( Uri? uri)  swaption,}) {final _that = this;
switch (_that) {
case LinkResultDetailsSwap():
return swap(_that.orderId,_that.privateId);case LinkResultDetailsSwaption():
return swaption(_that.uri);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? orderId,  String? privateId)?  swap,TResult? Function( Uri? uri)?  swaption,}) {final _that = this;
switch (_that) {
case LinkResultDetailsSwap() when swap != null:
return swap(_that.orderId,_that.privateId);case LinkResultDetailsSwaption() when swaption != null:
return swaption(_that.uri);case _:
  return null;

}
}

}

/// @nodoc


class LinkResultDetailsSwap with DiagnosticableTreeMixin implements LinkResultDetails {
  const LinkResultDetailsSwap({this.orderId, this.privateId});
  

 final  String? orderId;
 final  String? privateId;

/// Create a copy of LinkResultDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkResultDetailsSwapCopyWith<LinkResultDetailsSwap> get copyWith => _$LinkResultDetailsSwapCopyWithImpl<LinkResultDetailsSwap>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultDetails.swap'))
    ..add(DiagnosticsProperty('orderId', orderId))..add(DiagnosticsProperty('privateId', privateId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultDetailsSwap&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.privateId, privateId) || other.privateId == privateId));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,privateId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultDetails.swap(orderId: $orderId, privateId: $privateId)';
}


}

/// @nodoc
abstract mixin class $LinkResultDetailsSwapCopyWith<$Res> implements $LinkResultDetailsCopyWith<$Res> {
  factory $LinkResultDetailsSwapCopyWith(LinkResultDetailsSwap value, $Res Function(LinkResultDetailsSwap) _then) = _$LinkResultDetailsSwapCopyWithImpl;
@useResult
$Res call({
 String? orderId, String? privateId
});




}
/// @nodoc
class _$LinkResultDetailsSwapCopyWithImpl<$Res>
    implements $LinkResultDetailsSwapCopyWith<$Res> {
  _$LinkResultDetailsSwapCopyWithImpl(this._self, this._then);

  final LinkResultDetailsSwap _self;
  final $Res Function(LinkResultDetailsSwap) _then;

/// Create a copy of LinkResultDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderId = freezed,Object? privateId = freezed,}) {
  return _then(LinkResultDetailsSwap(
orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,privateId: freezed == privateId ? _self.privateId : privateId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class LinkResultDetailsSwaption with DiagnosticableTreeMixin implements LinkResultDetails {
  const LinkResultDetailsSwaption({this.uri});
  

 final  Uri? uri;

/// Create a copy of LinkResultDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkResultDetailsSwaptionCopyWith<LinkResultDetailsSwaption> get copyWith => _$LinkResultDetailsSwaptionCopyWithImpl<LinkResultDetailsSwaption>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultDetails.swaption'))
    ..add(DiagnosticsProperty('uri', uri));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultDetailsSwaption&&(identical(other.uri, uri) || other.uri == uri));
}


@override
int get hashCode => Object.hash(runtimeType,uri);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultDetails.swaption(uri: $uri)';
}


}

/// @nodoc
abstract mixin class $LinkResultDetailsSwaptionCopyWith<$Res> implements $LinkResultDetailsCopyWith<$Res> {
  factory $LinkResultDetailsSwaptionCopyWith(LinkResultDetailsSwaption value, $Res Function(LinkResultDetailsSwaption) _then) = _$LinkResultDetailsSwaptionCopyWithImpl;
@useResult
$Res call({
 Uri? uri
});




}
/// @nodoc
class _$LinkResultDetailsSwaptionCopyWithImpl<$Res>
    implements $LinkResultDetailsSwaptionCopyWith<$Res> {
  _$LinkResultDetailsSwaptionCopyWithImpl(this._self, this._then);

  final LinkResultDetailsSwaption _self;
  final $Res Function(LinkResultDetailsSwaption) _then;

/// Create a copy of LinkResultDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uri = freezed,}) {
  return _then(LinkResultDetailsSwaption(
uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri?,
  ));
}


}

/// @nodoc
mixin _$LinkResultState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState()';
}


}

/// @nodoc
class $LinkResultStateCopyWith<$Res>  {
$LinkResultStateCopyWith(LinkResultState _, $Res Function(LinkResultState) __);
}


/// Adds pattern-matching-related methods to [LinkResultState].
extension LinkResultStatePatterns on LinkResultState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LinkResultStateEmpty value)?  empty,TResult Function( LinkResultStateUnknown value)?  unknown,TResult Function( LinkResultStateUnknownUri value)?  unknownUri,TResult Function( LinkResultStateUnknownScheme value)?  unknownScheme,TResult Function( LinkResultStateUnknownHost value)?  unknownHost,TResult Function( LinkResultStateFailed value)?  failed,TResult Function( LinkResultStateFailedUriPath value)?  failedUriPath,TResult Function( LinkResultStateSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LinkResultStateEmpty() when empty != null:
return empty(_that);case LinkResultStateUnknown() when unknown != null:
return unknown(_that);case LinkResultStateUnknownUri() when unknownUri != null:
return unknownUri(_that);case LinkResultStateUnknownScheme() when unknownScheme != null:
return unknownScheme(_that);case LinkResultStateUnknownHost() when unknownHost != null:
return unknownHost(_that);case LinkResultStateFailed() when failed != null:
return failed(_that);case LinkResultStateFailedUriPath() when failedUriPath != null:
return failedUriPath(_that);case LinkResultStateSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LinkResultStateEmpty value)  empty,required TResult Function( LinkResultStateUnknown value)  unknown,required TResult Function( LinkResultStateUnknownUri value)  unknownUri,required TResult Function( LinkResultStateUnknownScheme value)  unknownScheme,required TResult Function( LinkResultStateUnknownHost value)  unknownHost,required TResult Function( LinkResultStateFailed value)  failed,required TResult Function( LinkResultStateFailedUriPath value)  failedUriPath,required TResult Function( LinkResultStateSuccess value)  success,}){
final _that = this;
switch (_that) {
case LinkResultStateEmpty():
return empty(_that);case LinkResultStateUnknown():
return unknown(_that);case LinkResultStateUnknownUri():
return unknownUri(_that);case LinkResultStateUnknownScheme():
return unknownScheme(_that);case LinkResultStateUnknownHost():
return unknownHost(_that);case LinkResultStateFailed():
return failed(_that);case LinkResultStateFailedUriPath():
return failedUriPath(_that);case LinkResultStateSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LinkResultStateEmpty value)?  empty,TResult? Function( LinkResultStateUnknown value)?  unknown,TResult? Function( LinkResultStateUnknownUri value)?  unknownUri,TResult? Function( LinkResultStateUnknownScheme value)?  unknownScheme,TResult? Function( LinkResultStateUnknownHost value)?  unknownHost,TResult? Function( LinkResultStateFailed value)?  failed,TResult? Function( LinkResultStateFailedUriPath value)?  failedUriPath,TResult? Function( LinkResultStateSuccess value)?  success,}){
final _that = this;
switch (_that) {
case LinkResultStateEmpty() when empty != null:
return empty(_that);case LinkResultStateUnknown() when unknown != null:
return unknown(_that);case LinkResultStateUnknownUri() when unknownUri != null:
return unknownUri(_that);case LinkResultStateUnknownScheme() when unknownScheme != null:
return unknownScheme(_that);case LinkResultStateUnknownHost() when unknownHost != null:
return unknownHost(_that);case LinkResultStateFailed() when failed != null:
return failed(_that);case LinkResultStateFailedUriPath() when failedUriPath != null:
return failedUriPath(_that);case LinkResultStateSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function()?  unknown,TResult Function()?  unknownUri,TResult Function()?  unknownScheme,TResult Function()?  unknownHost,TResult Function()?  failed,TResult Function()?  failedUriPath,TResult Function( LinkResultDetails? details)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LinkResultStateEmpty() when empty != null:
return empty();case LinkResultStateUnknown() when unknown != null:
return unknown();case LinkResultStateUnknownUri() when unknownUri != null:
return unknownUri();case LinkResultStateUnknownScheme() when unknownScheme != null:
return unknownScheme();case LinkResultStateUnknownHost() when unknownHost != null:
return unknownHost();case LinkResultStateFailed() when failed != null:
return failed();case LinkResultStateFailedUriPath() when failedUriPath != null:
return failedUriPath();case LinkResultStateSuccess() when success != null:
return success(_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function()  unknown,required TResult Function()  unknownUri,required TResult Function()  unknownScheme,required TResult Function()  unknownHost,required TResult Function()  failed,required TResult Function()  failedUriPath,required TResult Function( LinkResultDetails? details)  success,}) {final _that = this;
switch (_that) {
case LinkResultStateEmpty():
return empty();case LinkResultStateUnknown():
return unknown();case LinkResultStateUnknownUri():
return unknownUri();case LinkResultStateUnknownScheme():
return unknownScheme();case LinkResultStateUnknownHost():
return unknownHost();case LinkResultStateFailed():
return failed();case LinkResultStateFailedUriPath():
return failedUriPath();case LinkResultStateSuccess():
return success(_that.details);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function()?  unknown,TResult? Function()?  unknownUri,TResult? Function()?  unknownScheme,TResult? Function()?  unknownHost,TResult? Function()?  failed,TResult? Function()?  failedUriPath,TResult? Function( LinkResultDetails? details)?  success,}) {final _that = this;
switch (_that) {
case LinkResultStateEmpty() when empty != null:
return empty();case LinkResultStateUnknown() when unknown != null:
return unknown();case LinkResultStateUnknownUri() when unknownUri != null:
return unknownUri();case LinkResultStateUnknownScheme() when unknownScheme != null:
return unknownScheme();case LinkResultStateUnknownHost() when unknownHost != null:
return unknownHost();case LinkResultStateFailed() when failed != null:
return failed();case LinkResultStateFailedUriPath() when failedUriPath != null:
return failedUriPath();case LinkResultStateSuccess() when success != null:
return success(_that.details);case _:
  return null;

}
}

}

/// @nodoc


class LinkResultStateEmpty with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateEmpty();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.empty'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.empty()';
}


}




/// @nodoc


class LinkResultStateUnknown with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateUnknown();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.unknown'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.unknown()';
}


}




/// @nodoc


class LinkResultStateUnknownUri with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateUnknownUri();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.unknownUri'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateUnknownUri);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.unknownUri()';
}


}




/// @nodoc


class LinkResultStateUnknownScheme with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateUnknownScheme();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.unknownScheme'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateUnknownScheme);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.unknownScheme()';
}


}




/// @nodoc


class LinkResultStateUnknownHost with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateUnknownHost();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.unknownHost'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateUnknownHost);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.unknownHost()';
}


}




/// @nodoc


class LinkResultStateFailed with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateFailed();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.failed'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.failed()';
}


}




/// @nodoc


class LinkResultStateFailedUriPath with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateFailedUriPath();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.failedUriPath'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateFailedUriPath);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.failedUriPath()';
}


}




/// @nodoc


class LinkResultStateSuccess with DiagnosticableTreeMixin implements LinkResultState {
  const LinkResultStateSuccess({this.details});
  

 final  LinkResultDetails? details;

/// Create a copy of LinkResultState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkResultStateSuccessCopyWith<LinkResultStateSuccess> get copyWith => _$LinkResultStateSuccessCopyWithImpl<LinkResultStateSuccess>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultState.success'))
    ..add(DiagnosticsProperty('details', details));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultStateSuccess&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,details);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultState.success(details: $details)';
}


}

/// @nodoc
abstract mixin class $LinkResultStateSuccessCopyWith<$Res> implements $LinkResultStateCopyWith<$Res> {
  factory $LinkResultStateSuccessCopyWith(LinkResultStateSuccess value, $Res Function(LinkResultStateSuccess) _then) = _$LinkResultStateSuccessCopyWithImpl;
@useResult
$Res call({
 LinkResultDetails? details
});


$LinkResultDetailsCopyWith<$Res>? get details;

}
/// @nodoc
class _$LinkResultStateSuccessCopyWithImpl<$Res>
    implements $LinkResultStateSuccessCopyWith<$Res> {
  _$LinkResultStateSuccessCopyWithImpl(this._self, this._then);

  final LinkResultStateSuccess _self;
  final $Res Function(LinkResultStateSuccess) _then;

/// Create a copy of LinkResultState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? details = freezed,}) {
  return _then(LinkResultStateSuccess(
details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as LinkResultDetails?,
  ));
}

/// Create a copy of LinkResultState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LinkResultDetailsCopyWith<$Res>? get details {
    if (_self.details == null) {
    return null;
  }

  return $LinkResultDetailsCopyWith<$Res>(_self.details!, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

// dart format on
