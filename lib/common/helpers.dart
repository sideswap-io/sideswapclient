import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/market_helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/screens/qr_scanner/address_qr_scanner.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

const int kCoin = 100000000;
const int kMaxCoins = 100000000 * kCoin;

const int kDefaultPrecision = 8;

const String kBitcoinTicker = 'BTC';
const String kLiquidBitcoinTicker = 'L-BTC';
const String kTetherTicker = 'USDt';
const String kEurxTicker = 'EURx';
const String kUnknownTicker = '???';

const String kPackageSideswap = 'sideswap';
const String kPackageGdk = 'GDK';

const int kOneMinute = 60;
const int kTenMinutes = kOneMinute * 10;
const int kHalfHour = kTenMinutes * 3;
const int kOneHour = kHalfHour * 2;
const int kSixHours = kOneHour * 6;
const int kTwelveHours = kSixHours * 2;
const int kOneDay = kSixHours * 4;
const int kOneWeek = kOneDay * 7;
const int kInfTtl = 0;

final unlimitedTtl = 'Inf'.tr();

List<int> availableTtlValues(bool offline) {
  return [
    kTenMinutes,
    kHalfHour,
    kOneHour,
    kSixHours,
    kTwelveHours,
    kOneDay,
    kOneWeek,
    if (offline) kInfTtl,
  ];
}

const int kEditPriceMaxPercent = 10;
const int kEditPriceMaxTrackingPercent = 1;

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

int toIntAmount(double amount, {int precision = 8}) {
  return (amount * pow(10, precision)).round();
}

String priceStr(double price, bool priceInLiquid, {int? precision}) {
  final newPrice = Decimal.tryParse('$price') ?? Decimal.zero;

  if (priceInLiquid) {
    return newPrice.toStringAsFixed(8);
  }

  if (precision != null) {
    return newPrice.toStringAsFixed(precision);
  }

  return newPrice.toStringAsPrecision(7);
}

String priceStrForMarket(double price, MarketType market) {
  return priceStr(
      price, market == MarketType.token || market == MarketType.amp);
}

// Same as priceStr but without trailing zeros
String priceStrForEdit(double price) {
  return price.toString();
}

final shortFormat = DateFormat('MMM d, yyyy');

// Returns timestamp in UTC
DateTime parseTimestamp(String timestamp) {
  return DateTime.parse('${timestamp}Z');
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

Future<void> copyToClipboard(
  BuildContext context,
  String text, {
  bool displaySnackbar = true,
  String? suffix,
}) async {
  await Clipboard.setData(ClipboardData(text: text)).then((value) {
    if (displaySnackbar) {
      final displayString =
          suffix != null ? '${'Copied'.tr()}: $suffix' : 'Copied'.tr();
      final flushbar = Flushbar<void>(
        messageText: Text(displayString),
        duration: const Duration(seconds: 3),
        backgroundColor: SideSwapColors.chathamsBlue,
      );
      flushbar.show(context);
    }
  });
}

void setControllerValue(TextEditingController? controller, String value) {
  controller?.text = value;
  controller?.selection =
      TextSelection.fromPosition(TextPosition(offset: value.length));
}

Future<void> handlePasteSingleLine(TextEditingController? controller) async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  final text = data?.text;
  if (text != null) {
    final textUpdated = text.replaceAll('\n', '').trim();
    setControllerValue(controller, textUpdated);
  }
}

Future<void> openUrl(
  String url, {
  LaunchMode mode = LaunchMode.platformDefault,
}) async {
  // Skip canLaunch(url) check because it fails to open twitter link if twitter client is installed
  // More details here - https://github.com/flutter/flutter/issues/63727
  logger.d('Opening url: $url');
  final uri = Uri.tryParse(url);
  if (uri != null) {
    await launchUrl(uri, mode: mode);
  }
}

String generateTxidUrl(
  String txid,
  bool isLiquid, {
  String blindedValues = '',
  bool testnet = false,
}) {
  String baseUrl;
  if (!testnet) {
    baseUrl = isLiquid
        ? 'https://blockstream.info/liquid'
        : 'https://blockstream.info';
  } else {
    baseUrl = isLiquid
        ? 'https://blockstream.info/liquidtestnet'
        : 'https://blockstream.info/testnet';
  }

  var url = '$baseUrl/tx/$txid';
  if (blindedValues.isNotEmpty) {
    url = '$url/#blinded=$blindedValues';
  }

  return url;
}

String generateAssetUrl({required String? assetId, required bool testnet}) {
  final baseUrl = testnet
      ? 'https://blockstream.info/liquidtestnet'
      : 'https://blockstream.info/liquid';
  return '$baseUrl/asset/${assetId ?? ''}';
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

Future<void> shareLogFile(String name, RenderBox box) async {
  final dir = (await getApplicationSupportDirectory()).path;
  final path = '$dir/$name';
  try {
    await Share.shareXFiles(
      [XFile(path, mimeType: "text/plain")],
    );
  } on PlatformException {
    logger.e('share log failed');
  }
}

int boolToInt(bool a) {
  return a ? 1 : 0;
}

int compareBool(bool a, bool b) {
  return boolToInt(a).compareTo(boolToInt(b));
}

double indexPriceToTrackerValue(double value) {
  return roundTrackerValue((value - 1) * 100);
}

double trackerValueToIndexPrice(double value) {
  return 1 + value / 100;
}

double roundTrackerValue(double value) {
  return (value * 100).round().toDouble() / 100.0;
}

final _formatterThousandsSep = NumberFormat("#,##0.00");

String formatThousandsSep(double value) {
  return _formatterThousandsSep.format(value).replaceAll(',', ' ');
}

final alphaNumFormatter =
    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"));

Widget getAddressQrScanner({required bool bitcoinAddress}) {
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    return AddressQrScanner(
        expectedAddress: bitcoinAddress ? QrCodeAddressType.bitcoin : null);
  } else {
    return Container();
  }
}
