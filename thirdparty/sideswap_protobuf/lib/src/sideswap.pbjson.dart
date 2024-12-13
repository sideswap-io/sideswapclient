//
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use assetTypeDescriptor instead')
const AssetType$json = {
  '1': 'AssetType',
  '2': [
    {'1': 'BASE', '2': 1},
    {'1': 'QUOTE', '2': 2},
  ],
};

/// Descriptor for `AssetType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetTypeDescriptor = $convert.base64Decode(
    'CglBc3NldFR5cGUSCAoEQkFTRRABEgkKBVFVT1RFEAI=');

@$core.Deprecated('Use marketType_Descriptor instead')
const MarketType_$json = {
  '1': 'MarketType_',
  '2': [
    {'1': 'STABLECOIN', '2': 1},
    {'1': 'AMP', '2': 2},
    {'1': 'TOKEN', '2': 3},
  ],
};

/// Descriptor for `MarketType_`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List marketType_Descriptor = $convert.base64Decode(
    'CgtNYXJrZXRUeXBlXxIOCgpTVEFCTEVDT0lOEAESBwoDQU1QEAISCQoFVE9LRU4QAw==');

@$core.Deprecated('Use tradeDirDescriptor instead')
const TradeDir$json = {
  '1': 'TradeDir',
  '2': [
    {'1': 'SELL', '2': 1},
    {'1': 'BUY', '2': 2},
  ],
};

/// Descriptor for `TradeDir`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tradeDirDescriptor = $convert.base64Decode(
    'CghUcmFkZURpchIICgRTRUxMEAESBwoDQlVZEAI=');

@$core.Deprecated('Use histStatusDescriptor instead')
const HistStatus$json = {
  '1': 'HistStatus',
  '2': [
    {'1': 'MEMPOOL', '2': 1},
    {'1': 'CONFIRMED', '2': 2},
    {'1': 'TX_CONFLICT', '2': 3},
    {'1': 'TX_NOT_FOUND', '2': 4},
    {'1': 'ELAPSED', '2': 5},
    {'1': 'CANCELLED', '2': 6},
    {'1': 'UTXO_INVALIDATED', '2': 7},
    {'1': 'REPLACED', '2': 8},
  ],
};

/// Descriptor for `HistStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List histStatusDescriptor = $convert.base64Decode(
    'CgpIaXN0U3RhdHVzEgsKB01FTVBPT0wQARINCglDT05GSVJNRUQQAhIPCgtUWF9DT05GTElDVB'
    'ADEhAKDFRYX05PVF9GT1VORBAEEgsKB0VMQVBTRUQQBRINCglDQU5DRUxMRUQQBhIUChBVVFhP'
    'X0lOVkFMSURBVEVEEAcSDAoIUkVQTEFDRUQQCA==');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50Eg4KAmlkGAEgAigFUgJpZA==');

