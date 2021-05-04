import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

const int kCoin = 100000000;
const int kMaxCoins = 100000000 * kCoin;

const int kDefaultPrecision = 8;

const String kBitcoinTicker = 'BTC';
const String kLiquidBitcoinTicker = 'L-BTC';
const String kTetherTicker = 'USDt';
const String kUnknownTicker = '???';

const String kPackageSideswap = 'sideswap';
const String kPackageLibwally = 'libwally-core';
const String kPackageGdk = 'GDK';

String amountStr(int amount, {bool forceSign = false}) {
  if (amount == null) {
    return '-';
  }
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
  return '${sign}${bitAmount}.${satAmountStr}';
}

String amountStrNamed(int amount, String ticker, {bool forceSign = false}) {
  final valueStr = amountStr(amount, forceSign: forceSign);
  return '$valueStr $ticker';
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

void showMessage(BuildContext context, String title, String message) {
  final alert =
      AlertDialog(title: Text(title), content: Text(message), actions: <Widget>[
    TextButton(
      child: Text('OK').tr(),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
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

  CustomTitle(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          data,
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Future<void> copyToClipboard(BuildContext context, String addr,
    {bool displaySnackbar = true}) async {
  await Clipboard.setData(ClipboardData(text: addr));
  if (displaySnackbar) {
    final flushbar = Flushbar<Widget>(
      messageText: Text('Copied'),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0xFF135579),
    );
    await flushbar.show(context);
  }
}

void setValue(TextEditingController controller, String value) {
  controller.text = value;
  controller.selection =
      TextSelection.fromPosition(TextPosition(offset: value.length));
}

void setMaxAmount(TextEditingController controller, int amount) {
  setValue(controller, amountStr(amount ?? 0));
}

Future<void> pasteFromClipboard(TextEditingController controller) async {
  final value = await Clipboard.getData(Clipboard.kTextPlain);
  if (value?.text != null) {
    var text = value.text.replaceAll('\n', '');
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

String generateTxidUrl(String txid, bool isLiquid, String blindedValues) {
  var url = isLiquid
      ? 'https://blockstream.info/liquid/tx/$txid'
      : 'https://blockstream.info/tx/$txid';
  if (blindedValues != null) {
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

String replaceCharacterOnPosition({
  @required String input,
  String char = ' ',
  int position = 3,
  String currencyChar = '',
  CurrencyCharAlignment currencyCharAlignment = CurrencyCharAlignment.begin,
  bool useDecimal = false,
}) {
  var newValue = input.replaceAll(' ', '').replaceAll(currencyChar, '');
  final dotIndex = newValue.indexOf('.');
  var firstPart = newValue;
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
  firstPart = '$buffer';

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
    if (currencyCharAlignment == CurrencyCharAlignment.begin) {
      newValue = '$currencyChar $newValue';
    } else if (currencyCharAlignment == CurrencyCharAlignment.end) {
      newValue = '$newValue $currencyChar';
    }
  }

  return newValue;
}
