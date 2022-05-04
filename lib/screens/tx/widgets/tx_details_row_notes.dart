import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class TxDetailsRowNotes extends ConsumerWidget {
  const TxDetailsRowNotes({
    Key? key,
    required this.tx,
  }) : super(key: key);

  final Tx tx;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memo = ref.watch(walletProvider).txMemo(tx);
    return SizedBox(
      width: 343.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My notes',
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00C5FF),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SizedBox(
                  width: 222.w,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      memo.isEmpty ? 'Only visible to you' : memo,
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF709EBA),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SizedBox(
                  width: 26.w,
                  height: 26.w,
                  child: TextButton(
                    onPressed: () {
                      ref.read(walletProvider).editTxMemo(tx);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: SvgPicture.asset(
                      'assets/copy.svg',
                      width: 18.w,
                      height: 18.w,
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
