import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

enum TxType {
  received,
  sent,
  swap,
  internal,
  unknown,
}

TxType txType(Tx tx) {
  var anyPositive = false;
  var anyNegative = false;
  var anyRegular = false;
  var anyAmp = false;
  for (var balance in tx.balances) {
    if (balance.amount > 0) {
      anyPositive = true;
    }
    if (balance.amount < 0) {
      anyNegative = true;
    }
    if (balance.account.amp) {
      anyAmp = true;
    } else {
      anyRegular = true;
    }
  }
  if (tx.balances.length == 2 &&
      anyPositive &&
      anyPositive &&
      (tx.balances[0].assetId != tx.balances[1].assetId)) {
    return TxType.swap;
  }

  if (tx.balances.length == 1 &&
      tx.balances.first.amount == -tx.networkFee &&
      tx.balances.first.assetId == AccountAsset.liquidAssetId) {
    return TxType.internal;
  }
  if (anyPositive && !anyNegative) {
    return TxType.received;
  }
  if (anyNegative && !anyPositive) {
    return TxType.sent;
  }
  if (anyAmp && anyRegular) {
    return TxType.internal;
  }

  return TxType.unknown;
}

IconData txIcon(TxType type) {
  switch (type) {
    case TxType.received:
      return Icons.arrow_circle_down;
    case TxType.sent:
      return Icons.arrow_circle_up;
    case TxType.swap:
      return Icons.swap_horiz;
    case TxType.internal:
      return Icons.swap_horiz;
    case TxType.unknown:
      return Icons.device_unknown;
  }
}

String txTypeName(TxType type) {
  switch (type) {
    case TxType.received:
      return 'Received'.tr();
    case TxType.sent:
      return 'Sent'.tr();
    case TxType.swap:
      return 'Swap'.tr();
    case TxType.internal:
      return 'Internal'.tr();
    case TxType.unknown:
      return 'Unknown'.tr();
  }
}

String pegTypeName(bool isPegIn) {
  if (isPegIn) {
    return 'Peg-In'.tr();
  }
  return 'Peg-Out'.tr();
}

int txAssetAmount(Tx tx, String assetId, AccountType accountType) {
  var sum = 0;
  for (var balance in tx.balances) {
    if (balance.assetId == assetId &&
        getAccountType(balance.account) == accountType) {
      sum += balance.amount.toInt();
    }
  }
  return sum;
}

class WalletTxMemo extends StatefulWidget {
  const WalletTxMemo({Key? key}) : super(key: key);

  @override
  _WalletTxMemoState createState() => _WalletTxMemoState();
}

class _WalletTxMemoState extends State<WalletTxMemo> {
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild(context));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void afterBuild(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: 176.h,
          child: Column(
            children: [
              const CustomAppBar(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Row(
                        children: [
                          Text(
                            'My notes'.tr(),
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF00C5FF),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Only visible to you'.tr(),
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF709EBA),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final tx = ref.watch(walletProvider).txDetails.tx;
                          final initialValue =
                              ref.watch(walletProvider).txMemo(tx);
                          return TextFormField(
                            focusNode: _focusNode,
                            initialValue: initialValue,
                            onChanged: (value) =>
                                ref.read(walletProvider).onTxMemoChanged(value),
                            onFieldSubmitted: (value) {
                              ref.read(walletProvider).goBack();
                            },
                            style: GoogleFonts.roboto(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF002241),
                            ),
                            decoration: const SideSwapInputDecoration(
                              hintText: '',
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
