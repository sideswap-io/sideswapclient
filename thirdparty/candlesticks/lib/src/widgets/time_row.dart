import 'package:candlesticks/src/constant/view_constants.dart';
import 'package:candlesticks/src/models/candle.dart';
import 'package:candlesticks/src/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimeRow extends StatefulWidget {
  final List<Candle> candles;
  final double candleWidth;
  final double? indicatorX;
  final DateTime? indicatorTime;
  final int index;

  const TimeRow({
    super.key,
    required this.candles,
    required this.candleWidth,
    this.indicatorX,
    required this.indicatorTime,
    required this.index,
  });

  @override
  State<TimeRow> createState() => _TimeRowState();
}

class _TimeRowState extends State<TimeRow> {
  final ScrollController _scrollController = ScrollController();

  /// Calculates number of candles between two time indicator
  int _stepCalculator() {
    return switch (widget.candleWidth) {
      final candleWidth when candleWidth < 3 => 31,
      final candleWidth when candleWidth < 5 => 19,
      final candleWidth when candleWidth < 7 => 13,
      _ => 9,
    };
  }

  /// Calculates [DateTime] of a given candle index
  DateTime _timeCalculator(int step, int index, Duration dif) {
    int candleNumber = (step + 1) ~/ 2 - 10 + index * step + -1;
    DateTime? time;
    if (candleNumber < 0) {
      time = widget
          .candles[math.min(step + candleNumber, widget.candles.length - 1)]
          .date
          .add(dif);
    } else if (candleNumber < widget.candles.length) {
      time = widget.candles[candleNumber].date;
    } else {
      final stepsBack = (candleNumber - widget.candles.length) ~/ step + 1;
      final newIndex = candleNumber - stepsBack * step;
      time = widget
          .candles[math.max(0, math.min(newIndex, widget.candles.length - 1))]
          .date
          .subtract(dif * stepsBack);
    }
    return time;
  }

  /// Fomats number as 2 digit integer
  String numberFormat(int value) {
    return "${value < 10 ? 0 : ""}$value";
  }

  /// Day/month text widget
  Text _monthDayText(DateTime time, Color color) {
    return Text(
      "${numberFormat(time.month)}/${numberFormat(time.day)}",
      style: TextStyle(color: color, fontSize: 12),
    );
  }

  /// Hour/minute text widget
  Text _hourMinuteText(DateTime time, Color color) {
    return Text(
      "${numberFormat(time.hour)}:${numberFormat(time.minute)}",
      style: TextStyle(color: color, fontSize: 12),
    );
  }

  String dateFormatter(DateTime date) {
    return "${date.year}-${numberFormat(date.month)}-${numberFormat(date.day)} ${numberFormat(date.hour)}:${numberFormat(date.minute)}";
  }

  @override
  void didUpdateWidget(TimeRow oldWidget) {
    if (oldWidget.index != widget.index ||
        oldWidget.candleWidth != widget.candleWidth) {
      _scrollController.jumpTo((widget.index + 10) * widget.candleWidth);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    int step = _stepCalculator();
    final dif = widget.candles[0].date.difference(
      widget.candles[math.min(step, widget.candles.length - 1)].date,
    );
    return Padding(
      padding: const EdgeInsets.only(right: priceBarWidth + 1.0),
      child: Stack(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.candles.length,
            scrollDirection: Axis.horizontal,
            itemExtent: step * widget.candleWidth,
            controller: _scrollController,
            reverse: true,
            itemBuilder: (context, index) {
              DateTime time = _timeCalculator(step, index, dif);
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      width: 0.05,
                      color: Theme.of(context).grayColor,
                    ),
                  ),
                  dif.compareTo(const Duration(days: 1)) > 0
                      ? _monthDayText(time, Theme.of(context).scaleNumbersColor)
                      : _hourMinuteText(
                        time,
                        Theme.of(context).scaleNumbersColor,
                      ),
                ],
              );
            },
          ),
          widget.indicatorX == null
              ? Container()
              : Positioned(
                bottom: 0,
                left: math.max(widget.indicatorX! - 55, 0),
                child: Container(
                  color: Theme.of(context).hoverIndicatorBackgroundColor,
                  width: 110,
                  height: 20,
                  child: Center(
                    child: Text(
                      dateFormatter(widget.indicatorTime!),
                      style: TextStyle(
                        color: Theme.of(context).hoverIndicatorTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
