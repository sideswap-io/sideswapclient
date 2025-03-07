// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 String? get orderId; String? get privateId;
/// Create a copy of LinkResultDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LinkResultDetailsCopyWith<LinkResultDetails> get copyWith => _$LinkResultDetailsCopyWithImpl<LinkResultDetails>(this as LinkResultDetails, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LinkResultDetails'))
    ..add(DiagnosticsProperty('orderId', orderId))..add(DiagnosticsProperty('privateId', privateId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LinkResultDetails&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.privateId, privateId) || other.privateId == privateId));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,privateId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LinkResultDetails(orderId: $orderId, privateId: $privateId)';
}


}

/// @nodoc
abstract mixin class $LinkResultDetailsCopyWith<$Res>  {
  factory $LinkResultDetailsCopyWith(LinkResultDetails value, $Res Function(LinkResultDetails) _then) = _$LinkResultDetailsCopyWithImpl;
@useResult
$Res call({
 String? orderId, String? privateId
});




}
/// @nodoc
class _$LinkResultDetailsCopyWithImpl<$Res>
    implements $LinkResultDetailsCopyWith<$Res> {
  _$LinkResultDetailsCopyWithImpl(this._self, this._then);

  final LinkResultDetails _self;
  final $Res Function(LinkResultDetails) _then;

/// Create a copy of LinkResultDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = freezed,Object? privateId = freezed,}) {
  return _then(_self.copyWith(
orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,privateId: freezed == privateId ? _self.privateId : privateId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class LinkResultDetailsSwap with DiagnosticableTreeMixin implements LinkResultDetails {
  const LinkResultDetailsSwap({this.orderId, this.privateId});
  

@override final  String? orderId;
@override final  String? privateId;

/// Create a copy of LinkResultDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
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
@override @useResult
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
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = freezed,Object? privateId = freezed,}) {
  return _then(LinkResultDetailsSwap(
orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,privateId: freezed == privateId ? _self.privateId : privateId // ignore: cast_nullable_to_non_nullable
as String?,
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
