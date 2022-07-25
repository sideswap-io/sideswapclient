import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class TxDetailsRowNotes extends ConsumerWidget {
  const TxDetailsRowNotes({
    super.key,
    required this.tx,
  });

  final Tx tx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memo = ref.watch(walletProvider).txMemo(tx);
    return SizedBox(
      width: 343,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My notes',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF00C5FF),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 222,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      memo.isEmpty ? 'Only visible to you' : memo,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF709EBA),
                      ),
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
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: SvgPicture.asset(
                      'assets/copy.svg',
                      width: 18,
                      height: 18,
                      color: const Color(0xFF00C5FF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
