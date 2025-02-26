import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TxItemDate extends StatelessWidget {
  const TxItemDate({super.key, required this.createdAt});

  final int createdAt;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMMMd(
        context.locale.toLanguageTag(),
      ).format(DateTime.fromMillisecondsSinceEpoch(createdAt)),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
    );
  }
}
