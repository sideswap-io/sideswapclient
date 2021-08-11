///
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class To_Subscribe_Market extends $pb.ProtobufEnum {
  static const To_Subscribe_Market NONE = To_Subscribe_Market._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NONE');
  static const To_Subscribe_Market TOKENS = To_Subscribe_Market._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TOKENS');
  static const To_Subscribe_Market ASSET = To_Subscribe_Market._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ASSET');

  static const $core.List<To_Subscribe_Market> values = <To_Subscribe_Market> [
    NONE,
    TOKENS,
    ASSET,
  ];

  static final $core.Map<$core.int, To_Subscribe_Market> _byValue = $pb.ProtobufEnum.initByValue(values);
  static To_Subscribe_Market? valueOf($core.int value) => _byValue[value];

  const To_Subscribe_Market._($core.int v, $core.String n) : super(v, n);
}

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

