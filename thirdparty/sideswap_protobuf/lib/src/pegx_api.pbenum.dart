//
//  Generated code. Do not modify.
//  source: pegx_api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AccountState extends $pb.ProtobufEnum {
  static const AccountState DISABLED = AccountState._(1, _omitEnumNames ? '' : 'DISABLED');
  static const AccountState VERIFICATION = AccountState._(2, _omitEnumNames ? '' : 'VERIFICATION');
  static const AccountState ACTIVE = AccountState._(3, _omitEnumNames ? '' : 'ACTIVE');

  static const $core.List<AccountState> values = <AccountState> [
    DISABLED,
    VERIFICATION,
    ACTIVE,
  ];

  static final $core.Map<$core.int, AccountState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AccountState? valueOf($core.int value) => _byValue[value];

  const AccountState._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
