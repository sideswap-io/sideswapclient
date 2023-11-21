//
//  Generated code. Do not modify.
//  source: pegx_api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use accountStateDescriptor instead')
const AccountState$json = {
  '1': 'AccountState',
  '2': [
    {'1': 'DISABLED', '2': 1},
    {'1': 'VERIFICATION', '2': 2},
    {'1': 'ACTIVE', '2': 3},
  ],
};

/// Descriptor for `AccountState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List accountStateDescriptor = $convert.base64Decode(
    'CgxBY2NvdW50U3RhdGUSDAoIRElTQUJMRUQQARIQCgxWRVJJRklDQVRJT04QAhIKCgZBQ1RJVk'
    'UQAw==');

@$core.Deprecated('Use accountKeyDescriptor instead')
const AccountKey$json = {
  '1': 'AccountKey',
  '2': [
    {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `AccountKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountKeyDescriptor = $convert.base64Decode(
    'CgpBY2NvdW50S2V5Eh8KC2FjY291bnRfa2V5GAEgAigJUgphY2NvdW50S2V5EhIKBG5hbWUYAi'
    'ACKAlSBG5hbWU=');

@$core.Deprecated('Use accountDetailsDescriptor instead')
const AccountDetails$json = {
  '1': 'AccountDetails',
  '2': [
    {'1': 'org', '3': 1, '4': 1, '5': 11, '6': '.api.proto.AccountDetails.OrgDetails', '9': 0, '10': 'org'},
    {'1': 'individual', '3': 2, '4': 1, '5': 11, '6': '.api.proto.AccountDetails.IndividualDetails', '9': 0, '10': 'individual'},
    {'1': 'account_state', '3': 3, '4': 2, '5': 14, '6': '.api.proto.AccountState', '10': 'accountState'},
  ],
  '3': [AccountDetails_OrgDetails$json, AccountDetails_IndividualDetails$json],
  '8': [
    {'1': 'details'},
  ],
};

@$core.Deprecated('Use accountDetailsDescriptor instead')
const AccountDetails_OrgDetails$json = {
  '1': 'OrgDetails',
  '2': [
    {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    {'1': 'address', '3': 2, '4': 2, '5': 9, '10': 'address'},
    {'1': 'city', '3': 3, '4': 2, '5': 9, '10': 'city'},
    {'1': 'postcode', '3': 4, '4': 2, '5': 9, '10': 'postcode'},
    {'1': 'country', '3': 5, '4': 2, '5': 9, '10': 'country'},
    {'1': 'website', '3': 6, '4': 2, '5': 9, '10': 'website'},
    {'1': 'reg_number', '3': 7, '4': 2, '5': 9, '10': 'regNumber'},
    {'1': 'owner_email', '3': 8, '4': 2, '5': 9, '10': 'ownerEmail'},
  ],
};

@$core.Deprecated('Use accountDetailsDescriptor instead')
const AccountDetails_IndividualDetails$json = {
  '1': 'IndividualDetails',
  '2': [
    {'1': 'first_name', '3': 1, '4': 2, '5': 9, '10': 'firstName'},
    {'1': 'last_name', '3': 2, '4': 2, '5': 9, '10': 'lastName'},
    {'1': 'email', '3': 3, '4': 2, '5': 9, '10': 'email'},
    {'1': 'phone_number', '3': 4, '4': 2, '5': 9, '10': 'phoneNumber'},
    {'1': 'gender', '3': 5, '4': 2, '5': 9, '10': 'gender'},
    {'1': 'date_of_birth', '3': 6, '4': 2, '5': 9, '10': 'dateOfBirth'},
    {'1': 'nationality', '3': 7, '4': 2, '5': 9, '10': 'nationality'},
    {'1': 'personal_number', '3': 8, '4': 2, '5': 9, '10': 'personalNumber'},
    {'1': 'residency_country', '3': 9, '4': 2, '5': 9, '10': 'residencyCountry'},
    {'1': 'residency_area', '3': 10, '4': 2, '5': 9, '10': 'residencyArea'},
    {'1': 'residency_city', '3': 11, '4': 2, '5': 9, '10': 'residencyCity'},
    {'1': 'residency_postcode', '3': 12, '4': 2, '5': 9, '10': 'residencyPostcode'},
    {'1': 'residency_address', '3': 13, '4': 2, '5': 9, '10': 'residencyAddress'},
    {'1': 'residency_address2', '3': 14, '4': 2, '5': 9, '10': 'residencyAddress2'},
  ],
};

/// Descriptor for `AccountDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDetailsDescriptor = $convert.base64Decode(
    'Cg5BY2NvdW50RGV0YWlscxI4CgNvcmcYASABKAsyJC5hcGkucHJvdG8uQWNjb3VudERldGFpbH'
    'MuT3JnRGV0YWlsc0gAUgNvcmcSTQoKaW5kaXZpZHVhbBgCIAEoCzIrLmFwaS5wcm90by5BY2Nv'
    'dW50RGV0YWlscy5JbmRpdmlkdWFsRGV0YWlsc0gAUgppbmRpdmlkdWFsEjwKDWFjY291bnRfc3'
    'RhdGUYAyACKA4yFy5hcGkucHJvdG8uQWNjb3VudFN0YXRlUgxhY2NvdW50U3RhdGUa3gEKCk9y'
    'Z0RldGFpbHMSEgoEbmFtZRgBIAIoCVIEbmFtZRIYCgdhZGRyZXNzGAIgAigJUgdhZGRyZXNzEh'
    'IKBGNpdHkYAyACKAlSBGNpdHkSGgoIcG9zdGNvZGUYBCACKAlSCHBvc3Rjb2RlEhgKB2NvdW50'
    'cnkYBSACKAlSB2NvdW50cnkSGAoHd2Vic2l0ZRgGIAIoCVIHd2Vic2l0ZRIdCgpyZWdfbnVtYm'
    'VyGAcgAigJUglyZWdOdW1iZXISHwoLb3duZXJfZW1haWwYCCACKAlSCm93bmVyRW1haWwalQQK'
    'EUluZGl2aWR1YWxEZXRhaWxzEh0KCmZpcnN0X25hbWUYASACKAlSCWZpcnN0TmFtZRIbCglsYX'
    'N0X25hbWUYAiACKAlSCGxhc3ROYW1lEhQKBWVtYWlsGAMgAigJUgVlbWFpbBIhCgxwaG9uZV9u'
    'dW1iZXIYBCACKAlSC3Bob25lTnVtYmVyEhYKBmdlbmRlchgFIAIoCVIGZ2VuZGVyEiIKDWRhdG'
    'Vfb2ZfYmlydGgYBiACKAlSC2RhdGVPZkJpcnRoEiAKC25hdGlvbmFsaXR5GAcgAigJUgtuYXRp'
    'b25hbGl0eRInCg9wZXJzb25hbF9udW1iZXIYCCACKAlSDnBlcnNvbmFsTnVtYmVyEisKEXJlc2'
    'lkZW5jeV9jb3VudHJ5GAkgAigJUhByZXNpZGVuY3lDb3VudHJ5EiUKDnJlc2lkZW5jeV9hcmVh'
    'GAogAigJUg1yZXNpZGVuY3lBcmVhEiUKDnJlc2lkZW5jeV9jaXR5GAsgAigJUg1yZXNpZGVuY3'
    'lDaXR5Ei0KEnJlc2lkZW5jeV9wb3N0Y29kZRgMIAIoCVIRcmVzaWRlbmN5UG9zdGNvZGUSKwoR'
    'cmVzaWRlbmN5X2FkZHJlc3MYDSACKAlSEHJlc2lkZW5jeUFkZHJlc3MSLQoScmVzaWRlbmN5X2'
    'FkZHJlc3MyGA4gAigJUhFyZXNpZGVuY3lBZGRyZXNzMkIJCgdkZXRhaWxz');

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    {'1': 'details', '3': 2, '4': 2, '5': 11, '6': '.api.proto.AccountDetails', '10': 'details'},
    {'1': 'gaids', '3': 3, '4': 3, '5': 9, '10': 'gaids'},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50Eh8KC2FjY291bnRfa2V5GAEgAigJUgphY2NvdW50S2V5EjMKB2RldGFpbHMYAi'
    'ACKAsyGS5hcGkucHJvdG8uQWNjb3VudERldGFpbHNSB2RldGFpbHMSFAoFZ2FpZHMYAyADKAlS'
    'BWdhaWRz');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'ticker', '3': 3, '4': 2, '5': 9, '10': 'ticker'},
    {'1': 'precision', '3': 4, '4': 2, '5': 5, '10': 'precision'},
    {'1': 'domain', '3': 5, '4': 2, '5': 9, '10': 'domain'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEh'
    'YKBnRpY2tlchgDIAIoCVIGdGlja2VyEhwKCXByZWNpc2lvbhgEIAIoBVIJcHJlY2lzaW9uEhYK'
    'BmRvbWFpbhgFIAIoCVIGZG9tYWlu');

@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = {
  '1': 'Balance',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'balance', '3': 2, '4': 2, '5': 1, '10': 'balance'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode(
    'CgdCYWxhbmNlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhgKB2JhbGFuY2UYAiACKAFSB2'
    'JhbGFuY2U=');

@$core.Deprecated('Use sharesDescriptor instead')
const Shares$json = {
  '1': 'Shares',
  '2': [
    {'1': 'count', '3': 1, '4': 2, '5': 1, '10': 'count'},
    {'1': 'total', '3': 2, '4': 2, '5': 1, '10': 'total'},
  ],
};

/// Descriptor for `Shares`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sharesDescriptor = $convert.base64Decode(
    'CgZTaGFyZXMSFAoFY291bnQYASACKAFSBWNvdW50EhQKBXRvdGFsGAIgAigBUgV0b3RhbA==');

@$core.Deprecated('Use inOutDescriptor instead')
const InOut$json = {
  '1': 'InOut',
  '2': [
    {'1': 'amount', '3': 1, '4': 2, '5': 1, '10': 'amount'},
    {'1': 'gaid', '3': 2, '4': 1, '5': 9, '10': 'gaid'},
  ],
};

/// Descriptor for `InOut`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inOutDescriptor = $convert.base64Decode(
    'CgVJbk91dBIWCgZhbW91bnQYASACKAFSBmFtb3VudBISCgRnYWlkGAIgASgJUgRnYWlk');

