import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/providers/wallet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TxDetailsRowNotes extends HookConsumerWidget {
  const TxDetailsRowNotes({super.key, required this.tx});

  final Tx tx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My notes'.tr(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              tx.memo.isEmpty ? 'Only visible to you'.tr() : tx.memo,
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: SideSwapColors.airSuperiorityBlue,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SizedBox(
            width: 26,
            height: 26,
            child: TextButton(
              onPressed: () {
                ref.read(walletProvider).editTxMemo(tx);
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: SvgPicture.asset(
                'assets/copy.svg',
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  SideSwapColors.brightTurquoise,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
