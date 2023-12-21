import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryDate extends StatelessWidget {
  const DTxHistoryDate({
    super.key,
    required this.dateFormatDate,
    required this.dateFormatTime,
    required this.tx,
    this.dateTextStyle = const TextStyle(
      color: SideSwapColors.airSuperiorityBlue,
    ),
    this.timeTextStyle = const TextStyle(
      color: SideSwapColors.airSuperiorityBlue,
    ),
  });

  final DateFormat dateFormatDate;
  final DateFormat dateFormatTime;
  final TransItem tx;
  final TextStyle? dateTextStyle;
  final TextStyle? timeTextStyle;

  @override
  Widget build(BuildContext context) {
    final timestampCopy =
        DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt());
    return Row(children: [
      Text(
        dateFormatDate.format(timestampCopy),
        style: dateTextStyle,
      ),
      Text(
        dateFormatTime.format(timestampCopy),
        style: timeTextStyle,
      ),
    ]);
  }
}