@$core.Deprecated('Use fullTransactionDescriptor instead')
const FullTransaction$json = {
  '1': 'FullTransaction',
  '2': [
    {'1': 'inputs', '3': 1, '4': 3, '5': 11, '6': '.api.proto.InOut', '10': 'inputs'},
    {'1': 'outputs', '3': 2, '4': 3, '5': 11, '6': '.api.proto.InOut', '10': 'outputs'},
    {'1': 'txid', '3': 3, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'timestamp', '3': 4, '4': 2, '5': 3, '10': 'timestamp'},
    {'1': 'unblinded', '3': 5, '4': 2, '5': 9, '10': 'unblinded'},
    {'1': 'price', '3': 6, '4': 1, '5': 1, '10': 'price'},
  ],
};

/// Descriptor for `FullTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fullTransactionDescriptor = $convert.base64Decode(
    'Cg9GdWxsVHJhbnNhY3Rpb24SKAoGaW5wdXRzGAEgAygLMhAuYXBpLnByb3RvLkluT3V0UgZpbn'
    'B1dHMSKgoHb3V0cHV0cxgCIAMoCzIQLmFwaS5wcm90by5Jbk91dFIHb3V0cHV0cxISCgR0eGlk'
    'GAMgAigJUgR0eGlkEhwKCXRpbWVzdGFtcBgEIAIoA1IJdGltZXN0YW1wEhwKCXVuYmxpbmRlZB'
    'gFIAIoCVIJdW5ibGluZGVkEhQKBXByaWNlGAYgASgBUgVwcmljZQ==');

@$core.Deprecated('Use ownTransactionDescriptor instead')
const OwnTransaction$json = {
  '1': 'OwnTransaction',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'timestamp', '3': 2, '4': 2, '5': 3, '10': 'timestamp'},
    {'1': 'amount', '3': 3, '4': 2, '5': 1, '10': 'amount'},
    {'1': 'price', '3': 4, '4': 1, '5': 1, '10': 'price'},
  ],
};

/// Descriptor for `OwnTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ownTransactionDescriptor = $convert.base64Decode(
    'Cg5Pd25UcmFuc2FjdGlvbhISCgR0eGlkGAEgAigJUgR0eGlkEhwKCXRpbWVzdGFtcBgCIAIoA1'
    'IJdGltZXN0YW1wEhYKBmFtb3VudBgDIAIoAVIGYW1vdW50EhQKBXByaWNlGAQgASgBUgVwcmlj'
    'ZQ==');

