// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'universal_link_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LinkResultDetails {
  String? get orderId => throw _privateConstructorUsedError;
  String? get privateId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? orderId, String? privateId) swap,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? orderId, String? privateId)? swap,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? orderId, String? privateId)? swap,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultDetailsSwap value) swap,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultDetailsSwap value)? swap,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultDetailsSwap value)? swap,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of LinkResultDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LinkResultDetailsCopyWith<LinkResultDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkResultDetailsCopyWith<$Res> {
  factory $LinkResultDetailsCopyWith(
    LinkResultDetails value,
    $Res Function(LinkResultDetails) then,
  ) = _$LinkResultDetailsCopyWithImpl<$Res, LinkResultDetails>;
  @useResult
  $Res call({String? orderId, String? privateId});
}

/// @nodoc
class _$LinkResultDetailsCopyWithImpl<$Res, $Val extends LinkResultDetails>
    implements $LinkResultDetailsCopyWith<$Res> {
  _$LinkResultDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkResultDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orderId = freezed, Object? privateId = freezed}) {
    return _then(
      _value.copyWith(
            orderId:
                freezed == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as String?,
            privateId:
                freezed == privateId
                    ? _value.privateId
                    : privateId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LinkResultDetailsSwapImplCopyWith<$Res>
    implements $LinkResultDetailsCopyWith<$Res> {
  factory _$$LinkResultDetailsSwapImplCopyWith(
    _$LinkResultDetailsSwapImpl value,
    $Res Function(_$LinkResultDetailsSwapImpl) then,
  ) = __$$LinkResultDetailsSwapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? orderId, String? privateId});
}

/// @nodoc
class __$$LinkResultDetailsSwapImplCopyWithImpl<$Res>
    extends _$LinkResultDetailsCopyWithImpl<$Res, _$LinkResultDetailsSwapImpl>
    implements _$$LinkResultDetailsSwapImplCopyWith<$Res> {
  __$$LinkResultDetailsSwapImplCopyWithImpl(
    _$LinkResultDetailsSwapImpl _value,
    $Res Function(_$LinkResultDetailsSwapImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orderId = freezed, Object? privateId = freezed}) {
    return _then(
      _$LinkResultDetailsSwapImpl(
        orderId:
            freezed == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as String?,
        privateId:
            freezed == privateId
                ? _value.privateId
                : privateId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$LinkResultDetailsSwapImpl
    with DiagnosticableTreeMixin
    implements LinkResultDetailsSwap {
  const _$LinkResultDetailsSwapImpl({this.orderId, this.privateId});

  @override
  final String? orderId;
  @override
  final String? privateId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultDetails.swap(orderId: $orderId, privateId: $privateId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LinkResultDetails.swap'))
      ..add(DiagnosticsProperty('orderId', orderId))
      ..add(DiagnosticsProperty('privateId', privateId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultDetailsSwapImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.privateId, privateId) ||
                other.privateId == privateId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId, privateId);

  /// Create a copy of LinkResultDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkResultDetailsSwapImplCopyWith<_$LinkResultDetailsSwapImpl>
  get copyWith =>
      __$$LinkResultDetailsSwapImplCopyWithImpl<_$LinkResultDetailsSwapImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? orderId, String? privateId) swap,
  }) {
    return swap(orderId, privateId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? orderId, String? privateId)? swap,
  }) {
    return swap?.call(orderId, privateId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? orderId, String? privateId)? swap,
    required TResult orElse(),
  }) {
    if (swap != null) {
      return swap(orderId, privateId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultDetailsSwap value) swap,
  }) {
    return swap(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultDetailsSwap value)? swap,
  }) {
    return swap?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultDetailsSwap value)? swap,
    required TResult orElse(),
  }) {
    if (swap != null) {
      return swap(this);
    }
    return orElse();
  }
}

abstract class LinkResultDetailsSwap implements LinkResultDetails {
  const factory LinkResultDetailsSwap({
    final String? orderId,
    final String? privateId,
  }) = _$LinkResultDetailsSwapImpl;

  @override
  String? get orderId;
  @override
  String? get privateId;

  /// Create a copy of LinkResultDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkResultDetailsSwapImplCopyWith<_$LinkResultDetailsSwapImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LinkResultState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LinkResultStateCopyWith<$Res> {
  factory $LinkResultStateCopyWith(
    LinkResultState value,
    $Res Function(LinkResultState) then,
  ) = _$LinkResultStateCopyWithImpl<$Res, LinkResultState>;
}

