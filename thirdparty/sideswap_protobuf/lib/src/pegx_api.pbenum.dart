// This is a generated file - do not edit.
//
// Generated from pegx_api.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AccountState extends $pb.ProtobufEnum {
  static const AccountState DISABLED =
      AccountState._(1, _omitEnumNames ? '' : 'DISABLED');
  static const AccountState VERIFICATION =
      AccountState._(2, _omitEnumNames ? '' : 'VERIFICATION');
  static const AccountState ACTIVE =
      AccountState._(3, _omitEnumNames ? '' : 'ACTIVE');

  static const $core.List<AccountState> values = <AccountState>[
    DISABLED,
    VERIFICATION,
    ACTIVE,
  ];

  static final $core.List<AccountState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AccountState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AccountState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