@$core.Deprecated('Use balanceOwnerDescriptor instead')
const BalanceOwner$json = {
  '1': 'BalanceOwner',
  '2': [
    {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    {'1': 'amount', '3': 2, '4': 2, '5': 1, '10': 'amount'},
  ],
};

/// Descriptor for `BalanceOwner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceOwnerDescriptor = $convert.base64Decode(
    'CgxCYWxhbmNlT3duZXISHwoLYWNjb3VudF9rZXkYASACKAlSCmFjY291bnRLZXkSFgoGYW1vdW'
    '50GAIgAigBUgZhbW91bnQ=');

@$core.Deprecated('Use serieDescriptor instead')
const Serie$json = {
  '1': 'Serie',
  '2': [
    {'1': 'start', '3': 2, '4': 2, '5': 3, '10': 'start'},
    {'1': 'count', '3': 3, '4': 2, '5': 3, '10': 'count'},
  ],
};

/// Descriptor for `Serie`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serieDescriptor = $convert.base64Decode(
    'CgVTZXJpZRIUCgVzdGFydBgCIAIoA1IFc3RhcnQSFAoFY291bnQYAyACKANSBWNvdW50');

@$core.Deprecated('Use serieOwnerDescriptor instead')
const SerieOwner$json = {
  '1': 'SerieOwner',
  '2': [
    {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    {'1': 'series', '3': 2, '4': 3, '5': 11, '6': '.api.proto.Serie', '10': 'series'},
  ],
};

/// Descriptor for `SerieOwner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serieOwnerDescriptor = $convert.base64Decode(
    'CgpTZXJpZU93bmVyEh8KC2FjY291bnRfa2V5GAEgAigJUgphY2NvdW50S2V5EigKBnNlcmllcx'
    'gCIAMoCzIQLmFwaS5wcm90by5TZXJpZVIGc2VyaWVz');

