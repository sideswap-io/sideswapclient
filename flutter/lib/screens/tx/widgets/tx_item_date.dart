import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TxItemDate extends StatelessWidget {
  const TxItemDate({
    super.key,
    required this.createdAt,
  });

  final int createdAt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMd(context.locale.toLanguageTag()).format(
              DateTime.fromMillisecondsSinceEpoch(createdAt),
            ),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          const Divider(
            height: 1,
            color: Color(0xFF2B6F95),
          ),
        ],
      ),
    );
  }
}
