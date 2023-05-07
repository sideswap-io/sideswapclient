///
//  Generated code. Do not modify.
//  source: pegx_api.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use accountStateDescriptor instead')
const AccountState$json = const {
  '1': 'AccountState',
  '2': const [
    const {'1': 'DISABLED', '2': 1},
    const {'1': 'VERIFICATION', '2': 2},
    const {'1': 'ACTIVE', '2': 3},
  ],
};

/// Descriptor for `AccountState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List accountStateDescriptor = $convert.base64Decode('CgxBY2NvdW50U3RhdGUSDAoIRElTQUJMRUQQARIQCgxWRVJJRklDQVRJT04QAhIKCgZBQ1RJVkUQAw==');
@$core.Deprecated('Use accountKeyDescriptor instead')
const AccountKey$json = const {
  '1': 'AccountKey',
  '2': const [
    const {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `AccountKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountKeyDescriptor = $convert.base64Decode('CgpBY2NvdW50S2V5Eh8KC2FjY291bnRfa2V5GAEgAigJUgphY2NvdW50S2V5EhIKBG5hbWUYAiACKAlSBG5hbWU=');
@$core.Deprecated('Use accountDetailsDescriptor instead')
const AccountDetails$json = const {
  '1': 'AccountDetails',
  '2': const [
    const {'1': 'org', '3': 1, '4': 1, '5': 11, '6': '.api.proto.AccountDetails.OrgDetails', '9': 0, '10': 'org'},
    const {'1': 'individual', '3': 2, '4': 1, '5': 11, '6': '.api.proto.AccountDetails.IndividualDetails', '9': 0, '10': 'individual'},
    const {'1': 'account_state', '3': 3, '4': 2, '5': 14, '6': '.api.proto.AccountState', '10': 'accountState'},
  ],
  '3': const [AccountDetails_OrgDetails$json, AccountDetails_IndividualDetails$json],
  '8': const [
    const {'1': 'details'},
  ],
};

@$core.Deprecated('Use accountDetailsDescriptor instead')
const AccountDetails_OrgDetails$json = const {
  '1': 'OrgDetails',
  '2': const [
    const {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'address', '3': 2, '4': 2, '5': 9, '10': 'address'},
    const {'1': 'city', '3': 3, '4': 2, '5': 9, '10': 'city'},
    const {'1': 'postcode', '3': 4, '4': 2, '5': 9, '10': 'postcode'},
    const {'1': 'country', '3': 5, '4': 2, '5': 9, '10': 'country'},
    const {'1': 'website', '3': 6, '4': 2, '5': 9, '10': 'website'},
    const {'1': 'reg_number', '3': 7, '4': 2, '5': 9, '10': 'regNumber'},
    const {'1': 'owner_email', '3': 8, '4': 2, '5': 9, '10': 'ownerEmail'},
  ],
};

@$core.Deprecated('Use accountDetailsDescriptor instead')
const AccountDetails_IndividualDetails$json = const {
  '1': 'IndividualDetails',
  '2': const [
    const {'1': 'first_name', '3': 1, '4': 2, '5': 9, '10': 'firstName'},
    const {'1': 'last_name', '3': 2, '4': 2, '5': 9, '10': 'lastName'},
    const {'1': 'email', '3': 3, '4': 2, '5': 9, '10': 'email'},
    const {'1': 'phone_number', '3': 4, '4': 2, '5': 9, '10': 'phoneNumber'},
    const {'1': 'gender', '3': 5, '4': 2, '5': 9, '10': 'gender'},
    const {'1': 'date_of_birth', '3': 6, '4': 2, '5': 9, '10': 'dateOfBirth'},
    const {'1': 'nationality', '3': 7, '4': 2, '5': 9, '10': 'nationality'},
    const {'1': 'personal_number', '3': 8, '4': 2, '5': 9, '10': 'personalNumber'},
    const {'1': 'residency_country', '3': 9, '4': 2, '5': 9, '10': 'residencyCountry'},
    const {'1': 'residency_area', '3': 10, '4': 2, '5': 9, '10': 'residencyArea'},
    const {'1': 'residency_city', '3': 11, '4': 2, '5': 9, '10': 'residencyCity'},
    const {'1': 'residency_postcode', '3': 12, '4': 2, '5': 9, '10': 'residencyPostcode'},
    const {'1': 'residency_address', '3': 13, '4': 2, '5': 9, '10': 'residencyAddress'},
    const {'1': 'residency_address2', '3': 14, '4': 2, '5': 9, '10': 'residencyAddress2'},
  ],
};

/// Descriptor for `AccountDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDetailsDescriptor = $convert.base64Decode('Cg5BY2NvdW50RGV0YWlscxI4CgNvcmcYASABKAsyJC5hcGkucHJvdG8uQWNjb3VudERldGFpbHMuT3JnRGV0YWlsc0gAUgNvcmcSTQoKaW5kaXZpZHVhbBgCIAEoCzIrLmFwaS5wcm90by5BY2NvdW50RGV0YWlscy5JbmRpdmlkdWFsRGV0YWlsc0gAUgppbmRpdmlkdWFsEjwKDWFjY291bnRfc3RhdGUYAyACKA4yFy5hcGkucHJvdG8uQWNjb3VudFN0YXRlUgxhY2NvdW50U3RhdGUa3gEKCk9yZ0RldGFpbHMSEgoEbmFtZRgBIAIoCVIEbmFtZRIYCgdhZGRyZXNzGAIgAigJUgdhZGRyZXNzEhIKBGNpdHkYAyACKAlSBGNpdHkSGgoIcG9zdGNvZGUYBCACKAlSCHBvc3Rjb2RlEhgKB2NvdW50cnkYBSACKAlSB2NvdW50cnkSGAoHd2Vic2l0ZRgGIAIoCVIHd2Vic2l0ZRIdCgpyZWdfbnVtYmVyGAcgAigJUglyZWdOdW1iZXISHwoLb3duZXJfZW1haWwYCCACKAlSCm93bmVyRW1haWwalQQKEUluZGl2aWR1YWxEZXRhaWxzEh0KCmZpcnN0X25hbWUYASACKAlSCWZpcnN0TmFtZRIbCglsYXN0X25hbWUYAiACKAlSCGxhc3ROYW1lEhQKBWVtYWlsGAMgAigJUgVlbWFpbBIhCgxwaG9uZV9udW1iZXIYBCACKAlSC3Bob25lTnVtYmVyEhYKBmdlbmRlchgFIAIoCVIGZ2VuZGVyEiIKDWRhdGVfb2ZfYmlydGgYBiACKAlSC2RhdGVPZkJpcnRoEiAKC25hdGlvbmFsaXR5GAcgAigJUgtuYXRpb25hbGl0eRInCg9wZXJzb25hbF9udW1iZXIYCCACKAlSDnBlcnNvbmFsTnVtYmVyEisKEXJlc2lkZW5jeV9jb3VudHJ5GAkgAigJUhByZXNpZGVuY3lDb3VudHJ5EiUKDnJlc2lkZW5jeV9hcmVhGAogAigJUg1yZXNpZGVuY3lBcmVhEiUKDnJlc2lkZW5jeV9jaXR5GAsgAigJUg1yZXNpZGVuY3lDaXR5Ei0KEnJlc2lkZW5jeV9wb3N0Y29kZRgMIAIoCVIRcmVzaWRlbmN5UG9zdGNvZGUSKwoRcmVzaWRlbmN5X2FkZHJlc3MYDSACKAlSEHJlc2lkZW5jeUFkZHJlc3MSLQoScmVzaWRlbmN5X2FkZHJlc3MyGA4gAigJUhFyZXNpZGVuY3lBZGRyZXNzMkIJCgdkZXRhaWxz');
@$core.Deprecated('Use accountDescriptor instead')
const Account$json = const {
  '1': 'Account',
  '2': const [
    const {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    const {'1': 'details', '3': 2, '4': 2, '5': 11, '6': '.api.proto.AccountDetails', '10': 'details'},
    const {'1': 'gaids', '3': 3, '4': 3, '5': 9, '10': 'gaids'},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode('CgdBY2NvdW50Eh8KC2FjY291bnRfa2V5GAEgAigJUgphY2NvdW50S2V5EjMKB2RldGFpbHMYAiACKAsyGS5hcGkucHJvdG8uQWNjb3VudERldGFpbHNSB2RldGFpbHMSFAoFZ2FpZHMYAyADKAlSBWdhaWRz');
@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = const {
  '1': 'Asset',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'ticker', '3': 3, '4': 2, '5': 9, '10': 'ticker'},
    const {'1': 'precision', '3': 4, '4': 2, '5': 5, '10': 'precision'},
    const {'1': 'domain', '3': 5, '4': 2, '5': 9, '10': 'domain'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode('CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEhYKBnRpY2tlchgDIAIoCVIGdGlja2VyEhwKCXByZWNpc2lvbhgEIAIoBVIJcHJlY2lzaW9uEhYKBmRvbWFpbhgFIAIoCVIGZG9tYWlu');
@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = const {
  '1': 'Balance',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'balance', '3': 2, '4': 2, '5': 1, '10': 'balance'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode('CgdCYWxhbmNlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhgKB2JhbGFuY2UYAiACKAFSB2JhbGFuY2U=');
@$core.Deprecated('Use sharesDescriptor instead')
const Shares$json = const {
  '1': 'Shares',
  '2': const [
    const {'1': 'count', '3': 1, '4': 2, '5': 1, '10': 'count'},
    const {'1': 'total', '3': 2, '4': 2, '5': 1, '10': 'total'},
  ],
};

/// Descriptor for `Shares`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sharesDescriptor = $convert.base64Decode('CgZTaGFyZXMSFAoFY291bnQYASACKAFSBWNvdW50EhQKBXRvdGFsGAIgAigBUgV0b3RhbA==');
@$core.Deprecated('Use inOutDescriptor instead')
const InOut$json = const {
  '1': 'InOut',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 2, '5': 1, '10': 'amount'},
    const {'1': 'gaid', '3': 2, '4': 1, '5': 9, '10': 'gaid'},
  ],
};

/// Descriptor for `InOut`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inOutDescriptor = $convert.base64Decode('CgVJbk91dBIWCgZhbW91bnQYASACKAFSBmFtb3VudBISCgRnYWlkGAIgASgJUgRnYWlk');
@$core.Deprecated('Use fullTransactionDescriptor instead')
const FullTransaction$json = const {
  '1': 'FullTransaction',
  '2': const [
    const {'1': 'inputs', '3': 1, '4': 3, '5': 11, '6': '.api.proto.InOut', '10': 'inputs'},
    const {'1': 'outputs', '3': 2, '4': 3, '5': 11, '6': '.api.proto.InOut', '10': 'outputs'},
    const {'1': 'txid', '3': 3, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'timestamp', '3': 4, '4': 2, '5': 3, '10': 'timestamp'},
    const {'1': 'unblinded', '3': 5, '4': 2, '5': 9, '10': 'unblinded'},
    const {'1': 'price', '3': 6, '4': 1, '5': 1, '10': 'price'},
  ],
};

/// Descriptor for `FullTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fullTransactionDescriptor = $convert.base64Decode('Cg9GdWxsVHJhbnNhY3Rpb24SKAoGaW5wdXRzGAEgAygLMhAuYXBpLnByb3RvLkluT3V0UgZpbnB1dHMSKgoHb3V0cHV0cxgCIAMoCzIQLmFwaS5wcm90by5Jbk91dFIHb3V0cHV0cxISCgR0eGlkGAMgAigJUgR0eGlkEhwKCXRpbWVzdGFtcBgEIAIoA1IJdGltZXN0YW1wEhwKCXVuYmxpbmRlZBgFIAIoCVIJdW5ibGluZGVkEhQKBXByaWNlGAYgASgBUgVwcmljZQ==');
@$core.Deprecated('Use ownTransactionDescriptor instead')
const OwnTransaction$json = const {
  '1': 'OwnTransaction',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'timestamp', '3': 2, '4': 2, '5': 3, '10': 'timestamp'},
    const {'1': 'amount', '3': 3, '4': 2, '5': 1, '10': 'amount'},
    const {'1': 'price', '3': 4, '4': 1, '5': 1, '10': 'price'},
  ],
};

/// Descriptor for `OwnTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ownTransactionDescriptor = $convert.base64Decode('Cg5Pd25UcmFuc2FjdGlvbhISCgR0eGlkGAEgAigJUgR0eGlkEhwKCXRpbWVzdGFtcBgCIAIoA1IJdGltZXN0YW1wEhYKBmFtb3VudBgDIAIoAVIGYW1vdW50EhQKBXByaWNlGAQgASgBUgVwcmljZQ==');
@$core.Deprecated('Use balanceOwnerDescriptor instead')
const BalanceOwner$json = const {
  '1': 'BalanceOwner',
  '2': const [
    const {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 1, '10': 'amount'},
  ],
};

/// Descriptor for `BalanceOwner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceOwnerDescriptor = $convert.base64Decode('CgxCYWxhbmNlT3duZXISHwoLYWNjb3VudF9rZXkYASACKAlSCmFjY291bnRLZXkSFgoGYW1vdW50GAIgAigBUgZhbW91bnQ=');
@$core.Deprecated('Use serieDescriptor instead')
const Serie$json = const {
  '1': 'Serie',
  '2': const [
    const {'1': 'start', '3': 2, '4': 2, '5': 3, '10': 'start'},
    const {'1': 'count', '3': 3, '4': 2, '5': 3, '10': 'count'},
  ],
};

/// Descriptor for `Serie`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serieDescriptor = $convert.base64Decode('CgVTZXJpZRIUCgVzdGFydBgCIAIoA1IFc3RhcnQSFAoFY291bnQYAyACKANSBWNvdW50');
@$core.Deprecated('Use serieOwnerDescriptor instead')
const SerieOwner$json = const {
  '1': 'SerieOwner',
  '2': const [
    const {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    const {'1': 'series', '3': 2, '4': 3, '5': 11, '6': '.api.proto.Serie', '10': 'series'},
  ],
};

/// Descriptor for `SerieOwner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serieOwnerDescriptor = $convert.base64Decode('CgpTZXJpZU93bmVyEh8KC2FjY291bnRfa2V5GAEgAigJUgphY2NvdW50S2V5EigKBnNlcmllcxgCIAMoCzIQLmFwaS5wcm90by5TZXJpZVIGc2VyaWVz');
@$core.Deprecated('Use reqDescriptor instead')
const Req$json = const {
  '1': 'Req',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 3, '10': 'id'},
    const {'1': 'login', '3': 10, '4': 1, '5': 11, '6': '.api.proto.Req.Login', '9': 0, '10': 'login'},
    const {'1': 'register', '3': 11, '4': 1, '5': 11, '6': '.api.proto.Req.Register', '9': 0, '10': 'register'},
    const {'1': 'register_issuer', '3': 14, '4': 1, '5': 11, '6': '.api.proto.Req.RegisterIssuer', '9': 0, '10': 'registerIssuer'},
    const {'1': 'resume', '3': 12, '4': 1, '5': 11, '6': '.api.proto.Req.Resume', '9': 0, '10': 'resume'},
    const {'1': 'logout', '3': 13, '4': 1, '5': 11, '6': '.api.proto.Req.Logout', '9': 0, '10': 'logout'},
    const {'1': 'add_gaid', '3': 20, '4': 1, '5': 11, '6': '.api.proto.Req.AddGaid', '9': 0, '10': 'addGaid'},
    const {'1': 'load_assets', '3': 21, '4': 1, '5': 11, '6': '.api.proto.Req.LoadAssets', '9': 0, '10': 'loadAssets'},
    const {'1': 'buy_shares', '3': 24, '4': 1, '5': 11, '6': '.api.proto.Req.BuyShares', '9': 0, '10': 'buyShares'},
    const {'1': 'load_countries', '3': 25, '4': 1, '5': 11, '6': '.api.proto.Req.LoadCountries', '9': 0, '10': 'loadCountries'},
    const {'1': 'load_regs', '3': 26, '4': 1, '5': 11, '6': '.api.proto.Req.LoadRegs', '9': 0, '10': 'loadRegs'},
    const {'1': 'load_file', '3': 28, '4': 1, '5': 11, '6': '.api.proto.Req.LoadFile', '9': 0, '10': 'loadFile'},
    const {'1': 'update_reg', '3': 27, '4': 1, '5': 11, '6': '.api.proto.Req.UpdateReg', '9': 0, '10': 'updateReg'},
    const {'1': 'list_all_transactions', '3': 29, '4': 1, '5': 11, '6': '.api.proto.Req.ListAllTransactions', '9': 0, '10': 'listAllTransactions'},
    const {'1': 'list_own_transactions', '3': 30, '4': 1, '5': 11, '6': '.api.proto.Req.ListOwnTransactions', '9': 0, '10': 'listOwnTransactions'},
    const {'1': 'list_all_balances', '3': 31, '4': 1, '5': 11, '6': '.api.proto.Req.ListAllBalances', '9': 0, '10': 'listAllBalances'},
    const {'1': 'list_all_series', '3': 32, '4': 1, '5': 11, '6': '.api.proto.Req.ListAllSeries', '9': 0, '10': 'listAllSeries'},
  ],
  '3': const [Req_Login$json, Req_Register$json, Req_RegisterIssuer$json, Req_Resume$json, Req_Logout$json, Req_AddGaid$json, Req_LoadAssets$json, Req_BuyShares$json, Req_LoadCountries$json, Req_LoadRegs$json, Req_LoadFile$json, Req_UpdateReg$json, Req_ListAllTransactions$json, Req_ListOwnTransactions$json, Req_ListAllBalances$json, Req_ListAllSeries$json],
  '8': const [
    const {'1': 'body'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_Login$json = const {
  '1': 'Login',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_Register$json = const {
  '1': 'Register',
  '2': const [
    const {'1': 'org', '3': 1, '4': 1, '5': 11, '6': '.api.proto.Req.Register.Org', '10': 'org'},
  ],
  '3': const [Req_Register_Org$json],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_Register_Org$json = const {
  '1': 'Org',
  '2': const [
    const {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'address', '3': 2, '4': 2, '5': 9, '10': 'address'},
    const {'1': 'city', '3': 3, '4': 2, '5': 9, '10': 'city'},
    const {'1': 'postcode', '3': 4, '4': 2, '5': 9, '10': 'postcode'},
    const {'1': 'country', '3': 5, '4': 2, '5': 9, '10': 'country'},
    const {'1': 'website', '3': 6, '4': 2, '5': 9, '10': 'website'},
    const {'1': 'reg_number', '3': 7, '4': 2, '5': 9, '10': 'regNumber'},
    const {'1': 'reg_proof', '3': 8, '4': 2, '5': 12, '10': 'regProof'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_RegisterIssuer$json = const {
  '1': 'RegisterIssuer',
  '2': const [
    const {'1': 'email', '3': 1, '4': 2, '5': 9, '10': 'email'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'website', '3': 3, '4': 2, '5': 9, '10': 'website'},
    const {'1': 'message', '3': 4, '4': 2, '5': 9, '10': 'message'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_Resume$json = const {
  '1': 'Resume',
  '2': const [
    const {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
    const {'1': 'account_key', '3': 2, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_Logout$json = const {
  '1': 'Logout',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_AddGaid$json = const {
  '1': 'AddGaid',
  '2': const [
    const {'1': 'gaid', '3': 1, '4': 2, '5': 9, '10': 'gaid'},
    const {'1': 'accept_free_shares', '3': 2, '4': 2, '5': 8, '10': 'acceptFreeShares'},
    const {'1': 'use_local_account', '3': 3, '4': 2, '5': 8, '10': 'useLocalAccount'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadAssets$json = const {
  '1': 'LoadAssets',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_BuyShares$json = const {
  '1': 'BuyShares',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 2, '5': 1, '10': 'amount'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadCountries$json = const {
  '1': 'LoadCountries',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadRegs$json = const {
  '1': 'LoadRegs',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadFile$json = const {
  '1': 'LoadFile',
  '2': const [
    const {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_UpdateReg$json = const {
  '1': 'UpdateReg',
  '2': const [
    const {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    const {'1': 'valid', '3': 2, '4': 2, '5': 8, '10': 'valid'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListAllTransactions$json = const {
  '1': 'ListAllTransactions',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListOwnTransactions$json = const {
  '1': 'ListOwnTransactions',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListAllBalances$json = const {
  '1': 'ListAllBalances',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListAllSeries$json = const {
  '1': 'ListAllSeries',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `Req`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reqDescriptor = $convert.base64Decode('CgNSZXESDgoCaWQYASACKANSAmlkEiwKBWxvZ2luGAogASgLMhQuYXBpLnByb3RvLlJlcS5Mb2dpbkgAUgVsb2dpbhI1CghyZWdpc3RlchgLIAEoCzIXLmFwaS5wcm90by5SZXEuUmVnaXN0ZXJIAFIIcmVnaXN0ZXISSAoPcmVnaXN0ZXJfaXNzdWVyGA4gASgLMh0uYXBpLnByb3RvLlJlcS5SZWdpc3Rlcklzc3VlckgAUg5yZWdpc3Rlcklzc3VlchIvCgZyZXN1bWUYDCABKAsyFS5hcGkucHJvdG8uUmVxLlJlc3VtZUgAUgZyZXN1bWUSLwoGbG9nb3V0GA0gASgLMhUuYXBpLnByb3RvLlJlcS5Mb2dvdXRIAFIGbG9nb3V0EjMKCGFkZF9nYWlkGBQgASgLMhYuYXBpLnByb3RvLlJlcS5BZGRHYWlkSABSB2FkZEdhaWQSPAoLbG9hZF9hc3NldHMYFSABKAsyGS5hcGkucHJvdG8uUmVxLkxvYWRBc3NldHNIAFIKbG9hZEFzc2V0cxI5CgpidXlfc2hhcmVzGBggASgLMhguYXBpLnByb3RvLlJlcS5CdXlTaGFyZXNIAFIJYnV5U2hhcmVzEkUKDmxvYWRfY291bnRyaWVzGBkgASgLMhwuYXBpLnByb3RvLlJlcS5Mb2FkQ291bnRyaWVzSABSDWxvYWRDb3VudHJpZXMSNgoJbG9hZF9yZWdzGBogASgLMhcuYXBpLnByb3RvLlJlcS5Mb2FkUmVnc0gAUghsb2FkUmVncxI2Cglsb2FkX2ZpbGUYHCABKAsyFy5hcGkucHJvdG8uUmVxLkxvYWRGaWxlSABSCGxvYWRGaWxlEjkKCnVwZGF0ZV9yZWcYGyABKAsyGC5hcGkucHJvdG8uUmVxLlVwZGF0ZVJlZ0gAUgl1cGRhdGVSZWcSWAoVbGlzdF9hbGxfdHJhbnNhY3Rpb25zGB0gASgLMiIuYXBpLnByb3RvLlJlcS5MaXN0QWxsVHJhbnNhY3Rpb25zSABSE2xpc3RBbGxUcmFuc2FjdGlvbnMSWAoVbGlzdF9vd25fdHJhbnNhY3Rpb25zGB4gASgLMiIuYXBpLnByb3RvLlJlcS5MaXN0T3duVHJhbnNhY3Rpb25zSABSE2xpc3RPd25UcmFuc2FjdGlvbnMSTAoRbGlzdF9hbGxfYmFsYW5jZXMYHyABKAsyHi5hcGkucHJvdG8uUmVxLkxpc3RBbGxCYWxhbmNlc0gAUg9saXN0QWxsQmFsYW5jZXMSRgoPbGlzdF9hbGxfc2VyaWVzGCAgASgLMhwuYXBpLnByb3RvLlJlcS5MaXN0QWxsU2VyaWVzSABSDWxpc3RBbGxTZXJpZXMaBwoFTG9naW4ajwIKCFJlZ2lzdGVyEi0KA29yZxgBIAEoCzIbLmFwaS5wcm90by5SZXEuUmVnaXN0ZXIuT3JnUgNvcmca0wEKA09yZxISCgRuYW1lGAEgAigJUgRuYW1lEhgKB2FkZHJlc3MYAiACKAlSB2FkZHJlc3MSEgoEY2l0eRgDIAIoCVIEY2l0eRIaCghwb3N0Y29kZRgEIAIoCVIIcG9zdGNvZGUSGAoHY291bnRyeRgFIAIoCVIHY291bnRyeRIYCgd3ZWJzaXRlGAYgAigJUgd3ZWJzaXRlEh0KCnJlZ19udW1iZXIYByACKAlSCXJlZ051bWJlchIbCglyZWdfcHJvb2YYCCACKAxSCHJlZ1Byb29mGm4KDlJlZ2lzdGVySXNzdWVyEhQKBWVtYWlsGAEgAigJUgVlbWFpbBISCgRuYW1lGAIgAigJUgRuYW1lEhgKB3dlYnNpdGUYAyACKAlSB3dlYnNpdGUSGAoHbWVzc2FnZRgEIAIoCVIHbWVzc2FnZRo/CgZSZXN1bWUSFAoFdG9rZW4YASACKAlSBXRva2VuEh8KC2FjY291bnRfa2V5GAIgAigJUgphY2NvdW50S2V5GggKBkxvZ291dBp3CgdBZGRHYWlkEhIKBGdhaWQYASACKAlSBGdhaWQSLAoSYWNjZXB0X2ZyZWVfc2hhcmVzGAIgAigIUhBhY2NlcHRGcmVlU2hhcmVzEioKEXVzZV9sb2NhbF9hY2NvdW50GAMgAigIUg91c2VMb2NhbEFjY291bnQaDAoKTG9hZEFzc2V0cxojCglCdXlTaGFyZXMSFgoGYW1vdW50GAEgAigBUgZhbW91bnQaDwoNTG9hZENvdW50cmllcxoKCghMb2FkUmVncxorCghMb2FkRmlsZRIfCgthY2NvdW50X2tleRgBIAIoCVIKYWNjb3VudEtleRpCCglVcGRhdGVSZWcSHwoLYWNjb3VudF9rZXkYASACKAlSCmFjY291bnRLZXkSFAoFdmFsaWQYAiACKAhSBXZhbGlkGjAKE0xpc3RBbGxUcmFuc2FjdGlvbnMSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQaMAoTTGlzdE93blRyYW5zYWN0aW9ucxIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBosCg9MaXN0QWxsQmFsYW5jZXMSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQaKgoNTGlzdEFsbFNlcmllcxIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZEIGCgRib2R5');
@$core.Deprecated('Use respDescriptor instead')
const Resp$json = const {
  '1': 'Resp',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 3, '10': 'id'},
    const {'1': 'login', '3': 10, '4': 1, '5': 11, '6': '.api.proto.Resp.Login', '9': 0, '10': 'login'},
    const {'1': 'register', '3': 11, '4': 1, '5': 11, '6': '.api.proto.Resp.Register', '9': 0, '10': 'register'},
    const {'1': 'register_issuer', '3': 14, '4': 1, '5': 11, '6': '.api.proto.Resp.RegisterIssuer', '9': 0, '10': 'registerIssuer'},
    const {'1': 'resume', '3': 12, '4': 1, '5': 11, '6': '.api.proto.Resp.Resume', '9': 0, '10': 'resume'},
    const {'1': 'logout', '3': 13, '4': 1, '5': 11, '6': '.api.proto.Resp.Logout', '9': 0, '10': 'logout'},
    const {'1': 'add_gaid', '3': 20, '4': 1, '5': 11, '6': '.api.proto.Resp.AddGaid', '9': 0, '10': 'addGaid'},
    const {'1': 'load_assets', '3': 21, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadAssets', '9': 0, '10': 'loadAssets'},
    const {'1': 'buy_shares', '3': 24, '4': 1, '5': 11, '6': '.api.proto.Resp.BuyShares', '9': 0, '10': 'buyShares'},
    const {'1': 'load_countries', '3': 25, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadCountries', '9': 0, '10': 'loadCountries'},
    const {'1': 'load_regs', '3': 26, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadRegs', '9': 0, '10': 'loadRegs'},
    const {'1': 'load_file', '3': 28, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadFile', '9': 0, '10': 'loadFile'},
    const {'1': 'update_reg', '3': 27, '4': 1, '5': 11, '6': '.api.proto.Resp.UpdateReg', '9': 0, '10': 'updateReg'},
    const {'1': 'list_all_transactions', '3': 29, '4': 1, '5': 11, '6': '.api.proto.Resp.ListAllTransactions', '9': 0, '10': 'listAllTransactions'},
    const {'1': 'list_own_transactions', '3': 30, '4': 1, '5': 11, '6': '.api.proto.Resp.ListOwnTransactions', '9': 0, '10': 'listOwnTransactions'},
    const {'1': 'list_all_balances', '3': 31, '4': 1, '5': 11, '6': '.api.proto.Resp.ListAllBalances', '9': 0, '10': 'listAllBalances'},
    const {'1': 'list_all_series', '3': 32, '4': 1, '5': 11, '6': '.api.proto.Resp.ListAllSeries', '9': 0, '10': 'listAllSeries'},
  ],
  '3': const [Resp_Login$json, Resp_Register$json, Resp_RegisterIssuer$json, Resp_Resume$json, Resp_Logout$json, Resp_AddGaid$json, Resp_LoadAssets$json, Resp_BuyShares$json, Resp_LoadCountries$json, Resp_LoadRegs$json, Resp_LoadFile$json, Resp_UpdateReg$json, Resp_ListAllTransactions$json, Resp_ListOwnTransactions$json, Resp_ListAllBalances$json, Resp_ListAllSeries$json],
  '8': const [
    const {'1': 'body'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_Login$json = const {
  '1': 'Login',
  '2': const [
    const {'1': 'request_id', '3': 1, '4': 2, '5': 9, '10': 'requestId'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_Register$json = const {
  '1': 'Register',
  '2': const [
    const {'1': 'request_id', '3': 1, '4': 2, '5': 9, '10': 'requestId'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_RegisterIssuer$json = const {
  '1': 'RegisterIssuer',
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_Resume$json = const {
  '1': 'Resume',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Account', '10': 'account'},
    const {'1': 'account_keys', '3': 2, '4': 3, '5': 11, '6': '.api.proto.AccountKey', '10': 'accountKeys'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_Logout$json = const {
  '1': 'Logout',
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_AddGaid$json = const {
  '1': 'AddGaid',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadAssets$json = const {
  '1': 'LoadAssets',
  '2': const [
    const {'1': 'assets', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Asset', '10': 'assets'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_BuyShares$json = const {
  '1': 'BuyShares',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 1, '10': 'amount'},
    const {'1': 'price', '3': 3, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'bitcoin_amount', '3': 4, '4': 2, '5': 1, '10': 'bitcoinAmount'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadCountries$json = const {
  '1': 'LoadCountries',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 9, '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadRegs$json = const {
  '1': 'LoadRegs',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Account', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadFile$json = const {
  '1': 'LoadFile',
  '2': const [
    const {'1': 'mime_type', '3': 1, '4': 2, '5': 9, '10': 'mimeType'},
    const {'1': 'data', '3': 2, '4': 2, '5': 12, '10': 'data'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_UpdateReg$json = const {
  '1': 'UpdateReg',
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListAllTransactions$json = const {
  '1': 'ListAllTransactions',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.FullTransaction', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListOwnTransactions$json = const {
  '1': 'ListOwnTransactions',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.OwnTransaction', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListAllBalances$json = const {
  '1': 'ListAllBalances',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.BalanceOwner', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListAllSeries$json = const {
  '1': 'ListAllSeries',
  '2': const [
    const {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.SerieOwner', '10': 'list'},
    const {'1': 'csv', '3': 2, '4': 2, '5': 9, '10': 'csv'},
  ],
};

/// Descriptor for `Resp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respDescriptor = $convert.base64Decode('CgRSZXNwEg4KAmlkGAEgAigDUgJpZBItCgVsb2dpbhgKIAEoCzIVLmFwaS5wcm90by5SZXNwLkxvZ2luSABSBWxvZ2luEjYKCHJlZ2lzdGVyGAsgASgLMhguYXBpLnByb3RvLlJlc3AuUmVnaXN0ZXJIAFIIcmVnaXN0ZXISSQoPcmVnaXN0ZXJfaXNzdWVyGA4gASgLMh4uYXBpLnByb3RvLlJlc3AuUmVnaXN0ZXJJc3N1ZXJIAFIOcmVnaXN0ZXJJc3N1ZXISMAoGcmVzdW1lGAwgASgLMhYuYXBpLnByb3RvLlJlc3AuUmVzdW1lSABSBnJlc3VtZRIwCgZsb2dvdXQYDSABKAsyFi5hcGkucHJvdG8uUmVzcC5Mb2dvdXRIAFIGbG9nb3V0EjQKCGFkZF9nYWlkGBQgASgLMhcuYXBpLnByb3RvLlJlc3AuQWRkR2FpZEgAUgdhZGRHYWlkEj0KC2xvYWRfYXNzZXRzGBUgASgLMhouYXBpLnByb3RvLlJlc3AuTG9hZEFzc2V0c0gAUgpsb2FkQXNzZXRzEjoKCmJ1eV9zaGFyZXMYGCABKAsyGS5hcGkucHJvdG8uUmVzcC5CdXlTaGFyZXNIAFIJYnV5U2hhcmVzEkYKDmxvYWRfY291bnRyaWVzGBkgASgLMh0uYXBpLnByb3RvLlJlc3AuTG9hZENvdW50cmllc0gAUg1sb2FkQ291bnRyaWVzEjcKCWxvYWRfcmVncxgaIAEoCzIYLmFwaS5wcm90by5SZXNwLkxvYWRSZWdzSABSCGxvYWRSZWdzEjcKCWxvYWRfZmlsZRgcIAEoCzIYLmFwaS5wcm90by5SZXNwLkxvYWRGaWxlSABSCGxvYWRGaWxlEjoKCnVwZGF0ZV9yZWcYGyABKAsyGS5hcGkucHJvdG8uUmVzcC5VcGRhdGVSZWdIAFIJdXBkYXRlUmVnElkKFWxpc3RfYWxsX3RyYW5zYWN0aW9ucxgdIAEoCzIjLmFwaS5wcm90by5SZXNwLkxpc3RBbGxUcmFuc2FjdGlvbnNIAFITbGlzdEFsbFRyYW5zYWN0aW9ucxJZChVsaXN0X293bl90cmFuc2FjdGlvbnMYHiABKAsyIy5hcGkucHJvdG8uUmVzcC5MaXN0T3duVHJhbnNhY3Rpb25zSABSE2xpc3RPd25UcmFuc2FjdGlvbnMSTQoRbGlzdF9hbGxfYmFsYW5jZXMYHyABKAsyHy5hcGkucHJvdG8uUmVzcC5MaXN0QWxsQmFsYW5jZXNIAFIPbGlzdEFsbEJhbGFuY2VzEkcKD2xpc3RfYWxsX3NlcmllcxggIAEoCzIdLmFwaS5wcm90by5SZXNwLkxpc3RBbGxTZXJpZXNIAFINbGlzdEFsbFNlcmllcxomCgVMb2dpbhIdCgpyZXF1ZXN0X2lkGAEgAigJUglyZXF1ZXN0SWQaKQoIUmVnaXN0ZXISHQoKcmVxdWVzdF9pZBgBIAIoCVIJcmVxdWVzdElkGhAKDlJlZ2lzdGVySXNzdWVyGnAKBlJlc3VtZRIsCgdhY2NvdW50GAEgAigLMhIuYXBpLnByb3RvLkFjY291bnRSB2FjY291bnQSOAoMYWNjb3VudF9rZXlzGAIgAygLMhUuYXBpLnByb3RvLkFjY291bnRLZXlSC2FjY291bnRLZXlzGggKBkxvZ291dBo3CgdBZGRHYWlkEiwKB2FjY291bnQYASACKAsyEi5hcGkucHJvdG8uQWNjb3VudFIHYWNjb3VudBo2CgpMb2FkQXNzZXRzEigKBmFzc2V0cxgBIAMoCzIQLmFwaS5wcm90by5Bc3NldFIGYXNzZXRzGnsKCUJ1eVNoYXJlcxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIWCgZhbW91bnQYAiACKAFSBmFtb3VudBIUCgVwcmljZRgDIAIoAVIFcHJpY2USJQoOYml0Y29pbl9hbW91bnQYBCACKAFSDWJpdGNvaW5BbW91bnQaIwoNTG9hZENvdW50cmllcxISCgRsaXN0GAEgAygJUgRsaXN0GjIKCExvYWRSZWdzEiYKBGxpc3QYASADKAsyEi5hcGkucHJvdG8uQWNjb3VudFIEbGlzdBo7CghMb2FkRmlsZRIbCgltaW1lX3R5cGUYASACKAlSCG1pbWVUeXBlEhIKBGRhdGEYAiACKAxSBGRhdGEaCwoJVXBkYXRlUmVnGkUKE0xpc3RBbGxUcmFuc2FjdGlvbnMSLgoEbGlzdBgBIAMoCzIaLmFwaS5wcm90by5GdWxsVHJhbnNhY3Rpb25SBGxpc3QaRAoTTGlzdE93blRyYW5zYWN0aW9ucxItCgRsaXN0GAEgAygLMhkuYXBpLnByb3RvLk93blRyYW5zYWN0aW9uUgRsaXN0Gj4KD0xpc3RBbGxCYWxhbmNlcxIrCgRsaXN0GAEgAygLMhcuYXBpLnByb3RvLkJhbGFuY2VPd25lclIEbGlzdBpMCg1MaXN0QWxsU2VyaWVzEikKBGxpc3QYASADKAsyFS5hcGkucHJvdG8uU2VyaWVPd25lclIEbGlzdBIQCgNjc3YYAiACKAlSA2NzdkIGCgRib2R5');
@$core.Deprecated('Use notifDescriptor instead')
const Notif$json = const {
  '1': 'Notif',
  '2': const [
    const {'1': 'login_failed', '3': 1, '4': 1, '5': 11, '6': '.api.proto.Notif.LoginFailed', '9': 0, '10': 'loginFailed'},
    const {'1': 'login_succeed', '3': 2, '4': 1, '5': 11, '6': '.api.proto.Notif.LoginSucceed', '9': 0, '10': 'loginSucceed'},
    const {'1': 'register_failed', '3': 3, '4': 1, '5': 11, '6': '.api.proto.Notif.RegisterFailed', '9': 0, '10': 'registerFailed'},
    const {'1': 'register_succeed', '3': 4, '4': 1, '5': 11, '6': '.api.proto.Notif.RegisterSucceed', '9': 0, '10': 'registerSucceed'},
    const {'1': 'free_shares', '3': 5, '4': 1, '5': 11, '6': '.api.proto.Notif.FreeShares', '9': 0, '10': 'freeShares'},
    const {'1': 'sold_shares', '3': 7, '4': 1, '5': 11, '6': '.api.proto.Notif.SoldShares', '9': 0, '10': 'soldShares'},
    const {'1': 'user_shares', '3': 8, '4': 1, '5': 11, '6': '.api.proto.Notif.UserShares', '9': 0, '10': 'userShares'},
    const {'1': 'buy_shares', '3': 6, '4': 1, '5': 11, '6': '.api.proto.Notif.BuyShares', '9': 0, '10': 'buyShares'},
    const {'1': 'update_prices', '3': 9, '4': 1, '5': 11, '6': '.api.proto.Notif.UpdatePrices', '9': 0, '10': 'updatePrices'},
    const {'1': 'update_market_data', '3': 10, '4': 1, '5': 11, '6': '.api.proto.Notif.UpdateMarketData', '9': 0, '10': 'updateMarketData'},
    const {'1': 'issued_amounts', '3': 11, '4': 1, '5': 11, '6': '.api.proto.Notif.IssuedAmounts', '9': 0, '10': 'issuedAmounts'},
    const {'1': 'update_balances', '3': 12, '4': 1, '5': 11, '6': '.api.proto.Notif.UpdateBalances', '9': 0, '10': 'updateBalances'},
    const {'1': 'eid_response', '3': 13, '4': 1, '5': 11, '6': '.api.proto.Notif.EidResponse', '9': 0, '10': 'eidResponse'},
  ],
  '3': const [Notif_LoginFailed$json, Notif_LoginSucceed$json, Notif_EidResponse$json, Notif_RegisterFailed$json, Notif_RegisterSucceed$json, Notif_FreeShares$json, Notif_SoldShares$json, Notif_UserShares$json, Notif_BuyShares$json, Notif_UpdatePrices$json, Notif_UpdateMarketData$json, Notif_IssuedAmounts$json, Notif_UpdateBalances$json],
  '8': const [
    const {'1': 'body'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_LoginFailed$json = const {
  '1': 'LoginFailed',
  '2': const [
    const {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_LoginSucceed$json = const {
  '1': 'LoginSucceed',
  '2': const [
    const {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
    const {'1': 'account_key', '3': 2, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_EidResponse$json = const {
  '1': 'EidResponse',
  '2': const [
    const {'1': 'request_id', '3': 1, '4': 2, '5': 9, '10': 'requestId'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_RegisterFailed$json = const {
  '1': 'RegisterFailed',
  '2': const [
    const {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_RegisterSucceed$json = const {
  '1': 'RegisterSucceed',
  '2': const [
    const {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
    const {'1': 'account_key', '3': 2, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_FreeShares$json = const {
  '1': 'FreeShares',
  '2': const [
    const {'1': 'free_shares', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Shares', '10': 'freeShares'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'amount', '3': 3, '4': 2, '5': 3, '10': 'amount'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_SoldShares$json = const {
  '1': 'SoldShares',
  '2': const [
    const {'1': 'sold_shares', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Shares', '10': 'soldShares'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UserShares$json = const {
  '1': 'UserShares',
  '2': const [
    const {'1': 'bought_shares', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Shares', '10': 'boughtShares'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_BuyShares$json = const {
  '1': 'BuyShares',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 1, '10': 'amount'},
    const {'1': 'price', '3': 3, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'bitcoin_amount', '3': 4, '4': 2, '5': 1, '10': 'bitcoinAmount'},
    const {'1': 'txid', '3': 5, '4': 1, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdatePrices$json = const {
  '1': 'UpdatePrices',
  '2': const [
    const {'1': 'bitcoin_usd_price', '3': 1, '4': 1, '5': 1, '10': 'bitcoinUsdPrice'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdateMarketData$json = const {
  '1': 'UpdateMarketData',
  '2': const [
    const {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Notif.UpdateMarketData.Data', '10': 'data'},
  ],
  '3': const [Notif_UpdateMarketData_Data$json],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdateMarketData_Data$json = const {
  '1': 'Data',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'last_price', '3': 2, '4': 1, '5': 1, '10': 'lastPrice'},
    const {'1': 'volume_30d', '3': 3, '4': 1, '5': 1, '10': 'volume30d'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_IssuedAmounts$json = const {
  '1': 'IssuedAmounts',
  '2': const [
    const {'1': 'assets', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Notif.IssuedAmounts.Asset', '10': 'assets'},
  ],
  '3': const [Notif_IssuedAmounts_Asset$json],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_IssuedAmounts_Asset$json = const {
  '1': 'Asset',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'online', '3': 2, '4': 2, '5': 1, '10': 'online'},
    const {'1': 'offline', '3': 3, '4': 2, '5': 1, '10': 'offline'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdateBalances$json = const {
  '1': 'UpdateBalances',
  '2': const [
    const {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    const {'1': 'balances', '3': 2, '4': 3, '5': 11, '6': '.api.proto.Balance', '10': 'balances'},
  ],
};

/// Descriptor for `Notif`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifDescriptor = $convert.base64Decode('CgVOb3RpZhJBCgxsb2dpbl9mYWlsZWQYASABKAsyHC5hcGkucHJvdG8uTm90aWYuTG9naW5GYWlsZWRIAFILbG9naW5GYWlsZWQSRAoNbG9naW5fc3VjY2VlZBgCIAEoCzIdLmFwaS5wcm90by5Ob3RpZi5Mb2dpblN1Y2NlZWRIAFIMbG9naW5TdWNjZWVkEkoKD3JlZ2lzdGVyX2ZhaWxlZBgDIAEoCzIfLmFwaS5wcm90by5Ob3RpZi5SZWdpc3RlckZhaWxlZEgAUg5yZWdpc3RlckZhaWxlZBJNChByZWdpc3Rlcl9zdWNjZWVkGAQgASgLMiAuYXBpLnByb3RvLk5vdGlmLlJlZ2lzdGVyU3VjY2VlZEgAUg9yZWdpc3RlclN1Y2NlZWQSPgoLZnJlZV9zaGFyZXMYBSABKAsyGy5hcGkucHJvdG8uTm90aWYuRnJlZVNoYXJlc0gAUgpmcmVlU2hhcmVzEj4KC3NvbGRfc2hhcmVzGAcgASgLMhsuYXBpLnByb3RvLk5vdGlmLlNvbGRTaGFyZXNIAFIKc29sZFNoYXJlcxI+Cgt1c2VyX3NoYXJlcxgIIAEoCzIbLmFwaS5wcm90by5Ob3RpZi5Vc2VyU2hhcmVzSABSCnVzZXJTaGFyZXMSOwoKYnV5X3NoYXJlcxgGIAEoCzIaLmFwaS5wcm90by5Ob3RpZi5CdXlTaGFyZXNIAFIJYnV5U2hhcmVzEkQKDXVwZGF0ZV9wcmljZXMYCSABKAsyHS5hcGkucHJvdG8uTm90aWYuVXBkYXRlUHJpY2VzSABSDHVwZGF0ZVByaWNlcxJRChJ1cGRhdGVfbWFya2V0X2RhdGEYCiABKAsyIS5hcGkucHJvdG8uTm90aWYuVXBkYXRlTWFya2V0RGF0YUgAUhB1cGRhdGVNYXJrZXREYXRhEkcKDmlzc3VlZF9hbW91bnRzGAsgASgLMh4uYXBpLnByb3RvLk5vdGlmLklzc3VlZEFtb3VudHNIAFINaXNzdWVkQW1vdW50cxJKCg91cGRhdGVfYmFsYW5jZXMYDCABKAsyHy5hcGkucHJvdG8uTm90aWYuVXBkYXRlQmFsYW5jZXNIAFIOdXBkYXRlQmFsYW5jZXMSQQoMZWlkX3Jlc3BvbnNlGA0gASgLMhwuYXBpLnByb3RvLk5vdGlmLkVpZFJlc3BvbnNlSABSC2VpZFJlc3BvbnNlGiEKC0xvZ2luRmFpbGVkEhIKBHRleHQYASACKAlSBHRleHQaRQoMTG9naW5TdWNjZWVkEhQKBXRva2VuGAEgAigJUgV0b2tlbhIfCgthY2NvdW50X2tleRgCIAIoCVIKYWNjb3VudEtleRosCgtFaWRSZXNwb25zZRIdCgpyZXF1ZXN0X2lkGAEgAigJUglyZXF1ZXN0SWQaJAoOUmVnaXN0ZXJGYWlsZWQSEgoEdGV4dBgBIAIoCVIEdGV4dBpICg9SZWdpc3RlclN1Y2NlZWQSFAoFdG9rZW4YASACKAlSBXRva2VuEh8KC2FjY291bnRfa2V5GAIgAigJUgphY2NvdW50S2V5GmwKCkZyZWVTaGFyZXMSMgoLZnJlZV9zaGFyZXMYASACKAsyES5hcGkucHJvdG8uU2hhcmVzUgpmcmVlU2hhcmVzEhIKBG5hbWUYAiACKAlSBG5hbWUSFgoGYW1vdW50GAMgAigDUgZhbW91bnQaQAoKU29sZFNoYXJlcxIyCgtzb2xkX3NoYXJlcxgBIAIoCzIRLmFwaS5wcm90by5TaGFyZXNSCnNvbGRTaGFyZXMaRAoKVXNlclNoYXJlcxI2Cg1ib3VnaHRfc2hhcmVzGAEgAigLMhEuYXBpLnByb3RvLlNoYXJlc1IMYm91Z2h0U2hhcmVzGo8BCglCdXlTaGFyZXMSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSFgoGYW1vdW50GAIgAigBUgZhbW91bnQSFAoFcHJpY2UYAyACKAFSBXByaWNlEiUKDmJpdGNvaW5fYW1vdW50GAQgAigBUg1iaXRjb2luQW1vdW50EhIKBHR4aWQYBSABKAlSBHR4aWQaOgoMVXBkYXRlUHJpY2VzEioKEWJpdGNvaW5fdXNkX3ByaWNlGAEgASgBUg9iaXRjb2luVXNkUHJpY2UarwEKEFVwZGF0ZU1hcmtldERhdGESOgoEZGF0YRgBIAMoCzImLmFwaS5wcm90by5Ob3RpZi5VcGRhdGVNYXJrZXREYXRhLkRhdGFSBGRhdGEaXwoERGF0YRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIdCgpsYXN0X3ByaWNlGAIgASgBUglsYXN0UHJpY2USHQoKdm9sdW1lXzMwZBgDIAEoAVIJdm9sdW1lMzBkGqMBCg1Jc3N1ZWRBbW91bnRzEjwKBmFzc2V0cxgBIAMoCzIkLmFwaS5wcm90by5Ob3RpZi5Jc3N1ZWRBbW91bnRzLkFzc2V0UgZhc3NldHMaVAoFQXNzZXQSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSFgoGb25saW5lGAIgAigBUgZvbmxpbmUSGAoHb2ZmbGluZRgDIAIoAVIHb2ZmbGluZRphCg5VcGRhdGVCYWxhbmNlcxIfCgthY2NvdW50X2tleRgBIAIoCVIKYWNjb3VudEtleRIuCghiYWxhbmNlcxgCIAMoCzISLmFwaS5wcm90by5CYWxhbmNlUghiYWxhbmNlc0IGCgRib2R5');
@$core.Deprecated('Use errDescriptor instead')
const Err$json = const {
  '1': 'Err',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'text', '3': 2, '4': 2, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Err`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errDescriptor = $convert.base64Decode('CgNFcnISDgoCaWQYASABKANSAmlkEhIKBHRleHQYAiACKAlSBHRleHQ=');
@$core.Deprecated('Use resDescriptor instead')
const Res$json = const {
  '1': 'Res',
  '2': const [
    const {'1': 'resp', '3': 1, '4': 1, '5': 11, '6': '.api.proto.Resp', '9': 0, '10': 'resp'},
    const {'1': 'notif', '3': 2, '4': 1, '5': 11, '6': '.api.proto.Notif', '9': 0, '10': 'notif'},
    const {'1': 'error', '3': 3, '4': 1, '5': 11, '6': '.api.proto.Err', '9': 0, '10': 'error'},
  ],
  '8': const [
    const {'1': 'body'},
  ],
};

/// Descriptor for `Res`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resDescriptor = $convert.base64Decode('CgNSZXMSJQoEcmVzcBgBIAEoCzIPLmFwaS5wcm90by5SZXNwSABSBHJlc3ASKAoFbm90aWYYAiABKAsyEC5hcGkucHJvdG8uTm90aWZIAFIFbm90aWYSJgoFZXJyb3IYAyABKAsyDi5hcGkucHJvdG8uRXJySABSBWVycm9yQgYKBGJvZHk=');