@$core.Deprecated('Use reqDescriptor instead')
const Req$json = {
  '1': 'Req',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 3, '10': 'id'},
    {'1': 'login_or_register', '3': 11, '4': 1, '5': 11, '6': '.api.proto.Req.LoginOrRegister', '9': 0, '10': 'loginOrRegister'},
    {'1': 'register_issuer', '3': 14, '4': 1, '5': 11, '6': '.api.proto.Req.RegisterIssuer', '9': 0, '10': 'registerIssuer'},
    {'1': 'resume', '3': 12, '4': 1, '5': 11, '6': '.api.proto.Req.Resume', '9': 0, '10': 'resume'},
    {'1': 'logout', '3': 13, '4': 1, '5': 11, '6': '.api.proto.Req.Logout', '9': 0, '10': 'logout'},
    {'1': 'add_gaid', '3': 20, '4': 1, '5': 11, '6': '.api.proto.Req.AddGaid', '9': 0, '10': 'addGaid'},
    {'1': 'load_assets', '3': 21, '4': 1, '5': 11, '6': '.api.proto.Req.LoadAssets', '9': 0, '10': 'loadAssets'},
    {'1': 'buy_shares', '3': 24, '4': 1, '5': 11, '6': '.api.proto.Req.BuyShares', '9': 0, '10': 'buyShares'},
    {'1': 'load_countries', '3': 25, '4': 1, '5': 11, '6': '.api.proto.Req.LoadCountries', '9': 0, '10': 'loadCountries'},
    {'1': 'load_regs', '3': 26, '4': 1, '5': 11, '6': '.api.proto.Req.LoadRegs', '9': 0, '10': 'loadRegs'},
    {'1': 'load_file', '3': 28, '4': 1, '5': 11, '6': '.api.proto.Req.LoadFile', '9': 0, '10': 'loadFile'},
    {'1': 'update_reg', '3': 27, '4': 1, '5': 11, '6': '.api.proto.Req.UpdateReg', '9': 0, '10': 'updateReg'},
    {'1': 'list_all_transactions', '3': 29, '4': 1, '5': 11, '6': '.api.proto.Req.ListAllTransactions', '9': 0, '10': 'listAllTransactions'},
    {'1': 'list_own_transactions', '3': 30, '4': 1, '5': 11, '6': '.api.proto.Req.ListOwnTransactions', '9': 0, '10': 'listOwnTransactions'},
    {'1': 'list_all_balances', '3': 31, '4': 1, '5': 11, '6': '.api.proto.Req.ListAllBalances', '9': 0, '10': 'listAllBalances'},
    {'1': 'list_all_series', '3': 32, '4': 1, '5': 11, '6': '.api.proto.Req.ListAllSeries', '9': 0, '10': 'listAllSeries'},
  ],
  '3': [Req_LoginOrRegister$json, Req_RegisterIssuer$json, Req_Resume$json, Req_Logout$json, Req_AddGaid$json, Req_LoadAssets$json, Req_BuyShares$json, Req_LoadCountries$json, Req_LoadRegs$json, Req_LoadFile$json, Req_UpdateReg$json, Req_ListAllTransactions$json, Req_ListOwnTransactions$json, Req_ListAllBalances$json, Req_ListAllSeries$json],
  '8': [
    {'1': 'body'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoginOrRegister$json = {
  '1': 'LoginOrRegister',
  '2': [
    {'1': 'org', '3': 1, '4': 1, '5': 11, '6': '.api.proto.Req.LoginOrRegister.Org', '10': 'org'},
  ],
  '3': [Req_LoginOrRegister_Org$json],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoginOrRegister_Org$json = {
  '1': 'Org',
  '2': [
    {'1': 'name', '3': 1, '4': 2, '5': 9, '10': 'name'},
    {'1': 'address', '3': 2, '4': 2, '5': 9, '10': 'address'},
    {'1': 'city', '3': 3, '4': 2, '5': 9, '10': 'city'},
    {'1': 'postcode', '3': 4, '4': 2, '5': 9, '10': 'postcode'},
    {'1': 'country', '3': 5, '4': 2, '5': 9, '10': 'country'},
    {'1': 'website', '3': 6, '4': 2, '5': 9, '10': 'website'},
    {'1': 'reg_number', '3': 7, '4': 2, '5': 9, '10': 'regNumber'},
    {'1': 'reg_proof', '3': 8, '4': 2, '5': 12, '10': 'regProof'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_RegisterIssuer$json = {
  '1': 'RegisterIssuer',
  '2': [
    {'1': 'email', '3': 1, '4': 2, '5': 9, '10': 'email'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'website', '3': 3, '4': 2, '5': 9, '10': 'website'},
    {'1': 'message', '3': 4, '4': 2, '5': 9, '10': 'message'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_Resume$json = {
  '1': 'Resume',
  '2': [
    {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
    {'1': 'account_key', '3': 2, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_Logout$json = {
  '1': 'Logout',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_AddGaid$json = {
  '1': 'AddGaid',
  '2': [
    {'1': 'gaid', '3': 1, '4': 2, '5': 9, '10': 'gaid'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadAssets$json = {
  '1': 'LoadAssets',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_BuyShares$json = {
  '1': 'BuyShares',
  '2': [
    {'1': 'amount', '3': 1, '4': 2, '5': 1, '10': 'amount'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadCountries$json = {
  '1': 'LoadCountries',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadRegs$json = {
  '1': 'LoadRegs',
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_LoadFile$json = {
  '1': 'LoadFile',
  '2': [
    {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_UpdateReg$json = {
  '1': 'UpdateReg',
  '2': [
    {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    {'1': 'valid', '3': 2, '4': 2, '5': 8, '10': 'valid'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListAllTransactions$json = {
  '1': 'ListAllTransactions',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListOwnTransactions$json = {
  '1': 'ListOwnTransactions',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListAllBalances$json = {
  '1': 'ListAllBalances',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use reqDescriptor instead')
const Req_ListAllSeries$json = {
  '1': 'ListAllSeries',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `Req`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reqDescriptor = $convert.base64Decode(
    'CgNSZXESDgoCaWQYASACKANSAmlkEkwKEWxvZ2luX29yX3JlZ2lzdGVyGAsgASgLMh4uYXBpLn'
    'Byb3RvLlJlcS5Mb2dpbk9yUmVnaXN0ZXJIAFIPbG9naW5PclJlZ2lzdGVyEkgKD3JlZ2lzdGVy'
    'X2lzc3VlchgOIAEoCzIdLmFwaS5wcm90by5SZXEuUmVnaXN0ZXJJc3N1ZXJIAFIOcmVnaXN0ZX'
    'JJc3N1ZXISLwoGcmVzdW1lGAwgASgLMhUuYXBpLnByb3RvLlJlcS5SZXN1bWVIAFIGcmVzdW1l'
    'Ei8KBmxvZ291dBgNIAEoCzIVLmFwaS5wcm90by5SZXEuTG9nb3V0SABSBmxvZ291dBIzCghhZG'
    'RfZ2FpZBgUIAEoCzIWLmFwaS5wcm90by5SZXEuQWRkR2FpZEgAUgdhZGRHYWlkEjwKC2xvYWRf'
    'YXNzZXRzGBUgASgLMhkuYXBpLnByb3RvLlJlcS5Mb2FkQXNzZXRzSABSCmxvYWRBc3NldHMSOQ'
    'oKYnV5X3NoYXJlcxgYIAEoCzIYLmFwaS5wcm90by5SZXEuQnV5U2hhcmVzSABSCWJ1eVNoYXJl'
    'cxJFCg5sb2FkX2NvdW50cmllcxgZIAEoCzIcLmFwaS5wcm90by5SZXEuTG9hZENvdW50cmllc0'
    'gAUg1sb2FkQ291bnRyaWVzEjYKCWxvYWRfcmVncxgaIAEoCzIXLmFwaS5wcm90by5SZXEuTG9h'
    'ZFJlZ3NIAFIIbG9hZFJlZ3MSNgoJbG9hZF9maWxlGBwgASgLMhcuYXBpLnByb3RvLlJlcS5Mb2'
    'FkRmlsZUgAUghsb2FkRmlsZRI5Cgp1cGRhdGVfcmVnGBsgASgLMhguYXBpLnByb3RvLlJlcS5V'
    'cGRhdGVSZWdIAFIJdXBkYXRlUmVnElgKFWxpc3RfYWxsX3RyYW5zYWN0aW9ucxgdIAEoCzIiLm'
    'FwaS5wcm90by5SZXEuTGlzdEFsbFRyYW5zYWN0aW9uc0gAUhNsaXN0QWxsVHJhbnNhY3Rpb25z'
    'ElgKFWxpc3Rfb3duX3RyYW5zYWN0aW9ucxgeIAEoCzIiLmFwaS5wcm90by5SZXEuTGlzdE93bl'
    'RyYW5zYWN0aW9uc0gAUhNsaXN0T3duVHJhbnNhY3Rpb25zEkwKEWxpc3RfYWxsX2JhbGFuY2Vz'
    'GB8gASgLMh4uYXBpLnByb3RvLlJlcS5MaXN0QWxsQmFsYW5jZXNIAFIPbGlzdEFsbEJhbGFuY2'
    'VzEkYKD2xpc3RfYWxsX3NlcmllcxggIAEoCzIcLmFwaS5wcm90by5SZXEuTGlzdEFsbFNlcmll'
    'c0gAUg1saXN0QWxsU2VyaWVzGp0CCg9Mb2dpbk9yUmVnaXN0ZXISNAoDb3JnGAEgASgLMiIuYX'
    'BpLnByb3RvLlJlcS5Mb2dpbk9yUmVnaXN0ZXIuT3JnUgNvcmca0wEKA09yZxISCgRuYW1lGAEg'
    'AigJUgRuYW1lEhgKB2FkZHJlc3MYAiACKAlSB2FkZHJlc3MSEgoEY2l0eRgDIAIoCVIEY2l0eR'
    'IaCghwb3N0Y29kZRgEIAIoCVIIcG9zdGNvZGUSGAoHY291bnRyeRgFIAIoCVIHY291bnRyeRIY'
    'Cgd3ZWJzaXRlGAYgAigJUgd3ZWJzaXRlEh0KCnJlZ19udW1iZXIYByACKAlSCXJlZ051bWJlch'
    'IbCglyZWdfcHJvb2YYCCACKAxSCHJlZ1Byb29mGm4KDlJlZ2lzdGVySXNzdWVyEhQKBWVtYWls'
    'GAEgAigJUgVlbWFpbBISCgRuYW1lGAIgAigJUgRuYW1lEhgKB3dlYnNpdGUYAyACKAlSB3dlYn'
    'NpdGUSGAoHbWVzc2FnZRgEIAIoCVIHbWVzc2FnZRo/CgZSZXN1bWUSFAoFdG9rZW4YASACKAlS'
    'BXRva2VuEh8KC2FjY291bnRfa2V5GAIgAigJUgphY2NvdW50S2V5GggKBkxvZ291dBodCgdBZG'
    'RHYWlkEhIKBGdhaWQYASACKAlSBGdhaWQaDAoKTG9hZEFzc2V0cxojCglCdXlTaGFyZXMSFgoG'
    'YW1vdW50GAEgAigBUgZhbW91bnQaDwoNTG9hZENvdW50cmllcxoKCghMb2FkUmVncxorCghMb2'
    'FkRmlsZRIfCgthY2NvdW50X2tleRgBIAIoCVIKYWNjb3VudEtleRpCCglVcGRhdGVSZWcSHwoL'
    'YWNjb3VudF9rZXkYASACKAlSCmFjY291bnRLZXkSFAoFdmFsaWQYAiACKAhSBXZhbGlkGjAKE0'
    'xpc3RBbGxUcmFuc2FjdGlvbnMSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQaMAoTTGlzdE93'
    'blRyYW5zYWN0aW9ucxIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBosCg9MaXN0QWxsQmFsYW'
    '5jZXMSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQaKgoNTGlzdEFsbFNlcmllcxIZCghhc3Nl'
    'dF9pZBgBIAIoCVIHYXNzZXRJZEIGCgRib2R5');

@$core.Deprecated('Use respDescriptor instead')
const Resp$json = {
  '1': 'Resp',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 3, '10': 'id'},
    {'1': 'login_or_register', '3': 11, '4': 1, '5': 11, '6': '.api.proto.Resp.LoginOrRegister', '9': 0, '10': 'loginOrRegister'},
    {'1': 'register_issuer', '3': 14, '4': 1, '5': 11, '6': '.api.proto.Resp.RegisterIssuer', '9': 0, '10': 'registerIssuer'},
    {'1': 'resume', '3': 12, '4': 1, '5': 11, '6': '.api.proto.Resp.Resume', '9': 0, '10': 'resume'},
    {'1': 'logout', '3': 13, '4': 1, '5': 11, '6': '.api.proto.Resp.Logout', '9': 0, '10': 'logout'},
    {'1': 'add_gaid', '3': 20, '4': 1, '5': 11, '6': '.api.proto.Resp.AddGaid', '9': 0, '10': 'addGaid'},
    {'1': 'load_assets', '3': 21, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadAssets', '9': 0, '10': 'loadAssets'},
    {'1': 'buy_shares', '3': 24, '4': 1, '5': 11, '6': '.api.proto.Resp.BuyShares', '9': 0, '10': 'buyShares'},
    {'1': 'load_countries', '3': 25, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadCountries', '9': 0, '10': 'loadCountries'},
    {'1': 'load_regs', '3': 26, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadRegs', '9': 0, '10': 'loadRegs'},
    {'1': 'load_file', '3': 28, '4': 1, '5': 11, '6': '.api.proto.Resp.LoadFile', '9': 0, '10': 'loadFile'},
    {'1': 'update_reg', '3': 27, '4': 1, '5': 11, '6': '.api.proto.Resp.UpdateReg', '9': 0, '10': 'updateReg'},
    {'1': 'list_all_transactions', '3': 29, '4': 1, '5': 11, '6': '.api.proto.Resp.ListAllTransactions', '9': 0, '10': 'listAllTransactions'},
    {'1': 'list_own_transactions', '3': 30, '4': 1, '5': 11, '6': '.api.proto.Resp.ListOwnTransactions', '9': 0, '10': 'listOwnTransactions'},
    {'1': 'list_all_balances', '3': 31, '4': 1, '5': 11, '6': '.api.proto.Resp.ListAllBalances', '9': 0, '10': 'listAllBalances'},
    {'1': 'list_all_series', '3': 32, '4': 1, '5': 11, '6': '.api.proto.Resp.ListAllSeries', '9': 0, '10': 'listAllSeries'},
  ],
  '3': [Resp_LoginOrRegister$json, Resp_RegisterIssuer$json, Resp_Resume$json, Resp_Logout$json, Resp_AddGaid$json, Resp_LoadAssets$json, Resp_BuyShares$json, Resp_LoadCountries$json, Resp_LoadRegs$json, Resp_LoadFile$json, Resp_UpdateReg$json, Resp_ListAllTransactions$json, Resp_ListOwnTransactions$json, Resp_ListAllBalances$json, Resp_ListAllSeries$json],
  '8': [
    {'1': 'body'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoginOrRegister$json = {
  '1': 'LoginOrRegister',
  '2': [
    {'1': 'request_id', '3': 1, '4': 2, '5': 9, '10': 'requestId'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_RegisterIssuer$json = {
  '1': 'RegisterIssuer',
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_Resume$json = {
  '1': 'Resume',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Account', '10': 'account'},
    {'1': 'account_keys', '3': 2, '4': 3, '5': 11, '6': '.api.proto.AccountKey', '10': 'accountKeys'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_Logout$json = {
  '1': 'Logout',
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_AddGaid$json = {
  '1': 'AddGaid',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadAssets$json = {
  '1': 'LoadAssets',
  '2': [
    {'1': 'assets', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Asset', '10': 'assets'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_BuyShares$json = {
  '1': 'BuyShares',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'amount', '3': 2, '4': 2, '5': 1, '10': 'amount'},
    {'1': 'price', '3': 3, '4': 2, '5': 1, '10': 'price'},
    {'1': 'bitcoin_amount', '3': 4, '4': 2, '5': 1, '10': 'bitcoinAmount'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadCountries$json = {
  '1': 'LoadCountries',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 9, '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadRegs$json = {
  '1': 'LoadRegs',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Account', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_LoadFile$json = {
  '1': 'LoadFile',
  '2': [
    {'1': 'mime_type', '3': 1, '4': 2, '5': 9, '10': 'mimeType'},
    {'1': 'data', '3': 2, '4': 2, '5': 12, '10': 'data'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_UpdateReg$json = {
  '1': 'UpdateReg',
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListAllTransactions$json = {
  '1': 'ListAllTransactions',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.FullTransaction', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListOwnTransactions$json = {
  '1': 'ListOwnTransactions',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.OwnTransaction', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListAllBalances$json = {
  '1': 'ListAllBalances',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.BalanceOwner', '10': 'list'},
  ],
};

@$core.Deprecated('Use respDescriptor instead')
const Resp_ListAllSeries$json = {
  '1': 'ListAllSeries',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.api.proto.SerieOwner', '10': 'list'},
    {'1': 'csv', '3': 2, '4': 2, '5': 9, '10': 'csv'},
  ],
};

/// Descriptor for `Resp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respDescriptor = $convert.base64Decode(
    'CgRSZXNwEg4KAmlkGAEgAigDUgJpZBJNChFsb2dpbl9vcl9yZWdpc3RlchgLIAEoCzIfLmFwaS'
    '5wcm90by5SZXNwLkxvZ2luT3JSZWdpc3RlckgAUg9sb2dpbk9yUmVnaXN0ZXISSQoPcmVnaXN0'
    'ZXJfaXNzdWVyGA4gASgLMh4uYXBpLnByb3RvLlJlc3AuUmVnaXN0ZXJJc3N1ZXJIAFIOcmVnaX'
    'N0ZXJJc3N1ZXISMAoGcmVzdW1lGAwgASgLMhYuYXBpLnByb3RvLlJlc3AuUmVzdW1lSABSBnJl'
    'c3VtZRIwCgZsb2dvdXQYDSABKAsyFi5hcGkucHJvdG8uUmVzcC5Mb2dvdXRIAFIGbG9nb3V0Ej'
    'QKCGFkZF9nYWlkGBQgASgLMhcuYXBpLnByb3RvLlJlc3AuQWRkR2FpZEgAUgdhZGRHYWlkEj0K'
    'C2xvYWRfYXNzZXRzGBUgASgLMhouYXBpLnByb3RvLlJlc3AuTG9hZEFzc2V0c0gAUgpsb2FkQX'
    'NzZXRzEjoKCmJ1eV9zaGFyZXMYGCABKAsyGS5hcGkucHJvdG8uUmVzcC5CdXlTaGFyZXNIAFIJ'
    'YnV5U2hhcmVzEkYKDmxvYWRfY291bnRyaWVzGBkgASgLMh0uYXBpLnByb3RvLlJlc3AuTG9hZE'
    'NvdW50cmllc0gAUg1sb2FkQ291bnRyaWVzEjcKCWxvYWRfcmVncxgaIAEoCzIYLmFwaS5wcm90'
    'by5SZXNwLkxvYWRSZWdzSABSCGxvYWRSZWdzEjcKCWxvYWRfZmlsZRgcIAEoCzIYLmFwaS5wcm'
    '90by5SZXNwLkxvYWRGaWxlSABSCGxvYWRGaWxlEjoKCnVwZGF0ZV9yZWcYGyABKAsyGS5hcGku'
    'cHJvdG8uUmVzcC5VcGRhdGVSZWdIAFIJdXBkYXRlUmVnElkKFWxpc3RfYWxsX3RyYW5zYWN0aW'
    '9ucxgdIAEoCzIjLmFwaS5wcm90by5SZXNwLkxpc3RBbGxUcmFuc2FjdGlvbnNIAFITbGlzdEFs'
    'bFRyYW5zYWN0aW9ucxJZChVsaXN0X293bl90cmFuc2FjdGlvbnMYHiABKAsyIy5hcGkucHJvdG'
    '8uUmVzcC5MaXN0T3duVHJhbnNhY3Rpb25zSABSE2xpc3RPd25UcmFuc2FjdGlvbnMSTQoRbGlz'
    'dF9hbGxfYmFsYW5jZXMYHyABKAsyHy5hcGkucHJvdG8uUmVzcC5MaXN0QWxsQmFsYW5jZXNIAF'
    'IPbGlzdEFsbEJhbGFuY2VzEkcKD2xpc3RfYWxsX3NlcmllcxggIAEoCzIdLmFwaS5wcm90by5S'
    'ZXNwLkxpc3RBbGxTZXJpZXNIAFINbGlzdEFsbFNlcmllcxowCg9Mb2dpbk9yUmVnaXN0ZXISHQ'
    'oKcmVxdWVzdF9pZBgBIAIoCVIJcmVxdWVzdElkGhAKDlJlZ2lzdGVySXNzdWVyGnAKBlJlc3Vt'
    'ZRIsCgdhY2NvdW50GAEgAigLMhIuYXBpLnByb3RvLkFjY291bnRSB2FjY291bnQSOAoMYWNjb3'
    'VudF9rZXlzGAIgAygLMhUuYXBpLnByb3RvLkFjY291bnRLZXlSC2FjY291bnRLZXlzGggKBkxv'
    'Z291dBo3CgdBZGRHYWlkEiwKB2FjY291bnQYASACKAsyEi5hcGkucHJvdG8uQWNjb3VudFIHYW'
    'Njb3VudBo2CgpMb2FkQXNzZXRzEigKBmFzc2V0cxgBIAMoCzIQLmFwaS5wcm90by5Bc3NldFIG'
    'YXNzZXRzGnsKCUJ1eVNoYXJlcxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIWCgZhbW91bn'
    'QYAiACKAFSBmFtb3VudBIUCgVwcmljZRgDIAIoAVIFcHJpY2USJQoOYml0Y29pbl9hbW91bnQY'
    'BCACKAFSDWJpdGNvaW5BbW91bnQaIwoNTG9hZENvdW50cmllcxISCgRsaXN0GAEgAygJUgRsaX'
    'N0GjIKCExvYWRSZWdzEiYKBGxpc3QYASADKAsyEi5hcGkucHJvdG8uQWNjb3VudFIEbGlzdBo7'
    'CghMb2FkRmlsZRIbCgltaW1lX3R5cGUYASACKAlSCG1pbWVUeXBlEhIKBGRhdGEYAiACKAxSBG'
    'RhdGEaCwoJVXBkYXRlUmVnGkUKE0xpc3RBbGxUcmFuc2FjdGlvbnMSLgoEbGlzdBgBIAMoCzIa'
    'LmFwaS5wcm90by5GdWxsVHJhbnNhY3Rpb25SBGxpc3QaRAoTTGlzdE93blRyYW5zYWN0aW9ucx'
    'ItCgRsaXN0GAEgAygLMhkuYXBpLnByb3RvLk93blRyYW5zYWN0aW9uUgRsaXN0Gj4KD0xpc3RB'
    'bGxCYWxhbmNlcxIrCgRsaXN0GAEgAygLMhcuYXBpLnByb3RvLkJhbGFuY2VPd25lclIEbGlzdB'
    'pMCg1MaXN0QWxsU2VyaWVzEikKBGxpc3QYASADKAsyFS5hcGkucHJvdG8uU2VyaWVPd25lclIE'
    'bGlzdBIQCgNjc3YYAiACKAlSA2NzdkIGCgRib2R5');

@$core.Deprecated('Use notifDescriptor instead')
const Notif$json = {
  '1': 'Notif',
  '2': [
    {'1': 'login_or_register_failed', '3': 3, '4': 1, '5': 11, '6': '.api.proto.Notif.LoginOrRegisterFailed', '9': 0, '10': 'loginOrRegisterFailed'},
    {'1': 'login_or_register_succeed', '3': 4, '4': 1, '5': 11, '6': '.api.proto.Notif.LoginOrRegisterSucceed', '9': 0, '10': 'loginOrRegisterSucceed'},
    {'1': 'free_shares', '3': 5, '4': 1, '5': 11, '6': '.api.proto.Notif.FreeShares', '9': 0, '10': 'freeShares'},
    {'1': 'sold_shares', '3': 7, '4': 1, '5': 11, '6': '.api.proto.Notif.SoldShares', '9': 0, '10': 'soldShares'},
    {'1': 'user_shares', '3': 8, '4': 1, '5': 11, '6': '.api.proto.Notif.UserShares', '9': 0, '10': 'userShares'},
    {'1': 'buy_shares', '3': 6, '4': 1, '5': 11, '6': '.api.proto.Notif.BuyShares', '9': 0, '10': 'buyShares'},
    {'1': 'update_prices', '3': 9, '4': 1, '5': 11, '6': '.api.proto.Notif.UpdatePrices', '9': 0, '10': 'updatePrices'},
    {'1': 'update_market_data', '3': 10, '4': 1, '5': 11, '6': '.api.proto.Notif.UpdateMarketData', '9': 0, '10': 'updateMarketData'},
    {'1': 'issued_amounts', '3': 11, '4': 1, '5': 11, '6': '.api.proto.Notif.IssuedAmounts', '9': 0, '10': 'issuedAmounts'},
    {'1': 'update_balances', '3': 12, '4': 1, '5': 11, '6': '.api.proto.Notif.UpdateBalances', '9': 0, '10': 'updateBalances'},
  ],
  '3': [Notif_LoginOrRegisterFailed$json, Notif_LoginOrRegisterSucceed$json, Notif_RegisterFailed$json, Notif_RegisterSucceed$json, Notif_FreeShares$json, Notif_SoldShares$json, Notif_UserShares$json, Notif_BuyShares$json, Notif_UpdatePrices$json, Notif_UpdateMarketData$json, Notif_IssuedAmounts$json, Notif_UpdateBalances$json],
  '8': [
    {'1': 'body'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_LoginOrRegisterFailed$json = {
  '1': 'LoginOrRegisterFailed',
  '2': [
    {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_LoginOrRegisterSucceed$json = {
  '1': 'LoginOrRegisterSucceed',
  '2': [
    {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
    {'1': 'account_key', '3': 2, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_RegisterFailed$json = {
  '1': 'RegisterFailed',
  '2': [
    {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_RegisterSucceed$json = {
  '1': 'RegisterSucceed',
  '2': [
    {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
    {'1': 'account_key', '3': 2, '4': 2, '5': 9, '10': 'accountKey'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_FreeShares$json = {
  '1': 'FreeShares',
  '2': [
    {'1': 'free_shares', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Shares', '10': 'freeShares'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'amount', '3': 3, '4': 2, '5': 3, '10': 'amount'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_SoldShares$json = {
  '1': 'SoldShares',
  '2': [
    {'1': 'sold_shares', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Shares', '10': 'soldShares'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UserShares$json = {
  '1': 'UserShares',
  '2': [
    {'1': 'bought_shares', '3': 1, '4': 2, '5': 11, '6': '.api.proto.Shares', '10': 'boughtShares'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_BuyShares$json = {
  '1': 'BuyShares',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'amount', '3': 2, '4': 2, '5': 1, '10': 'amount'},
    {'1': 'price', '3': 3, '4': 2, '5': 1, '10': 'price'},
    {'1': 'bitcoin_amount', '3': 4, '4': 2, '5': 1, '10': 'bitcoinAmount'},
    {'1': 'txid', '3': 5, '4': 1, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdatePrices$json = {
  '1': 'UpdatePrices',
  '2': [
    {'1': 'bitcoin_usd_price', '3': 1, '4': 1, '5': 1, '10': 'bitcoinUsdPrice'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdateMarketData$json = {
  '1': 'UpdateMarketData',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Notif.UpdateMarketData.Data', '10': 'data'},
  ],
  '3': [Notif_UpdateMarketData_Data$json],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdateMarketData_Data$json = {
  '1': 'Data',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'last_price', '3': 2, '4': 1, '5': 1, '10': 'lastPrice'},
    {'1': 'volume_30d', '3': 3, '4': 1, '5': 1, '10': 'volume30d'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_IssuedAmounts$json = {
  '1': 'IssuedAmounts',
  '2': [
    {'1': 'assets', '3': 1, '4': 3, '5': 11, '6': '.api.proto.Notif.IssuedAmounts.Asset', '10': 'assets'},
  ],
  '3': [Notif_IssuedAmounts_Asset$json],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_IssuedAmounts_Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'online', '3': 2, '4': 2, '5': 1, '10': 'online'},
    {'1': 'offline', '3': 3, '4': 2, '5': 1, '10': 'offline'},
  ],
};

@$core.Deprecated('Use notifDescriptor instead')
const Notif_UpdateBalances$json = {
  '1': 'UpdateBalances',
  '2': [
    {'1': 'account_key', '3': 1, '4': 2, '5': 9, '10': 'accountKey'},
    {'1': 'balances', '3': 2, '4': 3, '5': 11, '6': '.api.proto.Balance', '10': 'balances'},
  ],
};

/// Descriptor for `Notif`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifDescriptor = $convert.base64Decode(
    'CgVOb3RpZhJhChhsb2dpbl9vcl9yZWdpc3Rlcl9mYWlsZWQYAyABKAsyJi5hcGkucHJvdG8uTm'
    '90aWYuTG9naW5PclJlZ2lzdGVyRmFpbGVkSABSFWxvZ2luT3JSZWdpc3RlckZhaWxlZBJkChls'
    'b2dpbl9vcl9yZWdpc3Rlcl9zdWNjZWVkGAQgASgLMicuYXBpLnByb3RvLk5vdGlmLkxvZ2luT3'
    'JSZWdpc3RlclN1Y2NlZWRIAFIWbG9naW5PclJlZ2lzdGVyU3VjY2VlZBI+CgtmcmVlX3NoYXJl'
    'cxgFIAEoCzIbLmFwaS5wcm90by5Ob3RpZi5GcmVlU2hhcmVzSABSCmZyZWVTaGFyZXMSPgoLc2'
    '9sZF9zaGFyZXMYByABKAsyGy5hcGkucHJvdG8uTm90aWYuU29sZFNoYXJlc0gAUgpzb2xkU2hh'
    'cmVzEj4KC3VzZXJfc2hhcmVzGAggASgLMhsuYXBpLnByb3RvLk5vdGlmLlVzZXJTaGFyZXNIAF'
    'IKdXNlclNoYXJlcxI7CgpidXlfc2hhcmVzGAYgASgLMhouYXBpLnByb3RvLk5vdGlmLkJ1eVNo'
    'YXJlc0gAUglidXlTaGFyZXMSRAoNdXBkYXRlX3ByaWNlcxgJIAEoCzIdLmFwaS5wcm90by5Ob3'
    'RpZi5VcGRhdGVQcmljZXNIAFIMdXBkYXRlUHJpY2VzElEKEnVwZGF0ZV9tYXJrZXRfZGF0YRgK'
    'IAEoCzIhLmFwaS5wcm90by5Ob3RpZi5VcGRhdGVNYXJrZXREYXRhSABSEHVwZGF0ZU1hcmtldE'
    'RhdGESRwoOaXNzdWVkX2Ftb3VudHMYCyABKAsyHi5hcGkucHJvdG8uTm90aWYuSXNzdWVkQW1v'
    'dW50c0gAUg1pc3N1ZWRBbW91bnRzEkoKD3VwZGF0ZV9iYWxhbmNlcxgMIAEoCzIfLmFwaS5wcm'
    '90by5Ob3RpZi5VcGRhdGVCYWxhbmNlc0gAUg51cGRhdGVCYWxhbmNlcxorChVMb2dpbk9yUmVn'
    'aXN0ZXJGYWlsZWQSEgoEdGV4dBgBIAIoCVIEdGV4dBpPChZMb2dpbk9yUmVnaXN0ZXJTdWNjZW'
    'VkEhQKBXRva2VuGAEgAigJUgV0b2tlbhIfCgthY2NvdW50X2tleRgCIAIoCVIKYWNjb3VudEtl'
    'eRokCg5SZWdpc3RlckZhaWxlZBISCgR0ZXh0GAEgAigJUgR0ZXh0GkgKD1JlZ2lzdGVyU3VjY2'
    'VlZBIUCgV0b2tlbhgBIAIoCVIFdG9rZW4SHwoLYWNjb3VudF9rZXkYAiACKAlSCmFjY291bnRL'
    'ZXkabAoKRnJlZVNoYXJlcxIyCgtmcmVlX3NoYXJlcxgBIAIoCzIRLmFwaS5wcm90by5TaGFyZX'
    'NSCmZyZWVTaGFyZXMSEgoEbmFtZRgCIAIoCVIEbmFtZRIWCgZhbW91bnQYAyACKANSBmFtb3Vu'
    'dBpACgpTb2xkU2hhcmVzEjIKC3NvbGRfc2hhcmVzGAEgAigLMhEuYXBpLnByb3RvLlNoYXJlc1'
    'IKc29sZFNoYXJlcxpECgpVc2VyU2hhcmVzEjYKDWJvdWdodF9zaGFyZXMYASACKAsyES5hcGku'
    'cHJvdG8uU2hhcmVzUgxib3VnaHRTaGFyZXMajwEKCUJ1eVNoYXJlcxIZCghvcmRlcl9pZBgBIA'
    'IoCVIHb3JkZXJJZBIWCgZhbW91bnQYAiACKAFSBmFtb3VudBIUCgVwcmljZRgDIAIoAVIFcHJp'
    'Y2USJQoOYml0Y29pbl9hbW91bnQYBCACKAFSDWJpdGNvaW5BbW91bnQSEgoEdHhpZBgFIAEoCV'
    'IEdHhpZBo6CgxVcGRhdGVQcmljZXMSKgoRYml0Y29pbl91c2RfcHJpY2UYASABKAFSD2JpdGNv'
    'aW5Vc2RQcmljZRqvAQoQVXBkYXRlTWFya2V0RGF0YRI6CgRkYXRhGAEgAygLMiYuYXBpLnByb3'
    'RvLk5vdGlmLlVwZGF0ZU1hcmtldERhdGEuRGF0YVIEZGF0YRpfCgREYXRhEhkKCGFzc2V0X2lk'
    'GAEgAigJUgdhc3NldElkEh0KCmxhc3RfcHJpY2UYAiABKAFSCWxhc3RQcmljZRIdCgp2b2x1bW'
    'VfMzBkGAMgASgBUgl2b2x1bWUzMGQaowEKDUlzc3VlZEFtb3VudHMSPAoGYXNzZXRzGAEgAygL'
    'MiQuYXBpLnByb3RvLk5vdGlmLklzc3VlZEFtb3VudHMuQXNzZXRSBmFzc2V0cxpUCgVBc3NldB'
    'IZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIWCgZvbmxpbmUYAiACKAFSBm9ubGluZRIYCgdv'
    'ZmZsaW5lGAMgAigBUgdvZmZsaW5lGmEKDlVwZGF0ZUJhbGFuY2VzEh8KC2FjY291bnRfa2V5GA'
    'EgAigJUgphY2NvdW50S2V5Ei4KCGJhbGFuY2VzGAIgAygLMhIuYXBpLnByb3RvLkJhbGFuY2VS'
    'CGJhbGFuY2VzQgYKBGJvZHk=');

@$core.Deprecated('Use errDescriptor instead')
const Err$json = {
  '1': 'Err',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'text', '3': 2, '4': 2, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Err`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errDescriptor = $convert.base64Decode(
    'CgNFcnISDgoCaWQYASABKANSAmlkEhIKBHRleHQYAiACKAlSBHRleHQ=');

@$core.Deprecated('Use resDescriptor instead')
const Res$json = {
  '1': 'Res',
  '2': [
    {'1': 'resp', '3': 1, '4': 1, '5': 11, '6': '.api.proto.Resp', '9': 0, '10': 'resp'},
    {'1': 'notif', '3': 2, '4': 1, '5': 11, '6': '.api.proto.Notif', '9': 0, '10': 'notif'},
    {'1': 'error', '3': 3, '4': 1, '5': 11, '6': '.api.proto.Err', '9': 0, '10': 'error'},
  ],
  '8': [
    {'1': 'body'},
  ],
};

/// Descriptor for `Res`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resDescriptor = $convert.base64Decode(
    'CgNSZXMSJQoEcmVzcBgBIAEoCzIPLmFwaS5wcm90by5SZXNwSABSBHJlc3ASKAoFbm90aWYYAi'
    'ABKAsyEC5hcGkucHJvdG8uTm90aWZIAFIFbm90aWYSJgoFZXJyb3IYAyABKAsyDi5hcGkucHJv'
    'dG8uRXJySABSBWVycm9yQgYKBGJvZHk=');

