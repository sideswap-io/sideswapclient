import 'dart:math';
import 'dart:io';
import 'dart:collection';
import 'package:csv/csv.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

const int kCoin = 100000000;
const int kMaxCoins = 100000000 * kCoin;

const int kDefaultPrecision = 8;

const String kBitcoinTicker = 'BTC';
const String kLiquidBitcoinTicker = 'L-BTC';
const String kTetherTicker = 'USDt';
const String kEurxTicker = 'EURx';
const String kUnknownTicker = '???';

const String kPackageSideswap = 'sideswap';
const String kPackageLibwally = 'libwally-core';
const String kPackageGdk = 'GDK';

const int kOneMinute = 60;
const int kTenMinutes = kOneMinute * 10;
const int kHalfHour = kTenMinutes * 3;
const int kOneHour = kHalfHour * 2;
const int kSixHours = kOneHour * 6;
const int kTwelveHours = kSixHours * 2;
const int kOneDay = kSixHours * 4;

double convertToNewRange({
  required double value,
  required double minValue,
  required double maxValue,
  required double newMin,
  required double newMax,
}) {
  final converted =
      ((((value - minValue) * (newMax - newMin)) / (maxValue - minValue)) +
              newMin)
          .toStringAsFixed(2);
  return double.tryParse(converted) ?? 0;
}

double toFloat(int amount, {int precision = 8}) {
  return amount / pow(10, precision);
}

String amountStr(int amount, {bool forceSign = false, int precision = 8}) {
  var sign = '';
  if (amount < 0) {
    sign = '-';
    amount = -amount;
  } else if (forceSign && amount > 0) {
    sign = '+';
  }
  final bitAmount = amount ~/ kCoin;
  final satAmount = amount % kCoin;
  final satAmountStr = satAmount.toString().padLeft(8, '0');
  final newAmount =
      Decimal.tryParse('$sign$bitAmount$satAmountStr') ?? Decimal.zero;
  final power =
      Decimal.tryParse(pow(10, precision).toStringAsFixed(precision)) ??
          Decimal.zero;
  final amountWithPrecision = newAmount / power;
  if (precision == 0) {
    return amountWithPrecision.toInt().toString();
  }
  return (newAmount / power).toStringAsFixed(precision);
}

String amountStrNamed(int amount, String ticker,
    {bool forceSign = false, int precision = 8}) {
  final valueStr =
      amountStr(amount, forceSign: forceSign, precision: precision);
  return '$valueStr $ticker';
}

String priceStr(double price) {
  if (price >= 1000000) {
    return price.toStringAsFixed(0);
  }
  if (price >= 10000) {
    return price.toStringAsFixed(2);
  }
  if (price >= 100) {
    return price.toStringAsFixed(4);
  }
  return price.toString();
}

final shortFormat = DateFormat('MMM d, yyyy');

// Returns timestamp in UTC
DateTime parseTimestamp(String timestamp) {
  return DateTime.parse(timestamp + 'Z');
}

String txDateStrShort(DateTime timestamp) {
  return shortFormat.format(timestamp.toLocal());
}

String txDateStrLong(DateTime timestamp) {
  final longFormat = DateFormat('MMM d, yyyy \'at\' HH:mm');
  return longFormat.format(timestamp);
}

String txDateCsvExport(int timestamp) {
  final longFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  return longFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
}

void showMessage(BuildContext context, String title, String message) {
  final alert =
      AlertDialog(title: Text(title), content: Text(message), actions: <Widget>[
    TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: const Text('OK').tr(),
    ),
  ]);

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String txItemToStatus(TransItem transItem, {bool isPeg = false}) {
  if (isPeg && !transItem.hasConfs()) {
    return !transItem.peg.hasTxidRecv() ? 'Initiated'.tr() : 'Complete'.tr();
  }
  var status = !transItem.hasConfs()
      ? 'Confirmed'.tr()
      : transItem.confs.count == 0
          ? 'Unconfirmed'.tr()
          : '${transItem.confs.count} / ${transItem.confs.total}';
  return status;
}

class CustomTitle extends StatelessWidget {
  final String data;

  const CustomTitle(
    Key? key,
    this.data,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        data,
        style: const TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }
}

Future<void> copyToClipboard(BuildContext context, String addr,
    {bool displaySnackbar = true}) async {
  await Clipboard.setData(ClipboardData(text: addr));
  if (displaySnackbar) {
    final flushbar = Flushbar<void>(
      messageText: const Text('Copied'),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color(0xFF135579),
    );
    await flushbar.show(context);
  }
}

void setValue(TextEditingController controller, String value) {
  controller.text = value;
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: value.length));
}

Future<void> pasteFromClipboard(TextEditingController? controller) async {
  final value = await Clipboard.getData(Clipboard.kTextPlain);
  if (value?.text != null && controller != null) {
    var text = value!.text!.replaceAll('\n', '');
    text = text.replaceAll(' ', '');
    setValue(controller, text);
  }
}

Future<void> openUrl(String url) async {
  // Skip canLaunch(url) check because it fails to open twitter link if twitter client is installed
  // More details here - https://github.com/flutter/flutter/issues/63727
  logger.d('Opening url: $url');
  await launch(url);
}

String generateTxidUrl(
  String txid,
  bool isLiquid, {
  String blindedValues = '',
}) {
  var url = isLiquid
      ? 'https://blockstream.info/liquid/tx/$txid'
      : 'https://blockstream.info/tx/$txid';
  if (blindedValues.isNotEmpty) {
    url = url + '/#blinded=' + blindedValues;
  }

  return url;
}

