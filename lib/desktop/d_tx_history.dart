import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/widgets/d_transparent_button.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';

class DesktopTxHistory extends StatefulWidget {
  const DesktopTxHistory({
    Key? key,
    this.horizontalPadding = 32,
    this.newTxsOnly = false,
  }) : super(key: key);

  final double horizontalPadding;
  final bool newTxsOnly;

  @override
  _DesktopTxHistoryState createState() => _DesktopTxHistoryState();
}

class _DesktopTxHistoryState extends State<DesktopTxHistory> {
  static DateFormat dateFormatDate = DateFormat('y-MM-dd ');
  static DateFormat dateFormatTime = DateFormat('HH:mm:ss');

  Balance getSentBalance(
      TransItem tx, TxType txType, String liquidBitcoin, String bitcoin) {
    if (tx.hasPeg()) {
      return Balance(
          amount: tx.peg.amountSend,
          assetId: tx.peg.isPegIn ? bitcoin : liquidBitcoin);
    }

    switch (txType) {
      case TxType.sent:
        final balance = tx.tx.balances.length == 1
            ? tx.tx.balances.first
            : tx.tx.balances.firstWhere((e) => e.assetId != liquidBitcoin);
        final amount = balance.assetId == liquidBitcoin
            ? -balance.amount - tx.tx.networkFee
            : -balance.amount;
        return Balance(amount: amount, assetId: balance.assetId);
      case TxType.swap:
        final balance = tx.tx.balances.firstWhere((e) => e.amount < 0);
        return Balance(amount: -balance.amount, assetId: balance.assetId);
      case TxType.received:
      case TxType.internal:
      case TxType.unknown:
        return Balance();
    }
  }

