import 'package:candlesticks/src/models/candle.dart';
import 'package:candlesticks/src/theme/theme_data.dart';
import 'package:candlesticks/src/utils/helper_functions.dart';
import 'package:flutter/material.dart';

class CandleInfoText extends StatelessWidget {
  const CandleInfoText({super.key, required this.candle});

  final Candle candle;

  String numberFormat(int value) {
    return "${value < 10 ? 0 : ""}$value";
  }

  String dateFormatter(DateTime date) {
    return "${date.year}-${numberFormat(date.month)}-${numberFormat(date.day)} ${numberFormat(date.hour)}:${numberFormat(date.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: dateFormatter(candle.date),
        style: TextStyle(color: Theme.of(context).grayColor, fontSize: 12),
        children: <TextSpan>[
          const TextSpan(text: "   O: "),
          TextSpan(
            text: HelperFunctions.priceToString(candle.open),
            style: TextStyle(
              color:
                  candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed,
            ),
          ),
          const TextSpan(text: "   H: "),
          TextSpan(
            text: HelperFunctions.priceToString(candle.high),
            style: TextStyle(
              color:
                  candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed,
            ),
          ),
          const TextSpan(text: "   L: "),
          TextSpan(
            text: HelperFunctions.priceToString(candle.low),
            style: TextStyle(
              color:
                  candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed,
            ),
          ),
          const TextSpan(text: "   C: "),
          TextSpan(
            text: HelperFunctions.priceToString(candle.close),
            style: TextStyle(
              color:
                  candle.isBull
                      ? Theme.of(context).primaryGreen
                      : Theme.of(context).primaryRed,
            ),
          ),
          const TextSpan(text: "\n\n"),
          const TextSpan(text: "Volume: "),
          TextSpan(text: candle.volume.toString()),
        ],
      ),
    );
  }
}
