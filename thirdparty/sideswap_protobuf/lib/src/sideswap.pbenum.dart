//
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class From_DecryptPin_ErrorCode extends $pb.ProtobufEnum {
  static const From_DecryptPin_ErrorCode WRONG_PIN = From_DecryptPin_ErrorCode._(1, _omitEnumNames ? '' : 'WRONG_PIN');
  static const From_DecryptPin_ErrorCode NETWORK_ERROR = From_DecryptPin_ErrorCode._(2, _omitEnumNames ? '' : 'NETWORK_ERROR');
  static const From_DecryptPin_ErrorCode INVALID_DATA = From_DecryptPin_ErrorCode._(3, _omitEnumNames ? '' : 'INVALID_DATA');

  static const $core.List<From_DecryptPin_ErrorCode> values = <From_DecryptPin_ErrorCode> [
    WRONG_PIN,
    NETWORK_ERROR,
    INVALID_DATA,
  ];

  static final $core.Map<$core.int, From_DecryptPin_ErrorCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static From_DecryptPin_ErrorCode? valueOf($core.int value) => _byValue[value];

  const From_DecryptPin_ErrorCode._($core.int v, $core.String n) : super(v, n);
}

class From_SubmitReview_Step extends $pb.ProtobufEnum {
  static const From_SubmitReview_Step SUBMIT = From_SubmitReview_Step._(1, _omitEnumNames ? '' : 'SUBMIT');
  static const From_SubmitReview_Step QUOTE = From_SubmitReview_Step._(2, _omitEnumNames ? '' : 'QUOTE');
  static const From_SubmitReview_Step SIGN = From_SubmitReview_Step._(3, _omitEnumNames ? '' : 'SIGN');

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
  static const From_JadeStatus_Status CONNECTING = From_JadeStatus_Status._(9, _omitEnumNames ? '' : 'CONNECTING');
  static const From_JadeStatus_Status IDLE = From_JadeStatus_Status._(1, _omitEnumNames ? '' : 'IDLE');
  static const From_JadeStatus_Status READ_STATUS = From_JadeStatus_Status._(2, _omitEnumNames ? '' : 'READ_STATUS');
  static const From_JadeStatus_Status AUTH_USER = From_JadeStatus_Status._(3, _omitEnumNames ? '' : 'AUTH_USER');
  static const From_JadeStatus_Status MASTER_BLINDING_KEY = From_JadeStatus_Status._(5, _omitEnumNames ? '' : 'MASTER_BLINDING_KEY');
  static const From_JadeStatus_Status SIGN_TX = From_JadeStatus_Status._(4, _omitEnumNames ? '' : 'SIGN_TX');
  static const From_JadeStatus_Status SIGN_SWAP = From_JadeStatus_Status._(8, _omitEnumNames ? '' : 'SIGN_SWAP');
  static const From_JadeStatus_Status SIGN_SWAP_OUTPUT = From_JadeStatus_Status._(6, _omitEnumNames ? '' : 'SIGN_SWAP_OUTPUT');
  static const From_JadeStatus_Status SIGN_OFFLINE_SWAP = From_JadeStatus_Status._(7, _omitEnumNames ? '' : 'SIGN_OFFLINE_SWAP');

  static const $core.List<From_JadeStatus_Status> values = <From_JadeStatus_Status> [
    CONNECTING,
    IDLE,
    READ_STATUS,
    AUTH_USER,
    MASTER_BLINDING_KEY,
    SIGN_TX,
    SIGN_SWAP,
    SIGN_SWAP_OUTPUT,
    SIGN_OFFLINE_SWAP,
  ];

  static final $core.Map<$core.int, From_JadeStatus_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static From_JadeStatus_Status? valueOf($core.int value) => _byValue[value];

  const From_JadeStatus_Status._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
