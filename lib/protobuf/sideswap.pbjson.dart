///
//  Generated code. Do not modify.
//  source: sideswap.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use accountDescriptor instead')
const Account$json = const {
  '1': 'Account',
  '2': const [
    const {'1': 'amp', '3': 1, '4': 2, '5': 8, '10': 'amp'},
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode('CgdBY2NvdW50EhAKA2FtcBgBIAIoCFIDYW1w');
@$core.Deprecated('Use addressDescriptor instead')
const Address$json = const {
  '1': 'Address',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode('CgdBZGRyZXNzEhIKBGFkZHIYASACKAlSBGFkZHI=');
@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = const {
  '1': 'Balance',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode('CgdCYWxhbmNlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhYKBmFtb3VudBgCIAIoA1IGYW1vdW50');
@$core.Deprecated('Use txBalanceDescriptor instead')
const TxBalance$json = const {
  '1': 'TxBalance',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'amount', '3': 2, '4': 2, '5': 3, '10': 'amount'},
    const {'1': 'account', '3': 3, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

/// Descriptor for `TxBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txBalanceDescriptor = $convert.base64Decode('CglUeEJhbGFuY2USGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSFgoGYW1vdW50GAIgAigDUgZhbW91bnQSMQoHYWNjb3VudBgDIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQ=');
@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = const {
  '1': 'Asset',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'ticker', '3': 3, '4': 2, '5': 9, '10': 'ticker'},
    const {'1': 'icon', '3': 4, '4': 2, '5': 9, '10': 'icon'},
    const {'1': 'precision', '3': 5, '4': 2, '5': 13, '10': 'precision'},
    const {'1': 'swap_market', '3': 6, '4': 2, '5': 8, '10': 'swapMarket'},
    const {'1': 'amp_market', '3': 9, '4': 2, '5': 8, '10': 'ampMarket'},
    const {'1': 'unregistered', '3': 8, '4': 2, '5': 8, '10': 'unregistered'},
    const {'1': 'domain', '3': 7, '4': 1, '5': 9, '10': 'domain'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode('CgVBc3NldBIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBISCgRuYW1lGAIgAigJUgRuYW1lEhYKBnRpY2tlchgDIAIoCVIGdGlja2VyEhIKBGljb24YBCACKAlSBGljb24SHAoJcHJlY2lzaW9uGAUgAigNUglwcmVjaXNpb24SHwoLc3dhcF9tYXJrZXQYBiACKAhSCnN3YXBNYXJrZXQSHQoKYW1wX21hcmtldBgJIAIoCFIJYW1wTWFya2V0EiIKDHVucmVnaXN0ZXJlZBgIIAIoCFIMdW5yZWdpc3RlcmVkEhYKBmRvbWFpbhgHIAEoCVIGZG9tYWlu');
@$core.Deprecated('Use txDescriptor instead')
const Tx$json = const {
  '1': 'Tx',
  '2': const [
    const {'1': 'balances', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.TxBalance', '10': 'balances'},
    const {'1': 'txid', '3': 2, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'network_fee', '3': 3, '4': 2, '5': 3, '10': 'networkFee'},
    const {'1': 'memo', '3': 4, '4': 2, '5': 9, '10': 'memo'},
  ],
};

/// Descriptor for `Tx`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List txDescriptor = $convert.base64Decode('CgJUeBI1CghiYWxhbmNlcxgBIAMoCzIZLnNpZGVzd2FwLnByb3RvLlR4QmFsYW5jZVIIYmFsYW5jZXMSEgoEdHhpZBgCIAIoCVIEdHhpZBIfCgtuZXR3b3JrX2ZlZRgDIAIoA1IKbmV0d29ya0ZlZRISCgRtZW1vGAQgAigJUgRtZW1v');
@$core.Deprecated('Use pegDescriptor instead')
const Peg$json = const {
  '1': 'Peg',
  '2': const [
    const {'1': 'is_peg_in', '3': 1, '4': 2, '5': 8, '10': 'isPegIn'},
    const {'1': 'amount_send', '3': 2, '4': 2, '5': 3, '10': 'amountSend'},
    const {'1': 'amount_recv', '3': 3, '4': 2, '5': 3, '10': 'amountRecv'},
    const {'1': 'addr_send', '3': 4, '4': 2, '5': 9, '10': 'addrSend'},
    const {'1': 'addr_recv', '3': 5, '4': 2, '5': 9, '10': 'addrRecv'},
    const {'1': 'txid_send', '3': 6, '4': 2, '5': 9, '10': 'txidSend'},
    const {'1': 'vout_send', '3': 7, '4': 2, '5': 5, '10': 'voutSend'},
    const {'1': 'txid_recv', '3': 8, '4': 1, '5': 9, '10': 'txidRecv'},
  ],
};

/// Descriptor for `Peg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pegDescriptor = $convert.base64Decode('CgNQZWcSGgoJaXNfcGVnX2luGAEgAigIUgdpc1BlZ0luEh8KC2Ftb3VudF9zZW5kGAIgAigDUgphbW91bnRTZW5kEh8KC2Ftb3VudF9yZWN2GAMgAigDUgphbW91bnRSZWN2EhsKCWFkZHJfc2VuZBgEIAIoCVIIYWRkclNlbmQSGwoJYWRkcl9yZWN2GAUgAigJUghhZGRyUmVjdhIbCgl0eGlkX3NlbmQYBiACKAlSCHR4aWRTZW5kEhsKCXZvdXRfc2VuZBgHIAIoBVIIdm91dFNlbmQSGwoJdHhpZF9yZWN2GAggASgJUgh0eGlkUmVjdg==');
@$core.Deprecated('Use confsDescriptor instead')
const Confs$json = const {
  '1': 'Confs',
  '2': const [
    const {'1': 'count', '3': 1, '4': 2, '5': 13, '10': 'count'},
    const {'1': 'total', '3': 2, '4': 2, '5': 13, '10': 'total'},
  ],
};

/// Descriptor for `Confs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confsDescriptor = $convert.base64Decode('CgVDb25mcxIUCgVjb3VudBgBIAIoDVIFY291bnQSFAoFdG90YWwYAiACKA1SBXRvdGFs');
@$core.Deprecated('Use transItemDescriptor instead')
const TransItem$json = const {
  '1': 'TransItem',
  '2': const [
    const {'1': 'id', '3': 1, '4': 2, '5': 9, '10': 'id'},
    const {'1': 'created_at', '3': 2, '4': 2, '5': 3, '10': 'createdAt'},
    const {'1': 'confs', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Confs', '10': 'confs'},
    const {'1': 'tx', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.Tx', '9': 0, '10': 'tx'},
    const {'1': 'peg', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Peg', '9': 0, '10': 'peg'},
  ],
  '8': const [
    const {'1': 'item'},
  ],
};

/// Descriptor for `TransItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transItemDescriptor = $convert.base64Decode('CglUcmFuc0l0ZW0SDgoCaWQYASACKAlSAmlkEh0KCmNyZWF0ZWRfYXQYAiACKANSCWNyZWF0ZWRBdBIrCgVjb25mcxgDIAEoCzIVLnNpZGVzd2FwLnByb3RvLkNvbmZzUgVjb25mcxIkCgJ0eBgKIAEoCzISLnNpZGVzd2FwLnByb3RvLlR4SABSAnR4EicKA3BlZxgLIAEoCzITLnNpZGVzd2FwLnByb3RvLlBlZ0gAUgNwZWdCBgoEaXRlbQ==');
@$core.Deprecated('Use assetIdDescriptor instead')
const AssetId$json = const {
  '1': 'AssetId',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `AssetId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetIdDescriptor = $convert.base64Decode('CgdBc3NldElkEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElk');
@$core.Deprecated('Use genericResponseDescriptor instead')
const GenericResponse$json = const {
  '1': 'GenericResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 2, '5': 8, '10': 'success'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

/// Descriptor for `GenericResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericResponseDescriptor = $convert.base64Decode('Cg9HZW5lcmljUmVzcG9uc2USGAoHc3VjY2VzcxgBIAIoCFIHc3VjY2VzcxIbCgllcnJvcl9tc2cYAiABKAlSCGVycm9yTXNn');
@$core.Deprecated('Use feeRateDescriptor instead')
const FeeRate$json = const {
  '1': 'FeeRate',
  '2': const [
    const {'1': 'blocks', '3': 1, '4': 2, '5': 5, '10': 'blocks'},
    const {'1': 'value', '3': 2, '4': 2, '5': 1, '10': 'value'},
  ],
};

/// Descriptor for `FeeRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feeRateDescriptor = $convert.base64Decode('CgdGZWVSYXRlEhYKBmJsb2NrcxgBIAIoBVIGYmxvY2tzEhQKBXZhbHVlGAIgAigBUgV2YWx1ZQ==');
@$core.Deprecated('Use serverStatusDescriptor instead')
const ServerStatus$json = const {
  '1': 'ServerStatus',
  '2': const [
    const {'1': 'min_peg_in_amount', '3': 1, '4': 2, '5': 3, '10': 'minPegInAmount'},
    const {'1': 'min_peg_out_amount', '3': 2, '4': 2, '5': 3, '10': 'minPegOutAmount'},
    const {'1': 'server_fee_percent_peg_in', '3': 3, '4': 2, '5': 1, '10': 'serverFeePercentPegIn'},
    const {'1': 'server_fee_percent_peg_out', '3': 4, '4': 2, '5': 1, '10': 'serverFeePercentPegOut'},
    const {'1': 'bitcoin_fee_rates', '3': 5, '4': 3, '5': 11, '6': '.sideswap.proto.FeeRate', '10': 'bitcoinFeeRates'},
  ],
};

/// Descriptor for `ServerStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverStatusDescriptor = $convert.base64Decode('CgxTZXJ2ZXJTdGF0dXMSKQoRbWluX3BlZ19pbl9hbW91bnQYASACKANSDm1pblBlZ0luQW1vdW50EisKEm1pbl9wZWdfb3V0X2Ftb3VudBgCIAIoA1IPbWluUGVnT3V0QW1vdW50EjgKGXNlcnZlcl9mZWVfcGVyY2VudF9wZWdfaW4YAyACKAFSFXNlcnZlckZlZVBlcmNlbnRQZWdJbhI6ChpzZXJ2ZXJfZmVlX3BlcmNlbnRfcGVnX291dBgEIAIoAVIWc2VydmVyRmVlUGVyY2VudFBlZ091dBJDChFiaXRjb2luX2ZlZV9yYXRlcxgFIAMoCzIXLnNpZGVzd2FwLnByb3RvLkZlZVJhdGVSD2JpdGNvaW5GZWVSYXRlcw==');
@$core.Deprecated('Use uploadContactDescriptor instead')
const UploadContact$json = const {
  '1': 'UploadContact',
  '2': const [
    const {'1': 'identifier', '3': 1, '4': 2, '5': 9, '10': 'identifier'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'phones', '3': 3, '4': 3, '5': 9, '10': 'phones'},
  ],
};

/// Descriptor for `UploadContact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadContactDescriptor = $convert.base64Decode('Cg1VcGxvYWRDb250YWN0Eh4KCmlkZW50aWZpZXIYASACKAlSCmlkZW50aWZpZXISEgoEbmFtZRgCIAIoCVIEbmFtZRIWCgZwaG9uZXMYAyADKAlSBnBob25lcw==');
@$core.Deprecated('Use contactDescriptor instead')
const Contact$json = const {
  '1': 'Contact',
  '2': const [
    const {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
    const {'1': 'name', '3': 2, '4': 2, '5': 9, '10': 'name'},
    const {'1': 'phone', '3': 3, '4': 2, '5': 9, '10': 'phone'},
  ],
};

/// Descriptor for `Contact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactDescriptor = $convert.base64Decode('CgdDb250YWN0Eh8KC2NvbnRhY3Rfa2V5GAEgAigJUgpjb250YWN0S2V5EhIKBG5hbWUYAiACKAlSBG5hbWUSFAoFcGhvbmUYAyACKAlSBXBob25l');
@$core.Deprecated('Use contactTransactionDescriptor instead')
const ContactTransaction$json = const {
  '1': 'ContactTransaction',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'contact_key', '3': 2, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

/// Descriptor for `ContactTransaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactTransactionDescriptor = $convert.base64Decode('ChJDb250YWN0VHJhbnNhY3Rpb24SEgoEdHhpZBgBIAIoCVIEdHhpZBIfCgtjb250YWN0X2tleRgCIAIoCVIKY29udGFjdEtleQ==');
@$core.Deprecated('Use orderDescriptor instead')
const Order$json = const {
  '1': 'Order',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    const {'1': 'send_bitcoins', '3': 10, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'server_fee', '3': 4, '4': 2, '5': 3, '10': 'serverFee'},
    const {'1': 'asset_amount', '3': 5, '4': 2, '5': 3, '10': 'assetAmount'},
    const {'1': 'price', '3': 6, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'created_at', '3': 7, '4': 2, '5': 3, '10': 'createdAt'},
    const {'1': 'expires_at', '3': 8, '4': 2, '5': 3, '10': 'expiresAt'},
    const {'1': 'private', '3': 9, '4': 2, '5': 8, '10': 'private'},
    const {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
    const {'1': 'own', '3': 12, '4': 2, '5': 8, '10': 'own'},
    const {'1': 'from_notification', '3': 13, '4': 2, '5': 8, '10': 'fromNotification'},
    const {'1': 'index_price', '3': 15, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode('CgVPcmRlchIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIZCghhc3NldF9pZBgCIAIoCVIHYXNzZXRJZBIlCg5iaXRjb2luX2Ftb3VudBgDIAIoA1INYml0Y29pbkFtb3VudBIjCg1zZW5kX2JpdGNvaW5zGAogAigIUgxzZW5kQml0Y29pbnMSHQoKc2VydmVyX2ZlZRgEIAIoA1IJc2VydmVyRmVlEiEKDGFzc2V0X2Ftb3VudBgFIAIoA1ILYXNzZXRBbW91bnQSFAoFcHJpY2UYBiACKAFSBXByaWNlEh0KCmNyZWF0ZWRfYXQYByACKANSCWNyZWF0ZWRBdBIdCgpleHBpcmVzX2F0GAggAigDUglleHBpcmVzQXQSGAoHcHJpdmF0ZRgJIAIoCFIHcHJpdmF0ZRIbCglhdXRvX3NpZ24YCyACKAhSCGF1dG9TaWduEhAKA293bhgMIAIoCFIDb3duEisKEWZyb21fbm90aWZpY2F0aW9uGA0gAigIUhBmcm9tTm90aWZpY2F0aW9uEh8KC2luZGV4X3ByaWNlGA8gASgBUgppbmRleFByaWNl');
@$core.Deprecated('Use swapDetailsDescriptor instead')
const SwapDetails$json = const {
  '1': 'SwapDetails',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'send_asset', '3': 2, '4': 2, '5': 9, '10': 'sendAsset'},
    const {'1': 'recv_asset', '3': 3, '4': 2, '5': 9, '10': 'recvAsset'},
    const {'1': 'send_amount', '3': 4, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 5, '4': 2, '5': 3, '10': 'recvAmount'},
    const {'1': 'upload_url', '3': 6, '4': 2, '5': 9, '10': 'uploadUrl'},
  ],
};

/// Descriptor for `SwapDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swapDetailsDescriptor = $convert.base64Decode('CgtTd2FwRGV0YWlscxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIdCgpzZW5kX2Fzc2V0GAIgAigJUglzZW5kQXNzZXQSHQoKcmVjdl9hc3NldBgDIAIoCVIJcmVjdkFzc2V0Eh8KC3NlbmRfYW1vdW50GAQgAigDUgpzZW5kQW1vdW50Eh8KC3JlY3ZfYW1vdW50GAUgAigDUgpyZWN2QW1vdW50Eh0KCnVwbG9hZF91cmwYBiACKAlSCXVwbG9hZFVybA==');
@$core.Deprecated('Use networkSettingsDescriptor instead')
const NetworkSettings$json = const {
  '1': 'NetworkSettings',
  '2': const [
    const {'1': 'blockstream', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'blockstream'},
    const {'1': 'custom', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.NetworkSettings.Custom', '9': 0, '10': 'custom'},
  ],
  '3': const [NetworkSettings_Custom$json],
  '8': const [
    const {'1': 'selected'},
  ],
};

@$core.Deprecated('Use networkSettingsDescriptor instead')
const NetworkSettings_Custom$json = const {
  '1': 'Custom',
  '2': const [
    const {'1': 'host', '3': 1, '4': 2, '5': 9, '10': 'host'},
    const {'1': 'port', '3': 2, '4': 2, '5': 5, '10': 'port'},
    const {'1': 'use_tls', '3': 3, '4': 2, '5': 8, '10': 'useTls'},
  ],
};

/// Descriptor for `NetworkSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List networkSettingsDescriptor = $convert.base64Decode('Cg9OZXR3b3JrU2V0dGluZ3MSOQoLYmxvY2tzdHJlYW0YASABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUgtibG9ja3N0cmVhbRJACgZjdXN0b20YAiABKAsyJi5zaWRlc3dhcC5wcm90by5OZXR3b3JrU2V0dGluZ3MuQ3VzdG9tSABSBmN1c3RvbRpJCgZDdXN0b20SEgoEaG9zdBgBIAIoCVIEaG9zdBISCgRwb3J0GAIgAigFUgRwb3J0EhcKB3VzZV90bHMYAyACKAhSBnVzZVRsc0IKCghzZWxlY3RlZA==');
@$core.Deprecated('Use toDescriptor instead')
const To$json = const {
  '1': 'To',
  '2': const [
    const {'1': 'login', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.To.Login', '9': 0, '10': 'login'},
    const {'1': 'logout', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'logout'},
    const {'1': 'change_network', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.To.ChangeNetwork', '9': 0, '10': 'changeNetwork'},
    const {'1': 'update_push_token', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.To.UpdatePushToken', '9': 0, '10': 'updatePushToken'},
    const {'1': 'encrypt_pin', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.To.EncryptPin', '9': 0, '10': 'encryptPin'},
    const {'1': 'decrypt_pin', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.To.DecryptPin', '9': 0, '10': 'decryptPin'},
    const {'1': 'push_message', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'pushMessage'},
    const {'1': 'app_state', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.To.AppState', '9': 0, '10': 'appState'},
    const {'1': 'set_memo', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.To.SetMemo', '9': 0, '10': 'setMemo'},
    const {'1': 'get_recv_address', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.Account', '9': 0, '10': 'getRecvAddress'},
    const {'1': 'create_tx', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.To.CreateTx', '9': 0, '10': 'createTx'},
    const {'1': 'send_tx', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.To.SendTx', '9': 0, '10': 'sendTx'},
    const {'1': 'blinded_values', '3': 14, '4': 1, '5': 11, '6': '.sideswap.proto.To.BlindedValues', '9': 0, '10': 'blindedValues'},
    const {'1': 'swap_request', '3': 20, '4': 1, '5': 11, '6': '.sideswap.proto.To.SwapRequest', '9': 0, '10': 'swapRequest'},
    const {'1': 'peg_in_request', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegInRequest', '9': 0, '10': 'pegInRequest'},
    const {'1': 'peg_out_request', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.To.PegOutRequest', '9': 0, '10': 'pegOutRequest'},
    const {'1': 'swap_accept', '3': 23, '4': 1, '5': 11, '6': '.sideswap.proto.SwapDetails', '9': 0, '10': 'swapAccept'},
    const {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.To.RegisterPhone', '9': 0, '10': 'registerPhone'},
    const {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.To.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    const {'1': 'unregister_phone', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.To.UnregisterPhone', '9': 0, '10': 'unregisterPhone'},
    const {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadAvatar', '9': 0, '10': 'uploadAvatar'},
    const {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.To.UploadContacts', '9': 0, '10': 'uploadContacts'},
    const {'1': 'submit_order', '3': 49, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitOrder', '9': 0, '10': 'submitOrder'},
    const {'1': 'link_order', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.To.LinkOrder', '9': 0, '10': 'linkOrder'},
    const {'1': 'submit_decision', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubmitDecision', '9': 0, '10': 'submitDecision'},
    const {'1': 'edit_order', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.To.EditOrder', '9': 0, '10': 'editOrder'},
    const {'1': 'cancel_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.To.CancelOrder', '9': 0, '10': 'cancelOrder'},
    const {'1': 'subscribe', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.To.Subscribe', '9': 0, '10': 'subscribe'},
    const {'1': 'asset_details', '3': 57, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'assetDetails'},
    const {'1': 'subscribe_price', '3': 55, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'subscribePrice'},
    const {'1': 'unsubscribe_price', '3': 56, '4': 1, '5': 11, '6': '.sideswap.proto.AssetId', '9': 0, '10': 'unsubscribePrice'},
    const {'1': 'subscribe_price_stream', '3': 58, '4': 1, '5': 11, '6': '.sideswap.proto.To.SubscribePriceStream', '9': 0, '10': 'subscribePriceStream'},
    const {'1': 'unsubscribe_price_stream', '3': 59, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'unsubscribePriceStream'},
  ],
  '3': const [To_Login$json, To_ChangeNetwork$json, To_EncryptPin$json, To_DecryptPin$json, To_AppState$json, To_SwapRequest$json, To_PegInRequest$json, To_PegOutRequest$json, To_SetMemo$json, To_CreateTx$json, To_SendTx$json, To_BlindedValues$json, To_UpdatePushToken$json, To_RegisterPhone$json, To_VerifyPhone$json, To_UnregisterPhone$json, To_UploadAvatar$json, To_UploadContacts$json, To_SubmitOrder$json, To_LinkOrder$json, To_SubmitDecision$json, To_EditOrder$json, To_CancelOrder$json, To_Subscribe$json, To_SubscribePriceStream$json],
  '8': const [
    const {'1': 'msg'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Login$json = const {
  '1': 'Login',
  '2': const [
    const {'1': 'mnemonic', '3': 1, '4': 2, '5': 9, '10': 'mnemonic'},
    const {'1': 'phone_key', '3': 2, '4': 1, '5': 9, '10': 'phoneKey'},
    const {'1': 'network', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.NetworkSettings', '10': 'network'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_ChangeNetwork$json = const {
  '1': 'ChangeNetwork',
  '2': const [
    const {'1': 'network', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.NetworkSettings', '10': 'network'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EncryptPin$json = const {
  '1': 'EncryptPin',
  '2': const [
    const {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    const {'1': 'mnemonic', '3': 2, '4': 2, '5': 9, '10': 'mnemonic'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_DecryptPin$json = const {
  '1': 'DecryptPin',
  '2': const [
    const {'1': 'pin', '3': 1, '4': 2, '5': 9, '10': 'pin'},
    const {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    const {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    const {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_AppState$json = const {
  '1': 'AppState',
  '2': const [
    const {'1': 'active', '3': 1, '4': 2, '5': 8, '10': 'active'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SwapRequest$json = const {
  '1': 'SwapRequest',
  '2': const [
    const {'1': 'send_bitcoins', '3': 1, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    const {'1': 'send_amount', '3': 3, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 4, '4': 2, '5': 3, '10': 'recvAmount'},
    const {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegInRequest$json = const {
  '1': 'PegInRequest',
};

@$core.Deprecated('Use toDescriptor instead')
const To_PegOutRequest$json = const {
  '1': 'PegOutRequest',
  '2': const [
    const {'1': 'send_amount', '3': 1, '4': 2, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_addr', '3': 2, '4': 2, '5': 9, '10': 'recvAddr'},
    const {'1': 'blocks', '3': 3, '4': 2, '5': 5, '10': 'blocks'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SetMemo$json = const {
  '1': 'SetMemo',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'memo', '3': 2, '4': 2, '5': 9, '10': 'memo'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_CreateTx$json = const {
  '1': 'CreateTx',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 9, '10': 'addr'},
    const {'1': 'balance', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balance'},
    const {'1': 'is_contact', '3': 3, '4': 2, '5': 8, '10': 'isContact'},
    const {'1': 'account', '3': 4, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SendTx$json = const {
  '1': 'SendTx',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_BlindedValues$json = const {
  '1': 'BlindedValues',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UpdatePushToken$json = const {
  '1': 'UpdatePushToken',
  '2': const [
    const {'1': 'token', '3': 1, '4': 2, '5': 9, '10': 'token'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_RegisterPhone$json = const {
  '1': 'RegisterPhone',
  '2': const [
    const {'1': 'number', '3': 1, '4': 2, '5': 9, '10': 'number'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_VerifyPhone$json = const {
  '1': 'VerifyPhone',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    const {'1': 'code', '3': 2, '4': 2, '5': 9, '10': 'code'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UnregisterPhone$json = const {
  '1': 'UnregisterPhone',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadAvatar$json = const {
  '1': 'UploadAvatar',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    const {'1': 'image', '3': 2, '4': 2, '5': 9, '10': 'image'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_UploadContacts$json = const {
  '1': 'UploadContacts',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 2, '5': 9, '10': 'phoneKey'},
    const {'1': 'contacts', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.UploadContact', '10': 'contacts'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitOrder$json = const {
  '1': 'SubmitOrder',
  '2': const [
    const {'1': 'account', '3': 7, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'bitcoin_amount', '3': 3, '4': 1, '5': 1, '10': 'bitcoinAmount'},
    const {'1': 'asset_amount', '3': 4, '4': 1, '5': 1, '10': 'assetAmount'},
    const {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'index_price', '3': 6, '4': 1, '5': 1, '10': 'indexPrice'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_LinkOrder$json = const {
  '1': 'LinkOrder',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubmitDecision$json = const {
  '1': 'SubmitDecision',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'accept', '3': 2, '4': 2, '5': 8, '10': 'accept'},
    const {'1': 'auto_sign', '3': 3, '4': 1, '5': 8, '10': 'autoSign'},
    const {'1': 'private', '3': 4, '4': 1, '5': 8, '10': 'private'},
    const {'1': 'ttl_seconds', '3': 5, '4': 1, '5': 4, '10': 'ttlSeconds'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_EditOrder$json = const {
  '1': 'EditOrder',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'price', '3': 2, '4': 1, '5': 1, '9': 0, '10': 'price'},
    const {'1': 'index_price', '3': 3, '4': 1, '5': 1, '9': 0, '10': 'indexPrice'},
    const {'1': 'auto_sign', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'autoSign'},
  ],
  '8': const [
    const {'1': 'data'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_CancelOrder$json = const {
  '1': 'CancelOrder',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe$json = const {
  '1': 'Subscribe',
  '2': const [
    const {'1': 'market', '3': 1, '4': 2, '5': 14, '6': '.sideswap.proto.To.Subscribe.Market', '10': 'market'},
    const {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
  ],
  '4': const [To_Subscribe_Market$json],
};

@$core.Deprecated('Use toDescriptor instead')
const To_Subscribe_Market$json = const {
  '1': 'Market',
  '2': const [
    const {'1': 'NONE', '2': 0},
    const {'1': 'TOKENS', '2': 1},
    const {'1': 'ASSET', '2': 2},
  ],
};

@$core.Deprecated('Use toDescriptor instead')
const To_SubscribePriceStream$json = const {
  '1': 'SubscribePriceStream',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
  ],
};

/// Descriptor for `To`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toDescriptor = $convert.base64Decode('CgJUbxIwCgVsb2dpbhgBIAEoCzIYLnNpZGVzd2FwLnByb3RvLlRvLkxvZ2luSABSBWxvZ2luEi8KBmxvZ291dBgCIAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSBmxvZ291dBJJCg5jaGFuZ2VfbmV0d29yaxgJIAEoCzIgLnNpZGVzd2FwLnByb3RvLlRvLkNoYW5nZU5ldHdvcmtIAFINY2hhbmdlTmV0d29yaxJQChF1cGRhdGVfcHVzaF90b2tlbhgDIAEoCzIiLnNpZGVzd2FwLnByb3RvLlRvLlVwZGF0ZVB1c2hUb2tlbkgAUg91cGRhdGVQdXNoVG9rZW4SQAoLZW5jcnlwdF9waW4YBCABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQAoLZGVjcnlwdF9waW4YBSABKAsyHS5zaWRlc3dhcC5wcm90by5Uby5EZWNyeXB0UGluSABSCmRlY3J5cHRQaW4SIwoMcHVzaF9tZXNzYWdlGAYgASgJSABSC3B1c2hNZXNzYWdlEjoKCWFwcF9zdGF0ZRgIIAEoCzIbLnNpZGVzd2FwLnByb3RvLlRvLkFwcFN0YXRlSABSCGFwcFN0YXRlEjcKCHNldF9tZW1vGAogASgLMhouc2lkZXN3YXAucHJvdG8uVG8uU2V0TWVtb0gAUgdzZXRNZW1vEkMKEGdldF9yZWN2X2FkZHJlc3MYCyABKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50SABSDmdldFJlY3ZBZGRyZXNzEjoKCWNyZWF0ZV90eBgMIAEoCzIbLnNpZGVzd2FwLnByb3RvLlRvLkNyZWF0ZVR4SABSCGNyZWF0ZVR4EjQKB3NlbmRfdHgYDSABKAsyGS5zaWRlc3dhcC5wcm90by5Uby5TZW5kVHhIAFIGc2VuZFR4EkkKDmJsaW5kZWRfdmFsdWVzGA4gASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uQmxpbmRlZFZhbHVlc0gAUg1ibGluZGVkVmFsdWVzEkMKDHN3YXBfcmVxdWVzdBgUIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlN3YXBSZXF1ZXN0SABSC3N3YXBSZXF1ZXN0EkcKDnBlZ19pbl9yZXF1ZXN0GBUgASgLMh8uc2lkZXN3YXAucHJvdG8uVG8uUGVnSW5SZXF1ZXN0SABSDHBlZ0luUmVxdWVzdBJKCg9wZWdfb3V0X3JlcXVlc3QYFiABKAsyIC5zaWRlc3dhcC5wcm90by5Uby5QZWdPdXRSZXF1ZXN0SABSDXBlZ091dFJlcXVlc3QSPgoLc3dhcF9hY2NlcHQYFyABKAsyGy5zaWRlc3dhcC5wcm90by5Td2FwRGV0YWlsc0gAUgpzd2FwQWNjZXB0EkkKDnJlZ2lzdGVyX3Bob25lGCggASgLMiAuc2lkZXN3YXAucHJvdG8uVG8uUmVnaXN0ZXJQaG9uZUgAUg1yZWdpc3RlclBob25lEkMKDHZlcmlmeV9waG9uZRgpIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlZlcmlmeVBob25lSABSC3ZlcmlmeVBob25lEk8KEHVucmVnaXN0ZXJfcGhvbmUYLCABKAsyIi5zaWRlc3dhcC5wcm90by5Uby5VbnJlZ2lzdGVyUGhvbmVIAFIPdW5yZWdpc3RlclBob25lEkYKDXVwbG9hZF9hdmF0YXIYKiABKAsyHy5zaWRlc3dhcC5wcm90by5Uby5VcGxvYWRBdmF0YXJIAFIMdXBsb2FkQXZhdGFyEkwKD3VwbG9hZF9jb250YWN0cxgrIAEoCzIhLnNpZGVzd2FwLnByb3RvLlRvLlVwbG9hZENvbnRhY3RzSABSDnVwbG9hZENvbnRhY3RzEkMKDHN1Ym1pdF9vcmRlchgxIAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLlN1Ym1pdE9yZGVySABSC3N1Ym1pdE9yZGVyEj0KCmxpbmtfb3JkZXIYMiABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5MaW5rT3JkZXJIAFIJbGlua09yZGVyEkwKD3N1Ym1pdF9kZWNpc2lvbhgzIAEoCzIhLnNpZGVzd2FwLnByb3RvLlRvLlN1Ym1pdERlY2lzaW9uSABSDnN1Ym1pdERlY2lzaW9uEj0KCmVkaXRfb3JkZXIYNCABKAsyHC5zaWRlc3dhcC5wcm90by5Uby5FZGl0T3JkZXJIAFIJZWRpdE9yZGVyEkMKDGNhbmNlbF9vcmRlchg1IAEoCzIeLnNpZGVzd2FwLnByb3RvLlRvLkNhbmNlbE9yZGVySABSC2NhbmNlbE9yZGVyEjwKCXN1YnNjcmliZRg2IAEoCzIcLnNpZGVzd2FwLnByb3RvLlRvLlN1YnNjcmliZUgAUglzdWJzY3JpYmUSPgoNYXNzZXRfZGV0YWlscxg5IAEoCzIXLnNpZGVzd2FwLnByb3RvLkFzc2V0SWRIAFIMYXNzZXREZXRhaWxzEkIKD3N1YnNjcmliZV9wcmljZRg3IAEoCzIXLnNpZGVzd2FwLnByb3RvLkFzc2V0SWRIAFIOc3Vic2NyaWJlUHJpY2USRgoRdW5zdWJzY3JpYmVfcHJpY2UYOCABKAsyFy5zaWRlc3dhcC5wcm90by5Bc3NldElkSABSEHVuc3Vic2NyaWJlUHJpY2USXwoWc3Vic2NyaWJlX3ByaWNlX3N0cmVhbRg6IAEoCzInLnNpZGVzd2FwLnByb3RvLlRvLlN1YnNjcmliZVByaWNlU3RyZWFtSABSFHN1YnNjcmliZVByaWNlU3RyZWFtElEKGHVuc3Vic2NyaWJlX3ByaWNlX3N0cmVhbRg7IAEoCzIVLnNpZGVzd2FwLnByb3RvLkVtcHR5SABSFnVuc3Vic2NyaWJlUHJpY2VTdHJlYW0aewoFTG9naW4SGgoIbW5lbW9uaWMYASACKAlSCG1uZW1vbmljEhsKCXBob25lX2tleRgCIAEoCVIIcGhvbmVLZXkSOQoHbmV0d29yaxgEIAIoCzIfLnNpZGVzd2FwLnByb3RvLk5ldHdvcmtTZXR0aW5nc1IHbmV0d29yaxpKCg1DaGFuZ2VOZXR3b3JrEjkKB25ldHdvcmsYASACKAsyHy5zaWRlc3dhcC5wcm90by5OZXR3b3JrU2V0dGluZ3NSB25ldHdvcmsaOgoKRW5jcnlwdFBpbhIQCgNwaW4YASACKAlSA3BpbhIaCghtbmVtb25pYxgCIAIoCVIIbW5lbW9uaWMagAEKCkRlY3J5cHRQaW4SEAoDcGluGAEgAigJUgNwaW4SEgoEc2FsdBgCIAIoCVIEc2FsdBIlCg5lbmNyeXB0ZWRfZGF0YRgDIAIoCVINZW5jcnlwdGVkRGF0YRIlCg5waW5faWRlbnRpZmllchgEIAIoCVINcGluSWRlbnRpZmllchoiCghBcHBTdGF0ZRIWCgZhY3RpdmUYASACKAhSBmFjdGl2ZRqgAQoLU3dhcFJlcXVlc3QSIwoNc2VuZF9iaXRjb2lucxgBIAIoCFIMc2VuZEJpdGNvaW5zEhQKBWFzc2V0GAIgAigJUgVhc3NldBIfCgtzZW5kX2Ftb3VudBgDIAIoA1IKc2VuZEFtb3VudBIfCgtyZWN2X2Ftb3VudBgEIAIoA1IKcmVjdkFtb3VudBIUCgVwcmljZRgFIAIoAVIFcHJpY2UaDgoMUGVnSW5SZXF1ZXN0GmUKDVBlZ091dFJlcXVlc3QSHwoLc2VuZF9hbW91bnQYASACKANSCnNlbmRBbW91bnQSGwoJcmVjdl9hZGRyGAIgAigJUghyZWN2QWRkchIWCgZibG9ja3MYAyACKAVSBmJsb2NrcxoxCgdTZXRNZW1vEhIKBHR4aWQYASACKAlSBHR4aWQSEgoEbWVtbxgCIAIoCVIEbWVtbxqjAQoIQ3JlYXRlVHgSEgoEYWRkchgBIAIoCVIEYWRkchIxCgdiYWxhbmNlGAIgAigLMhcuc2lkZXN3YXAucHJvdG8uQmFsYW5jZVIHYmFsYW5jZRIdCgppc19jb250YWN0GAMgAigIUglpc0NvbnRhY3QSMQoHYWNjb3VudBgEIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQaOwoGU2VuZFR4EjEKB2FjY291bnQYASACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50GiMKDUJsaW5kZWRWYWx1ZXMSEgoEdHhpZBgBIAIoCVIEdHhpZBonCg9VcGRhdGVQdXNoVG9rZW4SFAoFdG9rZW4YASACKAlSBXRva2VuGicKDVJlZ2lzdGVyUGhvbmUSFgoGbnVtYmVyGAEgAigJUgZudW1iZXIaPgoLVmVyaWZ5UGhvbmUSGwoJcGhvbmVfa2V5GAEgAigJUghwaG9uZUtleRISCgRjb2RlGAIgAigJUgRjb2RlGi4KD1VucmVnaXN0ZXJQaG9uZRIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5GkEKDFVwbG9hZEF2YXRhchIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EhQKBWltYWdlGAIgAigJUgVpbWFnZRpoCg5VcGxvYWRDb250YWN0cxIbCglwaG9uZV9rZXkYASACKAlSCHBob25lS2V5EjkKCGNvbnRhY3RzGAIgAygLMh0uc2lkZXN3YXAucHJvdG8uVXBsb2FkQ29udGFjdFIIY29udGFjdHMa+wEKC1N1Ym1pdE9yZGVyEjEKB2FjY291bnQYByACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50Eh0KCnNlc3Npb25faWQYASABKAlSCXNlc3Npb25JZBIZCghhc3NldF9pZBgCIAIoCVIHYXNzZXRJZBIlCg5iaXRjb2luX2Ftb3VudBgDIAEoAVINYml0Y29pbkFtb3VudBIhCgxhc3NldF9hbW91bnQYBCABKAFSC2Fzc2V0QW1vdW50EhQKBXByaWNlGAUgAigBUgVwcmljZRIfCgtpbmRleF9wcmljZRgGIAEoAVIKaW5kZXhQcmljZRomCglMaW5rT3JkZXISGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQamwEKDlN1Ym1pdERlY2lzaW9uEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkEhYKBmFjY2VwdBgCIAIoCFIGYWNjZXB0EhsKCWF1dG9fc2lnbhgDIAEoCFIIYXV0b1NpZ24SGAoHcHJpdmF0ZRgEIAEoCFIHcHJpdmF0ZRIfCgt0dGxfc2Vjb25kcxgFIAEoBFIKdHRsU2Vjb25kcxqIAQoJRWRpdE9yZGVyEhkKCG9yZGVyX2lkGAEgAigJUgdvcmRlcklkEhYKBXByaWNlGAIgASgBSABSBXByaWNlEiEKC2luZGV4X3ByaWNlGAMgASgBSABSCmluZGV4UHJpY2USHQoJYXV0b19zaWduGAQgASgISABSCGF1dG9TaWduQgYKBGRhdGEaKAoLQ2FuY2VsT3JkZXISGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQajgEKCVN1YnNjcmliZRI7CgZtYXJrZXQYASACKA4yIy5zaWRlc3dhcC5wcm90by5Uby5TdWJzY3JpYmUuTWFya2V0UgZtYXJrZXQSGQoIYXNzZXRfaWQYAiABKAlSB2Fzc2V0SWQiKQoGTWFya2V0EggKBE5PTkUQABIKCgZUT0tFTlMQARIJCgVBU1NFVBACGpgBChRTdWJzY3JpYmVQcmljZVN0cmVhbRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIjCg1zZW5kX2JpdGNvaW5zGAIgAigIUgxzZW5kQml0Y29pbnMSHwoLc2VuZF9hbW91bnQYAyABKANSCnNlbmRBbW91bnQSHwoLcmVjdl9hbW91bnQYBCABKANSCnJlY3ZBbW91bnRCBQoDbXNn');
@$core.Deprecated('Use fromDescriptor instead')
const From$json = const {
  '1': 'From',
  '2': const [
    const {'1': 'env_settings', '3': 13, '4': 1, '5': 11, '6': '.sideswap.proto.From.EnvSettings', '9': 0, '10': 'envSettings'},
    const {'1': 'register_amp', '3': 8, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterAmp', '9': 0, '10': 'registerAmp'},
    const {'1': 'updated_txs', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedTxs', '9': 0, '10': 'updatedTxs'},
    const {'1': 'removed_txs', '3': 12, '4': 1, '5': 11, '6': '.sideswap.proto.From.RemovedTxs', '9': 0, '10': 'removedTxs'},
    const {'1': 'updated_pegs', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatedPegs', '9': 0, '10': 'updatedPegs'},
    const {'1': 'new_asset', '3': 3, '4': 1, '5': 11, '6': '.sideswap.proto.Asset', '9': 0, '10': 'newAsset'},
    const {'1': 'amp_assets', '3': 9, '4': 1, '5': 11, '6': '.sideswap.proto.From.AmpAssets', '9': 0, '10': 'ampAssets'},
    const {'1': 'balance_update', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.BalanceUpdate', '9': 0, '10': 'balanceUpdate'},
    const {'1': 'server_status', '3': 5, '4': 1, '5': 11, '6': '.sideswap.proto.ServerStatus', '9': 0, '10': 'serverStatus'},
    const {'1': 'price_update', '3': 6, '4': 1, '5': 11, '6': '.sideswap.proto.From.PriceUpdate', '9': 0, '10': 'priceUpdate'},
    const {'1': 'wallet_loaded', '3': 7, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'walletLoaded'},
    const {'1': 'encrypt_pin', '3': 10, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin', '9': 0, '10': 'encryptPin'},
    const {'1': 'decrypt_pin', '3': 11, '4': 1, '5': 11, '6': '.sideswap.proto.From.DecryptPin', '9': 0, '10': 'decryptPin'},
    const {'1': 'pegin_wait_tx', '3': 21, '4': 1, '5': 11, '6': '.sideswap.proto.From.PeginWaitTx', '9': 0, '10': 'peginWaitTx'},
    const {'1': 'swap_succeed', '3': 22, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    const {'1': 'swap_failed', '3': 23, '4': 1, '5': 9, '9': 0, '10': 'swapFailed'},
    const {'1': 'recv_address', '3': 30, '4': 1, '5': 11, '6': '.sideswap.proto.From.RecvAddress', '9': 0, '10': 'recvAddress'},
    const {'1': 'create_tx_result', '3': 31, '4': 1, '5': 11, '6': '.sideswap.proto.From.CreateTxResult', '9': 0, '10': 'createTxResult'},
    const {'1': 'send_result', '3': 32, '4': 1, '5': 11, '6': '.sideswap.proto.From.SendResult', '9': 0, '10': 'sendResult'},
    const {'1': 'blinded_values', '3': 33, '4': 1, '5': 11, '6': '.sideswap.proto.From.BlindedValues', '9': 0, '10': 'blindedValues'},
    const {'1': 'register_phone', '3': 40, '4': 1, '5': 11, '6': '.sideswap.proto.From.RegisterPhone', '9': 0, '10': 'registerPhone'},
    const {'1': 'verify_phone', '3': 41, '4': 1, '5': 11, '6': '.sideswap.proto.From.VerifyPhone', '9': 0, '10': 'verifyPhone'},
    const {'1': 'upload_avatar', '3': 42, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadAvatar'},
    const {'1': 'upload_contacts', '3': 43, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'uploadContacts'},
    const {'1': 'contact_created', '3': 44, '4': 1, '5': 11, '6': '.sideswap.proto.Contact', '9': 0, '10': 'contactCreated'},
    const {'1': 'contact_removed', '3': 45, '4': 1, '5': 11, '6': '.sideswap.proto.From.ContactRemoved', '9': 0, '10': 'contactRemoved'},
    const {'1': 'contact_transaction', '3': 46, '4': 1, '5': 11, '6': '.sideswap.proto.ContactTransaction', '9': 0, '10': 'contactTransaction'},
    const {'1': 'account_status', '3': 47, '4': 1, '5': 11, '6': '.sideswap.proto.From.AccountStatus', '9': 0, '10': 'accountStatus'},
    const {'1': 'show_message', '3': 50, '4': 1, '5': 11, '6': '.sideswap.proto.From.ShowMessage', '9': 0, '10': 'showMessage'},
    const {'1': 'submit_review', '3': 51, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitReview', '9': 0, '10': 'submitReview'},
    const {'1': 'submit_result', '3': 52, '4': 1, '5': 11, '6': '.sideswap.proto.From.SubmitResult', '9': 0, '10': 'submitResult'},
    const {'1': 'edit_order', '3': 53, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'editOrder'},
    const {'1': 'cancel_order', '3': 54, '4': 1, '5': 11, '6': '.sideswap.proto.GenericResponse', '9': 0, '10': 'cancelOrder'},
    const {'1': 'server_connected', '3': 60, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverConnected'},
    const {'1': 'server_disconnected', '3': 61, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'serverDisconnected'},
    const {'1': 'order_created', '3': 62, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderCreated', '9': 0, '10': 'orderCreated'},
    const {'1': 'order_removed', '3': 63, '4': 1, '5': 11, '6': '.sideswap.proto.From.OrderRemoved', '9': 0, '10': 'orderRemoved'},
    const {'1': 'index_price', '3': 64, '4': 1, '5': 11, '6': '.sideswap.proto.From.IndexPrice', '9': 0, '10': 'indexPrice'},
    const {'1': 'asset_details', '3': 65, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails', '9': 0, '10': 'assetDetails'},
    const {'1': 'update_price_stream', '3': 66, '4': 1, '5': 11, '6': '.sideswap.proto.From.UpdatePriceStream', '9': 0, '10': 'updatePriceStream'},
  ],
  '3': const [From_EnvSettings$json, From_EncryptPin$json, From_DecryptPin$json, From_RegisterAmp$json, From_AmpAssets$json, From_UpdatedTxs$json, From_RemovedTxs$json, From_UpdatedPegs$json, From_BalanceUpdate$json, From_PeginWaitTx$json, From_RecvAddress$json, From_CreateTxResult$json, From_SendResult$json, From_BlindedValues$json, From_PriceUpdate$json, From_RegisterPhone$json, From_VerifyPhone$json, From_ShowMessage$json, From_SubmitReview$json, From_SubmitResult$json, From_OrderCreated$json, From_OrderRemoved$json, From_IndexPrice$json, From_ContactRemoved$json, From_AccountStatus$json, From_AssetDetails$json, From_UpdatePriceStream$json],
  '8': const [
    const {'1': 'msg'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EnvSettings$json = const {
  '1': 'EnvSettings',
  '2': const [
    const {'1': 'policy_asset_id', '3': 1, '4': 2, '5': 9, '10': 'policyAssetId'},
    const {'1': 'usdt_asset_id', '3': 2, '4': 2, '5': 9, '10': 'usdtAssetId'},
    const {'1': 'eurx_asset_id', '3': 3, '4': 2, '5': 9, '10': 'eurxAssetId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin$json = const {
  '1': 'EncryptPin',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    const {'1': 'data', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.EncryptPin.Data', '9': 0, '10': 'data'},
  ],
  '3': const [From_EncryptPin_Data$json],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_EncryptPin_Data$json = const {
  '1': 'Data',
  '2': const [
    const {'1': 'salt', '3': 2, '4': 2, '5': 9, '10': 'salt'},
    const {'1': 'encrypted_data', '3': 3, '4': 2, '5': 9, '10': 'encryptedData'},
    const {'1': 'pin_identifier', '3': 4, '4': 2, '5': 9, '10': 'pinIdentifier'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_DecryptPin$json = const {
  '1': 'DecryptPin',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'error'},
    const {'1': 'mnemonic', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'mnemonic'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RegisterAmp$json = const {
  '1': 'RegisterAmp',
  '2': const [
    const {'1': 'amp_id', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'ampId'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AmpAssets$json = const {
  '1': 'AmpAssets',
  '2': const [
    const {'1': 'assets', '3': 1, '4': 3, '5': 9, '10': 'assets'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedTxs$json = const {
  '1': 'UpdatedTxs',
  '2': const [
    const {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RemovedTxs$json = const {
  '1': 'RemovedTxs',
  '2': const [
    const {'1': 'txids', '3': 1, '4': 3, '5': 9, '10': 'txids'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatedPegs$json = const {
  '1': 'UpdatedPegs',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'items', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.TransItem', '10': 'items'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BalanceUpdate$json = const {
  '1': 'BalanceUpdate',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'balances', '3': 2, '4': 3, '5': 11, '6': '.sideswap.proto.Balance', '10': 'balances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PeginWaitTx$json = const {
  '1': 'PeginWaitTx',
  '2': const [
    const {'1': 'peg_addr', '3': 5, '4': 2, '5': 9, '10': 'pegAddr'},
    const {'1': 'recv_addr', '3': 6, '4': 2, '5': 9, '10': 'recvAddr'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RecvAddress$json = const {
  '1': 'RecvAddress',
  '2': const [
    const {'1': 'addr', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Address', '10': 'addr'},
    const {'1': 'account', '3': 2, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_CreateTxResult$json = const {
  '1': 'CreateTxResult',
  '2': const [
    const {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    const {'1': 'network_fee', '3': 2, '4': 1, '5': 3, '9': 0, '10': 'networkFee'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SendResult$json = const {
  '1': 'SendResult',
  '2': const [
    const {'1': 'error_msg', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    const {'1': 'tx_item', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'txItem'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_BlindedValues$json = const {
  '1': 'BlindedValues',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 2, '5': 9, '10': 'txid'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
    const {'1': 'blinded_values', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'blindedValues'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_PriceUpdate$json = const {
  '1': 'PriceUpdate',
  '2': const [
    const {'1': 'asset', '3': 1, '4': 2, '5': 9, '10': 'asset'},
    const {'1': 'bid', '3': 2, '4': 2, '5': 1, '10': 'bid'},
    const {'1': 'ask', '3': 3, '4': 2, '5': 1, '10': 'ask'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_RegisterPhone$json = const {
  '1': 'RegisterPhone',
  '2': const [
    const {'1': 'phone_key', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'phoneKey'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_VerifyPhone$json = const {
  '1': 'VerifyPhone',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'success'},
    const {'1': 'error_msg', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'errorMsg'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ShowMessage$json = const {
  '1': 'ShowMessage',
  '2': const [
    const {'1': 'text', '3': 1, '4': 2, '5': 9, '10': 'text'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitReview$json = const {
  '1': 'SubmitReview',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'asset', '3': 2, '4': 2, '5': 9, '10': 'asset'},
    const {'1': 'bitcoin_amount', '3': 3, '4': 2, '5': 3, '10': 'bitcoinAmount'},
    const {'1': 'server_fee', '3': 8, '4': 2, '5': 3, '10': 'serverFee'},
    const {'1': 'asset_amount', '3': 4, '4': 2, '5': 3, '10': 'assetAmount'},
    const {'1': 'price', '3': 5, '4': 2, '5': 1, '10': 'price'},
    const {'1': 'sell_bitcoin', '3': 6, '4': 2, '5': 8, '10': 'sellBitcoin'},
    const {'1': 'step', '3': 7, '4': 2, '5': 14, '6': '.sideswap.proto.From.SubmitReview.Step', '10': 'step'},
    const {'1': 'index_price', '3': 9, '4': 2, '5': 8, '10': 'indexPrice'},
    const {'1': 'auto_sign', '3': 11, '4': 2, '5': 8, '10': 'autoSign'},
  ],
  '4': const [From_SubmitReview_Step$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitReview_Step$json = const {
  '1': 'Step',
  '2': const [
    const {'1': 'SUBMIT', '2': 1},
    const {'1': 'QUOTE', '2': 2},
    const {'1': 'SIGN', '2': 3},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_SubmitResult$json = const {
  '1': 'SubmitResult',
  '2': const [
    const {'1': 'submit_succeed', '3': 1, '4': 1, '5': 11, '6': '.sideswap.proto.Empty', '9': 0, '10': 'submitSucceed'},
    const {'1': 'swap_succeed', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.TransItem', '9': 0, '10': 'swapSucceed'},
    const {'1': 'error', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'error'},
  ],
  '8': const [
    const {'1': 'result'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderCreated$json = const {
  '1': 'OrderCreated',
  '2': const [
    const {'1': 'order', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Order', '10': 'order'},
    const {'1': 'new', '3': 2, '4': 2, '5': 8, '10': 'new'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_OrderRemoved$json = const {
  '1': 'OrderRemoved',
  '2': const [
    const {'1': 'order_id', '3': 1, '4': 2, '5': 9, '10': 'orderId'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_IndexPrice$json = const {
  '1': 'IndexPrice',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'ind', '3': 2, '4': 1, '5': 1, '10': 'ind'},
    const {'1': 'last', '3': 3, '4': 1, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_ContactRemoved$json = const {
  '1': 'ContactRemoved',
  '2': const [
    const {'1': 'contact_key', '3': 1, '4': 2, '5': 9, '10': 'contactKey'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AccountStatus$json = const {
  '1': 'AccountStatus',
  '2': const [
    const {'1': 'registered', '3': 1, '4': 2, '5': 8, '10': 'registered'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails$json = const {
  '1': 'AssetDetails',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'stats', '3': 2, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.Stats', '10': 'stats'},
    const {'1': 'chart_url', '3': 3, '4': 1, '5': 9, '10': 'chartUrl'},
    const {'1': 'chart_stats', '3': 4, '4': 1, '5': 11, '6': '.sideswap.proto.From.AssetDetails.ChartStats', '10': 'chartStats'},
  ],
  '3': const [From_AssetDetails_Stats$json, From_AssetDetails_ChartStats$json],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_Stats$json = const {
  '1': 'Stats',
  '2': const [
    const {'1': 'issued_amount', '3': 1, '4': 2, '5': 3, '10': 'issuedAmount'},
    const {'1': 'burned_amount', '3': 2, '4': 2, '5': 3, '10': 'burnedAmount'},
    const {'1': 'has_blinded_issuances', '3': 3, '4': 2, '5': 8, '10': 'hasBlindedIssuances'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_AssetDetails_ChartStats$json = const {
  '1': 'ChartStats',
  '2': const [
    const {'1': 'low', '3': 1, '4': 2, '5': 1, '10': 'low'},
    const {'1': 'high', '3': 2, '4': 2, '5': 1, '10': 'high'},
    const {'1': 'last', '3': 3, '4': 2, '5': 1, '10': 'last'},
  ],
};

@$core.Deprecated('Use fromDescriptor instead')
const From_UpdatePriceStream$json = const {
  '1': 'UpdatePriceStream',
  '2': const [
    const {'1': 'asset_id', '3': 1, '4': 2, '5': 9, '10': 'assetId'},
    const {'1': 'send_bitcoins', '3': 2, '4': 2, '5': 8, '10': 'sendBitcoins'},
    const {'1': 'send_amount', '3': 3, '4': 1, '5': 3, '10': 'sendAmount'},
    const {'1': 'recv_amount', '3': 4, '4': 1, '5': 3, '10': 'recvAmount'},
    const {'1': 'price', '3': 5, '4': 1, '5': 1, '10': 'price'},
    const {'1': 'error_msg', '3': 6, '4': 1, '5': 9, '10': 'errorMsg'},
  ],
};

/// Descriptor for `From`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fromDescriptor = $convert.base64Decode('CgRGcm9tEkUKDGVudl9zZXR0aW5ncxgNIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uRW52U2V0dGluZ3NIAFILZW52U2V0dGluZ3MSRQoMcmVnaXN0ZXJfYW1wGAggASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5SZWdpc3RlckFtcEgAUgtyZWdpc3RlckFtcBJCCgt1cGRhdGVkX3R4cxgBIAEoCzIfLnNpZGVzd2FwLnByb3RvLkZyb20uVXBkYXRlZFR4c0gAUgp1cGRhdGVkVHhzEkIKC3JlbW92ZWRfdHhzGAwgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5SZW1vdmVkVHhzSABSCnJlbW92ZWRUeHMSRQoMdXBkYXRlZF9wZWdzGAIgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5VcGRhdGVkUGVnc0gAUgt1cGRhdGVkUGVncxI0CgluZXdfYXNzZXQYAyABKAsyFS5zaWRlc3dhcC5wcm90by5Bc3NldEgAUghuZXdBc3NldBI/CgphbXBfYXNzZXRzGAkgASgLMh4uc2lkZXN3YXAucHJvdG8uRnJvbS5BbXBBc3NldHNIAFIJYW1wQXNzZXRzEksKDmJhbGFuY2VfdXBkYXRlGAQgASgLMiIuc2lkZXN3YXAucHJvdG8uRnJvbS5CYWxhbmNlVXBkYXRlSABSDWJhbGFuY2VVcGRhdGUSQwoNc2VydmVyX3N0YXR1cxgFIAEoCzIcLnNpZGVzd2FwLnByb3RvLlNlcnZlclN0YXR1c0gAUgxzZXJ2ZXJTdGF0dXMSRQoMcHJpY2VfdXBkYXRlGAYgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5QcmljZVVwZGF0ZUgAUgtwcmljZVVwZGF0ZRI8Cg13YWxsZXRfbG9hZGVkGAcgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIMd2FsbGV0TG9hZGVkEkIKC2VuY3J5cHRfcGluGAogASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5FbmNyeXB0UGluSABSCmVuY3J5cHRQaW4SQgoLZGVjcnlwdF9waW4YCyABKAsyHy5zaWRlc3dhcC5wcm90by5Gcm9tLkRlY3J5cHRQaW5IAFIKZGVjcnlwdFBpbhJGCg1wZWdpbl93YWl0X3R4GBUgASgLMiAuc2lkZXN3YXAucHJvdG8uRnJvbS5QZWdpbldhaXRUeEgAUgtwZWdpbldhaXRUeBI+Cgxzd2FwX3N1Y2NlZWQYFiABKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1IAFILc3dhcFN1Y2NlZWQSIQoLc3dhcF9mYWlsZWQYFyABKAlIAFIKc3dhcEZhaWxlZBJFCgxyZWN2X2FkZHJlc3MYHiABKAsyIC5zaWRlc3dhcC5wcm90by5Gcm9tLlJlY3ZBZGRyZXNzSABSC3JlY3ZBZGRyZXNzEk8KEGNyZWF0ZV90eF9yZXN1bHQYHyABKAsyIy5zaWRlc3dhcC5wcm90by5Gcm9tLkNyZWF0ZVR4UmVzdWx0SABSDmNyZWF0ZVR4UmVzdWx0EkIKC3NlbmRfcmVzdWx0GCAgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5TZW5kUmVzdWx0SABSCnNlbmRSZXN1bHQSSwoOYmxpbmRlZF92YWx1ZXMYISABKAsyIi5zaWRlc3dhcC5wcm90by5Gcm9tLkJsaW5kZWRWYWx1ZXNIAFINYmxpbmRlZFZhbHVlcxJLCg5yZWdpc3Rlcl9waG9uZRgoIAEoCzIiLnNpZGVzd2FwLnByb3RvLkZyb20uUmVnaXN0ZXJQaG9uZUgAUg1yZWdpc3RlclBob25lEkUKDHZlcmlmeV9waG9uZRgpIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uVmVyaWZ5UGhvbmVIAFILdmVyaWZ5UGhvbmUSRgoNdXBsb2FkX2F2YXRhchgqIAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUgx1cGxvYWRBdmF0YXISSgoPdXBsb2FkX2NvbnRhY3RzGCsgASgLMh8uc2lkZXN3YXAucHJvdG8uR2VuZXJpY1Jlc3BvbnNlSABSDnVwbG9hZENvbnRhY3RzEkIKD2NvbnRhY3RfY3JlYXRlZBgsIAEoCzIXLnNpZGVzd2FwLnByb3RvLkNvbnRhY3RIAFIOY29udGFjdENyZWF0ZWQSTgoPY29udGFjdF9yZW1vdmVkGC0gASgLMiMuc2lkZXN3YXAucHJvdG8uRnJvbS5Db250YWN0UmVtb3ZlZEgAUg5jb250YWN0UmVtb3ZlZBJVChNjb250YWN0X3RyYW5zYWN0aW9uGC4gASgLMiIuc2lkZXN3YXAucHJvdG8uQ29udGFjdFRyYW5zYWN0aW9uSABSEmNvbnRhY3RUcmFuc2FjdGlvbhJLCg5hY2NvdW50X3N0YXR1cxgvIAEoCzIiLnNpZGVzd2FwLnByb3RvLkZyb20uQWNjb3VudFN0YXR1c0gAUg1hY2NvdW50U3RhdHVzEkUKDHNob3dfbWVzc2FnZRgyIAEoCzIgLnNpZGVzd2FwLnByb3RvLkZyb20uU2hvd01lc3NhZ2VIAFILc2hvd01lc3NhZ2USSAoNc3VibWl0X3JldmlldxgzIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uU3VibWl0UmV2aWV3SABSDHN1Ym1pdFJldmlldxJICg1zdWJtaXRfcmVzdWx0GDQgASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5TdWJtaXRSZXN1bHRIAFIMc3VibWl0UmVzdWx0EkAKCmVkaXRfb3JkZXIYNSABKAsyHy5zaWRlc3dhcC5wcm90by5HZW5lcmljUmVzcG9uc2VIAFIJZWRpdE9yZGVyEkQKDGNhbmNlbF9vcmRlchg2IAEoCzIfLnNpZGVzd2FwLnByb3RvLkdlbmVyaWNSZXNwb25zZUgAUgtjYW5jZWxPcmRlchJCChBzZXJ2ZXJfY29ubmVjdGVkGDwgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIPc2VydmVyQ29ubmVjdGVkEkgKE3NlcnZlcl9kaXNjb25uZWN0ZWQYPSABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUhJzZXJ2ZXJEaXNjb25uZWN0ZWQSSAoNb3JkZXJfY3JlYXRlZBg+IAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uT3JkZXJDcmVhdGVkSABSDG9yZGVyQ3JlYXRlZBJICg1vcmRlcl9yZW1vdmVkGD8gASgLMiEuc2lkZXN3YXAucHJvdG8uRnJvbS5PcmRlclJlbW92ZWRIAFIMb3JkZXJSZW1vdmVkEkIKC2luZGV4X3ByaWNlGEAgASgLMh8uc2lkZXN3YXAucHJvdG8uRnJvbS5JbmRleFByaWNlSABSCmluZGV4UHJpY2USSAoNYXNzZXRfZGV0YWlscxhBIAEoCzIhLnNpZGVzd2FwLnByb3RvLkZyb20uQXNzZXREZXRhaWxzSABSDGFzc2V0RGV0YWlscxJYChN1cGRhdGVfcHJpY2Vfc3RyZWFtGEIgASgLMiYuc2lkZXN3YXAucHJvdG8uRnJvbS5VcGRhdGVQcmljZVN0cmVhbUgAUhF1cGRhdGVQcmljZVN0cmVhbRp9CgtFbnZTZXR0aW5ncxImCg9wb2xpY3lfYXNzZXRfaWQYASACKAlSDXBvbGljeUFzc2V0SWQSIgoNdXNkdF9hc3NldF9pZBgCIAIoCVILdXNkdEFzc2V0SWQSIgoNZXVyeF9hc3NldF9pZBgDIAIoCVILZXVyeEFzc2V0SWQa1AEKCkVuY3J5cHRQaW4SFgoFZXJyb3IYASABKAlIAFIFZXJyb3ISOgoEZGF0YRgCIAEoCzIkLnNpZGVzd2FwLnByb3RvLkZyb20uRW5jcnlwdFBpbi5EYXRhSABSBGRhdGEaaAoERGF0YRISCgRzYWx0GAIgAigJUgRzYWx0EiUKDmVuY3J5cHRlZF9kYXRhGAMgAigJUg1lbmNyeXB0ZWREYXRhEiUKDnBpbl9pZGVudGlmaWVyGAQgAigJUg1waW5JZGVudGlmaWVyQggKBnJlc3VsdBpMCgpEZWNyeXB0UGluEhYKBWVycm9yGAEgASgJSABSBWVycm9yEhwKCG1uZW1vbmljGAIgASgJSABSCG1uZW1vbmljQggKBnJlc3VsdBpPCgtSZWdpc3RlckFtcBIXCgZhbXBfaWQYASABKAlIAFIFYW1wSWQSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnQggKBnJlc3VsdBojCglBbXBBc3NldHMSFgoGYXNzZXRzGAEgAygJUgZhc3NldHMaPQoKVXBkYXRlZFR4cxIvCgVpdGVtcxgBIAMoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbVIFaXRlbXMaIgoKUmVtb3ZlZFR4cxIUCgV0eGlkcxgBIAMoCVIFdHhpZHMaWQoLVXBkYXRlZFBlZ3MSGQoIb3JkZXJfaWQYASACKAlSB29yZGVySWQSLwoFaXRlbXMYAiADKAsyGS5zaWRlc3dhcC5wcm90by5UcmFuc0l0ZW1SBWl0ZW1zGncKDUJhbGFuY2VVcGRhdGUSMQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSMwoIYmFsYW5jZXMYAiADKAsyFy5zaWRlc3dhcC5wcm90by5CYWxhbmNlUghiYWxhbmNlcxpFCgtQZWdpbldhaXRUeBIZCghwZWdfYWRkchgFIAIoCVIHcGVnQWRkchIbCglyZWN2X2FkZHIYBiACKAlSCHJlY3ZBZGRyGm0KC1JlY3ZBZGRyZXNzEisKBGFkZHIYASACKAsyFy5zaWRlc3dhcC5wcm90by5BZGRyZXNzUgRhZGRyEjEKB2FjY291bnQYAiACKAsyFy5zaWRlc3dhcC5wcm90by5BY2NvdW50UgdhY2NvdW50GlwKDkNyZWF0ZVR4UmVzdWx0Eh0KCWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxIhCgtuZXR3b3JrX2ZlZRgCIAEoA0gAUgpuZXR3b3JrRmVlQggKBnJlc3VsdBprCgpTZW5kUmVzdWx0Eh0KCWVycm9yX21zZxgBIAEoCUgAUghlcnJvck1zZxI0Cgd0eF9pdGVtGAIgASgLMhkuc2lkZXN3YXAucHJvdG8uVHJhbnNJdGVtSABSBnR4SXRlbUIICgZyZXN1bHQadQoNQmxpbmRlZFZhbHVlcxISCgR0eGlkGAEgAigJUgR0eGlkEh0KCWVycm9yX21zZxgCIAEoCUgAUghlcnJvck1zZxInCg5ibGluZGVkX3ZhbHVlcxgDIAEoCUgAUg1ibGluZGVkVmFsdWVzQggKBnJlc3VsdBpHCgtQcmljZVVwZGF0ZRIUCgVhc3NldBgBIAIoCVIFYXNzZXQSEAoDYmlkGAIgAigBUgNiaWQSEAoDYXNrGAMgAigBUgNhc2saVwoNUmVnaXN0ZXJQaG9uZRIdCglwaG9uZV9rZXkYASABKAlIAFIIcGhvbmVLZXkSHQoJZXJyb3JfbXNnGAIgASgJSABSCGVycm9yTXNnQggKBnJlc3VsdBppCgtWZXJpZnlQaG9uZRIxCgdzdWNjZXNzGAEgASgLMhUuc2lkZXN3YXAucHJvdG8uRW1wdHlIAFIHc3VjY2VzcxIdCgllcnJvcl9tc2cYAiABKAlIAFIIZXJyb3JNc2dCCAoGcmVzdWx0GiEKC1Nob3dNZXNzYWdlEhIKBHRleHQYASACKAlSBHRleHQahAMKDFN1Ym1pdFJldmlldxIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBIUCgVhc3NldBgCIAIoCVIFYXNzZXQSJQoOYml0Y29pbl9hbW91bnQYAyACKANSDWJpdGNvaW5BbW91bnQSHQoKc2VydmVyX2ZlZRgIIAIoA1IJc2VydmVyRmVlEiEKDGFzc2V0X2Ftb3VudBgEIAIoA1ILYXNzZXRBbW91bnQSFAoFcHJpY2UYBSACKAFSBXByaWNlEiEKDHNlbGxfYml0Y29pbhgGIAIoCFILc2VsbEJpdGNvaW4SOgoEc3RlcBgHIAIoDjImLnNpZGVzd2FwLnByb3RvLkZyb20uU3VibWl0UmV2aWV3LlN0ZXBSBHN0ZXASHwoLaW5kZXhfcHJpY2UYCSACKAhSCmluZGV4UHJpY2USGwoJYXV0b19zaWduGAsgAigIUghhdXRvU2lnbiInCgRTdGVwEgoKBlNVQk1JVBABEgkKBVFVT1RFEAISCAoEU0lHThADGrABCgxTdWJtaXRSZXN1bHQSPgoOc3VibWl0X3N1Y2NlZWQYASABKAsyFS5zaWRlc3dhcC5wcm90by5FbXB0eUgAUg1zdWJtaXRTdWNjZWVkEj4KDHN3YXBfc3VjY2VlZBgCIAEoCzIZLnNpZGVzd2FwLnByb3RvLlRyYW5zSXRlbUgAUgtzd2FwU3VjY2VlZBIWCgVlcnJvchgDIAEoCUgAUgVlcnJvckIICgZyZXN1bHQaTQoMT3JkZXJDcmVhdGVkEisKBW9yZGVyGAEgAigLMhUuc2lkZXN3YXAucHJvdG8uT3JkZXJSBW9yZGVyEhAKA25ldxgCIAIoCFIDbmV3GikKDE9yZGVyUmVtb3ZlZBIZCghvcmRlcl9pZBgBIAIoCVIHb3JkZXJJZBpNCgpJbmRleFByaWNlEhkKCGFzc2V0X2lkGAEgAigJUgdhc3NldElkEhAKA2luZBgCIAEoAVIDaW5kEhIKBGxhc3QYAyABKAFSBGxhc3QaMQoOQ29udGFjdFJlbW92ZWQSHwoLY29udGFjdF9rZXkYASACKAlSCmNvbnRhY3RLZXkaLwoNQWNjb3VudFN0YXR1cxIeCgpyZWdpc3RlcmVkGAEgAigIUgpyZWdpc3RlcmVkGqQDCgxBc3NldERldGFpbHMSGQoIYXNzZXRfaWQYASACKAlSB2Fzc2V0SWQSPQoFc3RhdHMYAiABKAsyJy5zaWRlc3dhcC5wcm90by5Gcm9tLkFzc2V0RGV0YWlscy5TdGF0c1IFc3RhdHMSGwoJY2hhcnRfdXJsGAMgASgJUghjaGFydFVybBJNCgtjaGFydF9zdGF0cxgEIAEoCzIsLnNpZGVzd2FwLnByb3RvLkZyb20uQXNzZXREZXRhaWxzLkNoYXJ0U3RhdHNSCmNoYXJ0U3RhdHMahQEKBVN0YXRzEiMKDWlzc3VlZF9hbW91bnQYASACKANSDGlzc3VlZEFtb3VudBIjCg1idXJuZWRfYW1vdW50GAIgAigDUgxidXJuZWRBbW91bnQSMgoVaGFzX2JsaW5kZWRfaXNzdWFuY2VzGAMgAigIUhNoYXNCbGluZGVkSXNzdWFuY2VzGkYKCkNoYXJ0U3RhdHMSEAoDbG93GAEgAigBUgNsb3cSEgoEaGlnaBgCIAIoAVIEaGlnaBISCgRsYXN0GAMgAigBUgRsYXN0GsgBChFVcGRhdGVQcmljZVN0cmVhbRIZCghhc3NldF9pZBgBIAIoCVIHYXNzZXRJZBIjCg1zZW5kX2JpdGNvaW5zGAIgAigIUgxzZW5kQml0Y29pbnMSHwoLc2VuZF9hbW91bnQYAyABKANSCnNlbmRBbW91bnQSHwoLcmVjdl9hbW91bnQYBCABKANSCnJlY3ZBbW91bnQSFAoFcHJpY2UYBSABKAFSBXByaWNlEhsKCWVycm9yX21zZxgGIAEoCVIIZXJyb3JNc2dCBQoDbXNn');
@$core.Deprecated('Use settingsDescriptor instead')
const Settings$json = const {
  '1': 'Settings',
  '2': const [
    const {'1': 'disabled_accounts', '3': 1, '4': 3, '5': 11, '6': '.sideswap.proto.Settings.AccountAsset', '10': 'disabledAccounts'},
  ],
  '3': const [Settings_AccountAsset$json],
};

@$core.Deprecated('Use settingsDescriptor instead')
const Settings_AccountAsset$json = const {
  '1': 'AccountAsset',
  '2': const [
    const {'1': 'account', '3': 1, '4': 2, '5': 11, '6': '.sideswap.proto.Account', '10': 'account'},
    const {'1': 'asset_id', '3': 2, '4': 2, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `Settings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingsDescriptor = $convert.base64Decode('CghTZXR0aW5ncxJSChFkaXNhYmxlZF9hY2NvdW50cxgBIAMoCzIlLnNpZGVzd2FwLnByb3RvLlNldHRpbmdzLkFjY291bnRBc3NldFIQZGlzYWJsZWRBY2NvdW50cxpcCgxBY2NvdW50QXNzZXQSMQoHYWNjb3VudBgBIAIoCzIXLnNpZGVzd2FwLnByb3RvLkFjY291bnRSB2FjY291bnQSGQoIYXNzZXRfaWQYAiACKAlSB2Fzc2V0SWQ=');