Future<void> shareTxid(String txid) async {
  await Share.share(txid);
}

Future<void> shareAddress(String address) async {
  logger.d('Sharing address: $address');
  await Share.share(address);
}

enum CurrencyCharAlignment {
  begin,
  end,
}

String strip(String str, String charactersToRemove) {
  final escapedChars = RegExp.escape(charactersToRemove);
  final regex = RegExp(r'^[' + escapedChars + r']+|[' + escapedChars + r']+$');
  final newStr = str.replaceAll(regex, '').trim();
  return newStr;
}

String replaceCharacterOnPosition({
  required String input,
  String char = ' ',
  int position = 3,
  String currencyChar = '',
  CurrencyCharAlignment currencyCharAlignment = CurrencyCharAlignment.begin,
  bool useDecimal = false,
  bool stripLeadingZeros = false,
}) {
  var newValue = input.replaceAll(' ', '').replaceAll(currencyChar, '');
  final dotIndex = newValue.indexOf('.');
  var firstPart = newValue;

  if (stripLeadingZeros) {
    firstPart = strip(firstPart, '0');
  }

  var secondPart = '';

  if (dotIndex > 0) {
    firstPart = newValue.substring(0, dotIndex);
    secondPart = newValue.substring(dotIndex + 1)..replaceAll('0', '');
  }
  secondPart = secondPart.replaceAll('.', '');

  firstPart = String.fromCharCodes(firstPart.runes.toList().reversed);
  var buffer = '';
  for (var i = 0; i < firstPart.length; i++) {
    if (i != 0 && i % position == 0) {
      buffer = ' $buffer';
    }
    buffer = '${String.fromCharCode(firstPart.runes.elementAt(i))}$buffer';
  }
  firstPart = buffer;

  if (useDecimal && secondPart.isNotEmpty) {
    buffer = '';
    for (var i = 0; i < secondPart.length; i++) {
      if (i != 0 && i % position == 0) {
        buffer = ' $buffer';
      }
      buffer = '${String.fromCharCode(secondPart.runes.elementAt(i))}$buffer';
    }

    secondPart = String.fromCharCodes(buffer.runes.toList().reversed);
  }

  secondPart.isEmpty && dotIndex == -1
      ? newValue = firstPart
      : newValue = '$firstPart.$secondPart';

  if (newValue.isNotEmpty) {
    if (currencyCharAlignment == CurrencyCharAlignment.begin &&
        currencyChar.isNotEmpty) {
      newValue = '$currencyChar $newValue';
    } else if (currencyCharAlignment == CurrencyCharAlignment.end &&
        currencyChar.isNotEmpty) {
      newValue = '$newValue $currencyChar';
    }
  }

  return newValue;
}

TextEditingValue fixCursorPosition({
  required TextEditingController controller,
  required String newValue,
}) {
  var baseOffset = controller.value.selection.baseOffset;
  var additionalOffset = 0;
  var breakOffset = 0;
  for (var i = 0; i < newValue.length; i++) {
    if (newValue[i] == ' ') {
      additionalOffset++;
    } else {
      breakOffset++;
    }

    if (breakOffset == baseOffset) {
      break;
    }
  }
  baseOffset = baseOffset + additionalOffset;
  if (baseOffset > newValue.length) {
    baseOffset = newValue.length;
  }

  return TextEditingValue(
    text: newValue,
    selection: TextSelection.collapsed(offset: baseOffset),
  );
}

List<TransItem> selectTransactions(
    int start, int end, Iterable<TransItem> allTxs) {
  var result = <TransItem>[];
  for (final tx in allTxs) {
    if (tx.createdAt.toInt() >= start && tx.createdAt.toInt() < end) {
      result.add(tx);
    }
  }
  return result;
}

List<List<String>> exportTxList(
    Iterable<TransItem> txs, Map<String, Asset> assets) {
  var result = <List<String>>[];

  var usedAssets = SplayTreeSet<String>();
  for (final tx in txs) {
    for (final balance in tx.tx.balances) {
      usedAssets.add(balance.assetId);
    }
  }
  // Keep only known assets where
  usedAssets.remove((String asset) => !assets.containsKey(asset));

  // Header
  var line = <String>[];
  line.add("txid");
  line.add("type");
  line.add("timestamp");
  line.add("network fee");
  line.add("memo");
  for (final asset in usedAssets) {
    line.add(assets[asset]!.name);
  }
  result.add(line);

  // Items
  var txsSorted = txs.toList();
  txsSorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  for (var tx in txsSorted) {
    var line = <String>[];
    line.add(tx.tx.txid);
    line.add(txTypeName(txType(tx.tx)));
    line.add(txDateCsvExport(tx.createdAt.toInt()));
    line.add(amountStr(tx.tx.networkFee.toInt()));
    line.add(tx.tx.memo);
    for (final assetId in usedAssets) {
      final asset = assets[assetId]!;
      var balance = 0;
      tx.tx.balances
          .where((balance) => balance.assetId == asset.assetId)
          .forEach((item) => balance = item.amount.toInt());
      line.add(amountStr(balance, precision: asset.precision));
    }
    result.add(line);
  }

  return result;
}

String convertToCsv(List<List<String>> values) {
  return const ListToCsvConverter().convert(values);
}

Future<void> shareCsv(String data) async {
  final dir = (await getApplicationSupportDirectory()).path;
  final fileName = '$dir/data.csv';
  await File(fileName).writeAsString(data);
  Share.shareFiles([fileName], text: 'Transactions list');
}
