///
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class From_SubmitReview_Step extends $pb.ProtobufEnum {
  static const From_SubmitReview_Step SUBMIT = From_SubmitReview_Step._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SUBMIT');
  static const From_SubmitReview_Step QUOTE = From_SubmitReview_Step._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'QUOTE');
  static const From_SubmitReview_Step SIGN = From_SubmitReview_Step._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SIGN');

  static const $core.List<From_SubmitReview_Step> values = <From_SubmitReview_Step> [
    SUBMIT,
    QUOTE,
    SIGN,
  ];

  static final $core.Map<$core.int, From_SubmitReview_Step> _byValue = $pb.ProtobufEnum.initByValue(values);
  static From_SubmitReview_Step? valueOf($core.int value) => _byValue[value];

  const From_SubmitReview_Step._($core.int v, $core.String n) : super(v, n);
}

class From_JadeStatus_Status extends $pb.ProtobufEnum {
  static const From_JadeStatus_Status IDLE = From_JadeStatus_Status._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IDLE');
  static const From_JadeStatus_Status READ_STATUS = From_JadeStatus_Status._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'READ_STATUS');
  static const From_JadeStatus_Status AUTH_USER = From_JadeStatus_Status._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AUTH_USER');
  static const From_JadeStatus_Status SIGN_TX = From_JadeStatus_Status._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SIGN_TX');

  static const $core.List<From_JadeStatus_Status> values = <From_JadeStatus_Status> [
    IDLE,
    READ_STATUS,
    AUTH_USER,
    SIGN_TX,
  ];

  static final $core.Map<$core.int, From_JadeStatus_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static From_JadeStatus_Status? valueOf($core.int value) => _byValue[value];

  const From_JadeStatus_Status._($core.int v, $core.String n) : super(v, n);
}