/// @nodoc
class _$LinkResultStateCopyWithImpl<$Res, $Val extends LinkResultState>
    implements $LinkResultStateCopyWith<$Res> {
  _$LinkResultStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LinkResultStateEmptyImplCopyWith<$Res> {
  factory _$$LinkResultStateEmptyImplCopyWith(
    _$LinkResultStateEmptyImpl value,
    $Res Function(_$LinkResultStateEmptyImpl) then,
  ) = __$$LinkResultStateEmptyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LinkResultStateEmptyImplCopyWithImpl<$Res>
    extends _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateEmptyImpl>
    implements _$$LinkResultStateEmptyImplCopyWith<$Res> {
  __$$LinkResultStateEmptyImplCopyWithImpl(
    _$LinkResultStateEmptyImpl _value,
    $Res Function(_$LinkResultStateEmptyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LinkResultStateEmptyImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateEmpty {
  const _$LinkResultStateEmptyImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.empty()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'LinkResultState.empty'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateEmptyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
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
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateEmpty implements LinkResultState {
  const factory LinkResultStateEmpty() = _$LinkResultStateEmptyImpl;
}

/// @nodoc
abstract class _$$LinkResultStateUnknownImplCopyWith<$Res> {
  factory _$$LinkResultStateUnknownImplCopyWith(
    _$LinkResultStateUnknownImpl value,
    $Res Function(_$LinkResultStateUnknownImpl) then,
  ) = __$$LinkResultStateUnknownImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LinkResultStateUnknownImplCopyWithImpl<$Res>
    extends _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateUnknownImpl>
    implements _$$LinkResultStateUnknownImplCopyWith<$Res> {
  __$$LinkResultStateUnknownImplCopyWithImpl(
    _$LinkResultStateUnknownImpl _value,
    $Res Function(_$LinkResultStateUnknownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LinkResultStateUnknownImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateUnknown {
  const _$LinkResultStateUnknownImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.unknown()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'LinkResultState.unknown'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateUnknownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateUnknown implements LinkResultState {
  const factory LinkResultStateUnknown() = _$LinkResultStateUnknownImpl;
}

/// @nodoc
abstract class _$$LinkResultStateUnknownUriImplCopyWith<$Res> {
  factory _$$LinkResultStateUnknownUriImplCopyWith(
    _$LinkResultStateUnknownUriImpl value,
    $Res Function(_$LinkResultStateUnknownUriImpl) then,
  ) = __$$LinkResultStateUnknownUriImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LinkResultStateUnknownUriImplCopyWithImpl<$Res>
    extends _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateUnknownUriImpl>
    implements _$$LinkResultStateUnknownUriImplCopyWith<$Res> {
  __$$LinkResultStateUnknownUriImplCopyWithImpl(
    _$LinkResultStateUnknownUriImpl _value,
    $Res Function(_$LinkResultStateUnknownUriImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LinkResultStateUnknownUriImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateUnknownUri {
  const _$LinkResultStateUnknownUriImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.unknownUri()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'LinkResultState.unknownUri'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateUnknownUriImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return unknownUri();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return unknownUri?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) {
    if (unknownUri != null) {
      return unknownUri();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return unknownUri(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return unknownUri?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (unknownUri != null) {
      return unknownUri(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateUnknownUri implements LinkResultState {
  const factory LinkResultStateUnknownUri() = _$LinkResultStateUnknownUriImpl;
}

/// @nodoc
abstract class _$$LinkResultStateUnknownSchemeImplCopyWith<$Res> {
  factory _$$LinkResultStateUnknownSchemeImplCopyWith(
    _$LinkResultStateUnknownSchemeImpl value,
    $Res Function(_$LinkResultStateUnknownSchemeImpl) then,
  ) = __$$LinkResultStateUnknownSchemeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LinkResultStateUnknownSchemeImplCopyWithImpl<$Res>
    extends
        _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateUnknownSchemeImpl>
    implements _$$LinkResultStateUnknownSchemeImplCopyWith<$Res> {
  __$$LinkResultStateUnknownSchemeImplCopyWithImpl(
    _$LinkResultStateUnknownSchemeImpl _value,
    $Res Function(_$LinkResultStateUnknownSchemeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LinkResultStateUnknownSchemeImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateUnknownScheme {
  const _$LinkResultStateUnknownSchemeImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.unknownScheme()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LinkResultState.unknownScheme'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateUnknownSchemeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return unknownScheme();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return unknownScheme?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) {
    if (unknownScheme != null) {
      return unknownScheme();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return unknownScheme(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return unknownScheme?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (unknownScheme != null) {
      return unknownScheme(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateUnknownScheme implements LinkResultState {
  const factory LinkResultStateUnknownScheme() =
      _$LinkResultStateUnknownSchemeImpl;
}

/// @nodoc
abstract class _$$LinkResultStateUnknownHostImplCopyWith<$Res> {
  factory _$$LinkResultStateUnknownHostImplCopyWith(
    _$LinkResultStateUnknownHostImpl value,
    $Res Function(_$LinkResultStateUnknownHostImpl) then,
  ) = __$$LinkResultStateUnknownHostImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LinkResultStateUnknownHostImplCopyWithImpl<$Res>
    extends
        _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateUnknownHostImpl>
    implements _$$LinkResultStateUnknownHostImplCopyWith<$Res> {
  __$$LinkResultStateUnknownHostImplCopyWithImpl(
    _$LinkResultStateUnknownHostImpl _value,
    $Res Function(_$LinkResultStateUnknownHostImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LinkResultStateUnknownHostImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateUnknownHost {
  const _$LinkResultStateUnknownHostImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.unknownHost()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'LinkResultState.unknownHost'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateUnknownHostImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return unknownHost();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return unknownHost?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) {
    if (unknownHost != null) {
      return unknownHost();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return unknownHost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return unknownHost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (unknownHost != null) {
      return unknownHost(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateUnknownHost implements LinkResultState {
  const factory LinkResultStateUnknownHost() = _$LinkResultStateUnknownHostImpl;
}

/// @nodoc
abstract class _$$LinkResultStateFailedImplCopyWith<$Res> {
  factory _$$LinkResultStateFailedImplCopyWith(
    _$LinkResultStateFailedImpl value,
    $Res Function(_$LinkResultStateFailedImpl) then,
  ) = __$$LinkResultStateFailedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LinkResultStateFailedImplCopyWithImpl<$Res>
    extends _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateFailedImpl>
    implements _$$LinkResultStateFailedImplCopyWith<$Res> {
  __$$LinkResultStateFailedImplCopyWithImpl(
    _$LinkResultStateFailedImpl _value,
    $Res Function(_$LinkResultStateFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LinkResultStateFailedImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateFailed {
  const _$LinkResultStateFailedImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.failed()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'LinkResultState.failed'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateFailedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return failed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return failed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateFailed implements LinkResultState {
  const factory LinkResultStateFailed() = _$LinkResultStateFailedImpl;
}

/// @nodoc
abstract class _$$LinkResultStateFailedUriPathImplCopyWith<$Res> {
  factory _$$LinkResultStateFailedUriPathImplCopyWith(
    _$LinkResultStateFailedUriPathImpl value,
    $Res Function(_$LinkResultStateFailedUriPathImpl) then,
  ) = __$$LinkResultStateFailedUriPathImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LinkResultStateFailedUriPathImplCopyWithImpl<$Res>
    extends
        _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateFailedUriPathImpl>
    implements _$$LinkResultStateFailedUriPathImplCopyWith<$Res> {
  __$$LinkResultStateFailedUriPathImplCopyWithImpl(
    _$LinkResultStateFailedUriPathImpl _value,
    $Res Function(_$LinkResultStateFailedUriPathImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LinkResultStateFailedUriPathImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateFailedUriPath {
  const _$LinkResultStateFailedUriPathImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.failedUriPath()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LinkResultState.failedUriPath'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateFailedUriPathImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return failedUriPath();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return failedUriPath?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) {
    if (failedUriPath != null) {
      return failedUriPath();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return failedUriPath(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return failedUriPath?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (failedUriPath != null) {
      return failedUriPath(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateFailedUriPath implements LinkResultState {
  const factory LinkResultStateFailedUriPath() =
      _$LinkResultStateFailedUriPathImpl;
}

/// @nodoc
abstract class _$$LinkResultStateSuccessImplCopyWith<$Res> {
  factory _$$LinkResultStateSuccessImplCopyWith(
    _$LinkResultStateSuccessImpl value,
    $Res Function(_$LinkResultStateSuccessImpl) then,
  ) = __$$LinkResultStateSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LinkResultDetails? details});

  $LinkResultDetailsCopyWith<$Res>? get details;
}

/// @nodoc
class __$$LinkResultStateSuccessImplCopyWithImpl<$Res>
    extends _$LinkResultStateCopyWithImpl<$Res, _$LinkResultStateSuccessImpl>
    implements _$$LinkResultStateSuccessImplCopyWith<$Res> {
  __$$LinkResultStateSuccessImplCopyWithImpl(
    _$LinkResultStateSuccessImpl _value,
    $Res Function(_$LinkResultStateSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? details = freezed}) {
    return _then(
      _$LinkResultStateSuccessImpl(
        details:
            freezed == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                    as LinkResultDetails?,
      ),
    );
  }

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LinkResultDetailsCopyWith<$Res>? get details {
    if (_value.details == null) {
      return null;
    }

    return $LinkResultDetailsCopyWith<$Res>(_value.details!, (value) {
      return _then(_value.copyWith(details: value));
    });
  }
}

/// @nodoc

class _$LinkResultStateSuccessImpl
    with DiagnosticableTreeMixin
    implements LinkResultStateSuccess {
  const _$LinkResultStateSuccessImpl({this.details});

  @override
  final LinkResultDetails? details;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LinkResultState.success(details: $details)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LinkResultState.success'))
      ..add(DiagnosticsProperty('details', details));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LinkResultStateSuccessImpl &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, details);

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LinkResultStateSuccessImplCopyWith<_$LinkResultStateSuccessImpl>
  get copyWith =>
      __$$LinkResultStateSuccessImplCopyWithImpl<_$LinkResultStateSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() empty,
    required TResult Function() unknown,
    required TResult Function() unknownUri,
    required TResult Function() unknownScheme,
    required TResult Function() unknownHost,
    required TResult Function() failed,
    required TResult Function() failedUriPath,
    required TResult Function(LinkResultDetails? details) success,
  }) {
    return success(details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? empty,
    TResult? Function()? unknown,
    TResult? Function()? unknownUri,
    TResult? Function()? unknownScheme,
    TResult? Function()? unknownHost,
    TResult? Function()? failed,
    TResult? Function()? failedUriPath,
    TResult? Function(LinkResultDetails? details)? success,
  }) {
    return success?.call(details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? empty,
    TResult Function()? unknown,
    TResult Function()? unknownUri,
    TResult Function()? unknownScheme,
    TResult Function()? unknownHost,
    TResult Function()? failed,
    TResult Function()? failedUriPath,
    TResult Function(LinkResultDetails? details)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LinkResultStateEmpty value) empty,
    required TResult Function(LinkResultStateUnknown value) unknown,
    required TResult Function(LinkResultStateUnknownUri value) unknownUri,
    required TResult Function(LinkResultStateUnknownScheme value) unknownScheme,
    required TResult Function(LinkResultStateUnknownHost value) unknownHost,
    required TResult Function(LinkResultStateFailed value) failed,
    required TResult Function(LinkResultStateFailedUriPath value) failedUriPath,
    required TResult Function(LinkResultStateSuccess value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LinkResultStateEmpty value)? empty,
    TResult? Function(LinkResultStateUnknown value)? unknown,
    TResult? Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult? Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult? Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult? Function(LinkResultStateFailed value)? failed,
    TResult? Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult? Function(LinkResultStateSuccess value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LinkResultStateEmpty value)? empty,
    TResult Function(LinkResultStateUnknown value)? unknown,
    TResult Function(LinkResultStateUnknownUri value)? unknownUri,
    TResult Function(LinkResultStateUnknownScheme value)? unknownScheme,
    TResult Function(LinkResultStateUnknownHost value)? unknownHost,
    TResult Function(LinkResultStateFailed value)? failed,
    TResult Function(LinkResultStateFailedUriPath value)? failedUriPath,
    TResult Function(LinkResultStateSuccess value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class LinkResultStateSuccess implements LinkResultState {
  const factory LinkResultStateSuccess({final LinkResultDetails? details}) =
      _$LinkResultStateSuccessImpl;

  LinkResultDetails? get details;

  /// Create a copy of LinkResultState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LinkResultStateSuccessImplCopyWith<_$LinkResultStateSuccessImpl>
  get copyWith => throw _privateConstructorUsedError;
}
