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
    {'1': 'is_greedy', '3': 4, '4': 1, '5': 8, '10': 'isGreedy'},
  ],
};

/// Descriptor for `AddressAmount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressAmountDescriptor = $convert.base64Decode(
    'Cg1BZGRyZXNzQW1vdW50EhgKB2FkZHJlc3MYASACKAlSB2FkZHJlc3MSFgoGYW1vdW50GAIgAi'
    'gDUgZhbW91bnQSGQoIYXNzZXRfaWQYAyACKAlSB2Fzc2V0SWQSGwoJaXNfZ3JlZWR5GAQgASgI'
    'Ughpc0dyZWVkeQ==');

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
    {'1': 'always_show', '3': 12, '4': 1, '5': 8, '10': 'alwaysShow'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEh'
    'YKBnRpY2tlchgDIAIoCVIGdGlja2VyEhIKBGljb24YBCACKAlSBGljb24SHAoJcHJlY2lzaW9u'
    'GAUgAigNUglwcmVjaXNpb24SIwoNaW5zdGFudF9zd2FwcxgLIAIoCFIMaW5zdGFudFN3YXBzEh'
    '8KC3N3YXBfbWFya2V0GAYgAigIUgpzd2FwTWFya2V0Eh0KCmFtcF9tYXJrZXQYCSACKAhSCWFt'
    'cE1hcmtldBIiCgx1bnJlZ2lzdGVyZWQYCCACKAhSDHVucmVnaXN0ZXJlZBIWCgZkb21haW4YBy'
    'ABKAlSBmRvbWFpbhIhCgxkb21haW5fYWdlbnQYCiABKAlSC2RvbWFpbkFnZW50Eh8KC2Fsd2F5'
    'c19zaG93GAwgASgIUgphbHdheXNTaG93');

