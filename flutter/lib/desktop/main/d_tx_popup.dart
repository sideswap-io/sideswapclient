import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';

class DTxPopup extends ConsumerStatefulWidget {
  const DTxPopup({
    super.key,
    required this.id,
  });

  final String id;

  @override
  DTxPopupState createState() => DTxPopupState();
}

class DTxPopupState extends ConsumerState<DTxPopup> {
  final scrollController = ScrollController();

  void openTx(WidgetRef ref, bool unblinded) {
    final wallet = ref.read(walletProvider);
    final txid = wallet.allTxs[widget.id]!.tx.txid;
    openTxidUrl(ref, txid, true, unblinded);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final tx = wallet.allTxs[widget.id]!;
    final type = txType(tx.tx);
    final typeName = txTypeName(type);
    final timestampStr = txDateStrLong(
        DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt()));
    final feeStr = amountStrNamed(tx.tx.networkFee.toInt(), 'L-BTC');
    // vsize is wrong on GDK for single-sig, do not show it here
    final sizeStr = '${tx.tx.size} Bytes';
    final count = tx.hasConfs() ? tx.confs.count : 2;
    final total = tx.hasConfs() ? tx.confs.total : 2;
    final confsStr = '$count/$total';

    final allBalances = tx.tx.balancesAll
        .map((e) => _Balance(
              assetId: e.assetId,
              amount: e.amount.toInt(),
            ))
        .toList();

    return DPopupWithClose(
      width: 580,
      height: 606,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TxImageSmall(txType: type),
              const SizedBox(width: 8),
              Text(
                typeName,
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              timestampStr,
              style: const TextStyle(
                color: Color(0xFF83B4D2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Asset'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF00C5FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Amount'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF00C5FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  height: min(allBalances.length, 3) * 42,
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView(
                      controller: scrollController,
                      children: allBalances,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _Field(name: 'Fee'.tr(), value: feeStr),
                      _Separator(),
                      _Field(name: 'Size of transaction'.tr(), value: sizeStr),
                      _Separator(),
                      _Field(
                          name: 'Number of confirmations'.tr(),
                          value: confsStr),
                      _Separator(),
                      _Field(name: 'Transaction ID'.tr(), value: ''),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tx.tx.txid,
                            ),
                          ),
                          const SizedBox(width: 40),
                          IconButton(
                            onPressed: () =>
                                copyToClipboard(context, tx.tx.txid),
                            icon: SvgPicture.asset('assets/copy2.svg',
                                width: 22, height: 22),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            color: const Color(0xFF135579),
            height: 138,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LinkButton(
                  text: 'Link to explorer\n(blinded data)'.tr(),
                  onPressed: () => openTx(ref, false),
                ),
                const SizedBox(width: 10),
                _LinkButton(
                  text: 'Link to explorer\n(unblinded data)'.tr(),
                  onPressed: () => openTx(ref, true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DPegPopup extends ConsumerWidget {
  const DPegPopup({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final txItem = wallet.allPegsById[id]!;
    final typeName = txItem.peg.isPegIn ? 'Peg-in'.tr() : 'Peg-out'.tr();
    final timestampStr = txDateStrLong(
        DateTime.fromMillisecondsSinceEpoch(txItem.createdAt.toInt()));
    final count = txItem.confs.count;
    final total = txItem.confs.total;
    final isPegIn = txItem.peg.isPegIn;
    final sendAsset =
        isPegIn ? wallet.bitcoinAssetId() : wallet.liquidAssetId();
    final recvAsset =
        isPegIn ? wallet.liquidAssetId() : wallet.bitcoinAssetId();
    final confsStr = txItem.hasConfs() ? '$count/$total' : 'Complete'.tr();
    final amountSend = txItem.peg.amountSend.toInt();
    final amountRecv = txItem.peg.amountRecv.toInt();
    final conversionRate = (amountSend != 0 && amountRecv != 0)
        ? amountRecv * 100 / amountSend
        : 0;
    final conversionRateStr = '${conversionRate.toStringAsFixed(2)}%';

    return DPopupWithClose(
      width: 580,
      height: 606,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PegImageSmall(isPegIn: txItem.peg.isPegIn),
              const SizedBox(width: 8),
              Text(
                typeName,
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              timestampStr,
              style: const TextStyle(
                color: Color(0xFF83B4D2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Asset'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF00C5FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Amount'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF00C5FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _Balance(
                  assetId: sendAsset,
                  amount: -txItem.peg.amountSend.toInt(),
                ),
                _Balance(
                  assetId: recvAsset,
                  amount: txItem.peg.amountRecv.toInt(),
                ),
                const SizedBox(height: 10),
                _Field(name: 'Conversion rate'.tr(), value: conversionRateStr),
                _Separator(),
                _Field(name: 'Number of confirmations'.tr(), value: confsStr),
                _Separator(),
                _Field(name: 'Transaction ID'.tr(), value: ''),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        txItem.peg.txidSend,
                      ),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () =>
                          copyToClipboard(context, txItem.peg.txidRecv),
                      icon: SvgPicture.asset('assets/copy2.svg',
                          width: 22, height: 22),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            color: const Color(0xFF135579),
            height: 138,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LinkButton(
                  text: 'Link to explorer\n(pay-in)'.tr(),
                  onPressed: () => openTxidUrl(
                      ref, txItem.peg.txidSend, !txItem.peg.isPegIn, false),
                ),
                const SizedBox(width: 10),
                _LinkButton(
                  text: 'Link to explorer\n(pay-out)'.tr(),
                  onPressed: txItem.peg.hasTxidRecv()
                      ? () => openTxidUrl(
                          ref, txItem.peg.txidRecv, txItem.peg.isPegIn, false)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Balance extends ConsumerWidget {
  const _Balance({
    required this.assetId,
    required this.amount,
  });

  final String assetId;
  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.read(walletProvider);
    final asset = wallet.assets[assetId]!;
    final icon = wallet.assetImagesVerySmall[assetId]!;
    final amountNamed = amountStrNamed(amount, asset.ticker,
        forceSign: true, precision: asset.precision);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color(0xFF135579),
        ),
        child: Center(
          child: Row(
            children: [
              icon,
              const SizedBox(width: 6),
              Text(asset.ticker),
              const Spacer(),
              Text(amountNamed),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF00C5FF),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0x805294B9),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DCustomTextBigButton(
      width: 245,
      height: 60,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          SvgPicture.asset(
            'assets/share3.svg',
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 16),
          Text(text.toUpperCase(), textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