  Balance getRecvBalance(
      TransItem tx, TxType txType, String liquidBitcoin, String bitcoin) {
    if (tx.hasPeg()) {
      return Balance(
          amount: tx.peg.amountRecv,
          assetId: tx.peg.isPegIn ? liquidBitcoin : bitcoin);
    }

    switch (txType) {
      case TxType.received:
      case TxType.swap:
        final balance = tx.tx.balances.firstWhere((e) => e.amount > 0);
        return Balance(amount: balance.amount, assetId: balance.assetId);
      case TxType.sent:
      case TxType.internal:
      case TxType.unknown:
        return Balance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final wallet = ref.watch(walletProvider);
        final txList = widget.newTxsOnly
            ? wallet.getAllNewTxsSorted()
            : wallet.getAllTxsSorted();

        final separator = Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          child: Container(
            height: 1,
            color: const Color(0xFF2B6F95),
          ),
        );

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding, vertical: 12),
              child: const _Row(list: [
                _Header(text: 'Date'),
                _Header(text: 'Wallet'),
                _Header(text: 'Type'),
                _Header(text: 'Sent'),
                _Header(text: 'Received'),
                _Header(text: 'Confirmations'),
                _Header(text: 'Link'),
              ]),
            ),
            Expanded(
              child: txList.isEmpty
                  ? Column(
                      children: [
                        separator,
                        const SizedBox(height: 12),
                        Text(
                          'No transactions'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF87C1E1),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      controller: ScrollController(),
                      itemBuilder: (BuildContext context, int index) {
                        final tx = txList[index];
                        final type =
                            tx.hasPeg() ? TxType.unknown : txType(tx.tx);
                        final sentBalance = getSentBalance(tx, type,
                            wallet.liquidAssetId(), wallet.bitcoinAssetId());
                        final recvBalance = getRecvBalance(tx, type,
                            wallet.liquidAssetId(), wallet.bitcoinAssetId());

                        return Column(
                          children: [
                            separator,
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.horizontalPadding,
                                  vertical: 1),
                              child: DTransparentButton(
                                child: _Row(
                                  list: [
                                    _Date(
                                        dateFormatDate: dateFormatDate,
                                        dateFormatTime: dateFormatTime,
                                        tx: tx),
                                    _Wallet(tx: tx),
                                    _Type(tx: tx, txType: type),
                                    _Amount(
                                        balance: sentBalance, wallet: wallet),
                                    _Amount(
                                        balance: recvBalance, wallet: wallet),
                                    _Confs(tx: tx),
                                    _Link(txid: tx.id),
                                  ],
                                ),
                                onPressed: () {
                                  desktopShowTx(context, tx.id,
                                      isPeg: wallet.allPegsById
                                          .containsKey(tx.id));
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: txList.length,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    Key? key,
    required this.list,
  }) : super(key: key);

  final List<Widget> list;

  @override
  Widget build(BuildContext context) {
    const flexes = [183, 97, 137, 210, 210, 122, 46];
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(
          flex: flexes[index],
          child: list[index],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF87C1E1),
        fontSize: 12,
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date({
    Key? key,
    required this.dateFormatDate,
    required this.dateFormatTime,
    required this.tx,
  }) : super(key: key);

  final DateFormat dateFormatDate;
  final DateFormat dateFormatTime;
  final TransItem tx;

  @override
  Widget build(BuildContext context) {
    final timestampCopy =
        DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt());
    return Row(children: [
      Text(dateFormatDate.format(timestampCopy)),
      Text(
        dateFormatTime.format(timestampCopy),
        style: const TextStyle(
          color: Color(0xFF709EBA),
        ),
      ),
    ]);
  }
}

class _Wallet extends StatelessWidget {
  const _Wallet({
    Key? key,
    required this.tx,
  }) : super(key: key);

  final TransItem tx;

  @override
  Widget build(BuildContext context) {
    final isAmp = tx.tx.balances.any((e) => e.account.amp);
    final isRegular = tx.tx.balances.any((e) => !e.account.amp);
    final accountName = tx.hasPeg()
        ? ''
        : ((isAmp && isRegular) ? 'Regular/AMP' : (isAmp ? 'AMP' : 'Regular'));
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(accountName),
    );
  }
}

class _Type extends StatelessWidget {
  const _Type({
    Key? key,
    required this.tx,
    required this.txType,
  }) : super(key: key);

  final TransItem tx;
  final TxType txType;

  @override
  Widget build(BuildContext context) {
    final icon = tx.hasPeg()
        ? PegImageSmall(isPegIn: tx.peg.isPegIn)
        : TxImageSmall(txType: txType);
    final typeName =
        tx.hasPeg() ? pegTypeName(tx.peg.isPegIn) : txTypeName(txType);
    return Row(
      children: [
        icon,
        const SizedBox(width: 11),
        Text(typeName),
      ],
    );
  }
}

class _Link extends ConsumerWidget {
  const _Link({
    Key? key,
    required this.txid,
  }) : super(key: key);

  final String txid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => openTxidUrl(ref, txid, true, true),
        icon: SvgPicture.asset(
          'assets/link2.svg',
          width: 14,
          height: 14,
        ),
      ),
    );
  }
}

class _Confs extends StatelessWidget {
  const _Confs({
    Key? key,
    required this.tx,
  }) : super(key: key);

  final TransItem tx;

  @override
  Widget build(BuildContext context) {
    final count = tx.hasConfs() ? tx.confs.count : 2;
    final total = tx.hasConfs() ? tx.confs.total : 2;
    final confirmed = count == total;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text('$count/$total',
          style: TextStyle(
            color:
                confirmed ? const Color(0xFF87C0E0) : const Color(0xFFFFFFFF),
          )),
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    Key? key,
    required this.balance,
    required this.wallet,
  }) : super(key: key);

  final Balance balance;
  final WalletChangeNotifier wallet;

  @override
  Widget build(BuildContext context) {
    if (balance.amount == 0) {
      return Container();
    }
    final asset = wallet.assets[balance.assetId]!;
    final amount =
        amountStr(balance.amount.toInt(), precision: asset.precision);
    return Row(
      children: [
        wallet.assetImagesVerySmall[balance.assetId]!,
        const SizedBox(width: 8),
        Text('$amount ${asset.ticker}'),
      ],
    );
  }
}
