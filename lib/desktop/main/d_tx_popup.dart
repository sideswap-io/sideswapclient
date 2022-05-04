import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';

class DTxPopup extends ConsumerWidget {
  const DTxPopup({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  void openTx(WidgetRef ref, bool unblinded) {
    openTxidUrl(ref, id, true, unblinded);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final tx = wallet.allTxs[id]!;
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
                Column(
                  children: tx.tx.balances
                      .map((e) => _Balance(
                            assetId: e.assetId,
                            amount: e.amount.toInt(),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _Field(name: 'Fee'.tr(), value: feeStr),
                      const _Separator(),
                      _Field(name: 'Size of transaction'.tr(), value: sizeStr),
                      const _Separator(),
                      _Field(
                          name: 'Number of confirmations'.tr(),
                          value: confsStr),
                      const _Separator(),
                      _Field(name: 'Transaction ID'.tr(), value: ''),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tx.id,
                            ),
                          ),
                          const SizedBox(width: 40),
                          IconButton(
                            onPressed: () => copyToClipboard(context, tx.id),
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
    Key? key,
    required this.id,
  }) : super(key: key);

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
                const _Separator(),
                _Field(name: 'Number of confirmations'.tr(), value: confsStr),
                const _Separator(),
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
    Key? key,
    required this.assetId,
    required this.amount,
  }) : super(key: key);

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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color(0xFF135579),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    Key? key,
    required this.name,
    required this.value,
  }) : super(key: key);

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
  const _Separator({Key? key}) : super(key: key);

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
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DCustomTextBigButton(
      width: 245,
      height: 60,
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
      onPressed: onPressed,
    );
  }
}