@$core.Deprecated('Use txDescriptor instead')
const Tx$json = {
  '1': 'Tx',
  '2': [
    {'1': 'balances', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
    {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'network_fee', '3': 3, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'size', '3': 5, '4': 2, '5': 3, '10': 'size'},
    {'1': 'vsize', '3': 6, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'memo', '3': 4, '4': 2, '5': 9, '10': 'memo'},
    {'1': 'balances_all', '3': 7, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balancesAll'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode(
    'CgJUeBIzCghiYWxhbmNlcxgBIAMoCzIXLnNpZGVzd2FwLnByb3RvLkJhbGFuY2VSCGJhbGFuY2'
    'VzEhIKBHR4aWQYAiACKAlSBHR4aWQSHwoLbmV0d29ya19mZWUYAyACKANSCm5ldHdvcmtGZWUS'
    'EgoEc2l6ZRgFIAIoA1IEc2l6ZRIUCgV2c2l6ZRgGIAIoA1IFdnNpemUSEgoEbWVtbxgEIAIoCV'
    'IEbWVtbxI6CgxiYWxhbmNlc19hbGwYByADKAsyFy5zaWRlc3dhcC5wcm90by5CYWxhbmNlUgti'
    'YWxhbmNlc0FsbA==');

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

@$core.Deprecated('Use createTxDescriptor instead')
const CreateTx$json = {
  '1': 'CreateTx',
  '2': [
    {'1': 'addressees', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
    {'1': 'account', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

/// Descriptor for `CreateTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTxDescriptor = $convert.base64Decode(
    'CghDcmVhdGVUeBI9CgphZGRyZXNzZWVzGAEgAygLMh0uc2lkZXN3YXAucHJvdG8uQWRkcmVzc0'
    'Ftb3VudFIKYWRkcmVzc2VlcxIxCgdhY2NvdW50GAIgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNj'
    'b3VudFIHYWNjb3VudA==');

@$core.Deprecated('Use createdTxDescriptor instead')
const CreatedTx$json = {
  '1': 'CreatedTx',
  '2': [
    {'1': 'req', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.CreateTx', '10': 'req'},
    {'1': 'input_count', '3': 2, '4': 2, '5': 5, '10': 'inputCount'},
    {'1': 'output_count', '3': 3, '4': 2, '5': 5, '10': 'outputCount'},
    {'1': 'size', '3': 4, '4': 2, '5': 3, '10': 'size'},
    {'1': 'vsize', '3': 7, '4': 2, '5': 3, '10': 'vsize'},
    {'1': 'network_fee', '3': 5, '4': 2, '5': 3, '10': 'networkFee'},
    {'1': 'fee_per_byte', '3': 6, '4': 2, '5': 1, '10': 'feePerByte'},
    {'1': 'addressees', '3': 8, '4': 3, '5': 11, '6': '.sideswap.proto.AddressAmount', '10': 'addressees'},
  ],
};

/// Descriptor for `CreatedTx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createdTxDescriptor = $convert.base64Decode(
    'CglDcmVhdGVkVHgSKgoDcmVxGAEgAigLMhguc2lkZXN3YXAucHJvdG8uQ3JlYXRlVHhSA3JlcR'
    'IfCgtpbnB1dF9jb3VudBgCIAIoBVIKaW5wdXRDb3VudBIhCgxvdXRwdXRfY291bnQYAyACKAVS'
    'C291dHB1dENvdW50EhIKBHNpemUYBCACKANSBHNpemUSFAoFdnNpemUYByACKANSBXZzaXplEh'
    '8KC25ldHdvcmtfZmVlGAUgAigDUgpuZXR3b3JrRmVlEiAKDGZlZV9wZXJfYnl0ZRgGIAIoAVIK'
    'ZmVlUGVyQnl0ZRI9CgphZGRyZXNzZWVzGAggAygLMh0uc2lkZXN3YXAucHJvdG8uQWRkcmVzc0'
    'Ftb3VudFIKYWRkcmVzc2Vlcw==');

@$core.Deprecated('Use createPayjoinDescriptor instead')
const CreatePayjoin$json = {
  '1': 'CreatePayjoin',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'addr', '3': 2, '4': 2, '5': 9, '10': 'addr'},
    {'1': 'balance', '3': 3, '4': 2, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balance'},
  ],
};

/// Descriptor for `CreatePayjoin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPayjoinDescriptor = $convert.base64Decode(
    'Cg1DcmVhdGVQYXlqb2luEjEKB2FjY291bnQYASACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW'
    '50UgdhY2NvdW50EhIKBGFkZHIYAiACKAlSBGFkZHISMQoHYmFsYW5jZRgDIAIoCzIXLnNpZGVz'
    'd2FwLnByb3RvLkJhbGFuY2VSB2JhbGFuY2U=');

@$core.Deprecated('Use createdPayjoinDescriptor instead')
const CreatedPayjoin$json = {
  '1': 'CreatedPayjoin',
  '2': [
    {'1': 'req', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.CreatePayjoin', '10': 'req'},
    {'1': 'pset', '3': 2, '4': 2, '5': 9, '10': 'pset'},
    {'1': 'asset_fee', '3': 3, '4': 2, '5': 3, '10': 'assetFee'},
  ],
};

/// Descriptor for `CreatedPayjoin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createdPayjoinDescriptor = $convert.base64Decode(
    'Cg5DcmVhdGVkUGF5am9pbhIvCgNyZXEYASACKAsyHS5zaWRlc3dhcC5wcm90by5DcmVhdGVQYX'
    'lqb2luUgNyZXESEgoEcHNldBgCIAIoCVIEcHNldBIbCglhc3NldF9mZWUYAyACKANSCGFzc2V0'
    'RmVl');

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
    {'1': 'create_payjoin', '3': 15, '4': 1, '5': 11, '6': '.sideswap.proto.CreatePayjoin', '9': 0, '10': 'createPayjoin'},
    {'1': 'send_payjoin', '3': 16, '4': 1, '5': 11, '6': '.sideswap.proto.CreatedPayjoin', '9': 0, '10': 'sendPayjoin'},
    {'1': 'blinded_values', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.To.BlindedValues', '9': 0, '10': 'blindedValues'},
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
    {'1': 'jade_rescan', '3': 71, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'jadeRescan'},
    {'1': 'gaid_status', '3': 81, '4': 1, '5': 11, '6': '.sideswap.proto.To.GaidStatus', '9': 0, '10': 'gaidStatus'},
  ],
  '3': [To_Login$json, To_NetworkSettings$json, To_ProxySettings$json, To_EncryptPin$json, To_DecryptPin$json, To_AppState$json, To_SwapRequest$json, To_PegInRequest$json, To_PegOutAmount$json, To_PegOutRequest$json, To_SetMemo$json, To_SendTx$json, To_BlindedValues$json, To_UpdatePushToken$json, To_RegisterPhone$json, To_VerifyPhone$json, To_UnregisterPhone$json, To_UploadAvatar$json, To_UploadContacts$json, To_SubmitOrder$json, To_LinkOrder$json, To_SubmitDecision$json, To_EditOrder$json, To_CancelOrder$json, To_Subscribe$json, To_SubscribePriceStream$json, To_MarketDataSubscribe$json, To_GaidStatus$json],
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
    {'1': 'send_utxo_updates', '3': 6, '4': 1, '5': 8, '10': 'sendUtxoUpdates'},
    {'1': 'force_auto_sign_maker', '3': 8, '4': 1, '5': 8, '10': 'forceAutoSignMaker'},
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
    'c3dhcC5wcm90by5Uby5TZW5kVHhIAFIGc2VuZFR4EkYKDmNyZWF0ZV9wYXlqb2luGA8gASgLMh'
    '0uc2lkZXN3YXAucHJvdG8uQ3JlYXRlUGF5am9pbkgAUg1jcmVhdGVQYXlqb2luEkMKDHNlbmRf'
    'cGF5am9pbhgQIAEoCzIeLnNpZGVzd2FwLnByb3RvLkNyZWF0ZWRQYXlqb2luSABSC3NlbmRQYX'
    'lqb2luEkkKDmJsaW5kZWRfdmFsdWVzGA4gASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uQmxpbmRl'
    'ZFZhbHVlc0gAUg1ibGluZGVkVmFsdWVzEkMKDHN3YXBfcmVxdWVzdBgUIAEoCzIeLnNpZGVzd2'
    'FwLnByb3RvLlRvLlN3YXBSZXF1ZXN0SABSC3N3YXBSZXF1ZXN0EkcKDnBlZ19pbl9yZXF1ZXN0'
    'GBUgASgLMh8uc2lkZXN3YXAucHJvdG8uVG8uUGVnSW5SZXF1ZXN0SABSDHBlZ0luUmVxdWVzdB'
    'JHCg5wZWdfb3V0X2Ftb3VudBgYIAEoCzIfLnNpZGVzd2FwLnByb3RvLlRvLlBlZ091dEFtb3Vu'
    'dEgAUgxwZWdPdXRBbW91bnQSSgoPcGVnX291dF9yZXF1ZXN0GBYgASgLMiAuc2lkZXN3YXAucH'
    'JvdG8uVG8uUGVnT3V0UmVxdWVzdEgAUg1wZWdPdXRSZXF1ZXN0Ej4KC3N3YXBfYWNjZXB0GBcg'
    'ASgLMhsuc2lkZXN3YXAucHJvdG8uU3dhcERldGFpbHNIAFIKc3dhcEFjY2VwdBJJCg5yZWdpc3'
    'Rlcl9waG9uZRgoIAEoCzIgLnNpZGVzd2FwLnByb3RvLlRvLlJlZ2lzdGVyUGhvbmVIAFINcmVn'
    'aXN0ZXJQaG9uZRJDCgx2ZXJpZnlfcGhvbmUYKSABKAsyHi5zaWRlc3dhcC5wcm90by5Uby5WZX'
    'JpZnlQaG9uZUgAUgt2ZXJpZnlQaG9uZRJPChB1bnJlZ2lzdGVyX3Bob25lGCwgASgLMiIuc2lk'
    'ZXN3YXAucHJvdG8uVG8uVW5yZWdpc3RlclBob25lSABSD3VucmVnaXN0ZXJQaG9uZRJGCg11cG'
    'xvYWRfYXZhdGFyGCogASgLMh8uc2lkZXN3YXAucHJvdG8uVG8uVXBsb2FkQXZhdGFySABSDHVw'
    'bG9hZEF2YXRhchJMCg91cGxvYWRfY29udGFjdHMYKyABKAsyIS5zaWRlc3dhcC5wcm90by5Uby'
    '5VcGxvYWRDb250YWN0c0gAUg51cGxvYWRDb250YWN0cxJDCgxzdWJtaXRfb3JkZXIYMSABKAsy'
    'Hi5zaWRlc3dhcC5wcm90by5Uby5TdWJtaXRPcmRlckgAUgtzdWJtaXRPcmRlchI9CgpsaW5rX2'
    '9yZGVyGDIgASgLMhwuc2lkZXN3YXAucHJvdG8uVG8uTGlua09yZGVySABSCWxpbmtPcmRlchJM'
    'Cg9zdWJtaXRfZGVjaXNpb24YMyABKAsyIS5zaWRlc3dhcC5wcm90by5Uby5TdWJtaXREZWNpc2'
    'lvbkgAUg5zdWJtaXREZWNpc2lvbhI9CgplZGl0X29yZGVyGDQgASgLMhwuc2lkZXN3YXAucHJv'
    'dG8uVG8uRWRpdE9yZGVySABSCWVkaXRPcmRlchJDCgxjYW5jZWxfb3JkZXIYNSABKAsyHi5zaW'
    'Rlc3dhcC5wcm90by5Uby5DYW5jZWxPcmRlckgAUgtjYW5jZWxPcmRlchI8CglzdWJzY3JpYmUY'
    'NiABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5TdWJzY3JpYmVIAFIJc3Vic2NyaWJlEj4KDWFzc2'
    'V0X2RldGFpbHMYOSABKAsyFy5zaWRlc3dhcC5wcm90by5Bc3NldElkSABSDGFzc2V0RGV0YWls'
    'cxJCCg9zdWJzY3JpYmVfcHJpY2UYNyABKAsyFy5zaWRlc3dhcC5wcm90by5Bc3NldElkSABSDn'
    'N1YnNjcmliZVByaWNlEkYKEXVuc3Vic2NyaWJlX3ByaWNlGDggASgLMhcuc2lkZXN3YXAucHJv'
    'dG8uQXNzZXRJZEgAUhB1bnN1YnNjcmliZVByaWNlEl8KFnN1YnNjcmliZV9wcmljZV9zdHJlYW'
    '0YOiABKAsyJy5zaWRlc3dhcC5wcm90by5Uby5TdWJzY3JpYmVQcmljZVN0cmVhbUgAUhRzdWJz'
    'Y3JpYmVQcmljZVN0cmVhbRJRChh1bnN1YnNjcmliZV9wcmljZV9zdHJlYW0YOyABKAsyFS5zaW'
    'Rlc3dhcC5wcm90by5FbXB0eUgAUhZ1bnN1YnNjcmliZVByaWNlU3RyZWFtElwKFW1hcmtldF9k'
    'YXRhX3N1YnNjcmliZRg8IAEoCzImLnNpZGVzd2FwLnByb3RvLlRvLk1hcmtldERhdGFTdWJzY3'
    'JpYmVIAFITbWFya2V0RGF0YVN1YnNjcmliZRJPChdtYXJrZXRfZGF0YV91bnN1YnNjcmliZRg9'
    'IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSFW1hcmtldERhdGFVbnN1YnNjcmliZRJCCh'
    'Bwb3J0Zm9saW9fcHJpY2VzGD4gASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIPcG9ydGZv'
    'bGlvUHJpY2VzEjgKC2phZGVfcmVzY2FuGEcgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAF'
    'IKamFkZVJlc2NhbhJACgtnYWlkX3N0YXR1cxhRIAEoCzIdLnNpZGVzd2FwLnByb3RvLlRvLkdh'
    'aWRTdGF0dXNIAFIKZ2FpZFN0YXR1cxrGAQoFTG9naW4SHAoIbW5lbW9uaWMYASABKAlIAFIIbW'
    '5lbW9uaWMSGQoHamFkZV9pZBgHIAEoCUgAUgZqYWRlSWQSGwoJcGhvbmVfa2V5GAIgASgJUghw'
    'aG9uZUtleRIqChFzZW5kX3V0eG9fdXBkYXRlcxgGIAEoCFIPc2VuZFV0eG9VcGRhdGVzEjEKFW'
    'ZvcmNlX2F1dG9fc2lnbl9tYWtlchgIIAEoCFISZm9yY2VBdXRvU2lnbk1ha2VyQggKBndhbGxl'
    'dBrXAgoPTmV0d29ya1NldHRpbmdzEjkKC2Jsb2Nrc3RyZWFtGAEgASgLMhUuc2lkZXN3YXAucH'
    'JvdG8uRW1wdHlIAFILYmxvY2tzdHJlYW0SMwoIc2lkZXN3YXAYAiABKAsyFS5zaWRlc3dhcC5w'
    'cm90by5FbXB0eUgAUghzaWRlc3dhcBI4CgtzaWRlc3dhcF9jbhgDIAEoCzIVLnNpZGVzd2FwLn'
    'Byb3RvLkVtcHR5SABSCnNpZGVzd2FwQ24SQwoGY3VzdG9tGAQgASgLMikuc2lkZXN3YXAucHJv'
    'dG8uVG8uTmV0d29ya1NldHRpbmdzLkN1c3RvbUgAUgZjdXN0b20aSQoGQ3VzdG9tEhIKBGhvc3'
    'QYASACKAlSBGhvc3QSEgoEcG9ydBgCIAIoBVIEcG9ydBIXCgd1c2VfdGxzGAMgAigIUgZ1c2VU'
    'bHNCCgoIc2VsZWN0ZWQafgoNUHJveHlTZXR0aW5ncxI8CgVwcm94eRgBIAEoCzImLnNpZGVzd2'
    'FwLnByb3RvLlRvLlByb3h5U2V0dGluZ3MuUHJveHlSBXByb3h5Gi8KBVByb3h5EhIKBGhvc3QY'
    'ASACKAlSBGhvc3QSEgoEcG9ydBgCIAIoBVIEcG9ydBo6CgpFbmNyeXB0UGluEhAKA3BpbhgBIA'
    'IoCVIDcGluEhoKCG1uZW1vbmljGAIgAigJUghtbmVtb25pYxqAAQoKRGVjcnlwdFBpbhIQCgNw'
    'aW4YASACKAlSA3BpbhISCgRzYWx0GAIgAigJUgRzYWx0EiUKDmVuY3J5cHRlZF9kYXRhGAMgAi'
    'gJUg1lbmNyeXB0ZWREYXRhEiUKDnBpbl9pZGVudGlmaWVyGAQgAigJUg1waW5JZGVudGlmaWVy'
    'GiIKCEFwcFN0YXRlEhYKBmFjdGl2ZRgBIAIoCFIGYWN0aXZlGqABCgtTd2FwUmVxdWVzdBIjCg'
    '1zZW5kX2JpdGNvaW5zGAEgAigIUgxzZW5kQml0Y29pbnMSFAoFYXNzZXQYAiACKAlSBWFzc2V0'
    'Eh8KC3NlbmRfYW1vdW50GAMgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAQgAigDUg'
    'pyZWN2QW1vdW50EhQKBXByaWNlGAUgAigBUgVwcmljZRoOCgxQZWdJblJlcXVlc3QanAEKDFBl'
    'Z091dEFtb3VudBIWCgZhbW91bnQYASACKANSBmFtb3VudBImCg9pc19zZW5kX2VudGVyZWQYAi'
    'ACKAhSDWlzU2VuZEVudGVyZWQSGQoIZmVlX3JhdGUYAyACKAFSB2ZlZVJhdGUSMQoHYWNjb3Vu'
    'dBgEIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQa/AEKDVBlZ091dFJlcX'
    'Vlc3QSHwoLc2VuZF9hbW91bnQYASACKANSCnNlbmRBbW91bnQSHwoLcmVjdl9hbW91bnQYAiAC'
    'KANSCnJlY3ZBbW91bnQSJgoPaXNfc2VuZF9lbnRlcmVkGAQgAigIUg1pc1NlbmRFbnRlcmVkEh'
    'kKCGZlZV9yYXRlGAUgAigBUgdmZWVSYXRlEhsKCXJlY3ZfYWRkchgGIAIoCVIIcmVjdkFkZHIS'
    'FgoGYmxvY2tzGAcgAigFUgZibG9ja3MSMQoHYWNjb3VudBgIIAIoCzIXLnNpZGVzd2FwLnByb3'
    'RvLkFjY291bnRSB2FjY291bnQaZAoHU2V0TWVtbxIxCgdhY2NvdW50GAEgAigLMhcuc2lkZXN3'
    'YXAucHJvdG8uQWNjb3VudFIHYWNjb3VudBISCgR0eGlkGAIgAigJUgR0eGlkEhIKBG1lbW8YAy'
    'ACKAlSBG1lbW8aOwoGU2VuZFR4EjEKB2FjY291bnQYASACKAsyFy5zaWRlc3dhcC5wcm90by5B'
    'Y2NvdW50UgdhY2NvdW50GiMKDUJsaW5kZWRWYWx1ZXMSEgoEdHhpZBgBIAIoCVIEdHhpZBonCg'
    '9VcGRhdGVQdXNoVG9rZW4SFAoFdG9rZW4YASACKAlSBXRva2VuGicKDVJlZ2lzdGVyUGhvbmUS'
    'FgoGbnVtYmVyGAEgAigJUgZudW1iZXIaPgoLVmVyaWZ5UGhvbmUSGwoJcGhvbmVfa2V5GAEgAi'
    'gJUghwaG9uZUtleRISCgRjb2RlGAIgAigJUgRjb2RlGi4KD1VucmVnaXN0ZXJQaG9uZRIbCglw'
    'aG9uZV9rZXkYASACKAlSCHBob25lS2V5GkEKDFVwbG9hZEF2YXRhchIbCglwaG9uZV9rZXkYAS'
    'ACKAlSCHBob25lS2V5EhQKBWltYWdlGAIgAigJUgVpbWFnZRpoCg5VcGxvYWRDb250YWN0cxIb'
    'CglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EjkKCGNvbnRhY3RzGAIgAygLMh0uc2lkZXN3YX'
    'AucHJvdG8uVXBsb2FkQ29udGFjdFIIY29udGFjdHMa3AEKC1N1Ym1pdE9yZGVyEjEKB2FjY291'
    'bnQYByACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50EhkKCGFzc2V0X2lkGA'
    'IgAigJUgdhc3NldElkEiUKDmJpdGNvaW5fYW1vdW50GAMgASgBUg1iaXRjb2luQW1vdW50EiEK'
    'DGFzc2V0X2Ftb3VudBgEIAEoAVILYXNzZXRBbW91bnQSFAoFcHJpY2UYBSACKAFSBXByaWNlEh'
    '8KC2luZGV4X3ByaWNlGAYgASgBUgppbmRleFByaWNlGiYKCUxpbmtPcmRlchIZCghvcmRlcl9p'
    'ZBgBIAIoCVIHb3JkZXJJZBqSAgoOU3VibWl0RGVjaXNpb24SGQoIb3JkZXJfaWQYASACKAlSB2'
    '9yZGVySWQSFgoGYWNjZXB0GAIgAigIUgZhY2NlcHQSGwoJYXV0b19zaWduGAMgASgIUghhdXRv'
    'U2lnbhIYCgdwcml2YXRlGAQgASgIUgdwcml2YXRlEhkKCHR3b19zdGVwGAYgASgIUgd0d29TdG'
    'VwEh8KC3R0bF9zZWNvbmRzGAUgASgEUgp0dGxTZWNvbmRzEi4KE3R4X2NoYWluaW5nX2FsbG93'
    'ZWQYByABKAhSEXR4Q2hhaW5pbmdBbGxvd2VkEioKEW9ubHlfdW51c2VkX3V0eG9zGAggASgIUg'
    '9vbmx5VW51c2VkVXR4b3MaiAEKCUVkaXRPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJ'
    'ZBIWCgVwcmljZRgCIAEoAUgAUgVwcmljZRIhCgtpbmRleF9wcmljZRgDIAEoAUgAUgppbmRleF'
    'ByaWNlEh0KCWF1dG9fc2lnbhgEIAEoCEgAUghhdXRvU2lnbkIGCgRkYXRhGigKC0NhbmNlbE9y'
    'ZGVyEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkGm8KCVN1YnNjcmliZRI9CgdtYXJrZXRzGA'
    'EgAygLMiMuc2lkZXN3YXAucHJvdG8uVG8uU3Vic2NyaWJlLk1hcmtldFIHbWFya2V0cxojCgZN'
    'YXJrZXQSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQamAEKFFN1YnNjcmliZVByaWNlU3RyZW'
    'FtEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEiMKDXNlbmRfYml0Y29pbnMYAiACKAhSDHNl'
    'bmRCaXRjb2lucxIfCgtzZW5kX2Ftb3VudBgDIAEoA1IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3'
    'VudBgEIAEoA1IKcmVjdkFtb3VudBowChNNYXJrZXREYXRhU3Vic2NyaWJlEhkKCGFzc2V0X2lk'
    'GAEgAigJUgdhc3NldElkGjsKCkdhaWRTdGF0dXMSEgoEZ2FpZBgBIAIoCVIEZ2FpZBIZCghhc3'
    'NldF9pZBgCIAIoCVIHYXNzZXRJZEIFCgNtc2c=');

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
    {'1': 'utxo_update', '3': 15, '4': 1, '5': 11, '6': '.sideswap.proto.From.UtxoUpdate', '9': 0, '10': 'utxoUpdate'},
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
    {'1': 'create_payjoin_result', '3': 34, '4': 1, '5': 11, '6': '.sideswap.proto.From.CreatePayjoinResult', '9': 0, '10': 'createPayjoinResult'},
    {'1': 'send_result', '3': 32, '4': 1, '5': 11, '6': '.sideswap.proto.From.SendResult', '9': 0, '10': 'sendResult'},
    {'1': 'blinded_values', '3': 33, '4': 1, '5': 11, '6': '.sideswap.proto.From.BlindedValues', '9': 0, '10': 'blindedValues'},
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
    {'1': 'jade_ports', '3': 80, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadePorts', '9': 0, '10': 'jadePorts'},
    {'1': 'jade_status', '3': 83, '4': 1, '5': 11, '6': '.sideswap.proto.From.JadeStatus', '9': 0, '10': 'jadeStatus'},
    {'1': 'gaid_status', '3': 91, '4': 1, '5': 11, '6': '.sideswap.proto.From.GaidStatus', '9': 0, '10': 'gaidStatus'},
  ],
  '3': [From_Login$json, From_EnvSettings$json, From_EncryptPin$json, From_DecryptPin$json, From_RegisterAmp$json, From_AmpAssets$json, From_TokenMarketOrder$json, From_UpdatedTxs$json, From_RemovedTxs$json, From_UpdatedPegs$json, From_BalanceUpdate$json, From_UtxoUpdate$json, From_PeginWaitTx$json, From_PegOutAmount$json, From_RecvAddress$json, From_CreateTxResult$json, From_CreatePayjoinResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_RegisterPhone$json, From_VerifyPhone$json, From_ShowMessage$json, From_ShowInsufficientFunds$json, From_SubmitReview$json, From_SubmitResult$json, From_StartTimer$json, From_OrderCreated$json, From_OrderRemoved$json, From_OrderComplete$json, From_IndexPrice$json, From_ContactRemoved$json, From_AccountStatus$json, From_AssetDetails$json, From_UpdatePriceStream$json, From_LocalMessage$json, From_MarketDataSubscribe$json, From_MarketDataUpdate$json, From_PortfolioPrices$json, From_JadePorts$json, From_JadeStatus$json, From_GaidStatus$json],
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
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin$json = {
  '1': 'DecryptPin',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    {'1': 'mnemonic', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
  ],
  '8': [
    {'1': 'result'},
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
const From_UtxoUpdate$json = {
  '1': 'UtxoUpdate',
  '2': [
    {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    {'1': 'utxos', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.From.UtxoUpdate.Utxo', '10': 'utxos'},
  ],
  '3': [From_UtxoUpdate_Utxo$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UtxoUpdate_Utxo$json = {
  '1': 'Utxo',
  '2': [
    {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    {'1': 'vout', '3': 2, '4': 2, '5': 13, '10': 'vout'},
    {'1': 'asset_id', '3': 3, '4': 2, '5': 9, '10': 'assetId'},
    {'1': 'amount', '3': 4, '4': 2, '5': 4, '10': 'amount'},
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
const From_CreatePayjoinResult$json = {
  '1': 'CreatePayjoinResult',
  '2': [
    {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    {'1': 'created_payjoin', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.CreatedPayjoin', '9': 0, '10': 'createdPayjoin'},
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
const From_JadePorts$json = {
  '1': 'JadePorts',
  '2': [
    {'1': 'ports', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.From.JadePorts.Port', '10': 'ports'},
  ],
  '3': [From_JadePorts_Port$json],
  '4': [From_JadePorts_State$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts_Port$json = {
  '1': 'Port',
  '2': [
    {'1': 'jade_id', '3': 1, '4': 2, '5': 9, '10': 'jadeId'},
    {'1': 'port', '3': 2, '4': 2, '5': 9, '10': 'port'},
    {'1': 'serial', '3': 3, '4': 2, '5': 9, '10': 'serial'},
    {'1': 'version', '3': 4, '4': 2, '5': 9, '10': 'version'},
    {'1': 'state', '3': 5, '4': 2, '5': 14, '6': '.sideswap.proto.From.JadePorts.State', '10': 'state'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_JadePorts_State$json = {
  '1': 'State',
  '2': [
    {'1': 'UNINIT', '2': 0},
    {'1': 'MAIN', '2': 1},
    {'1': 'TEST', '2': 2},
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
    'VIAFINYmFsYW5jZVVwZGF0ZRJCCgt1dHhvX3VwZGF0ZRgPIAEoCzIfLnNpZGVzd2FwLnByb3Rv'
    'LkZyb20uVXR4b1VwZGF0ZUgAUgp1dHhvVXBkYXRlEkMKDXNlcnZlcl9zdGF0dXMYBSABKAsyHC'
    '5zaWRlc3dhcC5wcm90by5TZXJ2ZXJTdGF0dXNIAFIMc2VydmVyU3RhdHVzEkUKDHByaWNlX3Vw'
    'ZGF0ZRgGIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uUHJpY2VVcGRhdGVIAFILcHJpY2VVcG'
    'RhdGUSPAoNd2FsbGV0X2xvYWRlZBgHIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSDHdh'
    'bGxldExvYWRlZBI8Cg1zeW5jX2NvbXBsZXRlGA4gASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdH'
    'lIAFIMc3luY0NvbXBsZXRlEkIKC2VuY3J5cHRfcGluGAogASgLMh8uc2lkZXN3YXAucHJvdG8u'
    'RnJvbS5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQgoLZGVjcnlwdF9waW4YCyABKAsyHy5zaW'
    'Rlc3dhcC5wcm90by5Gcm9tLkRlY3J5cHRQaW5IAFIKZGVjcnlwdFBpbhJGCg1wZWdpbl93YWl0'
    'X3R4GBUgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5QZWdpbldhaXRUeEgAUgtwZWdpbldhaX'
    'RUeBJJCg5wZWdfb3V0X2Ftb3VudBgYIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uUGVnT3V0'
    'QW1vdW50SABSDHBlZ091dEFtb3VudBI+Cgxzd2FwX3N1Y2NlZWQYFiABKAsyGS5zaWRlc3dhcC'
    '5wcm90by5UcmFuc0l0ZW1IAFILc3dhcFN1Y2NlZWQSIQoLc3dhcF9mYWlsZWQYFyABKAlIAFIK'
    'c3dhcEZhaWxlZBJFCgxyZWN2X2FkZHJlc3MYHiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLl'
    'JlY3ZBZGRyZXNzSABSC3JlY3ZBZGRyZXNzEk8KEGNyZWF0ZV90eF9yZXN1bHQYHyABKAsyIy5z'
    'aWRlc3dhcC5wcm90by5Gcm9tLkNyZWF0ZVR4UmVzdWx0SABSDmNyZWF0ZVR4UmVzdWx0El4KFW'
    'NyZWF0ZV9wYXlqb2luX3Jlc3VsdBgiIAEoCzIoLnNpZGVzd2FwLnByb3RvLkZyb20uQ3JlYXRl'
    'UGF5am9pblJlc3VsdEgAUhNjcmVhdGVQYXlqb2luUmVzdWx0EkIKC3NlbmRfcmVzdWx0GCAgAS'
    'gLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5TZW5kUmVzdWx0SABSCnNlbmRSZXN1bHQSSwoOYmxp'
    'bmRlZF92YWx1ZXMYISABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9tLkJsaW5kZWRWYWx1ZXNIAF'
    'INYmxpbmRlZFZhbHVlcxJLCg5yZWdpc3Rlcl9waG9uZRgoIAEoCzIiLnNpZGVzd2FwLnByb3Rv'
    'LkZyb20uUmVnaXN0ZXJQaG9uZUgAUg1yZWdpc3RlclBob25lEkUKDHZlcmlmeV9waG9uZRgpIA'
    'EoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uVmVyaWZ5UGhvbmVIAFILdmVyaWZ5UGhvbmUSRgoN'
    'dXBsb2FkX2F2YXRhchgqIAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUg'
    'x1cGxvYWRBdmF0YXISSgoPdXBsb2FkX2NvbnRhY3RzGCsgASgLMh8uc2lkZXN3YXAucHJvdG8u'
    'R2VuZXJpY1Jlc3BvbnNlSABSDnVwbG9hZENvbnRhY3RzEkIKD2NvbnRhY3RfY3JlYXRlZBgsIA'
    'EoCzIXLnNpZGVzd2FwLnByb3RvLkNvbnRhY3RIAFIOY29udGFjdENyZWF0ZWQSTgoPY29udGFj'
    'dF9yZW1vdmVkGC0gASgLMiMuc2lkZXN3YXAucHJvdG8uRnJvbS5Db250YWN0UmVtb3ZlZEgAUg'
    '5jb250YWN0UmVtb3ZlZBJVChNjb250YWN0X3RyYW5zYWN0aW9uGC4gASgLMiIuc2lkZXN3YXAu'
    'cHJvdG8uQ29udGFjdFRyYW5zYWN0aW9uSABSEmNvbnRhY3RUcmFuc2FjdGlvbhJLCg5hY2NvdW'
    '50X3N0YXR1cxgvIAEoCzIiLnNpZGVzd2FwLnByb3RvLkZyb20uQWNjb3VudFN0YXR1c0gAUg1h'
    'Y2NvdW50U3RhdHVzEkUKDHNob3dfbWVzc2FnZRgyIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb2'
    '0uU2hvd01lc3NhZ2VIAFILc2hvd01lc3NhZ2USWwoSaW5zdWZmaWNpZW50X2Z1bmRzGDcgASgL'
    'Miouc2lkZXN3YXAucHJvdG8uRnJvbS5TaG93SW5zdWZmaWNpZW50RnVuZHNIAFIRaW5zdWZmaW'
    'NpZW50RnVuZHMSSAoNc3VibWl0X3JldmlldxgzIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20u'
    'U3VibWl0UmV2aWV3SABSDHN1Ym1pdFJldmlldxJICg1zdWJtaXRfcmVzdWx0GDQgASgLMiEuc2'
    'lkZXN3YXAucHJvdG8uRnJvbS5TdWJtaXRSZXN1bHRIAFIMc3VibWl0UmVzdWx0EkAKCmVkaXRf'
    'b3JkZXIYNSABKAsyHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFIJZWRpdE9yZG'
    'VyEkQKDGNhbmNlbF9vcmRlchg2IAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25z'
    'ZUgAUgtjYW5jZWxPcmRlchJCCgtzdGFydF90aW1lchg4IAEoCzIfLnNpZGVzd2FwLnByb3RvLk'
    'Zyb20uU3RhcnRUaW1lckgAUgpzdGFydFRpbWVyEkIKEHNlcnZlcl9jb25uZWN0ZWQYPCABKAsy'
    'FS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg9zZXJ2ZXJDb25uZWN0ZWQSSAoTc2VydmVyX2Rpc2'
    'Nvbm5lY3RlZBg9IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSEnNlcnZlckRpc2Nvbm5l'
    'Y3RlZBJICg1vcmRlcl9jcmVhdGVkGD4gASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5PcmRlck'
    'NyZWF0ZWRIAFIMb3JkZXJDcmVhdGVkEkgKDW9yZGVyX3JlbW92ZWQYPyABKAsyIS5zaWRlc3dh'
    'cC5wcm90by5Gcm9tLk9yZGVyUmVtb3ZlZEgAUgxvcmRlclJlbW92ZWQSSwoOb3JkZXJfY29tcG'
    'xldGUYQyABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9tLk9yZGVyQ29tcGxldGVIAFINb3JkZXJD'
    'b21wbGV0ZRJCCgtpbmRleF9wcmljZRhAIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uSW5kZX'
    'hQcmljZUgAUgppbmRleFByaWNlEkgKDWFzc2V0X2RldGFpbHMYQSABKAsyIS5zaWRlc3dhcC5w'
    'cm90by5Gcm9tLkFzc2V0RGV0YWlsc0gAUgxhc3NldERldGFpbHMSWAoTdXBkYXRlX3ByaWNlX3'
    'N0cmVhbRhCIAEoCzImLnNpZGVzd2FwLnByb3RvLkZyb20uVXBkYXRlUHJpY2VTdHJlYW1IAFIR'
    'dXBkYXRlUHJpY2VTdHJlYW0SSAoNbG9jYWxfbWVzc2FnZRhEIAEoCzIhLnNpZGVzd2FwLnByb3'
    'RvLkZyb20uTG9jYWxNZXNzYWdlSABSDGxvY2FsTWVzc2FnZRJeChVtYXJrZXRfZGF0YV9zdWJz'
    'Y3JpYmUYRiABKAsyKC5zaWRlc3dhcC5wcm90by5Gcm9tLk1hcmtldERhdGFTdWJzY3JpYmVIAF'
    'ITbWFya2V0RGF0YVN1YnNjcmliZRJVChJtYXJrZXRfZGF0YV91cGRhdGUYRyABKAsyJS5zaWRl'
    'c3dhcC5wcm90by5Gcm9tLk1hcmtldERhdGFVcGRhdGVIAFIQbWFya2V0RGF0YVVwZGF0ZRJRCh'
    'Bwb3J0Zm9saW9fcHJpY2VzGEggASgLMiQuc2lkZXN3YXAucHJvdG8uRnJvbS5Qb3J0Zm9saW9Q'
    'cmljZXNIAFIPcG9ydGZvbGlvUHJpY2VzEj8KCmphZGVfcG9ydHMYUCABKAsyHi5zaWRlc3dhcC'
    '5wcm90by5Gcm9tLkphZGVQb3J0c0gAUglqYWRlUG9ydHMSQgoLamFkZV9zdGF0dXMYUyABKAsy'
    'Hy5zaWRlc3dhcC5wcm90by5Gcm9tLkphZGVTdGF0dXNIAFIKamFkZVN0YXR1cxJCCgtnYWlkX3'
    'N0YXR1cxhbIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uR2FpZFN0YXR1c0gAUgpnYWlkU3Rh'
    'dHVzGmMKBUxvZ2luEh0KCWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxIxCgdzdWNjZXNzGA'
    'IgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIHc3VjY2Vzc0IICgZyZXN1bHQafQoLRW52'
    'U2V0dGluZ3MSJgoPcG9saWN5X2Fzc2V0X2lkGAEgAigJUg1wb2xpY3lBc3NldElkEiIKDXVzZH'
    'RfYXNzZXRfaWQYAiACKAlSC3VzZHRBc3NldElkEiIKDWV1cnhfYXNzZXRfaWQYAyACKAlSC2V1'
    'cnhBc3NldElkGtQBCgpFbmNyeXB0UGluEhYKBWVycm9yGAEgASgJSABSBWVycm9yEjoKBGRhdG'
    'EYAiABKAsyJC5zaWRlc3dhcC5wcm90by5Gcm9tLkVuY3J5cHRQaW4uRGF0YUgAUgRkYXRhGmgK'
    'BERhdGESEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbmNyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcn'
    'lwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIoCVINcGluSWRlbnRpZmllckIICgZyZXN1'
    'bHQaTAoKRGVjcnlwdFBpbhIWCgVlcnJvchgBIAEoCUgAUgVlcnJvchIcCghtbmVtb25pYxgCIA'
    'EoCUgAUghtbmVtb25pY0IICgZyZXN1bHQaTwoLUmVnaXN0ZXJBbXASFwoGYW1wX2lkGAEgASgJ'
    'SABSBWFtcElkEh0KCWVycm9yX21zZxgCIAEoCUgAUghlcnJvck1zZ0IICgZyZXN1bHQaIwoJQW'
    '1wQXNzZXRzEhYKBmFzc2V0cxgBIAMoCVIGYXNzZXRzGi8KEFRva2VuTWFya2V0T3JkZXISGwoJ'
    'YXNzZXRfaWRzGAEgAygJUghhc3NldElkcxo9CgpVcGRhdGVkVHhzEi8KBWl0ZW1zGAEgAygLMh'
    'kuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtUgVpdGVtcxoiCgpSZW1vdmVkVHhzEhQKBXR4aWRz'
    'GAEgAygJUgV0eGlkcxpZCgtVcGRhdGVkUGVncxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZB'
    'IvCgVpdGVtcxgCIAMoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbVIFaXRlbXMadwoNQmFs'
    'YW5jZVVwZGF0ZRIxCgdhY2NvdW50GAEgAigLMhcuc2lkZXN3YXAucHJvdG8uQWNjb3VudFIHYW'
    'Njb3VudBIzCghiYWxhbmNlcxgCIAMoCzIXLnNpZGVzd2FwLnByb3RvLkJhbGFuY2VSCGJhbGFu'
    'Y2VzGt4BCgpVdHhvVXBkYXRlEjEKB2FjY291bnQYASACKAsyFy5zaWRlc3dhcC5wcm90by5BY2'
    'NvdW50UgdhY2NvdW50EjoKBXV0eG9zGAIgAygLMiQuc2lkZXN3YXAucHJvdG8uRnJvbS5VdHhv'
    'VXBkYXRlLlV0eG9SBXV0eG9zGmEKBFV0eG8SEgoEdHhpZBgBIAIoCVIEdHhpZBISCgR2b3V0GA'
    'IgAigNUgR2b3V0EhkKCGFzc2V0X2lkGAMgAigJUgdhc3NldElkEhYKBmFtb3VudBgEIAIoBFIG'
    'YW1vdW50GkUKC1BlZ2luV2FpdFR4EhkKCHBlZ19hZGRyGAUgAigJUgdwZWdBZGRyEhsKCXJlY3'
    'ZfYWRkchgGIAIoCVIIcmVjdkFkZHIawgIKDFBlZ091dEFtb3VudBIdCgllcnJvcl9tc2cYASAB'
    'KAlIAFIIZXJyb3JNc2cSRQoHYW1vdW50cxgCIAEoCzIpLnNpZGVzd2FwLnByb3RvLkZyb20uUG'
    'VnT3V0QW1vdW50LkFtb3VudHNIAFIHYW1vdW50cxrBAQoHQW1vdW50cxIfCgtzZW5kX2Ftb3Vu'
    'dBgBIAIoA1IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3VudBgCIAIoA1IKcmVjdkFtb3VudBImCg'
    '9pc19zZW5kX2VudGVyZWQYBCACKAhSDWlzU2VuZEVudGVyZWQSGQoIZmVlX3JhdGUYBSACKAFS'
    'B2ZlZVJhdGUSMQoHYWNjb3VudBgGIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY2'
    '91bnRCCAoGcmVzdWx0Gm0KC1JlY3ZBZGRyZXNzEisKBGFkZHIYASACKAsyFy5zaWRlc3dhcC5w'
    'cm90by5BZGRyZXNzUgRhZGRyEjEKB2FjY291bnQYAiACKAsyFy5zaWRlc3dhcC5wcm90by5BY2'
    'NvdW50UgdhY2NvdW50GnUKDkNyZWF0ZVR4UmVzdWx0Eh0KCWVycm9yX21zZxgBIAEoCUgAUghl'
    'cnJvck1zZxI6CgpjcmVhdGVkX3R4GAIgASgLMhkuc2lkZXN3YXAucHJvdG8uQ3JlYXRlZFR4SA'
    'BSCWNyZWF0ZWRUeEIICgZyZXN1bHQaiQEKE0NyZWF0ZVBheWpvaW5SZXN1bHQSHQoJZXJyb3Jf'
    'bXNnGAEgASgJSABSCGVycm9yTXNnEkkKD2NyZWF0ZWRfcGF5am9pbhgCIAEoCzIeLnNpZGVzd2'
    'FwLnByb3RvLkNyZWF0ZWRQYXlqb2luSABSDmNyZWF0ZWRQYXlqb2luQggKBnJlc3VsdBprCgpT'
    'ZW5kUmVzdWx0Eh0KCWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxI0Cgd0eF9pdGVtGAIgAS'
    'gLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtSABSBnR4SXRlbUIICgZyZXN1bHQadQoNQmxp'
    'bmRlZFZhbHVlcxISCgR0eGlkGAEgAigJUgR0eGlkEh0KCWVycm9yX21zZxgCIAEoCUgAUghlcn'
    'Jvck1zZxInCg5ibGluZGVkX3ZhbHVlcxgDIAEoCUgAUg1ibGluZGVkVmFsdWVzQggKBnJlc3Vs'
    'dBpHCgtQcmljZVVwZGF0ZRIUCgVhc3NldBgBIAIoCVIFYXNzZXQSEAoDYmlkGAIgAigBUgNiaW'
    'QSEAoDYXNrGAMgAigBUgNhc2saVwoNUmVnaXN0ZXJQaG9uZRIdCglwaG9uZV9rZXkYASABKAlI'
    'AFIIcGhvbmVLZXkSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnQggKBnJlc3VsdBppCg'
    'tWZXJpZnlQaG9uZRIxCgdzdWNjZXNzGAEgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIH'
    'c3VjY2VzcxIdCgllcnJvcl9tc2cYAiABKAlIAFIIZXJyb3JNc2dCCAoGcmVzdWx0GiEKC1Nob3'
    'dNZXNzYWdlEhIKBHRleHQYASACKAlSBHRleHQabAoVU2hvd0luc3VmZmljaWVudEZ1bmRzEhkK'
    'CGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhwKCWF2YWlsYWJsZRgCIAIoA1IJYXZhaWxhYmxlEh'
    'oKCHJlcXVpcmVkGAMgAigDUghyZXF1aXJlZBrRAwoMU3VibWl0UmV2aWV3EhkKCG9yZGVyX2lk'
    'GAEgAigJUgdvcmRlcklkEhQKBWFzc2V0GAIgAigJUgVhc3NldBIlCg5iaXRjb2luX2Ftb3VudB'
    'gDIAIoA1INYml0Y29pbkFtb3VudBIdCgpzZXJ2ZXJfZmVlGAggAigDUglzZXJ2ZXJGZWUSIQoM'
    'YXNzZXRfYW1vdW50GAQgAigDUgthc3NldEFtb3VudBIUCgVwcmljZRgFIAIoAVIFcHJpY2USIQ'
    'oMc2VsbF9iaXRjb2luGAYgAigIUgtzZWxsQml0Y29pbhI6CgRzdGVwGAcgAigOMiYuc2lkZXN3'
    'YXAucHJvdG8uRnJvbS5TdWJtaXRSZXZpZXcuU3RlcFIEc3RlcBIfCgtpbmRleF9wcmljZRgJIA'
    'IoCFIKaW5kZXhQcmljZRIbCglhdXRvX3NpZ24YCyACKAhSCGF1dG9TaWduEhkKCHR3b19zdGVw'
    'GAwgASgIUgd0d29TdGVwEjAKFHR4X2NoYWluaW5nX3JlcXVpcmVkGA0gASgIUhJ0eENoYWluaW'
    '5nUmVxdWlyZWQiJwoEU3RlcBIKCgZTVUJNSVQQARIJCgVRVU9URRACEggKBFNJR04QAxrKAgoM'
    'U3VibWl0UmVzdWx0Ej4KDnN1Ym1pdF9zdWNjZWVkGAEgASgLMhUuc2lkZXN3YXAucHJvdG8uRW'
    '1wdHlIAFINc3VibWl0U3VjY2VlZBI+Cgxzd2FwX3N1Y2NlZWQYAiABKAsyGS5zaWRlc3dhcC5w'
    'cm90by5UcmFuc0l0ZW1IAFILc3dhcFN1Y2NlZWQSFgoFZXJyb3IYAyABKAlIAFIFZXJyb3ISYQ'
    'oRdW5yZWdpc3RlcmVkX2dhaWQYBCABKAsyMi5zaWRlc3dhcC5wcm90by5Gcm9tLlN1Ym1pdFJl'
    'c3VsdC5VbnJlZ2lzdGVyZWRHYWlkSABSEHVucmVnaXN0ZXJlZEdhaWQaNQoQVW5yZWdpc3Rlcm'
    'VkR2FpZBIhCgxkb21haW5fYWdlbnQYASACKAlSC2RvbWFpbkFnZW50QggKBnJlc3VsdBonCgpT'
    'dGFydFRpbWVyEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkGk0KDE9yZGVyQ3JlYXRlZBIrCg'
    'VvcmRlchgBIAIoCzIVLnNpZGVzd2FwLnByb3RvLk9yZGVyUgVvcmRlchIQCgNuZXcYAiACKAhS'
    'A25ldxopCgxPcmRlclJlbW92ZWQSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQaPgoNT3JkZX'
    'JDb21wbGV0ZRIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBISCgR0eGlkGAIgASgJUgR0eGlk'
    'Gk0KCkluZGV4UHJpY2USGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSEAoDaW5kGAIgASgBUg'
    'NpbmQSEgoEbGFzdBgDIAEoAVIEbGFzdBoxCg5Db250YWN0UmVtb3ZlZBIfCgtjb250YWN0X2tl'
    'eRgBIAIoCVIKY29udGFjdEtleRovCg1BY2NvdW50U3RhdHVzEh4KCnJlZ2lzdGVyZWQYASACKA'
    'hSCnJlZ2lzdGVyZWQaywMKDEFzc2V0RGV0YWlscxIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJ'
    'ZBI9CgVzdGF0cxgCIAEoCzInLnNpZGVzd2FwLnByb3RvLkZyb20uQXNzZXREZXRhaWxzLlN0YX'
    'RzUgVzdGF0cxIbCgljaGFydF91cmwYAyABKAlSCGNoYXJ0VXJsEk0KC2NoYXJ0X3N0YXRzGAQg'
    'ASgLMiwuc2lkZXN3YXAucHJvdG8uRnJvbS5Bc3NldERldGFpbHMuQ2hhcnRTdGF0c1IKY2hhcn'
    'RTdGF0cxqsAQoFU3RhdHMSIwoNaXNzdWVkX2Ftb3VudBgBIAIoA1IMaXNzdWVkQW1vdW50EiMK'
    'DWJ1cm5lZF9hbW91bnQYAiACKANSDGJ1cm5lZEFtb3VudBIlCg5vZmZsaW5lX2Ftb3VudBgEIA'
    'IoA1INb2ZmbGluZUFtb3VudBIyChVoYXNfYmxpbmRlZF9pc3N1YW5jZXMYAyACKAhSE2hhc0Js'
    'aW5kZWRJc3N1YW5jZXMaRgoKQ2hhcnRTdGF0cxIQCgNsb3cYASACKAFSA2xvdxISCgRoaWdoGA'
    'IgAigBUgRoaWdoEhIKBGxhc3QYAyACKAFSBGxhc3QayAEKEVVwZGF0ZVByaWNlU3RyZWFtEhkK'
    'CGFzc2V0X2lkGAEgAigJUgdhc3NldElkEiMKDXNlbmRfYml0Y29pbnMYAiACKAhSDHNlbmRCaX'
    'Rjb2lucxIfCgtzZW5kX2Ftb3VudBgDIAEoA1IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3VudBgE'
    'IAEoA1IKcmVjdkFtb3VudBIUCgVwcmljZRgFIAEoAVIFcHJpY2USGwoJZXJyb3JfbXNnGAYgAS'
    'gJUghlcnJvck1zZxo4CgxMb2NhbE1lc3NhZ2USFAoFdGl0bGUYASACKAlSBXRpdGxlEhIKBGJv'
    'ZHkYAiACKAlSBGJvZHkaYAoTTWFya2V0RGF0YVN1YnNjcmliZRIZCghhc3NldF9pZBgBIAIoCV'
    'IHYXNzZXRJZBIuCgRkYXRhGAIgAygLMhouc2lkZXN3YXAucHJvdG8uQ2hhcnRQb2ludFIEZGF0'
    'YRphChBNYXJrZXREYXRhVXBkYXRlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEjIKBnVwZG'
    'F0ZRgCIAIoCzIaLnNpZGVzd2FwLnByb3RvLkNoYXJ0UG9pbnRSBnVwZGF0ZRqjAQoPUG9ydGZv'
    'bGlvUHJpY2VzElIKCnByaWNlc191c2QYASADKAsyMy5zaWRlc3dhcC5wcm90by5Gcm9tLlBvcn'
    'Rmb2xpb1ByaWNlcy5QcmljZXNVc2RFbnRyeVIJcHJpY2VzVXNkGjwKDlByaWNlc1VzZEVudHJ5'
    'EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgBUgV2YWx1ZToCOAEakwIKCUphZGVQb3'
    'J0cxI5CgVwb3J0cxgBIAMoCzIjLnNpZGVzd2FwLnByb3RvLkZyb20uSmFkZVBvcnRzLlBvcnRS'
    'BXBvcnRzGqEBCgRQb3J0EhcKB2phZGVfaWQYASACKAlSBmphZGVJZBISCgRwb3J0GAIgAigJUg'
    'Rwb3J0EhYKBnNlcmlhbBgDIAIoCVIGc2VyaWFsEhgKB3ZlcnNpb24YBCACKAlSB3ZlcnNpb24S'
    'OgoFc3RhdGUYBSACKA4yJC5zaWRlc3dhcC5wcm90by5Gcm9tLkphZGVQb3J0cy5TdGF0ZVIFc3'
    'RhdGUiJwoFU3RhdGUSCgoGVU5JTklUEAASCAoETUFJThABEggKBFRFU1QQAhrjAQoKSmFkZVN0'
    'YXR1cxI+CgZzdGF0dXMYASACKA4yJi5zaWRlc3dhcC5wcm90by5Gcm9tLkphZGVTdGF0dXMuU3'
    'RhdHVzUgZzdGF0dXMilAEKBlN0YXR1cxIICgRJRExFEAESDwoLUkVBRF9TVEFUVVMQAhINCglB'
    'VVRIX1VTRVIQAxIXChNNQVNURVJfQkxJTkRJTkdfS0VZEAUSCwoHU0lHTl9UWBAEEg0KCVNJR0'
    '5fU1dBUBAIEhQKEFNJR05fU1dBUF9PVVRQVVQQBhIVChFTSUdOX09GRkxJTkVfU1dBUBAHGlEK'
    'CkdhaWRTdGF0dXMSEgoEZ2FpZBgBIAIoCVIEZ2FpZBIZCghhc3NldF9pZBgCIAIoCVIHYXNzZX'
    'RJZBIUCgVlcnJvchgDIAEoCVIFZXJyb3JCBQoDbXNn');

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