@$core.Deprecated('Use addressDescriptor instead')
const Address$json = {
  '1': 'Address',
  '2': [
    {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode(
    'CgdBZGRyZXNzEhIKBGFkZHIYASACKAlSBGFkZHI=');

@$core.Deprecated('Use addressAmountDescriptor instead')
const AddressAmount$json = {
  '1': 'AddressAmount',
  '2': [
    {'1': 'address', '3': 1, '4': 2, '5': 9, '10': 'address'},
    {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
    {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `AddressAmount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressAmountDescriptor = $convert.base64Decode(
    'Cg1BZGRyZXNzQW1vdW50EhgKB2FkZHJlc3MYASACKAlSB2FkZHJlc3MSFgoGYW1vdW50GAIgAi'
    'gDUgZhbW91bnQSGQoIYXNzZXRfaWQYAyACKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = {
  '1': 'Balance',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode(
    'CgdCYWxhbmNlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhYKBmFtb3VudBgCIAIoA1IGYW'
    '1vdW50');

@$core.Deprecated('Use ampAssetRestrictionsDescriptor instead')
const AmpAssetRestrictions$json = {
  '1': 'AmpAssetRestrictions',
  '2': [
    {'1': 'allowed_countries', '3': 1, '4': 3, '5': 9, '10': 'allowedCountries'},
  ],
};

/// Descriptor for `AmpAssetRestrictions`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ampAssetRestrictionsDescriptor = $convert.base64Decode(
    'ChRBbXBBc3NldFJlc3RyaWN0aW9ucxIrChFhbGxvd2VkX2NvdW50cmllcxgBIAMoCVIQYWxsb3'
    'dlZENvdW50cmllcw==');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'ticker', '3': 3, '4': 2, '5': 9, '10': 'ticker'},
    {'1': 'icon', '3': 4, '4': 2, '5': 9, '10': 'icon'},
    {'1': 'precision', '3': 5, '4': 2, '5': 13, '10': 'precision'},
    {'1': 'instant_swaps', '3': 11, '4': 2, '5': 8, '10': 'instantSwaps'},
    {'1': 'swap_market', '3': 6, '4': 2, '5': 8, '10': 'swapMarket'},
    {'1': 'amp_market', '3': 9, '4': 2, '5': 8, '10': 'ampMarket'},
    {'1': 'unregistered', '3': 8, '4': 2, '5': 8, '10': 'unregistered'},
    {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
    {'1': 'domain_agent', '3': 10, '4': 1, '5': 9, '10': 'domainAgent'},
    {'1': 'domain_agent_link', '3': 13, '4': 1, '5': 9, '10': 'domainAgentLink'},
    {'1': 'always_show', '3': 12, '4': 1, '5': 8, '10': 'alwaysShow'},
    {'1': 'payjoin', '3': 15, '4': 1, '5': 8, '10': 'payjoin'},
    {'1': 'amp_asset_restrictions', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.AmpAssetRestrictions', '10': 'ampAssetRestrictions'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEh'
    'YKBnRpY2tlchgDIAIoCVIGdGlja2VyEhIKBGljb24YBCACKAlSBGljb24SHAoJcHJlY2lzaW9u'
    'GAUgAigNUglwcmVjaXNpb24SIwoNaW5zdGFudF9zd2FwcxgLIAIoCFIMaW5zdGFudFN3YXBzEh'
    '8KC3N3YXBfbWFya2V0GAYgAigIUgpzd2FwTWFya2V0Eh0KCmFtcF9tYXJrZXQYCSACKAhSCWFt'
    'cE1hcmtldBIiCgx1bnJlZ2lzdGVyZWQYCCACKAhSDHVucmVnaXN0ZXJlZBIWCgZkb21haW4YBy'
    'ABKAlSBmRvbWFpbhIhCgxkb21haW5fYWdlbnQYCiABKAlSC2RvbWFpbkFnZW50EioKEWRvbWFp'
    'bl9hZ2VudF9saW5rGA0gASgJUg9kb21haW5BZ2VudExpbmsSHwoLYWx3YXlzX3Nob3cYDCABKA'
    'hSCmFsd2F5c1Nob3cSGAoHcGF5am9pbhgPIAEoCFIHcGF5am9pbhJaChZhbXBfYXNzZXRfcmVz'
    'dHJpY3Rpb25zGA4gASgLMiQuc2lkZXN3YXAucHJvdG8uQW1wQXNzZXRSZXN0cmljdGlvbnNSFG'
    'FtcEFzc2V0UmVzdHJpY3Rpb25z');

@$core.Deprecated('Use txDescriptor instead')
const Tx$json = {
  '1': 'Tx',
  '2': [
    {'1': 'balances', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
    {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'network_fee', '3': 3, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'vsize', '3': 6, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'memo', '3': 4, '4': 2, '5': 9, '10': 'memo'},
    {'1': 'balances_all', '3': 7, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balancesAll'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode(
    'CgJUeBIzCghiYWxhbmNlcxgBIAMoCzIXLnNpZGVzd2FwLnByb3RvLkJhbGFuY2VSCGJhbGFuY2'
    'VzEhIKBHR4aWQYAiACKAlSBHR4aWQSHwoLbmV0d29ya19mZWUYAyACKANSCm5ldHdvcmtGZWUS'
    'FAoFdnNpemUYBiACKANSBXZzaXplEhIKBG1lbW8YBCACKAlSBG1lbW8SOgoMYmFsYW5jZXNfYW'
    'xsGAcgAygLMhcuc2lkZXN3YXAucHJvdG8uQmFsYW5jZVILYmFsYW5jZXNBbGw=');

@$core.Deprecated('Use pegDescriptor instead')
const Peg$json = {
  '1': 'Peg',
  '2': [
    {'1': 'is_peg_in', '3': 1, '4': 2, '5': 8, '10': 'isPegIn'},
    {'1': 'amount_send', '3': 2, '4': 2, '5': 3, '10': 'amountSend'},
    {'1': 'amount_recv', '3': 3, '4': 2, '5': 3, '10': 'amountRecv'},
    {'1': 'addr_send', '3': 4, '4': 2, '5': 9, '10': 'addrSend'},
    {'1': 'addr_recv', '3': 5, '4': 2, '5': 9, '10': 'addrRecv'},
    {'1': 'txid_send', '3': 6, '4': 2, '5': 9, '10': 'txidSend'},
    {'1': 'txid_recv', '3': 8, '4': 1, '5': 9, '10': 'txidRecv'},
  ],
};

/// Descriptor for `Peg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pegDescriptor = $convert.base64Decode(
    'CgNQZWcSGgoJaXNfcGVnX2luGAEgAigIUgdpc1BlZ0luEh8KC2Ftb3VudF9zZW5kGAIgAigDUg'
    'phbW91bnRTZW5kEh8KC2Ftb3VudF9yZWN2GAMgAigDUgphbW91bnRSZWN2EhsKCWFkZHJfc2Vu'
    'ZBgEIAIoCVIIYWRkclNlbmQSGwoJYWRkcl9yZWN2GAUgAigJUghhZGRyUmVjdhIbCgl0eGlkX3'
    'NlbmQYBiACKAlSCHR4aWRTZW5kEhsKCXR4aWRfcmVjdhgIIAEoCVIIdHhpZFJlY3Y=');

@$core.Deprecated('Use confsDescriptor instead')
const Confs$json = {
  '1': 'Confs',
  '2': [
    {'1': 'count', '3': 1, '4': 2, '5': 13, '10': 'count'},
    {'1': 'total', '3': 2, '4': 2, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `Confs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confsDescriptor = $convert.base64Decode(
    'CgVDb25mcxIUCgVjb3VudBgBIAIoDVIFY291bnQSFAoFdG90YWwYAiACKA1SBXRvdGFs');

@$core.Deprecated('Use transItemDescriptor instead')
const TransItem$json = {
  '1': 'TransItem',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 2, '5': 3, '10': 'createdAt'},
    {'1': 'confs', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Confs', '10': 'confs'},
    {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'tx', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.Tx', '9': 0, '10': 'tx'},
    {'1': 'peg', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Peg', '9': 0, '10': 'peg'},
  ],
  '8': [
    {'1': 'item'},
  ],
};

/// Descriptor for `TransItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transItemDescriptor = $convert.base64Decode(
    'CglUcmFuc0l0ZW0SDgoCaWQYASACKAlSAmlkEh0KCmNyZWF0ZWRfYXQYAiACKANSCWNyZWF0ZW'
    'RBdBIrCgVjb25mcxgDIAEoCzIVLnNpZGVzd2FwLnByb3RvLkNvbmZzUgVjb25mcxIxCgdhY2Nv'
    'dW50GAQgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudBIkCgJ0eBgKIAEoCz'
    'ISLnNpZGVzd2FwLnByb3RvLlR4SABSAnR4EicKA3BlZxgLIAEoCzITLnNpZGVzd2FwLnByb3Rv'
    'LlBlZ0gAUgNwZWdCBgoEaXRlbQ==');

@$core.Deprecated('Use assetIdDescriptor instead')
const AssetId$json = {
  '1': 'AssetId',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `AssetId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetIdDescriptor = $convert.base64Decode(
    'CgdBc3NldElkEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElk');

@$core.Deprecated('Use genericResponseDescriptor instead')
const GenericResponse$json = {
  '1': 'GenericResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 2, '5': 8, '10': 'success'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

/// Descriptor for `GenericResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericResponseDescriptor = $convert.base64Decode(
    'Cg9HZW5lcmljUmVzcG9uc2USGAoHc3VjY2VzcxgBIAIoCFIHc3VjY2VzcxIbCgllcnJvcl9tc2'
    'cYAiABKAlSCGVycm9yTXNn');

@$core.Deprecated('Use feeRateDescriptor instead')
const FeeRate$json = {
  '1': 'FeeRate',
  '2': [
    {'1': 'blocks', '3': 1, '4': 2, '5': 5, '10': 'blocks'},
    {'1': 'value', '3': 2, '4': 2, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `FeeRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feeRateDescriptor = $convert.base64Decode(
    'CgdGZWVSYXRlEhYKBmJsb2NrcxgBIAIoBVIGYmxvY2tzEhQKBXZhbHVlGAIgAigBUgV2YWx1ZQ'
    '==');

@$core.Deprecated('Use serverStatusDescriptor instead')
const ServerStatus$json = {
  '1': 'ServerStatus',
  '2': [
    {'1': 'min_peg_in_amount', '3': 1, '4': 2, '5': 3, '10': 'minPegInAmount'},
    {'1': 'min_peg_out_amount', '3': 2, '4': 2, '5': 3, '10': 'minPegOutAmount'},
    {'1': 'server_fee_percent_peg_in', '3': 3, '4': 2, '5': 1, '10': 'serverFeePercentPegIn'},
    {'1': 'server_fee_percent_peg_out', '3': 4, '4': 2, '5': 1, '10': 'serverFeePercentPegOut'},
    {'1': 'bitcoin_fee_rates', '3': 5, '4': 3, '5': 11, '6': '.sideswap.proto.FeeRate', '10': 'bitcoinFeeRates'},
  ],
};

/// Descriptor for `ServerStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverStatusDescriptor = $convert.base64Decode(
    'CgxTZXJ2ZXJTdGF0dXMSKQoRbWluX3BlZ19pbl9hbW91bnQYASACKANSDm1pblBlZ0luQW1vdW'
    '50EisKEm1pbl9wZWdfb3V0X2Ftb3VudBgCIAIoA1IPbWluUGVnT3V0QW1vdW50EjgKGXNlcnZl'
    'cl9mZWVfcGVyY2VudF9wZWdfaW4YAyACKAFSFXNlcnZlckZlZVBlcmNlbnRQZWdJbhI6ChpzZX'
    'J2ZXJfZmVlX3BlcmNlbnRfcGVnX291dBgEIAIoAVIWc2VydmVyRmVlUGVyY2VudFBlZ091dBJD'
    'ChFiaXRjb2luX2ZlZV9yYXRlcxgFIAMoCzIXLnNpZGVzd2FwLnByb3RvLkZlZVJhdGVSD2JpdG'
    'NvaW5GZWVSYXRlcw==');

@$core.Deprecated('Use uploadContactDescriptor instead')
const UploadContact$json = {
  '1': 'UploadContact',
  '2': [
    {'1': 'identifier', '3': 1, '4': 2, '5': 9, '10': 'identifier'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'phones', '3': 3, '4': 3, '5': 9, '10': 'phones'},
  ],
};

/// Descriptor for `UploadContact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadContactDescriptor = $convert.base64Decode(
    'Cg1VcGxvYWRDb250YWN0Eh4KCmlkZW50aWZpZXIYASACKAlSCmlkZW50aWZpZXISEgoEbmFtZR'
    'gCIAIoCVIEbmFtZRIWCgZwaG9uZXMYAyADKAlSBnBob25lcw==');

@$core.Deprecated('Use contactDescriptor instead')
const Contact$json = {
  '1': 'Contact',
  '2': [
    {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
    {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 3, '4': 2, '5': 9, '10': 'phone'},
  ],
};

/// Descriptor for `Contact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactDescriptor = $convert.base64Decode(
    'CgdDb250YWN0Eh8KC2NvbnRhY3Rfa2V5GAEgAigJUgpjb250YWN0S2V5EhIKBG5hbWUYAiACKA'
    'lSBG5hbWUSFAoFcGhvbmUYAyACKAlSBXBob25l');

@$core.Deprecated('Use contactTransactionDescriptor instead')
const ContactTransaction$json = {
  '1': 'ContactTransaction',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'contact_key', '3': 2, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

/// Descriptor for `ContactTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactTransactionDescriptor = $convert.base64Decode(
    'ChJDb250YWN0VHJhbnNhY3Rpb24SEgoEdHhpZBgBIAIoCVIEdHhpZBIfCgtjb250YWN0X2tleR'
    'gCIAIoCVIKY29udGFjdEtleQ==');

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    {'1': 'send_bitcoins', '3': 10, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'server_fee', '3': 4, '4': 2, '5': 3, '10': 'serverFee'},
    {'1': 'asset_amount', '3': 5, '4': 2, '5': 3, '10': 'assetAmount'},
    {'1': 'price', '3': 6, '4': 2, '5': 1, '10': 'price'},
    {'1': 'created_at', '3': 7, '4': 2, '5': 3, '10': 'createdAt'},
    {'1': 'expires_at', '3': 8, '4': 1, '5': 3, '10': 'expiresAt'},
    {'1': 'private', '3': 9, '4': 2, '5': 8, '10': 'private'},
    {'1': 'two_step', '3': 17, '4': 2, '5': 8, '10': 'twoStep'},
    {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
    {'1': 'own', '3': 12, '4': 2, '5': 8, '10': 'own'},
    {'1': 'token_market', '3': 16, '4': 2, '5': 8, '10': 'tokenMarket'},
    {'1': 'from_notification', '3': 13, '4': 2, '5': 8, '10': 'fromNotification'},
    {'1': 'index_price', '3': 15, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIZCghhc3NldF9pZBgCIAIoCVIHYX'
    'NzZXRJZBIlCg5iaXRjb2luX2Ftb3VudBgDIAIoA1INYml0Y29pbkFtb3VudBIjCg1zZW5kX2Jp'
    'dGNvaW5zGAogAigIUgxzZW5kQml0Y29pbnMSHQoKc2VydmVyX2ZlZRgEIAIoA1IJc2VydmVyRm'
    'VlEiEKDGFzc2V0X2Ftb3VudBgFIAIoA1ILYXNzZXRBbW91bnQSFAoFcHJpY2UYBiACKAFSBXBy'
    'aWNlEh0KCmNyZWF0ZWRfYXQYByACKANSCWNyZWF0ZWRBdBIdCgpleHBpcmVzX2F0GAggASgDUg'
    'lleHBpcmVzQXQSGAoHcHJpdmF0ZRgJIAIoCFIHcHJpdmF0ZRIZCgh0d29fc3RlcBgRIAIoCFIH'
    'dHdvU3RlcBIbCglhdXRvX3NpZ24YCyACKAhSCGF1dG9TaWduEhAKA293bhgMIAIoCFIDb3duEi'
    'EKDHRva2VuX21hcmtldBgQIAIoCFILdG9rZW5NYXJrZXQSKwoRZnJvbV9ub3RpZmljYXRpb24Y'
    'DSACKAhSEGZyb21Ob3RpZmljYXRpb24SHwoLaW5kZXhfcHJpY2UYDyABKAFSCmluZGV4UHJpY2'
    'U=');

@$core.Deprecated('Use swapDetailsDescriptor instead')
const SwapDetails$json = {
  '1': 'SwapDetails',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'send_asset', '3': 2, '4': 2, '5': 9, '10': 'sendAsset'},
    {'1': 'recv_asset', '3': 3, '4': 2, '5': 9, '10': 'recvAsset'},
    {'1': 'send_amount', '3': 4, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 5, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'upload_url', '3': 6, '4': 2, '5': 9, '10': 'uploadUrl'},
  ],
};

/// Descriptor for `SwapDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapDetailsDescriptor = $convert.base64Decode(
    'CgtTd2FwRGV0YWlscxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIdCgpzZW5kX2Fzc2V0GA'
    'IgAigJUglzZW5kQXNzZXQSHQoKcmVjdl9hc3NldBgDIAIoCVIJcmVjdkFzc2V0Eh8KC3NlbmRf'
    'YW1vdW50GAQgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAUgAigDUgpyZWN2QW1vdW'
    '50Eh0KCnVwbG9hZF91cmwYBiACKAlSCXVwbG9hZFVybA==');

@$core.Deprecated('Use outPointDescriptor instead')
const OutPoint$json = {
  '1': 'OutPoint',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'vout', '3': 2, '4': 2, '5': 13, '10': 'vout'},
  ],
};

/// Descriptor for `OutPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outPointDescriptor = $convert.base64Decode(
    'CghPdXRQb2ludBISCgR0eGlkGAEgAigJUgR0eGlkEhIKBHZvdXQYAiACKA1SBHZvdXQ=');

@$core.Deprecated('Use createTxDescriptor instead')
const CreateTx$json = {
  '1': 'CreateTx',
  '2': [
    {'1': 'addressees', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
    {'1': 'account', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'utxos', '3': 3, '4': 3, '5': 11, '6': '.sideswap.proto.OutPoint', '10': 'utxos'},
    {'1': 'fee_asset_id', '3': 4, '4': 1, '5': 9, '10': 'feeAssetId'},
    {'1': 'deduct_fee_output', '3': 5, '4': 1, '5': 13, '10': 'deductFeeOutput'},
  ],
};

/// Descriptor for `CreateTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTxDescriptor = $convert.base64Decode(
    'CghDcmVhdGVUeBI9CgphZGRyZXNzZWVzGAEgAygLMh0uc2lkZXN3YXAucHJvdG8uQWRkcmVzc0'
    'Ftb3VudFIKYWRkcmVzc2VlcxIxCgdhY2NvdW50GAIgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNj'
    'b3VudFIHYWNjb3VudBIuCgV1dHhvcxgDIAMoCzIYLnNpZGVzd2FwLnByb3RvLk91dFBvaW50Ug'
    'V1dHhvcxIgCgxmZWVfYXNzZXRfaWQYBCABKAlSCmZlZUFzc2V0SWQSKgoRZGVkdWN0X2ZlZV9v'
    'dXRwdXQYBSABKA1SD2RlZHVjdEZlZU91dHB1dA==');

@$core.Deprecated('Use createdTxDescriptor instead')
const CreatedTx$json = {
  '1': 'CreatedTx',
  '2': [
    {'1': 'id', '3': 9, '4': 2, '5': 9, '10': 'id'},
    {'1': 'req', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.CreateTx', '10': 'req'},
    {'1': 'input_count', '3': 2, '4': 2, '5': 5, '10': 'inputCount'},
    {'1': 'output_count', '3': 3, '4': 2, '5': 5, '10': 'outputCount'},
    {'1': 'size', '3': 4, '4': 2, '5': 3, '10': 'size'},
    {'1': 'vsize', '3': 7, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'network_fee', '3': 5, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'server_fee', '3': 10, '4': 1, '5': 3, '10': 'serverFee'},
    {'1': 'fee_per_byte', '3': 6, '4': 2, '5': 1, '10': 'feePerByte'},
    {'1': 'addressees', '3': 8, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
  ],
};

/// Descriptor for `CreatedTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createdTxDescriptor = $convert.base64Decode(
    'CglDcmVhdGVkVHgSDgoCaWQYCSACKAlSAmlkEioKA3JlcRgBIAIoCzIYLnNpZGVzd2FwLnByb3'
    'RvLkNyZWF0ZVR4UgNyZXESHwoLaW5wdXRfY291bnQYAiACKAVSCmlucHV0Q291bnQSIQoMb3V0'
    'cHV0X2NvdW50GAMgAigFUgtvdXRwdXRDb3VudBISCgRzaXplGAQgAigDUgRzaXplEhQKBXZzaX'
    'plGAcgAigDUgV2c2l6ZRIfCgtuZXR3b3JrX2ZlZRgFIAIoA1IKbmV0d29ya0ZlZRIdCgpzZXJ2'
    'ZXJfZmVlGAogASgDUglzZXJ2ZXJGZWUSIAoMZmVlX3Blcl9ieXRlGAYgAigBUgpmZWVQZXJCeX'
    'RlEj0KCmFkZHJlc3NlZXMYCCADKAsyHS5zaWRlc3dhcC5wcm90by5BZGRyZXNzQW1vdW50Ugph'
    'ZGRyZXNzZWVz');

@$core.Deprecated('Use chartPointDescriptor instead')
const ChartPoint$json = {
  '1': 'ChartPoint',
  '2': [
    {'1': 'time', '3': 1, '4': 2, '5': 9, '10': 'time'},
    {'1': 'open', '3': 2, '4': 2, '5': 1, '10': 'open'},
    {'1': 'close', '3': 3, '4': 2, '5': 1, '10': 'close'},
    {'1': 'high', '3': 4, '4': 2, '5': 1, '10': 'high'},
    {'1': 'low', '3': 5, '4': 2, '5': 1, '10': 'low'},
    {'1': 'volume', '3': 6, '4': 2, '5': 1, '10': 'volume'},
  ],
};

/// Descriptor for `ChartPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartPointDescriptor = $convert.base64Decode(
    'CgpDaGFydFBvaW50EhIKBHRpbWUYASACKAlSBHRpbWUSEgoEb3BlbhgCIAIoAVIEb3BlbhIUCg'
    'VjbG9zZRgDIAIoAVIFY2xvc2USEgoEaGlnaBgEIAIoAVIEaGlnaBIQCgNsb3cYBSACKAFSA2xv'
    'dxIWCgZ2b2x1bWUYBiACKAFSBnZvbHVtZQ==');

@$core.Deprecated('Use assetPairDescriptor instead')
const AssetPair$json = {
  '1': 'AssetPair',
  '2': [
    {'1': 'base', '3': 1, '4': 2, '5': 9, '10': 'base'},
    {'1': 'quote', '3': 2, '4': 2, '5': 9, '10': 'quote'},
  ],
};

/// Descriptor for `AssetPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetPairDescriptor = $convert.base64Decode(
    'CglBc3NldFBhaXISEgoEYmFzZRgBIAIoCVIEYmFzZRIUCgVxdW90ZRgCIAIoCVIFcXVvdGU=');

@$core.Deprecated('Use marketInfoDescriptor instead')
const MarketInfo$json = {
  '1': 'MarketInfo',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'fee_asset', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.AssetType', '10': 'feeAsset'},
    {'1': 'type', '3': 3, '4': 2, '5': 14, '6': '.sideswap.proto.MarketType_', '10': 'type'},
  ],
};

/// Descriptor for `MarketInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketInfoDescriptor = $convert.base64Decode(
    'CgpNYXJrZXRJbmZvEjgKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldF'
    'BhaXJSCWFzc2V0UGFpchI2CglmZWVfYXNzZXQYAiACKA4yGS5zaWRlc3dhcC5wcm90by5Bc3Nl'
    'dFR5cGVSCGZlZUFzc2V0Ei8KBHR5cGUYAyACKA4yGy5zaWRlc3dhcC5wcm90by5NYXJrZXRUeX'
    'BlX1IEdHlwZQ==');

@$core.Deprecated('Use orderIdDescriptor instead')
const OrderId$json = {
  '1': 'OrderId',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `OrderId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderIdDescriptor = $convert.base64Decode(
    'CgdPcmRlcklkEg4KAmlkGAEgAigEUgJpZA==');

@$core.Deprecated('Use publicOrderDescriptor instead')
const PublicOrder$json = {
  '1': 'PublicOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'asset_pair', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'trade_dir', '3': 3, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'amount', '3': 4, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    {'1': 'two_step', '3': 6, '4': 2, '5': 8, '10': 'twoStep'},
  ],
};

/// Descriptor for `PublicOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicOrderDescriptor = $convert.base64Decode(
    'CgtQdWJsaWNPcmRlchIyCghvcmRlcl9pZBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLk9yZGVySW'
    'RSB29yZGVySWQSOAoKYXNzZXRfcGFpchgCIAIoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UGFp'
    'clIJYXNzZXRQYWlyEjUKCXRyYWRlX2RpchgDIAIoDjIYLnNpZGVzd2FwLnByb3RvLlRyYWRlRG'
    'lyUgh0cmFkZURpchIWCgZhbW91bnQYBCACKARSBmFtb3VudBIUCgVwcmljZRgFIAIoAVIFcHJp'
    'Y2USGQoIdHdvX3N0ZXAYBiACKAhSB3R3b1N0ZXA=');

@$core.Deprecated('Use ownOrderDescriptor instead')
const OwnOrder$json = {
  '1': 'OwnOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'asset_pair', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'trade_dir', '3': 3, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'orig_amount', '3': 4, '4': 2, '5': 4, '10': 'origAmount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
  ],
};

/// Descriptor for `OwnOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ownOrderDescriptor = $convert.base64Decode(
    'CghPd25PcmRlchIyCghvcmRlcl9pZBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLk9yZGVySWRSB2'
    '9yZGVySWQSOAoKYXNzZXRfcGFpchgCIAIoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UGFpclIJ'
    'YXNzZXRQYWlyEjUKCXRyYWRlX2RpchgDIAIoDjIYLnNpZGVzd2FwLnByb3RvLlRyYWRlRGlyUg'
    'h0cmFkZURpchIfCgtvcmlnX2Ftb3VudBgEIAIoBFIKb3JpZ0Ftb3VudBIUCgVwcmljZRgFIAIo'
    'AVIFcHJpY2U=');

@$core.Deprecated('Use historyOrderDescriptor instead')
const HistoryOrder$json = {
  '1': 'HistoryOrder',
  '2': [
    {'1': 'id', '3': 1, '4': 2, '5': 4, '10': 'id'},
    {'1': 'order_id', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'asset_pair', '3': 3, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'base_amount', '3': 5, '4': 2, '5': 4, '10': 'baseAmount'},
    {'1': 'quote_amount', '3': 6, '4': 2, '5': 4, '10': 'quoteAmount'},
    {'1': 'price', '3': 7, '4': 2, '5': 1, '10': 'price'},
    {'1': 'status', '3': 8, '4': 2, '5': 14, '6': '.sideswap.proto.HistStatus', '10': 'status'},
    {'1': 'txid', '3': 9, '4': 1, '5': 9, '10': 'txid'},
  ],
};

/// Descriptor for `HistoryOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List historyOrderDescriptor = $convert.base64Decode(
    'CgxIaXN0b3J5T3JkZXISDgoCaWQYASACKARSAmlkEjIKCG9yZGVyX2lkGAIgAigLMhcuc2lkZX'
    'N3YXAucHJvdG8uT3JkZXJJZFIHb3JkZXJJZBI4Cgphc3NldF9wYWlyGAMgAigLMhkuc2lkZXN3'
    'YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISNQoJdHJhZGVfZGlyGAQgAigOMhguc2lkZX'
    'N3YXAucHJvdG8uVHJhZGVEaXJSCHRyYWRlRGlyEh8KC2Jhc2VfYW1vdW50GAUgAigEUgpiYXNl'
    'QW1vdW50EiEKDHF1b3RlX2Ftb3VudBgGIAIoBFILcXVvdGVBbW91bnQSFAoFcHJpY2UYByACKA'
    'FSBXByaWNlEjIKBnN0YXR1cxgIIAIoDjIaLnNpZGVzd2FwLnByb3RvLkhpc3RTdGF0dXNSBnN0'
    'YXR1cxISCgR0eGlkGAkgASgJUgR0eGlk');

@$core.Deprecated('Use toDescriptor instead')
const To$json = {
  '1': 'To',
  '2': [
    {'1': 'login', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.Login', '9': 0, '10': 'login'},
    {'1': 'logout', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    {'1': 'network_settings', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.To.NetworkSettings', '9': 0, '10': 'networkSettings'},
    {'1': 'proxy_settings', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.To.ProxySettings', '9': 0, '10': 'proxySettings'},
    {'1': 'update_push_token', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.To.UpdatePushToken', '9': 0, '10': 'updatePushToken'},
    {'1': 'encrypt_pin', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.EncryptPin', '9': 0, '10': 'encryptPin'},
    {'1': 'decrypt_pin', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.To.DecryptPin', '9': 0, '10': 'decryptPin'},
    {'1': 'push_message', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'pushMessage'},
    {'1': 'app_state', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.To.AppState', '9': 0, '10': 'appState'},
    {'1': 'set_memo', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.To.SetMemo', '9': 0, '10': 'setMemo'},
    {'1': 'get_recv_address', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Account', '9': 0, '10': 'getRecvAddress'},
    {'1': 'create_tx', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.CreateTx', '9': 0, '10': 'createTx'},
    {'1': 'send_tx', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.To.SendTx', '9': 0, '10': 'sendTx'},
    {'1': 'blinded_values', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.To.BlindedValues', '9': 0, '10': 'blindedValues'},
    {'1': 'load_utxos', '3': 17, '4': 1, '5': 11, '6': '.sideswap.proto.Account', '9': 0, '10': 'loadUtxos'},
    {'1': 'load_addresses', '3': 18, '4': 1, '5': 11, '6': '.sideswap.proto.Account', '9': 0, '10': 'loadAddresses'},
    {'1': 'swap_request', '3': 20, '4': 1, '5': 11, '6': '.sideswap.proto.To.SwapRequest', '9': 0, '10': 'swapRequest'},
    {'1': 'peg_in_request', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegInRequest', '9': 0, '10': 'pegInRequest'},
    {'1': 'peg_out_amount', '3': 24, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutAmount', '9': 0, '10': 'pegOutAmount'},
    {'1': 'peg_out_request', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutRequest', '9': 0, '10': 'pegOutRequest'},
    {'1': 'swap_accept', '3': 23, '4': 1, '5': 11, '6': '.sideswap.proto.SwapDetails', '9': 0, '10': 'swapAccept'},
    {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.To.RegisterPhone', '9': 0, '10': 'registerPhone'},
    {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.To.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    {'1': 'unregister_phone', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.To.UnregisterPhone', '9': 0, '10': 'unregisterPhone'},
    {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadAvatar', '9': 0, '10': 'uploadAvatar'},
    {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadContacts', '9': 0, '10': 'uploadContacts'},
    {'1': 'submit_order', '3': 49, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitOrder', '9': 0, '10': 'submitOrder'},
    {'1': 'link_order', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.To.LinkOrder', '9': 0, '10': 'linkOrder'},
    {'1': 'submit_decision', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitDecision', '9': 0, '10': 'submitDecision'},
    {'1': 'edit_order', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.To.EditOrder', '9': 0, '10': 'editOrder'},
    {'1': 'cancel_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.To.CancelOrder', '9': 0, '10': 'cancelOrder'},
    {'1': 'subscribe', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.To.Subscribe', '9': 0, '10': 'subscribe'},
    {'1': 'asset_details', '3': 57, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'assetDetails'},
    {'1': 'subscribe_price', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'subscribePrice'},
    {'1': 'unsubscribe_price', '3': 56, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'unsubscribePrice'},
    {'1': 'subscribe_price_stream', '3': 58, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubscribePriceStream', '9': 0, '10': 'subscribePriceStream'},
    {'1': 'unsubscribe_price_stream', '3': 59, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'unsubscribePriceStream'},
    {'1': 'market_data_subscribe', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.To.MarketDataSubscribe', '9': 0, '10': 'marketDataSubscribe'},
    {'1': 'market_data_unsubscribe', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'marketDataUnsubscribe'},
    {'1': 'portfolio_prices', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'portfolioPrices'},
    {'1': 'conversion_rates', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'conversionRates'},
    {'1': 'jade_rescan', '3': 71, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'jadeRescan'},
    {'1': 'gaid_status', '3': 81, '4': 1, '5': 11, '6': '.sideswap.proto.To.GaidStatus', '9': 0, '10': 'gaidStatus'},
    {'1': 'market_subscribe', '3': 100, '4': 1, '5': 11, '6': '.sideswap.proto.AssetPair', '9': 0, '10': 'marketSubscribe'},
    {'1': 'market_unsubscribe', '3': 101, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'marketUnsubscribe'},
    {'1': 'order_submit', '3': 102, '4': 1, '5': 11, '6': '.sideswap.proto.To.OrderSubmit', '9': 0, '10': 'orderSubmit'},
    {'1': 'order_edit', '3': 103, '4': 1, '5': 11, '6': '.sideswap.proto.To.OrderEdit', '9': 0, '10': 'orderEdit'},
    {'1': 'order_cancel', '3': 104, '4': 1, '5': 11, '6': '.sideswap.proto.To.OrderCancel', '9': 0, '10': 'orderCancel'},
    {'1': 'start_quotes', '3': 110, '4': 1, '5': 11, '6': '.sideswap.proto.To.StartQuotes', '9': 0, '10': 'startQuotes'},
    {'1': 'stop_quotes', '3': 111, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'stopQuotes'},
    {'1': 'accept_quote', '3': 112, '4': 1, '5': 11, '6': '.sideswap.proto.To.AcceptQuote', '9': 0, '10': 'acceptQuote'},
    {'1': 'charts_subscribe', '3': 120, '4': 1, '5': 11, '6': '.sideswap.proto.AssetPair', '9': 0, '10': 'chartsSubscribe'},
    {'1': 'charts_unsubscribe', '3': 121, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'chartsUnsubscribe'},
    {'1': 'load_history', '3': 130, '4': 1, '5': 11, '6': '.sideswap.proto.To.LoadHistory', '9': 0, '10': 'loadHistory'},
  ],
  '3': [To_Login$json, To_NetworkSettings$json, To_ProxySettings$json, To_EncryptPin$json, To_DecryptPin$json, To_AppState$json, To_SwapRequest$json, To_PegInRequest$json, To_PegOutAmount$json, To_PegOutRequest$json, To_SetMemo$json, To_SendTx$json, To_BlindedValues$json, To_UpdatePushToken$json, To_RegisterPhone$json, To_VerifyPhone$json, To_UnregisterPhone$json, To_UploadAvatar$json, To_UploadContacts$json, To_SubmitOrder$json, To_LinkOrder$json, To_SubmitDecision$json, To_EditOrder$json, To_CancelOrder$json, To_Subscribe$json, To_SubscribePriceStream$json, To_MarketDataSubscribe$json, To_GaidStatus$json, To_OrderSubmit$json, To_OrderEdit$json, To_OrderCancel$json, To_StartQuotes$json, To_AcceptQuote$json, To_LoadHistory$json],
  '8': [
    {'1': 'msg'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Login$json = {
  '1': 'Login',
  '2': [
    {'1': 'mnemonic', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
    {'1': 'jade_id', '3': 7, '4': 1, '5': 9, '9': 0, '10': 'jadeId'},
    {'1': 'phone_key', '3': 2, '4': 1, '5': 9, '10': 'phoneKey'},
  ],
  '8': [
    {'1': 'wallet'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_NetworkSettings$json = {
  '1': 'NetworkSettings',
  '2': [
    {'1': 'blockstream', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'blockstream'},
    {'1': 'sideswap', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'sideswap'},
    {'1': 'sideswap_cn', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'sideswapCn'},
    {'1': 'custom', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.NetworkSettings.Custom', '9': 0, '10': 'custom'},
  ],
  '3': [To_NetworkSettings_Custom$json],
  '8': [
    {'1': 'selected'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_NetworkSettings_Custom$json = {
  '1': 'Custom',
  '2': [
    {'1': 'host', '3': 1, '4': 2, '5': 9, '10': 'host'},
    {'1': 'port', '3': 2, '4': 2, '5': 5, '10': 'port'},
    {'1': 'use_tls', '3': 3, '4': 2, '5': 8, '10': 'useTls'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ProxySettings$json = {
  '1': 'ProxySettings',
  '2': [
    {'1': 'proxy', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.ProxySettings.Proxy', '10': 'proxy'},
  ],
  '3': [To_ProxySettings_Proxy$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ProxySettings_Proxy$json = {
  '1': 'Proxy',
  '2': [
    {'1': 'host', '3': 1, '4': 2, '5': 9, '10': 'host'},
    {'1': 'port', '3': 2, '4': 2, '5': 5, '10': 'port'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EncryptPin$json = {
  '1': 'EncryptPin',
  '2': [
    {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    {'1': 'mnemonic', '3': 2, '4': 2, '5': 9, '10': 'mnemonic'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_DecryptPin$json = {
  '1': 'DecryptPin',
  '2': [
    {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
    {'1': 'hmac', '3': 5, '4': 1, '5': 9, '10': 'hmac'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_AppState$json = {
  '1': 'AppState',
  '2': [
    {'1': 'active', '3': 1, '4': 2, '5': 8, '10': 'active'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SwapRequest$json = {
  '1': 'SwapRequest',
  '2': [
    {'1': 'send_bitcoins', '3': 1, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    {'1': 'send_amount', '3': 3, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 4, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegInRequest$json = {
  '1': 'PegInRequest',
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegOutAmount$json = {
  '1': 'PegOutAmount',
  '2': [
    {'1': 'amount', '3': 1, '4': 2, '5': 3, '10': 'amount'},
    {'1': 'is_send_entered', '3': 2, '4': 2, '5': 8, '10': 'isSendEntered'},
    {'1': 'fee_rate', '3': 3, '4': 2, '5': 1, '10': 'feeRate'},
    {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegOutRequest$json = {
  '1': 'PegOutRequest',
  '2': [
    {'1': 'send_amount', '3': 1, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 2, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'is_send_entered', '3': 4, '4': 2, '5': 8, '10': 'isSendEntered'},
    {'1': 'fee_rate', '3': 5, '4': 2, '5': 1, '10': 'feeRate'},
    {'1': 'recv_addr', '3': 6, '4': 2, '5': 9, '10': 'recvAddr'},
    {'1': 'blocks', '3': 7, '4': 2, '5': 5, '10': 'blocks'},
    {'1': 'account', '3': 8, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SetMemo$json = {
  '1': 'SetMemo',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'memo', '3': 3, '4': 2, '5': 9, '10': 'memo'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SendTx$json = {
  '1': 'SendTx',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'id', '3': 2, '4': 2, '5': 9, '10': 'id'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_BlindedValues$json = {
  '1': 'BlindedValues',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UpdatePushToken$json = {
  '1': 'UpdatePushToken',
  '2': [
    {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_RegisterPhone$json = {
  '1': 'RegisterPhone',
  '2': [
    {'1': 'number', '3': 1, '4': 2, '5': 9, '10': 'number'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_VerifyPhone$json = {
  '1': 'VerifyPhone',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    {'1': 'code', '3': 2, '4': 2, '5': 9, '10': 'code'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UnregisterPhone$json = {
  '1': 'UnregisterPhone',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadAvatar$json = {
  '1': 'UploadAvatar',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    {'1': 'image', '3': 2, '4': 2, '5': 9, '10': 'image'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadContacts$json = {
  '1': 'UploadContacts',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    {'1': 'contacts', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.UploadContact', '10': 'contacts'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitOrder$json = {
  '1': 'SubmitOrder',
  '2': [
    {'1': 'account', '3': 7, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'bitcoin_amount', '3': 3, '4': 1, '5': 1, '10': 'bitcoinAmount'},
    {'1': 'asset_amount', '3': 4, '4': 1, '5': 1, '10': 'assetAmount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    {'1': 'index_price', '3': 6, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_LinkOrder$json = {
  '1': 'LinkOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitDecision$json = {
  '1': 'SubmitDecision',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'accept', '3': 2, '4': 2, '5': 8, '10': 'accept'},
    {'1': 'auto_sign', '3': 3, '4': 1, '5': 8, '10': 'autoSign'},
    {'1': 'private', '3': 4, '4': 1, '5': 8, '10': 'private'},
    {'1': 'two_step', '3': 6, '4': 1, '5': 8, '10': 'twoStep'},
    {'1': 'ttl_seconds', '3': 5, '4': 1, '5': 4, '10': 'ttlSeconds'},
    {'1': 'tx_chaining_allowed', '3': 7, '4': 1, '5': 8, '10': 'txChainingAllowed'},
    {'1': 'only_unused_utxos', '3': 8, '4': 1, '5': 8, '10': 'onlyUnusedUtxos'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EditOrder$json = {
  '1': 'EditOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'price', '3': 2, '4': 1, '5': 1, '9': 0, '10': 'price'},
    {'1': 'index_price', '3': 3, '4': 1, '5': 1, '9': 0, '10': 'indexPrice'},
    {'1': 'auto_sign', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'autoSign'},
  ],
  '8': [
    {'1': 'data'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_CancelOrder$json = {
  '1': 'CancelOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe$json = {
  '1': 'Subscribe',
  '2': [
    {'1': 'markets', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.To.Subscribe.Market', '10': 'markets'},
  ],
  '3': [To_Subscribe_Market$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe_Market$json = {
  '1': 'Market',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubscribePriceStream$json = {
  '1': 'SubscribePriceStream',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_MarketDataSubscribe$json = {
  '1': 'MarketDataSubscribe',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_GaidStatus$json = {
  '1': 'GaidStatus',
  '2': [
    {'1': 'gaid', '3': 1, '4': 2, '5': 9, '10': 'gaid'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_OrderSubmit$json = {
  '1': 'OrderSubmit',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'base_amount', '3': 2, '4': 2, '5': 4, '10': 'baseAmount'},
    {'1': 'price', '3': 3, '4': 2, '5': 1, '10': 'price'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'ttl_seconds', '3': 5, '4': 1, '5': 4, '10': 'ttlSeconds'},
    {'1': 'two_step', '3': 6, '4': 2, '5': 8, '10': 'twoStep'},
    {'1': 'tx_chaining_allowed', '3': 7, '4': 1, '5': 8, '10': 'txChainingAllowed'},
    {'1': 'private', '3': 8, '4': 2, '5': 8, '10': 'private'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_OrderEdit$json = {
  '1': 'OrderEdit',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
    {'1': 'base_amount', '3': 2, '4': 1, '5': 4, '10': 'baseAmount'},
    {'1': 'price', '3': 3, '4': 1, '5': 1, '10': 'price'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_OrderCancel$json = {
  '1': 'OrderCancel',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.OrderId', '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_StartQuotes$json = {
  '1': 'StartQuotes',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'asset_type', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.AssetType', '10': 'assetType'},
    {'1': 'amount', '3': 3, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_AcceptQuote$json = {
  '1': 'AcceptQuote',
  '2': [
    {'1': 'quote_id', '3': 1, '4': 2, '5': 4, '10': 'quoteId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_LoadHistory$json = {
  '1': 'LoadHistory',
  '2': [
    {'1': 'skip', '3': 1, '4': 2, '5': 13, '10': 'skip'},
    {'1': 'count', '3': 2, '4': 2, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `To`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toDescriptor = $convert.base64Decode(
    'CgJUbxIwCgVsb2dpbhgBIAEoCzIYLnNpZGVzd2FwLnByb3RvLlRvLkxvZ2luSABSBWxvZ2luEi'
    '8KBmxvZ291dBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSBmxvZ291dBJPChBuZXR3'
    'b3JrX3NldHRpbmdzGAkgASgLMiIuc2lkZXN3YXAucHJvdG8uVG8uTmV0d29ya1NldHRpbmdzSA'
    'BSD25ldHdvcmtTZXR0aW5ncxJJCg5wcm94eV9zZXR0aW5ncxgHIAEoCzIgLnNpZGVzd2FwLnBy'
    'b3RvLlRvLlByb3h5U2V0dGluZ3NIAFINcHJveHlTZXR0aW5ncxJQChF1cGRhdGVfcHVzaF90b2'
    'tlbhgDIAEoCzIiLnNpZGVzd2FwLnByb3RvLlRvLlVwZGF0ZVB1c2hUb2tlbkgAUg91cGRhdGVQ'
    'dXNoVG9rZW4SQAoLZW5jcnlwdF9waW4YBCABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5FbmNyeX'
    'B0UGluSABSCmVuY3J5cHRQaW4SQAoLZGVjcnlwdF9waW4YBSABKAsyHS5zaWRlc3dhcC5wcm90'
    'by5Uby5EZWNyeXB0UGluSABSCmRlY3J5cHRQaW4SIwoMcHVzaF9tZXNzYWdlGAYgASgJSABSC3'
    'B1c2hNZXNzYWdlEjoKCWFwcF9zdGF0ZRgIIAEoCzIbLnNpZGVzd2FwLnByb3RvLlRvLkFwcFN0'
    'YXRlSABSCGFwcFN0YXRlEjcKCHNldF9tZW1vGAogASgLMhouc2lkZXN3YXAucHJvdG8uVG8uU2'
    'V0TWVtb0gAUgdzZXRNZW1vEkMKEGdldF9yZWN2X2FkZHJlc3MYCyABKAsyFy5zaWRlc3dhcC5w'
    'cm90by5BY2NvdW50SABSDmdldFJlY3ZBZGRyZXNzEjcKCWNyZWF0ZV90eBgMIAEoCzIYLnNpZG'
    'Vzd2FwLnByb3RvLkNyZWF0ZVR4SABSCGNyZWF0ZVR4EjQKB3NlbmRfdHgYDSABKAsyGS5zaWRl'
    'c3dhcC5wcm90by5Uby5TZW5kVHhIAFIGc2VuZFR4EkkKDmJsaW5kZWRfdmFsdWVzGA4gASgLMi'
    'Auc2lkZXN3YXAucHJvdG8uVG8uQmxpbmRlZFZhbHVlc0gAUg1ibGluZGVkVmFsdWVzEjgKCmxv'
    'YWRfdXR4b3MYESABKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50SABSCWxvYWRVdHhvcxJACg'
    '5sb2FkX2FkZHJlc3NlcxgSIAEoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRIAFINbG9hZEFk'
    'ZHJlc3NlcxJDCgxzd2FwX3JlcXVlc3QYFCABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5Td2FwUm'
    'VxdWVzdEgAUgtzd2FwUmVxdWVzdBJHCg5wZWdfaW5fcmVxdWVzdBgVIAEoCzIfLnNpZGVzd2Fw'
    'LnByb3RvLlRvLlBlZ0luUmVxdWVzdEgAUgxwZWdJblJlcXVlc3QSRwoOcGVnX291dF9hbW91bn'
    'QYGCABKAsyHy5zaWRlc3dhcC5wcm90by5Uby5QZWdPdXRBbW91bnRIAFIMcGVnT3V0QW1vdW50'
    'EkoKD3BlZ19vdXRfcmVxdWVzdBgWIAEoCzIgLnNpZGVzd2FwLnByb3RvLlRvLlBlZ091dFJlcX'
    'Vlc3RIAFINcGVnT3V0UmVxdWVzdBI+Cgtzd2FwX2FjY2VwdBgXIAEoCzIbLnNpZGVzd2FwLnBy'
    'b3RvLlN3YXBEZXRhaWxzSABSCnN3YXBBY2NlcHQSSQoOcmVnaXN0ZXJfcGhvbmUYKCABKAsyIC'
    '5zaWRlc3dhcC5wcm90by5Uby5SZWdpc3RlclBob25lSABSDXJlZ2lzdGVyUGhvbmUSQwoMdmVy'
    'aWZ5X3Bob25lGCkgASgLMh4uc2lkZXN3YXAucHJvdG8uVG8uVmVyaWZ5UGhvbmVIAFILdmVyaW'
    'Z5UGhvbmUSTwoQdW5yZWdpc3Rlcl9waG9uZRgsIAEoCzIiLnNpZGVzd2FwLnByb3RvLlRvLlVu'
    'cmVnaXN0ZXJQaG9uZUgAUg91bnJlZ2lzdGVyUGhvbmUSRgoNdXBsb2FkX2F2YXRhchgqIAEoCz'
    'IfLnNpZGVzd2FwLnByb3RvLlRvLlVwbG9hZEF2YXRhckgAUgx1cGxvYWRBdmF0YXISTAoPdXBs'
    'b2FkX2NvbnRhY3RzGCsgASgLMiEuc2lkZXN3YXAucHJvdG8uVG8uVXBsb2FkQ29udGFjdHNIAF'
    'IOdXBsb2FkQ29udGFjdHMSQwoMc3VibWl0X29yZGVyGDEgASgLMh4uc2lkZXN3YXAucHJvdG8u'
    'VG8uU3VibWl0T3JkZXJIAFILc3VibWl0T3JkZXISPQoKbGlua19vcmRlchgyIAEoCzIcLnNpZG'
    'Vzd2FwLnByb3RvLlRvLkxpbmtPcmRlckgAUglsaW5rT3JkZXISTAoPc3VibWl0X2RlY2lzaW9u'
    'GDMgASgLMiEuc2lkZXN3YXAucHJvdG8uVG8uU3VibWl0RGVjaXNpb25IAFIOc3VibWl0RGVjaX'
    'Npb24SPQoKZWRpdF9vcmRlchg0IAEoCzIcLnNpZGVzd2FwLnByb3RvLlRvLkVkaXRPcmRlckgA'
    'UgllZGl0T3JkZXISQwoMY2FuY2VsX29yZGVyGDUgASgLMh4uc2lkZXN3YXAucHJvdG8uVG8uQ2'
    'FuY2VsT3JkZXJIAFILY2FuY2VsT3JkZXISPAoJc3Vic2NyaWJlGDYgASgLMhwuc2lkZXN3YXAu'
    'cHJvdG8uVG8uU3Vic2NyaWJlSABSCXN1YnNjcmliZRI+Cg1hc3NldF9kZXRhaWxzGDkgASgLMh'
    'cuc2lkZXN3YXAucHJvdG8uQXNzZXRJZEgAUgxhc3NldERldGFpbHMSQgoPc3Vic2NyaWJlX3By'
    'aWNlGDcgASgLMhcuc2lkZXN3YXAucHJvdG8uQXNzZXRJZEgAUg5zdWJzY3JpYmVQcmljZRJGCh'
    'F1bnN1YnNjcmliZV9wcmljZRg4IAEoCzIXLnNpZGVzd2FwLnByb3RvLkFzc2V0SWRIAFIQdW5z'
    'dWJzY3JpYmVQcmljZRJfChZzdWJzY3JpYmVfcHJpY2Vfc3RyZWFtGDogASgLMicuc2lkZXN3YX'
    'AucHJvdG8uVG8uU3Vic2NyaWJlUHJpY2VTdHJlYW1IAFIUc3Vic2NyaWJlUHJpY2VTdHJlYW0S'
    'UQoYdW5zdWJzY3JpYmVfcHJpY2Vfc3RyZWFtGDsgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdH'
    'lIAFIWdW5zdWJzY3JpYmVQcmljZVN0cmVhbRJcChVtYXJrZXRfZGF0YV9zdWJzY3JpYmUYPCAB'
    'KAsyJi5zaWRlc3dhcC5wcm90by5Uby5NYXJrZXREYXRhU3Vic2NyaWJlSABSE21hcmtldERhdG'
    'FTdWJzY3JpYmUSTwoXbWFya2V0X2RhdGFfdW5zdWJzY3JpYmUYPSABKAsyFS5zaWRlc3dhcC5w'
    'cm90by5FbXB0eUgAUhVtYXJrZXREYXRhVW5zdWJzY3JpYmUSQgoQcG9ydGZvbGlvX3ByaWNlcx'
    'g+IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSD3BvcnRmb2xpb1ByaWNlcxJCChBjb252'
    'ZXJzaW9uX3JhdGVzGD8gASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIPY29udmVyc2lvbl'
    'JhdGVzEjgKC2phZGVfcmVzY2FuGEcgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIKamFk'
    'ZVJlc2NhbhJACgtnYWlkX3N0YXR1cxhRIAEoCzIdLnNpZGVzd2FwLnByb3RvLlRvLkdhaWRTdG'
    'F0dXNIAFIKZ2FpZFN0YXR1cxJGChBtYXJrZXRfc3Vic2NyaWJlGGQgASgLMhkuc2lkZXN3YXAu'
    'cHJvdG8uQXNzZXRQYWlySABSD21hcmtldFN1YnNjcmliZRJGChJtYXJrZXRfdW5zdWJzY3JpYm'
    'UYZSABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUhFtYXJrZXRVbnN1YnNjcmliZRJDCgxv'
    'cmRlcl9zdWJtaXQYZiABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5PcmRlclN1Ym1pdEgAUgtvcm'
    'RlclN1Ym1pdBI9CgpvcmRlcl9lZGl0GGcgASgLMhwuc2lkZXN3YXAucHJvdG8uVG8uT3JkZXJF'
    'ZGl0SABSCW9yZGVyRWRpdBJDCgxvcmRlcl9jYW5jZWwYaCABKAsyHi5zaWRlc3dhcC5wcm90by'
    '5Uby5PcmRlckNhbmNlbEgAUgtvcmRlckNhbmNlbBJDCgxzdGFydF9xdW90ZXMYbiABKAsyHi5z'
    'aWRlc3dhcC5wcm90by5Uby5TdGFydFF1b3Rlc0gAUgtzdGFydFF1b3RlcxI4CgtzdG9wX3F1b3'
    'RlcxhvIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSCnN0b3BRdW90ZXMSQwoMYWNjZXB0'
    'X3F1b3RlGHAgASgLMh4uc2lkZXN3YXAucHJvdG8uVG8uQWNjZXB0UXVvdGVIAFILYWNjZXB0UX'
    'VvdGUSRgoQY2hhcnRzX3N1YnNjcmliZRh4IAEoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UGFp'
    'ckgAUg9jaGFydHNTdWJzY3JpYmUSRgoSY2hhcnRzX3Vuc3Vic2NyaWJlGHkgASgLMhUuc2lkZX'
    'N3YXAucHJvdG8uRW1wdHlIAFIRY2hhcnRzVW5zdWJzY3JpYmUSRAoMbG9hZF9oaXN0b3J5GIIB'
    'IAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLkxvYWRIaXN0b3J5SABSC2xvYWRIaXN0b3J5GmcKBU'
    'xvZ2luEhwKCG1uZW1vbmljGAEgASgJSABSCG1uZW1vbmljEhkKB2phZGVfaWQYByABKAlIAFIG'
    'amFkZUlkEhsKCXBob25lX2tleRgCIAEoCVIIcGhvbmVLZXlCCAoGd2FsbGV0GtcCCg9OZXR3b3'
    'JrU2V0dGluZ3MSOQoLYmxvY2tzdHJlYW0YASABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgA'
    'UgtibG9ja3N0cmVhbRIzCghzaWRlc3dhcBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SA'
    'BSCHNpZGVzd2FwEjgKC3NpZGVzd2FwX2NuGAMgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlI'
    'AFIKc2lkZXN3YXBDbhJDCgZjdXN0b20YBCABKAsyKS5zaWRlc3dhcC5wcm90by5Uby5OZXR3b3'
    'JrU2V0dGluZ3MuQ3VzdG9tSABSBmN1c3RvbRpJCgZDdXN0b20SEgoEaG9zdBgBIAIoCVIEaG9z'
    'dBISCgRwb3J0GAIgAigFUgRwb3J0EhcKB3VzZV90bHMYAyACKAhSBnVzZVRsc0IKCghzZWxlY3'
    'RlZBp+Cg1Qcm94eVNldHRpbmdzEjwKBXByb3h5GAEgASgLMiYuc2lkZXN3YXAucHJvdG8uVG8u'
    'UHJveHlTZXR0aW5ncy5Qcm94eVIFcHJveHkaLwoFUHJveHkSEgoEaG9zdBgBIAIoCVIEaG9zdB'
    'ISCgRwb3J0GAIgAigFUgRwb3J0GjoKCkVuY3J5cHRQaW4SEAoDcGluGAEgAigJUgNwaW4SGgoI'
    'bW5lbW9uaWMYAiACKAlSCG1uZW1vbmljGpQBCgpEZWNyeXB0UGluEhAKA3BpbhgBIAIoCVIDcG'
    'luEhIKBHNhbHQYAiACKAlSBHNhbHQSJQoOZW5jcnlwdGVkX2RhdGEYAyACKAlSDWVuY3J5cHRl'
    'ZERhdGESJQoOcGluX2lkZW50aWZpZXIYBCACKAlSDXBpbklkZW50aWZpZXISEgoEaG1hYxgFIA'
    'EoCVIEaG1hYxoiCghBcHBTdGF0ZRIWCgZhY3RpdmUYASACKAhSBmFjdGl2ZRqgAQoLU3dhcFJl'
    'cXVlc3QSIwoNc2VuZF9iaXRjb2lucxgBIAIoCFIMc2VuZEJpdGNvaW5zEhQKBWFzc2V0GAIgAi'
    'gJUgVhc3NldBIfCgtzZW5kX2Ftb3VudBgDIAIoA1IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3Vu'
    'dBgEIAIoA1IKcmVjdkFtb3VudBIUCgVwcmljZRgFIAIoAVIFcHJpY2UaDgoMUGVnSW5SZXF1ZX'
    'N0GpwBCgxQZWdPdXRBbW91bnQSFgoGYW1vdW50GAEgAigDUgZhbW91bnQSJgoPaXNfc2VuZF9l'
    'bnRlcmVkGAIgAigIUg1pc1NlbmRFbnRlcmVkEhkKCGZlZV9yYXRlGAMgAigBUgdmZWVSYXRlEj'
    'EKB2FjY291bnQYBCACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50GvwBCg1Q'
    'ZWdPdXRSZXF1ZXN0Eh8KC3NlbmRfYW1vdW50GAEgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW'
    '1vdW50GAIgAigDUgpyZWN2QW1vdW50EiYKD2lzX3NlbmRfZW50ZXJlZBgEIAIoCFINaXNTZW5k'
    'RW50ZXJlZBIZCghmZWVfcmF0ZRgFIAIoAVIHZmVlUmF0ZRIbCglyZWN2X2FkZHIYBiACKAlSCH'
    'JlY3ZBZGRyEhYKBmJsb2NrcxgHIAIoBVIGYmxvY2tzEjEKB2FjY291bnQYCCACKAsyFy5zaWRl'
    'c3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50GmQKB1NldE1lbW8SMQoHYWNjb3VudBgBIAIoCz'
    'IXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSEgoEdHhpZBgCIAIoCVIEdHhpZBIS'
    'CgRtZW1vGAMgAigJUgRtZW1vGksKBlNlbmRUeBIxCgdhY2NvdW50GAEgAigLMhcuc2lkZXN3YX'
    'AucHJvdG8uQWNjb3VudFIHYWNjb3VudBIOCgJpZBgCIAIoCVICaWQaIwoNQmxpbmRlZFZhbHVl'
    'cxISCgR0eGlkGAEgAigJUgR0eGlkGicKD1VwZGF0ZVB1c2hUb2tlbhIUCgV0b2tlbhgBIAIoCV'
    'IFdG9rZW4aJwoNUmVnaXN0ZXJQaG9uZRIWCgZudW1iZXIYASACKAlSBm51bWJlcho+CgtWZXJp'
    'ZnlQaG9uZRIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EhIKBGNvZGUYAiACKAlSBGNvZG'
    'UaLgoPVW5yZWdpc3RlclBob25lEhsKCXBob25lX2tleRgBIAIoCVIIcGhvbmVLZXkaQQoMVXBs'
    'b2FkQXZhdGFyEhsKCXBob25lX2tleRgBIAIoCVIIcGhvbmVLZXkSFAoFaW1hZ2UYAiACKAlSBW'
    'ltYWdlGmgKDlVwbG9hZENvbnRhY3RzEhsKCXBob25lX2tleRgBIAIoCVIIcGhvbmVLZXkSOQoI'
    'Y29udGFjdHMYAiADKAsyHS5zaWRlc3dhcC5wcm90by5VcGxvYWRDb250YWN0Ughjb250YWN0cx'
    'rcAQoLU3VibWl0T3JkZXISMQoHYWNjb3VudBgHIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291'
    'bnRSB2FjY291bnQSGQoIYXNzZXRfaWQYAiACKAlSB2Fzc2V0SWQSJQoOYml0Y29pbl9hbW91bn'
    'QYAyABKAFSDWJpdGNvaW5BbW91bnQSIQoMYXNzZXRfYW1vdW50GAQgASgBUgthc3NldEFtb3Vu'
    'dBIUCgVwcmljZRgFIAIoAVIFcHJpY2USHwoLaW5kZXhfcHJpY2UYBiABKAFSCmluZGV4UHJpY2'
    'UaJgoJTGlua09yZGVyEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkGpICCg5TdWJtaXREZWNp'
    'c2lvbhIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIWCgZhY2NlcHQYAiACKAhSBmFjY2VwdB'
    'IbCglhdXRvX3NpZ24YAyABKAhSCGF1dG9TaWduEhgKB3ByaXZhdGUYBCABKAhSB3ByaXZhdGUS'
    'GQoIdHdvX3N0ZXAYBiABKAhSB3R3b1N0ZXASHwoLdHRsX3NlY29uZHMYBSABKARSCnR0bFNlY2'
    '9uZHMSLgoTdHhfY2hhaW5pbmdfYWxsb3dlZBgHIAEoCFIRdHhDaGFpbmluZ0FsbG93ZWQSKgoR'
    'b25seV91bnVzZWRfdXR4b3MYCCABKAhSD29ubHlVbnVzZWRVdHhvcxqIAQoJRWRpdE9yZGVyEh'
    'kKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkEhYKBXByaWNlGAIgASgBSABSBXByaWNlEiEKC2lu'
    'ZGV4X3ByaWNlGAMgASgBSABSCmluZGV4UHJpY2USHQoJYXV0b19zaWduGAQgASgISABSCGF1dG'
    '9TaWduQgYKBGRhdGEaKAoLQ2FuY2VsT3JkZXISGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQa'
    'bwoJU3Vic2NyaWJlEj0KB21hcmtldHMYASADKAsyIy5zaWRlc3dhcC5wcm90by5Uby5TdWJzY3'
    'JpYmUuTWFya2V0UgdtYXJrZXRzGiMKBk1hcmtldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJ'
    'ZBqYAQoUU3Vic2NyaWJlUHJpY2VTdHJlYW0SGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSIw'
    'oNc2VuZF9iaXRjb2lucxgCIAIoCFIMc2VuZEJpdGNvaW5zEh8KC3NlbmRfYW1vdW50GAMgASgD'
    'UgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAQgASgDUgpyZWN2QW1vdW50GjAKE01hcmtldE'
    'RhdGFTdWJzY3JpYmUSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQaOwoKR2FpZFN0YXR1cxIS'
    'CgRnYWlkGAEgAigJUgRnYWlkEhkKCGFzc2V0X2lkGAIgAigJUgdhc3NldElkGrsCCgtPcmRlcl'
    'N1Ym1pdBI4Cgphc3NldF9wYWlyGAEgAigLMhkuc2lkZXN3YXAucHJvdG8uQXNzZXRQYWlyUglh'
    'c3NldFBhaXISHwoLYmFzZV9hbW91bnQYAiACKARSCmJhc2VBbW91bnQSFAoFcHJpY2UYAyACKA'
    'FSBXByaWNlEjUKCXRyYWRlX2RpchgEIAIoDjIYLnNpZGVzd2FwLnByb3RvLlRyYWRlRGlyUgh0'
    'cmFkZURpchIfCgt0dGxfc2Vjb25kcxgFIAEoBFIKdHRsU2Vjb25kcxIZCgh0d29fc3RlcBgGIA'
    'IoCFIHdHdvU3RlcBIuChN0eF9jaGFpbmluZ19hbGxvd2VkGAcgASgIUhF0eENoYWluaW5nQWxs'
    'b3dlZBIYCgdwcml2YXRlGAggAigIUgdwcml2YXRlGnYKCU9yZGVyRWRpdBIyCghvcmRlcl9pZB'
    'gBIAIoCzIXLnNpZGVzd2FwLnByb3RvLk9yZGVySWRSB29yZGVySWQSHwoLYmFzZV9hbW91bnQY'
    'AiABKARSCmJhc2VBbW91bnQSFAoFcHJpY2UYAyABKAFSBXByaWNlGkEKC09yZGVyQ2FuY2VsEj'
    'IKCG9yZGVyX2lkGAEgAigLMhcuc2lkZXN3YXAucHJvdG8uT3JkZXJJZFIHb3JkZXJJZBrQAQoL'
    'U3RhcnRRdW90ZXMSOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UG'
    'FpclIJYXNzZXRQYWlyEjgKCmFzc2V0X3R5cGUYAiACKA4yGS5zaWRlc3dhcC5wcm90by5Bc3Nl'
    'dFR5cGVSCWFzc2V0VHlwZRIWCgZhbW91bnQYAyACKARSBmFtb3VudBI1Cgl0cmFkZV9kaXIYBC'
    'ACKA4yGC5zaWRlc3dhcC5wcm90by5UcmFkZURpclIIdHJhZGVEaXIaKAoLQWNjZXB0UXVvdGUS'
    'GQoIcXVvdGVfaWQYASACKARSB3F1b3RlSWQaNwoLTG9hZEhpc3RvcnkSEgoEc2tpcBgBIAIoDV'
    'IEc2tpcBIUCgVjb3VudBgCIAIoDVIFY291bnRCBQoDbXNn');

@$core.Deprecated('Use fromDescriptor instead')
const From$json = {
  '1': 'From',
  '2': [
    {'1': 'login', '3': 17, '4': 1, '5': 11, '6': '.sideswap.proto.From.Login', '9': 0, '10': 'login'},
    {'1': 'logout', '3': 16, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    {'1': 'env_settings', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.From.EnvSettings', '9': 0, '10': 'envSettings'},
    {'1': 'register_amp', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterAmp', '9': 0, '10': 'registerAmp'},
    {'1': 'updated_txs', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedTxs', '9': 0, '10': 'updatedTxs'},
    {'1': 'removed_txs', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.From.RemovedTxs', '9': 0, '10': 'removedTxs'},
    {'1': 'updated_pegs', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedPegs', '9': 0, '10': 'updatedPegs'},
    {'1': 'new_asset', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Asset', '9': 0, '10': 'newAsset'},
    {'1': 'amp_assets', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.From.AmpAssets', '9': 0, '10': 'ampAssets'},
    {'1': 'token_market_order', '3': 18, '4': 1, '5': 11, '6': '.sideswap.proto.From.TokenMarketOrder', '9': 0, '10': 'tokenMarketOrder'},
    {'1': 'balance_update', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.BalanceUpdate', '9': 0, '10': 'balanceUpdate'},
    {'1': 'server_status', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.ServerStatus', '9': 0, '10': 'serverStatus'},
    {'1': 'price_update', '3': 6, '4': 1, '5': 11, '6': '.sideswap.proto.From.PriceUpdate', '9': 0, '10': 'priceUpdate'},
    {'1': 'wallet_loaded', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'walletLoaded'},
    {'1': 'sync_complete', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'syncComplete'},
    {'1': 'encrypt_pin', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin', '9': 0, '10': 'encryptPin'},
    {'1': 'decrypt_pin', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin', '9': 0, '10': 'decryptPin'},
    {'1': 'pegin_wait_tx', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.From.PeginWaitTx', '9': 0, '10': 'peginWaitTx'},
    {'1': 'peg_out_amount', '3': 24, '4': 1, '5': 11, '6': '.sideswap.proto.From.PegOutAmount', '9': 0, '10': 'pegOutAmount'},
    {'1': 'swap_succeed', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    {'1': 'swap_failed', '3': 23, '4': 1, '5': 9, '9': 0, '10': 'swapFailed'},
    {'1': 'recv_address', '3': 30, '4': 1, '5': 11, '6': '.sideswap.proto.From.RecvAddress', '9': 0, '10': 'recvAddress'},
    {'1': 'create_tx_result', '3': 31, '4': 1, '5': 11, '6': '.sideswap.proto.From.CreateTxResult', '9': 0, '10': 'createTxResult'},
    {'1': 'send_result', '3': 32, '4': 1, '5': 11, '6': '.sideswap.proto.From.SendResult', '9': 0, '10': 'sendResult'},
    {'1': 'blinded_values', '3': 33, '4': 1, '5': 11, '6': '.sideswap.proto.From.BlindedValues', '9': 0, '10': 'blindedValues'},
    {'1': 'load_utxos', '3': 35, '4': 1, '5': 11, '6': '.sideswap.proto.From.LoadUtxos', '9': 0, '10': 'loadUtxos'},
    {'1': 'load_addresses', '3': 36, '4': 1, '5': 11, '6': '.sideswap.proto.From.LoadAddresses', '9': 0, '10': 'loadAddresses'},
    {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterPhone', '9': 0, '10': 'registerPhone'},
    {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.From.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadAvatar'},
    {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadContacts'},
    {'1': 'contact_created', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.Contact', '9': 0, '10': 'contactCreated'},
    {'1': 'contact_removed', '3': 45, '4': 1, '5': 11, '6': '.sideswap.proto.From.ContactRemoved', '9': 0, '10': 'contactRemoved'},
    {'1': 'contact_transaction', '3': 46, '4': 1, '5': 11, '6': '.sideswap.proto.ContactTransaction', '9': 0, '10': 'contactTransaction'},
    {'1': 'account_status', '3': 47, '4': 1, '5': 11, '6': '.sideswap.proto.From.AccountStatus', '9': 0, '10': 'accountStatus'},
    {'1': 'show_message', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowMessage', '9': 0, '10': 'showMessage'},
    {'1': 'insufficient_funds', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowInsufficientFunds', '9': 0, '10': 'insufficientFunds'},
    {'1': 'submit_review', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitReview', '9': 0, '10': 'submitReview'},
    {'1': 'submit_result', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult', '9': 0, '10': 'submitResult'},
    {'1': 'edit_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'editOrder'},
    {'1': 'cancel_order', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'cancelOrder'},
    {'1': 'start_timer', '3': 56, '4': 1, '5': 11, '6': '.sideswap.proto.From.StartTimer', '9': 0, '10': 'startTimer'},
    {'1': 'server_connected', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverConnected'},
    {'1': 'server_disconnected', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverDisconnected'},
    {'1': 'order_created', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderCreated', '9': 0, '10': 'orderCreated'},
    {'1': 'order_removed', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderRemoved', '9': 0, '10': 'orderRemoved'},
    {'1': 'order_complete', '3': 67, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderComplete', '9': 0, '10': 'orderComplete'},
    {'1': 'index_price', '3': 64, '4': 1, '5': 11, '6': '.sideswap.proto.From.IndexPrice', '9': 0, '10': 'indexPrice'},
    {'1': 'asset_details', '3': 65, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails', '9': 0, '10': 'assetDetails'},
    {'1': 'update_price_stream', '3': 66, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatePriceStream', '9': 0, '10': 'updatePriceStream'},
    {'1': 'local_message', '3': 68, '4': 1, '5': 11, '6': '.sideswap.proto.From.LocalMessage', '9': 0, '10': 'localMessage'},
    {'1': 'market_data_subscribe', '3': 70, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketDataSubscribe', '9': 0, '10': 'marketDataSubscribe'},
    {'1': 'market_data_update', '3': 71, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketDataUpdate', '9': 0, '10': 'marketDataUpdate'},
    {'1': 'portfolio_prices', '3': 72, '4': 1, '5': 11, '6': '.sideswap.proto.From.PortfolioPrices', '9': 0, '10': 'portfolioPrices'},
    {'1': 'conversion_rates', '3': 73, '4': 1, '5': 11, '6': '.sideswap.proto.From.ConversionRates', '9': 0, '10': 'conversionRates'},
    {'1': 'jade_ports', '3': 80, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadePorts', '9': 0, '10': 'jadePorts'},
    {'1': 'jade_status', '3': 83, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadeStatus', '9': 0, '10': 'jadeStatus'},
    {'1': 'gaid_status', '3': 91, '4': 1, '5': 11, '6': '.sideswap.proto.From.GaidStatus', '9': 0, '10': 'gaidStatus'},
    {'1': 'market_list', '3': 100, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketList', '9': 0, '10': 'marketList'},
    {'1': 'market_added', '3': 101, '4': 1, '5': 11, '6': '.sideswap.proto.MarketInfo', '9': 0, '10': 'marketAdded'},
    {'1': 'market_removed', '3': 102, '4': 1, '5': 11, '6': '.sideswap.proto.AssetPair', '9': 0, '10': 'marketRemoved'},
    {'1': 'public_orders', '3': 105, '4': 1, '5': 11, '6': '.sideswap.proto.From.PublicOrders', '9': 0, '10': 'publicOrders'},
    {'1': 'public_order_created', '3': 106, '4': 1, '5': 11, '6': '.sideswap.proto.PublicOrder', '9': 0, '10': 'publicOrderCreated'},
    {'1': 'public_order_removed', '3': 107, '4': 1, '5': 11, '6': '.sideswap.proto.OrderId', '9': 0, '10': 'publicOrderRemoved'},
    {'1': 'market_price', '3': 110, '4': 1, '5': 11, '6': '.sideswap.proto.From.MarketPrice', '9': 0, '10': 'marketPrice'},
    {'1': 'own_orders', '3': 120, '4': 1, '5': 11, '6': '.sideswap.proto.From.OwnOrders', '9': 0, '10': 'ownOrders'},
    {'1': 'own_order_created', '3': 121, '4': 1, '5': 11, '6': '.sideswap.proto.OwnOrder', '9': 0, '10': 'ownOrderCreated'},
    {'1': 'own_order_removed', '3': 122, '4': 1, '5': 11, '6': '.sideswap.proto.OrderId', '9': 0, '10': 'ownOrderRemoved'},
    {'1': 'order_submit', '3': 130, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderSubmit', '9': 0, '10': 'orderSubmit'},
    {'1': 'order_edit', '3': 131, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'orderEdit'},
    {'1': 'order_cancel', '3': 132, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'orderCancel'},
    {'1': 'quote', '3': 140, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote', '9': 0, '10': 'quote'},
    {'1': 'accept_quote', '3': 141, '4': 1, '5': 11, '6': '.sideswap.proto.From.AcceptQuote', '9': 0, '10': 'acceptQuote'},
    {'1': 'charts_subscribe', '3': 150, '4': 1, '5': 11, '6': '.sideswap.proto.From.ChartsSubscribe', '9': 0, '10': 'chartsSubscribe'},
    {'1': 'charts_update', '3': 151, '4': 1, '5': 11, '6': '.sideswap.proto.From.ChartsUpdate', '9': 0, '10': 'chartsUpdate'},
    {'1': 'load_history', '3': 160, '4': 1, '5': 11, '6': '.sideswap.proto.From.LoadHistory', '9': 0, '10': 'loadHistory'},
    {'1': 'history_updated', '3': 161, '4': 1, '5': 11, '6': '.sideswap.proto.From.HistoryUpdated', '9': 0, '10': 'historyUpdated'},
  ],
  '3': [From_Login$json, From_EnvSettings$json, From_EncryptPin$json, From_DecryptPin$json, From_RegisterAmp$json, From_AmpAssets$json, From_TokenMarketOrder$json, From_UpdatedTxs$json, From_RemovedTxs$json, From_UpdatedPegs$json, From_BalanceUpdate$json, From_PeginWaitTx$json, From_PegOutAmount$json, From_RecvAddress$json, From_LoadUtxos$json, From_LoadAddresses$json, From_CreateTxResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_RegisterPhone$json, From_VerifyPhone$json, From_ShowMessage$json, From_ShowInsufficientFunds$json, From_SubmitReview$json, From_SubmitResult$json, From_StartTimer$json, From_OrderCreated$json, From_OrderRemoved$json, From_OrderComplete$json, From_IndexPrice$json, From_ContactRemoved$json, From_AccountStatus$json, From_AssetDetails$json, From_UpdatePriceStream$json, From_LocalMessage$json, From_MarketDataSubscribe$json, From_MarketDataUpdate$json, From_PortfolioPrices$json, From_ConversionRates$json, From_JadePorts$json, From_JadeStatus$json, From_GaidStatus$json, From_MarketList$json, From_PublicOrders$json, From_OwnOrders$json, From_MarketPrice$json, From_OrderSubmit$json, From_Quote$json, From_AcceptQuote$json, From_ChartsSubscribe$json, From_ChartsUpdate$json, From_LoadHistory$json, From_HistoryUpdated$json],
  '8': [
    {'1': 'msg'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Login$json = {
  '1': 'Login',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'success', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'success'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EnvSettings$json = {
  '1': 'EnvSettings',
  '2': [
    {'1': 'policy_asset_id', '3': 1, '4': 2, '5': 9, '10': 'policyAssetId'},
    {'1': 'usdt_asset_id', '3': 2, '4': 2, '5': 9, '10': 'usdtAssetId'},
    {'1': 'eurx_asset_id', '3': 3, '4': 2, '5': 9, '10': 'eurxAssetId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin$json = {
  '1': 'EncryptPin',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'data', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin.Data', '9': 0, '10': 'data'},
  ],
  '3': [From_EncryptPin_Data$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin_Data$json = {
  '1': 'Data',
  '2': [
    {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
    {'1': 'hmac', '3': 5, '4': 1, '5': 9, '10': 'hmac'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin$json = {
  '1': 'DecryptPin',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin.Error', '9': 0, '10': 'error'},
    {'1': 'mnemonic', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
  ],
  '3': [From_DecryptPin_Error$json],
  '4': [From_DecryptPin_ErrorCode$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin_Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 2, '5': 9, '10': 'errorMsg'},
    {'1': 'error_code', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.From.DecryptPin.ErrorCode', '10': 'errorCode'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin_ErrorCode$json = {
  '1': 'ErrorCode',
  '2': [
    {'1': 'WRONG_PIN', '2': 1},
    {'1': 'NETWORK_ERROR', '2': 2},
    {'1': 'INVALID_DATA', '2': 3},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RegisterAmp$json = {
  '1': 'RegisterAmp',
  '2': [
    {'1': 'amp_id', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ampId'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AmpAssets$json = {
  '1': 'AmpAssets',
  '2': [
    {'1': 'assets', '3': 1, '4': 3, '5': 9, '10': 'assets'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_TokenMarketOrder$json = {
  '1': 'TokenMarketOrder',
  '2': [
    {'1': 'asset_ids', '3': 1, '4': 3, '5': 9, '10': 'assetIds'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedTxs$json = {
  '1': 'UpdatedTxs',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RemovedTxs$json = {
  '1': 'RemovedTxs',
  '2': [
    {'1': 'txids', '3': 1, '4': 3, '5': 9, '10': 'txids'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedPegs$json = {
  '1': 'UpdatedPegs',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'items', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BalanceUpdate$json = {
  '1': 'BalanceUpdate',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'balances', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PeginWaitTx$json = {
  '1': 'PeginWaitTx',
  '2': [
    {'1': 'peg_addr', '3': 5, '4': 2, '5': 9, '10': 'pegAddr'},
    {'1': 'recv_addr', '3': 6, '4': 2, '5': 9, '10': 'recvAddr'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PegOutAmount$json = {
  '1': 'PegOutAmount',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'amounts', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.PegOutAmount.Amounts', '9': 0, '10': 'amounts'},
  ],
  '3': [From_PegOutAmount_Amounts$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PegOutAmount_Amounts$json = {
  '1': 'Amounts',
  '2': [
    {'1': 'send_amount', '3': 1, '4': 2, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 2, '4': 2, '5': 3, '10': 'recvAmount'},
    {'1': 'is_send_entered', '3': 4, '4': 2, '5': 8, '10': 'isSendEntered'},
    {'1': 'fee_rate', '3': 5, '4': 2, '5': 1, '10': 'feeRate'},
    {'1': 'account', '3': 6, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RecvAddress$json = {
  '1': 'RecvAddress',
  '2': [
    {'1': 'addr', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Address', '10': 'addr'},
    {'1': 'account', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadUtxos$json = {
  '1': 'LoadUtxos',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'utxos', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.From.LoadUtxos.Utxo', '10': 'utxos'},
    {'1': 'error_msg', '3': 3, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
  '3': [From_LoadUtxos_Utxo$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadUtxos_Utxo$json = {
  '1': 'Utxo',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'vout', '3': 2, '4': 2, '5': 13, '10': 'vout'},
    {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'amount', '3': 4, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'address', '3': 5, '4': 2, '5': 9, '10': 'address'},
    {'1': 'is_internal', '3': 6, '4': 2, '5': 8, '10': 'isInternal'},
    {'1': 'is_confidential', '3': 7, '4': 2, '5': 8, '10': 'isConfidential'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadAddresses$json = {
  '1': 'LoadAddresses',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'addresses', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.From.LoadAddresses.Address', '10': 'addresses'},
    {'1': 'error_msg', '3': 3, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
  '3': [From_LoadAddresses_Address$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadAddresses_Address$json = {
  '1': 'Address',
  '2': [
    {'1': 'address', '3': 1, '4': 2, '5': 9, '10': 'address'},
    {'1': 'unconfidential_address', '3': 4, '4': 2, '5': 9, '10': 'unconfidentialAddress'},
    {'1': 'index', '3': 2, '4': 2, '5': 13, '10': 'index'},
    {'1': 'is_internal', '3': 3, '4': 2, '5': 8, '10': 'isInternal'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_CreateTxResult$json = {
  '1': 'CreateTxResult',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'created_tx', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.CreatedTx', '9': 0, '10': 'createdTx'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SendResult$json = {
  '1': 'SendResult',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'tx_item', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'txItem'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BlindedValues$json = {
  '1': 'BlindedValues',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'blinded_values', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'blindedValues'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PriceUpdate$json = {
  '1': 'PriceUpdate',
  '2': [
    {'1': 'asset', '3': 1, '4': 2, '5': 9, '10': 'asset'},
    {'1': 'bid', '3': 2, '4': 2, '5': 1, '10': 'bid'},
    {'1': 'ask', '3': 3, '4': 2, '5': 1, '10': 'ask'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RegisterPhone$json = {
  '1': 'RegisterPhone',
  '2': [
    {'1': 'phone_key', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'phoneKey'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_VerifyPhone$json = {
  '1': 'VerifyPhone',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'success'},
    {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowMessage$json = {
  '1': 'ShowMessage',
  '2': [
    {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowInsufficientFunds$json = {
  '1': 'ShowInsufficientFunds',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'available', '3': 2, '4': 2, '5': 3, '10': 'available'},
    {'1': 'required', '3': 3, '4': 2, '5': 3, '10': 'required'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitReview$json = {
  '1': 'SubmitReview',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    {'1': 'server_fee', '3': 8, '4': 2, '5': 3, '10': 'serverFee'},
    {'1': 'asset_amount', '3': 4, '4': 2, '5': 3, '10': 'assetAmount'},
    {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    {'1': 'sell_bitcoin', '3': 6, '4': 2, '5': 8, '10': 'sellBitcoin'},
    {'1': 'step', '3': 7, '4': 2, '5': 14, '6': '.sideswap.proto.From.SubmitReview.Step', '10': 'step'},
    {'1': 'index_price', '3': 9, '4': 2, '5': 8, '10': 'indexPrice'},
    {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
    {'1': 'two_step', '3': 12, '4': 1, '5': 8, '10': 'twoStep'},
    {'1': 'tx_chaining_required', '3': 13, '4': 1, '5': 8, '10': 'txChainingRequired'},
  ],
  '4': [From_SubmitReview_Step$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitReview_Step$json = {
  '1': 'Step',
  '2': [
    {'1': 'SUBMIT', '2': 1},
    {'1': 'QUOTE', '2': 2},
    {'1': 'SIGN', '2': 3},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitResult$json = {
  '1': 'SubmitResult',
  '2': [
    {'1': 'submit_succeed', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'submitSucceed'},
    {'1': 'swap_succeed', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'unregistered_gaid', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult.UnregisteredGaid', '9': 0, '10': 'unregisteredGaid'},
  ],
  '3': [From_SubmitResult_UnregisteredGaid$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitResult_UnregisteredGaid$json = {
  '1': 'UnregisteredGaid',
  '2': [
    {'1': 'domain_agent', '3': 1, '4': 2, '5': 9, '10': 'domainAgent'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_StartTimer$json = {
  '1': 'StartTimer',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderCreated$json = {
  '1': 'OrderCreated',
  '2': [
    {'1': 'order', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Order', '10': 'order'},
    {'1': 'new', '3': 2, '4': 2, '5': 8, '10': 'new'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderRemoved$json = {
  '1': 'OrderRemoved',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderComplete$json = {
  '1': 'OrderComplete',
  '2': [
    {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    {'1': 'txid', '3': 2, '4': 1, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_IndexPrice$json = {
  '1': 'IndexPrice',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'ind', '3': 2, '4': 1, '5': 1, '10': 'ind'},
    {'1': 'last', '3': 3, '4': 1, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ContactRemoved$json = {
  '1': 'ContactRemoved',
  '2': [
    {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AccountStatus$json = {
  '1': 'AccountStatus',
  '2': [
    {'1': 'registered', '3': 1, '4': 2, '5': 8, '10': 'registered'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails$json = {
  '1': 'AssetDetails',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'stats', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.Stats', '10': 'stats'},
    {'1': 'chart_url', '3': 3, '4': 1, '5': 9, '10': 'chartUrl'},
    {'1': 'chart_stats', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.ChartStats', '10': 'chartStats'},
  ],
  '3': [From_AssetDetails_Stats$json, From_AssetDetails_ChartStats$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_Stats$json = {
  '1': 'Stats',
  '2': [
    {'1': 'issued_amount', '3': 1, '4': 2, '5': 3, '10': 'issuedAmount'},
    {'1': 'burned_amount', '3': 2, '4': 2, '5': 3, '10': 'burnedAmount'},
    {'1': 'offline_amount', '3': 4, '4': 2, '5': 3, '10': 'offlineAmount'},
    {'1': 'has_blinded_issuances', '3': 3, '4': 2, '5': 8, '10': 'hasBlindedIssuances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_ChartStats$json = {
  '1': 'ChartStats',
  '2': [
    {'1': 'low', '3': 1, '4': 2, '5': 1, '10': 'low'},
    {'1': 'high', '3': 2, '4': 2, '5': 1, '10': 'high'},
    {'1': 'last', '3': 3, '4': 2, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatePriceStream$json = {
  '1': 'UpdatePriceStream',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
    {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    {'1': 'error_msg', '3': 6, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LocalMessage$json = {
  '1': 'LocalMessage',
  '2': [
    {'1': 'title', '3': 1, '4': 2, '5': 9, '10': 'title'},
    {'1': 'body', '3': 2, '4': 2, '5': 9, '10': 'body'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketDataSubscribe$json = {
  '1': 'MarketDataSubscribe',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'data', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'data'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketDataUpdate$json = {
  '1': 'MarketDataUpdate',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'update', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'update'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PortfolioPrices$json = {
  '1': 'PortfolioPrices',
  '2': [
    {'1': 'prices_usd', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.PortfolioPrices.PricesUsdEntry', '10': 'pricesUsd'},
  ],
  '3': [From_PortfolioPrices_PricesUsdEntry$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PortfolioPrices_PricesUsdEntry$json = {
  '1': 'PricesUsdEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ConversionRates$json = {
  '1': 'ConversionRates',
  '2': [
    {'1': 'usd_conversion_rates', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.ConversionRates.UsdConversionRatesEntry', '10': 'usdConversionRates'},
  ],
  '3': [From_ConversionRates_UsdConversionRatesEntry$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ConversionRates_UsdConversionRatesEntry$json = {
  '1': 'UsdConversionRatesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts$json = {
  '1': 'JadePorts',
  '2': [
    {'1': 'ports', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.JadePorts.Port', '10': 'ports'},
  ],
  '3': [From_JadePorts_Port$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts_Port$json = {
  '1': 'Port',
  '2': [
    {'1': 'jade_id', '3': 1, '4': 2, '5': 9, '10': 'jadeId'},
    {'1': 'port', '3': 2, '4': 2, '5': 9, '10': 'port'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadeStatus$json = {
  '1': 'JadeStatus',
  '2': [
    {'1': 'status', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.From.JadeStatus.Status', '10': 'status'},
  ],
  '4': [From_JadeStatus_Status$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadeStatus_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'CONNECTING', '2': 9},
    {'1': 'IDLE', '2': 1},
    {'1': 'READ_STATUS', '2': 2},
    {'1': 'AUTH_USER', '2': 3},
    {'1': 'MASTER_BLINDING_KEY', '2': 5},
    {'1': 'SIGN_TX', '2': 4},
    {'1': 'SIGN_SWAP', '2': 8},
    {'1': 'SIGN_SWAP_OUTPUT', '2': 6},
    {'1': 'SIGN_OFFLINE_SWAP', '2': 7},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_GaidStatus$json = {
  '1': 'GaidStatus',
  '2': [
    {'1': 'gaid', '3': 1, '4': 2, '5': 9, '10': 'gaid'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketList$json = {
  '1': 'MarketList',
  '2': [
    {'1': 'markets', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.MarketInfo', '10': 'markets'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PublicOrders$json = {
  '1': 'PublicOrders',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'list', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.PublicOrder', '10': 'list'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OwnOrders$json = {
  '1': 'OwnOrders',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.OwnOrder', '10': 'list'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_MarketPrice$json = {
  '1': 'MarketPrice',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'ind_price', '3': 2, '4': 1, '5': 1, '10': 'indPrice'},
    {'1': 'last_price', '3': 3, '4': 1, '5': 1, '10': 'lastPrice'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderSubmit$json = {
  '1': 'OrderSubmit',
  '2': [
    {'1': 'submit_succeed', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.OwnOrder', '9': 0, '10': 'submitSucceed'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'unregistered_gaid', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderSubmit.UnregisteredGaid', '9': 0, '10': 'unregisteredGaid'},
  ],
  '3': [From_OrderSubmit_UnregisteredGaid$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderSubmit_UnregisteredGaid$json = {
  '1': 'UnregisteredGaid',
  '2': [
    {'1': 'domain_agent', '3': 1, '4': 2, '5': 9, '10': 'domainAgent'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote$json = {
  '1': 'Quote',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'asset_type', '3': 2, '4': 2, '5': 14, '6': '.sideswap.proto.AssetType', '10': 'assetType'},
    {'1': 'amount', '3': 3, '4': 2, '5': 4, '10': 'amount'},
    {'1': 'trade_dir', '3': 4, '4': 2, '5': 14, '6': '.sideswap.proto.TradeDir', '10': 'tradeDir'},
    {'1': 'success', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote.Success', '9': 0, '10': 'success'},
    {'1': 'low_balance', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote.LowBalance', '9': 0, '10': 'lowBalance'},
    {'1': 'error', '3': 12, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'unregistered_gaid', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.From.Quote.UnregisteredGaid', '9': 0, '10': 'unregisteredGaid'},
  ],
  '3': [From_Quote_Success$json, From_Quote_LowBalance$json, From_Quote_UnregisteredGaid$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote_Success$json = {
  '1': 'Success',
  '2': [
    {'1': 'quote_id', '3': 1, '4': 2, '5': 4, '10': 'quoteId'},
    {'1': 'base_amount', '3': 2, '4': 2, '5': 4, '10': 'baseAmount'},
    {'1': 'quote_amount', '3': 3, '4': 2, '5': 4, '10': 'quoteAmount'},
    {'1': 'server_fee', '3': 4, '4': 2, '5': 4, '10': 'serverFee'},
    {'1': 'fixed_fee', '3': 5, '4': 2, '5': 4, '10': 'fixedFee'},
    {'1': 'ttl_milliseconds', '3': 6, '4': 2, '5': 4, '10': 'ttlMilliseconds'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote_LowBalance$json = {
  '1': 'LowBalance',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'required', '3': 2, '4': 2, '5': 4, '10': 'required'},
    {'1': 'available', '3': 3, '4': 2, '5': 4, '10': 'available'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_Quote_UnregisteredGaid$json = {
  '1': 'UnregisteredGaid',
  '2': [
    {'1': 'domain_agent', '3': 1, '4': 2, '5': 9, '10': 'domainAgent'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AcceptQuote$json = {
  '1': 'AcceptQuote',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.AcceptQuote.Success', '9': 0, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '3': [From_AcceptQuote_Success$json],
  '8': [
    {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AcceptQuote_Success$json = {
  '1': 'Success',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ChartsSubscribe$json = {
  '1': 'ChartsSubscribe',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'data', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'data'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ChartsUpdate$json = {
  '1': 'ChartsUpdate',
  '2': [
    {'1': 'asset_pair', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.AssetPair', '10': 'assetPair'},
    {'1': 'update', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.ChartPoint', '10': 'update'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_LoadHistory$json = {
  '1': 'LoadHistory',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.HistoryOrder', '10': 'list'},
    {'1': 'total', '3': 2, '4': 2, '5': 13, '10': 'total'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_HistoryUpdated$json = {
  '1': 'HistoryUpdated',
  '2': [
    {'1': 'order', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.HistoryOrder', '10': 'order'},
    {'1': 'is_new', '3': 2, '4': 2, '5': 8, '10': 'isNew'},
  ],
};

/// Descriptor for `From`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fromDescriptor = $convert.base64Decode(
    'CgRGcm9tEjIKBWxvZ2luGBEgASgLMhouc2lkZXN3YXAucHJvdG8uRnJvbS5Mb2dpbkgAUgVsb2'
    'dpbhIvCgZsb2dvdXQYECABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgZsb2dvdXQSRQoM'
    'ZW52X3NldHRpbmdzGA0gASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5FbnZTZXR0aW5nc0gAUg'
    'tlbnZTZXR0aW5ncxJFCgxyZWdpc3Rlcl9hbXAYCCABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9t'
    'LlJlZ2lzdGVyQW1wSABSC3JlZ2lzdGVyQW1wEkIKC3VwZGF0ZWRfdHhzGAEgASgLMh8uc2lkZX'
    'N3YXAucHJvdG8uRnJvbS5VcGRhdGVkVHhzSABSCnVwZGF0ZWRUeHMSQgoLcmVtb3ZlZF90eHMY'
    'DCABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLlJlbW92ZWRUeHNIAFIKcmVtb3ZlZFR4cxJFCg'
    'x1cGRhdGVkX3BlZ3MYAiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlVwZGF0ZWRQZWdzSABS'
    'C3VwZGF0ZWRQZWdzEjQKCW5ld19hc3NldBgDIAEoCzIVLnNpZGVzd2FwLnByb3RvLkFzc2V0SA'
    'BSCG5ld0Fzc2V0Ej8KCmFtcF9hc3NldHMYCSABKAsyHi5zaWRlc3dhcC5wcm90by5Gcm9tLkFt'
    'cEFzc2V0c0gAUglhbXBBc3NldHMSVQoSdG9rZW5fbWFya2V0X29yZGVyGBIgASgLMiUuc2lkZX'
    'N3YXAucHJvdG8uRnJvbS5Ub2tlbk1hcmtldE9yZGVySABSEHRva2VuTWFya2V0T3JkZXISSwoO'
    'YmFsYW5jZV91cGRhdGUYBCABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9tLkJhbGFuY2VVcGRhdG'
    'VIAFINYmFsYW5jZVVwZGF0ZRJDCg1zZXJ2ZXJfc3RhdHVzGAUgASgLMhwuc2lkZXN3YXAucHJv'
    'dG8uU2VydmVyU3RhdHVzSABSDHNlcnZlclN0YXR1cxJFCgxwcmljZV91cGRhdGUYBiABKAsyIC'
    '5zaWRlc3dhcC5wcm90by5Gcm9tLlByaWNlVXBkYXRlSABSC3ByaWNlVXBkYXRlEjwKDXdhbGxl'
    'dF9sb2FkZWQYByABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgx3YWxsZXRMb2FkZWQSPA'
    'oNc3luY19jb21wbGV0ZRgOIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSDHN5bmNDb21w'
    'bGV0ZRJCCgtlbmNyeXB0X3BpbhgKIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uRW5jcnlwdF'
    'BpbkgAUgplbmNyeXB0UGluEkIKC2RlY3J5cHRfcGluGAsgASgLMh8uc2lkZXN3YXAucHJvdG8u'
    'RnJvbS5EZWNyeXB0UGluSABSCmRlY3J5cHRQaW4SRgoNcGVnaW5fd2FpdF90eBgVIAEoCzIgLn'
    'NpZGVzd2FwLnByb3RvLkZyb20uUGVnaW5XYWl0VHhIAFILcGVnaW5XYWl0VHgSSQoOcGVnX291'
    'dF9hbW91bnQYGCABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLlBlZ091dEFtb3VudEgAUgxwZW'
    'dPdXRBbW91bnQSPgoMc3dhcF9zdWNjZWVkGBYgASgLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJ'
    'dGVtSABSC3N3YXBTdWNjZWVkEiEKC3N3YXBfZmFpbGVkGBcgASgJSABSCnN3YXBGYWlsZWQSRQ'
    'oMcmVjdl9hZGRyZXNzGB4gASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5SZWN2QWRkcmVzc0gA'
    'UgtyZWN2QWRkcmVzcxJPChBjcmVhdGVfdHhfcmVzdWx0GB8gASgLMiMuc2lkZXN3YXAucHJvdG'
    '8uRnJvbS5DcmVhdGVUeFJlc3VsdEgAUg5jcmVhdGVUeFJlc3VsdBJCCgtzZW5kX3Jlc3VsdBgg'
    'IAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uU2VuZFJlc3VsdEgAUgpzZW5kUmVzdWx0EksKDm'
    'JsaW5kZWRfdmFsdWVzGCEgASgLMiIuc2lkZXN3YXAucHJvdG8uRnJvbS5CbGluZGVkVmFsdWVz'
    'SABSDWJsaW5kZWRWYWx1ZXMSPwoKbG9hZF91dHhvcxgjIAEoCzIeLnNpZGVzd2FwLnByb3RvLk'
    'Zyb20uTG9hZFV0eG9zSABSCWxvYWRVdHhvcxJLCg5sb2FkX2FkZHJlc3NlcxgkIAEoCzIiLnNp'
    'ZGVzd2FwLnByb3RvLkZyb20uTG9hZEFkZHJlc3Nlc0gAUg1sb2FkQWRkcmVzc2VzEksKDnJlZ2'
    'lzdGVyX3Bob25lGCggASgLMiIuc2lkZXN3YXAucHJvdG8uRnJvbS5SZWdpc3RlclBob25lSABS'
    'DXJlZ2lzdGVyUGhvbmUSRQoMdmVyaWZ5X3Bob25lGCkgASgLMiAuc2lkZXN3YXAucHJvdG8uRn'
    'JvbS5WZXJpZnlQaG9uZUgAUgt2ZXJpZnlQaG9uZRJGCg11cGxvYWRfYXZhdGFyGCogASgLMh8u'
    'c2lkZXN3YXAucHJvdG8uR2VuZXJpY1Jlc3BvbnNlSABSDHVwbG9hZEF2YXRhchJKCg91cGxvYW'
    'RfY29udGFjdHMYKyABKAsyHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFIOdXBs'
    'b2FkQ29udGFjdHMSQgoPY29udGFjdF9jcmVhdGVkGCwgASgLMhcuc2lkZXN3YXAucHJvdG8uQ2'
    '9udGFjdEgAUg5jb250YWN0Q3JlYXRlZBJOCg9jb250YWN0X3JlbW92ZWQYLSABKAsyIy5zaWRl'
    'c3dhcC5wcm90by5Gcm9tLkNvbnRhY3RSZW1vdmVkSABSDmNvbnRhY3RSZW1vdmVkElUKE2Nvbn'
    'RhY3RfdHJhbnNhY3Rpb24YLiABKAsyIi5zaWRlc3dhcC5wcm90by5Db250YWN0VHJhbnNhY3Rp'
    'b25IAFISY29udGFjdFRyYW5zYWN0aW9uEksKDmFjY291bnRfc3RhdHVzGC8gASgLMiIuc2lkZX'
    'N3YXAucHJvdG8uRnJvbS5BY2NvdW50U3RhdHVzSABSDWFjY291bnRTdGF0dXMSRQoMc2hvd19t'
    'ZXNzYWdlGDIgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5TaG93TWVzc2FnZUgAUgtzaG93TW'
    'Vzc2FnZRJbChJpbnN1ZmZpY2llbnRfZnVuZHMYNyABKAsyKi5zaWRlc3dhcC5wcm90by5Gcm9t'
    'LlNob3dJbnN1ZmZpY2llbnRGdW5kc0gAUhFpbnN1ZmZpY2llbnRGdW5kcxJICg1zdWJtaXRfcm'
    'V2aWV3GDMgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5TdWJtaXRSZXZpZXdIAFIMc3VibWl0'
    'UmV2aWV3EkgKDXN1Ym1pdF9yZXN1bHQYNCABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLlN1Ym'
    '1pdFJlc3VsdEgAUgxzdWJtaXRSZXN1bHQSQAoKZWRpdF9vcmRlchg1IAEoCzIfLnNpZGVzd2Fw'
    'LnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUgllZGl0T3JkZXISRAoMY2FuY2VsX29yZGVyGDYgAS'
    'gLMh8uc2lkZXN3YXAucHJvdG8uR2VuZXJpY1Jlc3BvbnNlSABSC2NhbmNlbE9yZGVyEkIKC3N0'
    'YXJ0X3RpbWVyGDggASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5TdGFydFRpbWVySABSCnN0YX'
    'J0VGltZXISQgoQc2VydmVyX2Nvbm5lY3RlZBg8IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5'
    'SABSD3NlcnZlckNvbm5lY3RlZBJIChNzZXJ2ZXJfZGlzY29ubmVjdGVkGD0gASgLMhUuc2lkZX'
    'N3YXAucHJvdG8uRW1wdHlIAFISc2VydmVyRGlzY29ubmVjdGVkEkgKDW9yZGVyX2NyZWF0ZWQY'
    'PiABKAsyIS5zaWRlc3dhcC5wcm90by5Gcm9tLk9yZGVyQ3JlYXRlZEgAUgxvcmRlckNyZWF0ZW'
    'QSSAoNb3JkZXJfcmVtb3ZlZBg/IAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uT3JkZXJSZW1v'
    'dmVkSABSDG9yZGVyUmVtb3ZlZBJLCg5vcmRlcl9jb21wbGV0ZRhDIAEoCzIiLnNpZGVzd2FwLn'
    'Byb3RvLkZyb20uT3JkZXJDb21wbGV0ZUgAUg1vcmRlckNvbXBsZXRlEkIKC2luZGV4X3ByaWNl'
    'GEAgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5JbmRleFByaWNlSABSCmluZGV4UHJpY2USSA'
    'oNYXNzZXRfZGV0YWlscxhBIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uQXNzZXREZXRhaWxz'
    'SABSDGFzc2V0RGV0YWlscxJYChN1cGRhdGVfcHJpY2Vfc3RyZWFtGEIgASgLMiYuc2lkZXN3YX'
    'AucHJvdG8uRnJvbS5VcGRhdGVQcmljZVN0cmVhbUgAUhF1cGRhdGVQcmljZVN0cmVhbRJICg1s'
    'b2NhbF9tZXNzYWdlGEQgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5Mb2NhbE1lc3NhZ2VIAF'
    'IMbG9jYWxNZXNzYWdlEl4KFW1hcmtldF9kYXRhX3N1YnNjcmliZRhGIAEoCzIoLnNpZGVzd2Fw'
    'LnByb3RvLkZyb20uTWFya2V0RGF0YVN1YnNjcmliZUgAUhNtYXJrZXREYXRhU3Vic2NyaWJlEl'
    'UKEm1hcmtldF9kYXRhX3VwZGF0ZRhHIAEoCzIlLnNpZGVzd2FwLnByb3RvLkZyb20uTWFya2V0'
    'RGF0YVVwZGF0ZUgAUhBtYXJrZXREYXRhVXBkYXRlElEKEHBvcnRmb2xpb19wcmljZXMYSCABKA'
    'syJC5zaWRlc3dhcC5wcm90by5Gcm9tLlBvcnRmb2xpb1ByaWNlc0gAUg9wb3J0Zm9saW9Qcmlj'
    'ZXMSUQoQY29udmVyc2lvbl9yYXRlcxhJIAEoCzIkLnNpZGVzd2FwLnByb3RvLkZyb20uQ29udm'
    'Vyc2lvblJhdGVzSABSD2NvbnZlcnNpb25SYXRlcxI/CgpqYWRlX3BvcnRzGFAgASgLMh4uc2lk'
    'ZXN3YXAucHJvdG8uRnJvbS5KYWRlUG9ydHNIAFIJamFkZVBvcnRzEkIKC2phZGVfc3RhdHVzGF'
    'MgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5KYWRlU3RhdHVzSABSCmphZGVTdGF0dXMSQgoL'
    'Z2FpZF9zdGF0dXMYWyABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLkdhaWRTdGF0dXNIAFIKZ2'
    'FpZFN0YXR1cxJCCgttYXJrZXRfbGlzdBhkIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uTWFy'
    'a2V0TGlzdEgAUgptYXJrZXRMaXN0Ej8KDG1hcmtldF9hZGRlZBhlIAEoCzIaLnNpZGVzd2FwLn'
    'Byb3RvLk1hcmtldEluZm9IAFILbWFya2V0QWRkZWQSQgoObWFya2V0X3JlbW92ZWQYZiABKAsy'
    'GS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaXJIAFINbWFya2V0UmVtb3ZlZBJICg1wdWJsaWNfb3'
    'JkZXJzGGkgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5QdWJsaWNPcmRlcnNIAFIMcHVibGlj'
    'T3JkZXJzEk8KFHB1YmxpY19vcmRlcl9jcmVhdGVkGGogASgLMhsuc2lkZXN3YXAucHJvdG8uUH'
    'VibGljT3JkZXJIAFIScHVibGljT3JkZXJDcmVhdGVkEksKFHB1YmxpY19vcmRlcl9yZW1vdmVk'
    'GGsgASgLMhcuc2lkZXN3YXAucHJvdG8uT3JkZXJJZEgAUhJwdWJsaWNPcmRlclJlbW92ZWQSRQ'
    'oMbWFya2V0X3ByaWNlGG4gASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5NYXJrZXRQcmljZUgA'
    'UgttYXJrZXRQcmljZRI/Cgpvd25fb3JkZXJzGHggASgLMh4uc2lkZXN3YXAucHJvdG8uRnJvbS'
    '5Pd25PcmRlcnNIAFIJb3duT3JkZXJzEkYKEW93bl9vcmRlcl9jcmVhdGVkGHkgASgLMhguc2lk'
    'ZXN3YXAucHJvdG8uT3duT3JkZXJIAFIPb3duT3JkZXJDcmVhdGVkEkUKEW93bl9vcmRlcl9yZW'
    '1vdmVkGHogASgLMhcuc2lkZXN3YXAucHJvdG8uT3JkZXJJZEgAUg9vd25PcmRlclJlbW92ZWQS'
    'RgoMb3JkZXJfc3VibWl0GIIBIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uT3JkZXJTdWJtaX'
    'RIAFILb3JkZXJTdWJtaXQSQQoKb3JkZXJfZWRpdBiDASABKAsyHy5zaWRlc3dhcC5wcm90by5H'
    'ZW5lcmljUmVzcG9uc2VIAFIJb3JkZXJFZGl0EkUKDG9yZGVyX2NhbmNlbBiEASABKAsyHy5zaW'
    'Rlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFILb3JkZXJDYW5jZWwSMwoFcXVvdGUYjAEg'
    'ASgLMhouc2lkZXN3YXAucHJvdG8uRnJvbS5RdW90ZUgAUgVxdW90ZRJGCgxhY2NlcHRfcXVvdG'
    'UYjQEgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5BY2NlcHRRdW90ZUgAUgthY2NlcHRRdW90'
    'ZRJSChBjaGFydHNfc3Vic2NyaWJlGJYBIAEoCzIkLnNpZGVzd2FwLnByb3RvLkZyb20uQ2hhcn'
    'RzU3Vic2NyaWJlSABSD2NoYXJ0c1N1YnNjcmliZRJJCg1jaGFydHNfdXBkYXRlGJcBIAEoCzIh'
    'LnNpZGVzd2FwLnByb3RvLkZyb20uQ2hhcnRzVXBkYXRlSABSDGNoYXJ0c1VwZGF0ZRJGCgxsb2'
    'FkX2hpc3RvcnkYoAEgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5Mb2FkSGlzdG9yeUgAUgts'
    'b2FkSGlzdG9yeRJPCg9oaXN0b3J5X3VwZGF0ZWQYoQEgASgLMiMuc2lkZXN3YXAucHJvdG8uRn'
    'JvbS5IaXN0b3J5VXBkYXRlZEgAUg5oaXN0b3J5VXBkYXRlZBpjCgVMb2dpbhIdCgllcnJvcl9t'
    'c2cYASABKAlIAFIIZXJyb3JNc2cSMQoHc3VjY2VzcxgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLk'
    'VtcHR5SABSB3N1Y2Nlc3NCCAoGcmVzdWx0Gn0KC0VudlNldHRpbmdzEiYKD3BvbGljeV9hc3Nl'
    'dF9pZBgBIAIoCVINcG9saWN5QXNzZXRJZBIiCg11c2R0X2Fzc2V0X2lkGAIgAigJUgt1c2R0QX'
    'NzZXRJZBIiCg1ldXJ4X2Fzc2V0X2lkGAMgAigJUgtldXJ4QXNzZXRJZBroAQoKRW5jcnlwdFBp'
    'bhIWCgVlcnJvchgBIAEoCUgAUgVlcnJvchI6CgRkYXRhGAIgASgLMiQuc2lkZXN3YXAucHJvdG'
    '8uRnJvbS5FbmNyeXB0UGluLkRhdGFIAFIEZGF0YRp8CgREYXRhEhIKBHNhbHQYAiACKAlSBHNh'
    'bHQSJQoOZW5jcnlwdGVkX2RhdGEYAyACKAlSDWVuY3J5cHRlZERhdGESJQoOcGluX2lkZW50aW'
    'ZpZXIYBCACKAlSDXBpbklkZW50aWZpZXISEgoEaG1hYxgFIAEoCVIEaG1hY0IICgZyZXN1bHQa'
    'pAIKCkRlY3J5cHRQaW4SPQoFZXJyb3IYASABKAsyJS5zaWRlc3dhcC5wcm90by5Gcm9tLkRlY3'
    'J5cHRQaW4uRXJyb3JIAFIFZXJyb3ISHAoIbW5lbW9uaWMYAiABKAlIAFIIbW5lbW9uaWMabgoF'
    'RXJyb3ISGwoJZXJyb3JfbXNnGAEgAigJUghlcnJvck1zZxJICgplcnJvcl9jb2RlGAIgAigOMi'
    'kuc2lkZXN3YXAucHJvdG8uRnJvbS5EZWNyeXB0UGluLkVycm9yQ29kZVIJZXJyb3JDb2RlIj8K'
    'CUVycm9yQ29kZRINCglXUk9OR19QSU4QARIRCg1ORVRXT1JLX0VSUk9SEAISEAoMSU5WQUxJRF'
    '9EQVRBEANCCAoGcmVzdWx0Gk8KC1JlZ2lzdGVyQW1wEhcKBmFtcF9pZBgBIAEoCUgAUgVhbXBJ'
    'ZBIdCgllcnJvcl9tc2cYAiABKAlIAFIIZXJyb3JNc2dCCAoGcmVzdWx0GiMKCUFtcEFzc2V0cx'
    'IWCgZhc3NldHMYASADKAlSBmFzc2V0cxovChBUb2tlbk1hcmtldE9yZGVyEhsKCWFzc2V0X2lk'
    'cxgBIAMoCVIIYXNzZXRJZHMaPQoKVXBkYXRlZFR4cxIvCgVpdGVtcxgBIAMoCzIZLnNpZGVzd2'
    'FwLnByb3RvLlRyYW5zSXRlbVIFaXRlbXMaIgoKUmVtb3ZlZFR4cxIUCgV0eGlkcxgBIAMoCVIF'
    'dHhpZHMaWQoLVXBkYXRlZFBlZ3MSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSLwoFaXRlbX'
    'MYAiADKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1SBWl0ZW1zGncKDUJhbGFuY2VVcGRh'
    'dGUSMQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSMw'
    'oIYmFsYW5jZXMYAiADKAsyFy5zaWRlc3dhcC5wcm90by5CYWxhbmNlUghiYWxhbmNlcxpFCgtQ'
    'ZWdpbldhaXRUeBIZCghwZWdfYWRkchgFIAIoCVIHcGVnQWRkchIbCglyZWN2X2FkZHIYBiACKA'
    'lSCHJlY3ZBZGRyGsICCgxQZWdPdXRBbW91bnQSHQoJZXJyb3JfbXNnGAEgASgJSABSCGVycm9y'
    'TXNnEkUKB2Ftb3VudHMYAiABKAsyKS5zaWRlc3dhcC5wcm90by5Gcm9tLlBlZ091dEFtb3VudC'
    '5BbW91bnRzSABSB2Ftb3VudHMawQEKB0Ftb3VudHMSHwoLc2VuZF9hbW91bnQYASACKANSCnNl'
    'bmRBbW91bnQSHwoLcmVjdl9hbW91bnQYAiACKANSCnJlY3ZBbW91bnQSJgoPaXNfc2VuZF9lbn'
    'RlcmVkGAQgAigIUg1pc1NlbmRFbnRlcmVkEhkKCGZlZV9yYXRlGAUgAigBUgdmZWVSYXRlEjEK'
    'B2FjY291bnQYBiACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50QggKBnJlc3'
    'VsdBptCgtSZWN2QWRkcmVzcxIrCgRhZGRyGAEgAigLMhcuc2lkZXN3YXAucHJvdG8uQWRkcmVz'
    'c1IEYWRkchIxCgdhY2NvdW50GAIgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYWNjb3'
    'VudBreAgoJTG9hZFV0eG9zEjEKB2FjY291bnQYASACKAsyFy5zaWRlc3dhcC5wcm90by5BY2Nv'
    'dW50UgdhY2NvdW50EjkKBXV0eG9zGAIgAygLMiMuc2lkZXN3YXAucHJvdG8uRnJvbS5Mb2FkVX'
    'R4b3MuVXR4b1IFdXR4b3MSGwoJZXJyb3JfbXNnGAMgASgJUghlcnJvck1zZxrFAQoEVXR4bxIS'
    'CgR0eGlkGAEgAigJUgR0eGlkEhIKBHZvdXQYAiACKA1SBHZvdXQSGQoIYXNzZXRfaWQYAyACKA'
    'lSB2Fzc2V0SWQSFgoGYW1vdW50GAQgAigEUgZhbW91bnQSGAoHYWRkcmVzcxgFIAIoCVIHYWRk'
    'cmVzcxIfCgtpc19pbnRlcm5hbBgGIAIoCFIKaXNJbnRlcm5hbBInCg9pc19jb25maWRlbnRpYW'
    'wYByACKAhSDmlzQ29uZmlkZW50aWFsGr0CCg1Mb2FkQWRkcmVzc2VzEjEKB2FjY291bnQYASAC'
    'KAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50EkgKCWFkZHJlc3NlcxgCIAMoCz'
    'IqLnNpZGVzd2FwLnByb3RvLkZyb20uTG9hZEFkZHJlc3Nlcy5BZGRyZXNzUglhZGRyZXNzZXMS'
    'GwoJZXJyb3JfbXNnGAMgASgJUghlcnJvck1zZxqRAQoHQWRkcmVzcxIYCgdhZGRyZXNzGAEgAi'
    'gJUgdhZGRyZXNzEjUKFnVuY29uZmlkZW50aWFsX2FkZHJlc3MYBCACKAlSFXVuY29uZmlkZW50'
    'aWFsQWRkcmVzcxIUCgVpbmRleBgCIAIoDVIFaW5kZXgSHwoLaXNfaW50ZXJuYWwYAyACKAhSCm'
    'lzSW50ZXJuYWwadQoOQ3JlYXRlVHhSZXN1bHQSHQoJZXJyb3JfbXNnGAEgASgJSABSCGVycm9y'
    'TXNnEjoKCmNyZWF0ZWRfdHgYAiABKAsyGS5zaWRlc3dhcC5wcm90by5DcmVhdGVkVHhIAFIJY3'
    'JlYXRlZFR4QggKBnJlc3VsdBprCgpTZW5kUmVzdWx0Eh0KCWVycm9yX21zZxgBIAEoCUgAUghl'
    'cnJvck1zZxI0Cgd0eF9pdGVtGAIgASgLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtSABSBn'
    'R4SXRlbUIICgZyZXN1bHQadQoNQmxpbmRlZFZhbHVlcxISCgR0eGlkGAEgAigJUgR0eGlkEh0K'
    'CWVycm9yX21zZxgCIAEoCUgAUghlcnJvck1zZxInCg5ibGluZGVkX3ZhbHVlcxgDIAEoCUgAUg'
    '1ibGluZGVkVmFsdWVzQggKBnJlc3VsdBpHCgtQcmljZVVwZGF0ZRIUCgVhc3NldBgBIAIoCVIF'
    'YXNzZXQSEAoDYmlkGAIgAigBUgNiaWQSEAoDYXNrGAMgAigBUgNhc2saVwoNUmVnaXN0ZXJQaG'
    '9uZRIdCglwaG9uZV9rZXkYASABKAlIAFIIcGhvbmVLZXkSHQoJZXJyb3JfbXNnGAIgASgJSABS'
    'CGVycm9yTXNnQggKBnJlc3VsdBppCgtWZXJpZnlQaG9uZRIxCgdzdWNjZXNzGAEgASgLMhUuc2'
    'lkZXN3YXAucHJvdG8uRW1wdHlIAFIHc3VjY2VzcxIdCgllcnJvcl9tc2cYAiABKAlIAFIIZXJy'
    'b3JNc2dCCAoGcmVzdWx0GiEKC1Nob3dNZXNzYWdlEhIKBHRleHQYASACKAlSBHRleHQabAoVU2'
    'hvd0luc3VmZmljaWVudEZ1bmRzEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhwKCWF2YWls'
    'YWJsZRgCIAIoA1IJYXZhaWxhYmxlEhoKCHJlcXVpcmVkGAMgAigDUghyZXF1aXJlZBrRAwoMU3'
    'VibWl0UmV2aWV3EhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkEhQKBWFzc2V0GAIgAigJUgVh'
    'c3NldBIlCg5iaXRjb2luX2Ftb3VudBgDIAIoA1INYml0Y29pbkFtb3VudBIdCgpzZXJ2ZXJfZm'
    'VlGAggAigDUglzZXJ2ZXJGZWUSIQoMYXNzZXRfYW1vdW50GAQgAigDUgthc3NldEFtb3VudBIU'
    'CgVwcmljZRgFIAIoAVIFcHJpY2USIQoMc2VsbF9iaXRjb2luGAYgAigIUgtzZWxsQml0Y29pbh'
    'I6CgRzdGVwGAcgAigOMiYuc2lkZXN3YXAucHJvdG8uRnJvbS5TdWJtaXRSZXZpZXcuU3RlcFIE'
    'c3RlcBIfCgtpbmRleF9wcmljZRgJIAIoCFIKaW5kZXhQcmljZRIbCglhdXRvX3NpZ24YCyACKA'
    'hSCGF1dG9TaWduEhkKCHR3b19zdGVwGAwgASgIUgd0d29TdGVwEjAKFHR4X2NoYWluaW5nX3Jl'
    'cXVpcmVkGA0gASgIUhJ0eENoYWluaW5nUmVxdWlyZWQiJwoEU3RlcBIKCgZTVUJNSVQQARIJCg'
    'VRVU9URRACEggKBFNJR04QAxrKAgoMU3VibWl0UmVzdWx0Ej4KDnN1Ym1pdF9zdWNjZWVkGAEg'
    'ASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFINc3VibWl0U3VjY2VlZBI+Cgxzd2FwX3N1Y2'
    'NlZWQYAiABKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1IAFILc3dhcFN1Y2NlZWQSFgoF'
    'ZXJyb3IYAyABKAlIAFIFZXJyb3ISYQoRdW5yZWdpc3RlcmVkX2dhaWQYBCABKAsyMi5zaWRlc3'
    'dhcC5wcm90by5Gcm9tLlN1Ym1pdFJlc3VsdC5VbnJlZ2lzdGVyZWRHYWlkSABSEHVucmVnaXN0'
    'ZXJlZEdhaWQaNQoQVW5yZWdpc3RlcmVkR2FpZBIhCgxkb21haW5fYWdlbnQYASACKAlSC2RvbW'
    'FpbkFnZW50QggKBnJlc3VsdBonCgpTdGFydFRpbWVyEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRl'
    'cklkGk0KDE9yZGVyQ3JlYXRlZBIrCgVvcmRlchgBIAIoCzIVLnNpZGVzd2FwLnByb3RvLk9yZG'
    'VyUgVvcmRlchIQCgNuZXcYAiACKAhSA25ldxopCgxPcmRlclJlbW92ZWQSGQoIb3JkZXJfaWQY'
    'ASACKAlSB29yZGVySWQaPgoNT3JkZXJDb21wbGV0ZRIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZX'
    'JJZBISCgR0eGlkGAIgASgJUgR0eGlkGk0KCkluZGV4UHJpY2USGQoIYXNzZXRfaWQYASACKAlS'
    'B2Fzc2V0SWQSEAoDaW5kGAIgASgBUgNpbmQSEgoEbGFzdBgDIAEoAVIEbGFzdBoxCg5Db250YW'
    'N0UmVtb3ZlZBIfCgtjb250YWN0X2tleRgBIAIoCVIKY29udGFjdEtleRovCg1BY2NvdW50U3Rh'
    'dHVzEh4KCnJlZ2lzdGVyZWQYASACKAhSCnJlZ2lzdGVyZWQaywMKDEFzc2V0RGV0YWlscxIZCg'
    'hhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBI9CgVzdGF0cxgCIAEoCzInLnNpZGVzd2FwLnByb3Rv'
    'LkZyb20uQXNzZXREZXRhaWxzLlN0YXRzUgVzdGF0cxIbCgljaGFydF91cmwYAyABKAlSCGNoYX'
    'J0VXJsEk0KC2NoYXJ0X3N0YXRzGAQgASgLMiwuc2lkZXN3YXAucHJvdG8uRnJvbS5Bc3NldERl'
    'dGFpbHMuQ2hhcnRTdGF0c1IKY2hhcnRTdGF0cxqsAQoFU3RhdHMSIwoNaXNzdWVkX2Ftb3VudB'
    'gBIAIoA1IMaXNzdWVkQW1vdW50EiMKDWJ1cm5lZF9hbW91bnQYAiACKANSDGJ1cm5lZEFtb3Vu'
    'dBIlCg5vZmZsaW5lX2Ftb3VudBgEIAIoA1INb2ZmbGluZUFtb3VudBIyChVoYXNfYmxpbmRlZF'
    '9pc3N1YW5jZXMYAyACKAhSE2hhc0JsaW5kZWRJc3N1YW5jZXMaRgoKQ2hhcnRTdGF0cxIQCgNs'
    'b3cYASACKAFSA2xvdxISCgRoaWdoGAIgAigBUgRoaWdoEhIKBGxhc3QYAyACKAFSBGxhc3QayA'
    'EKEVVwZGF0ZVByaWNlU3RyZWFtEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEiMKDXNlbmRf'
    'Yml0Y29pbnMYAiACKAhSDHNlbmRCaXRjb2lucxIfCgtzZW5kX2Ftb3VudBgDIAEoA1IKc2VuZE'
    'Ftb3VudBIfCgtyZWN2X2Ftb3VudBgEIAEoA1IKcmVjdkFtb3VudBIUCgVwcmljZRgFIAEoAVIF'
    'cHJpY2USGwoJZXJyb3JfbXNnGAYgASgJUghlcnJvck1zZxo4CgxMb2NhbE1lc3NhZ2USFAoFdG'
    'l0bGUYASACKAlSBXRpdGxlEhIKBGJvZHkYAiACKAlSBGJvZHkaYAoTTWFya2V0RGF0YVN1YnNj'
    'cmliZRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIuCgRkYXRhGAIgAygLMhouc2lkZXN3YX'
    'AucHJvdG8uQ2hhcnRQb2ludFIEZGF0YRphChBNYXJrZXREYXRhVXBkYXRlEhkKCGFzc2V0X2lk'
    'GAEgAigJUgdhc3NldElkEjIKBnVwZGF0ZRgCIAIoCzIaLnNpZGVzd2FwLnByb3RvLkNoYXJ0UG'
    '9pbnRSBnVwZGF0ZRqjAQoPUG9ydGZvbGlvUHJpY2VzElIKCnByaWNlc191c2QYASADKAsyMy5z'
    'aWRlc3dhcC5wcm90by5Gcm9tLlBvcnRmb2xpb1ByaWNlcy5QcmljZXNVc2RFbnRyeVIJcHJpY2'
    'VzVXNkGjwKDlByaWNlc1VzZEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgB'
    'UgV2YWx1ZToCOAEayAEKD0NvbnZlcnNpb25SYXRlcxJuChR1c2RfY29udmVyc2lvbl9yYXRlcx'
    'gBIAMoCzI8LnNpZGVzd2FwLnByb3RvLkZyb20uQ29udmVyc2lvblJhdGVzLlVzZENvbnZlcnNp'
    'b25SYXRlc0VudHJ5UhJ1c2RDb252ZXJzaW9uUmF0ZXMaRQoXVXNkQ29udmVyc2lvblJhdGVzRW'
    '50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAFSBXZhbHVlOgI4ARp7CglKYWRl'
    'UG9ydHMSOQoFcG9ydHMYASADKAsyIy5zaWRlc3dhcC5wcm90by5Gcm9tLkphZGVQb3J0cy5Qb3'
    'J0UgVwb3J0cxozCgRQb3J0EhcKB2phZGVfaWQYASACKAlSBmphZGVJZBISCgRwb3J0GAIgAigJ'
    'UgRwb3J0GvMBCgpKYWRlU3RhdHVzEj4KBnN0YXR1cxgBIAIoDjImLnNpZGVzd2FwLnByb3RvLk'
    'Zyb20uSmFkZVN0YXR1cy5TdGF0dXNSBnN0YXR1cyKkAQoGU3RhdHVzEg4KCkNPTk5FQ1RJTkcQ'
    'CRIICgRJRExFEAESDwoLUkVBRF9TVEFUVVMQAhINCglBVVRIX1VTRVIQAxIXChNNQVNURVJfQk'
    'xJTkRJTkdfS0VZEAUSCwoHU0lHTl9UWBAEEg0KCVNJR05fU1dBUBAIEhQKEFNJR05fU1dBUF9P'
    'VVRQVVQQBhIVChFTSUdOX09GRkxJTkVfU1dBUBAHGlEKCkdhaWRTdGF0dXMSEgoEZ2FpZBgBIA'
    'IoCVIEZ2FpZBIZCghhc3NldF9pZBgCIAIoCVIHYXNzZXRJZBIUCgVlcnJvchgDIAEoCVIFZXJy'
    'b3IaQgoKTWFya2V0TGlzdBI0CgdtYXJrZXRzGAEgAygLMhouc2lkZXN3YXAucHJvdG8uTWFya2'
    'V0SW5mb1IHbWFya2V0cxp5CgxQdWJsaWNPcmRlcnMSOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNp'
    'ZGVzd2FwLnByb3RvLkFzc2V0UGFpclIJYXNzZXRQYWlyEi8KBGxpc3QYAiADKAsyGy5zaWRlc3'
    'dhcC5wcm90by5QdWJsaWNPcmRlclIEbGlzdBo5CglPd25PcmRlcnMSLAoEbGlzdBgBIAMoCzIY'
    'LnNpZGVzd2FwLnByb3RvLk93bk9yZGVyUgRsaXN0GoMBCgtNYXJrZXRQcmljZRI4Cgphc3NldF'
    '9wYWlyGAEgAigLMhkuc2lkZXN3YXAucHJvdG8uQXNzZXRQYWlyUglhc3NldFBhaXISGwoJaW5k'
    'X3ByaWNlGAIgASgBUghpbmRQcmljZRIdCgpsYXN0X3ByaWNlGAMgASgBUglsYXN0UHJpY2Uaiw'
    'IKC09yZGVyU3VibWl0EkEKDnN1Ym1pdF9zdWNjZWVkGAEgASgLMhguc2lkZXN3YXAucHJvdG8u'
    'T3duT3JkZXJIAFINc3VibWl0U3VjY2VlZBIWCgVlcnJvchgCIAEoCUgAUgVlcnJvchJgChF1bn'
    'JlZ2lzdGVyZWRfZ2FpZBgDIAEoCzIxLnNpZGVzd2FwLnByb3RvLkZyb20uT3JkZXJTdWJtaXQu'
    'VW5yZWdpc3RlcmVkR2FpZEgAUhB1bnJlZ2lzdGVyZWRHYWlkGjUKEFVucmVnaXN0ZXJlZEdhaW'
    'QSIQoMZG9tYWluX2FnZW50GAEgAigJUgtkb21haW5BZ2VudEIICgZyZXN1bHQavgYKBVF1b3Rl'
    'EjgKCmFzc2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaXJSCWFzc2V0UG'
    'FpchI4Cgphc3NldF90eXBlGAIgAigOMhkuc2lkZXN3YXAucHJvdG8uQXNzZXRUeXBlUglhc3Nl'
    'dFR5cGUSFgoGYW1vdW50GAMgAigEUgZhbW91bnQSNQoJdHJhZGVfZGlyGAQgAigOMhguc2lkZX'
    'N3YXAucHJvdG8uVHJhZGVEaXJSCHRyYWRlRGlyEj4KB3N1Y2Nlc3MYCiABKAsyIi5zaWRlc3dh'
    'cC5wcm90by5Gcm9tLlF1b3RlLlN1Y2Nlc3NIAFIHc3VjY2VzcxJICgtsb3dfYmFsYW5jZRgLIA'
    'EoCzIlLnNpZGVzd2FwLnByb3RvLkZyb20uUXVvdGUuTG93QmFsYW5jZUgAUgpsb3dCYWxhbmNl'
    'EhYKBWVycm9yGAwgASgJSABSBWVycm9yEloKEXVucmVnaXN0ZXJlZF9nYWlkGA0gASgLMisuc2'
    'lkZXN3YXAucHJvdG8uRnJvbS5RdW90ZS5VbnJlZ2lzdGVyZWRHYWlkSABSEHVucmVnaXN0ZXJl'
    'ZEdhaWQazwEKB1N1Y2Nlc3MSGQoIcXVvdGVfaWQYASACKARSB3F1b3RlSWQSHwoLYmFzZV9hbW'
    '91bnQYAiACKARSCmJhc2VBbW91bnQSIQoMcXVvdGVfYW1vdW50GAMgAigEUgtxdW90ZUFtb3Vu'
    'dBIdCgpzZXJ2ZXJfZmVlGAQgAigEUglzZXJ2ZXJGZWUSGwoJZml4ZWRfZmVlGAUgAigEUghmaX'
    'hlZEZlZRIpChB0dGxfbWlsbGlzZWNvbmRzGAYgAigEUg90dGxNaWxsaXNlY29uZHMaYQoKTG93'
    'QmFsYW5jZRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIaCghyZXF1aXJlZBgCIAIoBFIIcm'
    'VxdWlyZWQSHAoJYXZhaWxhYmxlGAMgAigEUglhdmFpbGFibGUaNQoQVW5yZWdpc3RlcmVkR2Fp'
    'ZBIhCgxkb21haW5fYWdlbnQYASACKAlSC2RvbWFpbkFnZW50QggKBnJlc3VsdBqUAQoLQWNjZX'
    'B0UXVvdGUSRAoHc3VjY2VzcxgBIAEoCzIoLnNpZGVzd2FwLnByb3RvLkZyb20uQWNjZXB0UXVv'
    'dGUuU3VjY2Vzc0gAUgdzdWNjZXNzEhYKBWVycm9yGAIgASgJSABSBWVycm9yGh0KB1N1Y2Nlc3'
    'MSEgoEdHhpZBgBIAIoCVIEdHhpZEIICgZyZXN1bHQaewoPQ2hhcnRzU3Vic2NyaWJlEjgKCmFz'
    'c2V0X3BhaXIYASACKAsyGS5zaWRlc3dhcC5wcm90by5Bc3NldFBhaXJSCWFzc2V0UGFpchIuCg'
    'RkYXRhGAIgAygLMhouc2lkZXN3YXAucHJvdG8uQ2hhcnRQb2ludFIEZGF0YRp8CgxDaGFydHNV'
    'cGRhdGUSOAoKYXNzZXRfcGFpchgBIAIoCzIZLnNpZGVzd2FwLnByb3RvLkFzc2V0UGFpclIJYX'
    'NzZXRQYWlyEjIKBnVwZGF0ZRgCIAIoCzIaLnNpZGVzd2FwLnByb3RvLkNoYXJ0UG9pbnRSBnVw'
    'ZGF0ZRpVCgtMb2FkSGlzdG9yeRIwCgRsaXN0GAEgAygLMhwuc2lkZXN3YXAucHJvdG8uSGlzdG'
    '9yeU9yZGVyUgRsaXN0EhQKBXRvdGFsGAIgAigNUgV0b3RhbBpbCg5IaXN0b3J5VXBkYXRlZBIy'
    'CgVvcmRlchgBIAIoCzIcLnNpZGVzd2FwLnByb3RvLkhpc3RvcnlPcmRlclIFb3JkZXISFQoGaX'
    'NfbmV3GAIgAigIUgVpc05ld0IFCgNtc2c=');

@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = {
  '1': 'Settings',
  '2': [
    {'1': 'disabled_accounts', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Settings.AccountAsset', '10': 'disabledAccounts'},
  ],
  '3': [Settings_AccountAsset$json],
};

@$core.Deprecated('Use settingsDescriptor instead')
const Settings_AccountAsset$json = {
  '1': 'AccountAsset',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode(
    'CghTZXR0aW5ncxJSChFkaXNhYmxlZF9hY2NvdW50cxgBIAMoCzIlLnNpZGVzd2FwLnByb3RvLl'
    'NldHRpbmdzLkFjY291bnRBc3NldFIQZGlzYWJsZWRBY2NvdW50cxpcCgxBY2NvdW50QXNzZXQS'
    'MQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSGQoIYX'
    'NzZXRfaWQYAiACKAlSB2Fzc2V0SWQ=');

