import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
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
    final allTxs = ref.read(allTxsNotifierProvider);
    final txid = allTxs[widget.id]!.tx.txid;
    openTxidUrl(ref, txid, true, unblinded);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTxs = ref.watch(allTxsNotifierProvider);
    final amountProvider = ref.watch(amountToStringProvider);

    final tx = allTxs[widget.id]!;
    final type = txType(tx.tx);
    final typeName = txTypeName(type);
    final timestampStr = txDateStrLong(
        DateTime.fromMillisecondsSinceEpoch(tx.createdAt.toInt()));
    final feeStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: tx.tx.networkFee.toInt(), ticker: 'L-BTC'));

    // vsize is wrong on GDK for single-sig, do not show it here
    final sizeStr = '${tx.tx.size} Bytes';
    final count = tx.hasConfs() ? tx.confs.count : 2;
    final total = tx.hasConfs() ? tx.confs.total : 2;
    final confsStr = '$count/$total';

    final allBalances = tx.tx.balancesAll
        .map((e) => DPopupBalance(
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
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              timestampStr,
              style: const TextStyle(
                color: SideSwapColors.halfBaked,
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
                          color: SideSwapColors.brightTurquoise,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Amount'.tr(),
                        style: const TextStyle(
                          color: SideSwapColors.brightTurquoise,
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
                      DPopupField(name: 'Fee'.tr(), value: feeStr),
                      const DPopupSeparator(),
                      DPopupField(
                          name: 'Size of transaction'.tr(), value: sizeStr),
                      const DPopupSeparator(),
                      DPopupField(
                          name: 'Number of confirmations'.tr(),
                          value: confsStr),
                      const DPopupSeparator(),
                      DPopupField(name: 'Transaction ID'.tr(), value: ''),
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
            color: SideSwapColors.chathamsBlue,
            height: 138,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DPopupLinkButton(
                  text: 'Link to explorer\n(blinded data)'.tr(),
                  onPressed: () => openTx(ref, false),
                ),
                const SizedBox(width: 10),
                DPopupLinkButton(
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
    final allPegsById = ref.watch(allPegsByIdProvider);
    final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
    final liquidAssetId = ref.watch(liquidAssetIdProvider);

    final txItem = allPegsById[id]!;
    final typeName = txItem.peg.isPegIn ? 'Peg-in'.tr() : 'Peg-out'.tr();
    final timestampStr = txDateStrLong(
        DateTime.fromMillisecondsSinceEpoch(txItem.createdAt.toInt()));
    final count = txItem.confs.count;
    final total = txItem.confs.total;
    final isPegIn = txItem.peg.isPegIn;
    final sendAsset = isPegIn ? bitcoinAssetId : liquidAssetId;
    final recvAsset = isPegIn ? liquidAssetId : bitcoinAssetId;
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
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              timestampStr,
              style: const TextStyle(
                color: SideSwapColors.halfBaked,
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
                        color: SideSwapColors.brightTurquoise,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Amount'.tr(),
                      style: const TextStyle(
                        color: SideSwapColors.brightTurquoise,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                DPopupBalance(
                  assetId: sendAsset,
                  amount: -txItem.peg.amountSend.toInt(),
                ),
                DPopupBalance(
                  assetId: recvAsset,
                  amount: txItem.peg.amountRecv.toInt(),
                ),
                const SizedBox(height: 10),
                DPopupField(
                    name: 'Conversion rate'.tr(), value: conversionRateStr),
                const DPopupSeparator(),
                DPopupField(
                    name: 'Number of confirmations'.tr(), value: confsStr),
                const DPopupSeparator(),
                DPopupField(name: 'Transaction ID'.tr(), value: ''),
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
            color: SideSwapColors.chathamsBlue,
            height: 138,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DPopupLinkButton(
                  text: 'Link to explorer\n(pay-in)'.tr(),
                  onPressed: () => openTxidUrl(
                      ref, txItem.peg.txidSend, !txItem.peg.isPegIn, false),
                ),
                const SizedBox(width: 10),
                DPopupLinkButton(
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

class DPopupBalance extends ConsumerWidget {
  const DPopupBalance({
    super.key,
    required this.assetId,
    required this.amount,
  });

  final String assetId;
  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset =
        ref.watch(assetsStateProvider.select((value) => value[assetId]));
    final icon = ref.watch(assetImageProvider).getVerySmallImage(assetId);
    final assetPrecision =
        ref.watch(assetUtilsProvider).getPrecisionForAssetId(assetId: assetId);
    final amountProvider = ref.watch(amountToStringProvider);
    final amountNamed = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: amount,
            ticker: asset?.ticker ?? '',
            precision: assetPrecision,
            forceSign: true));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: SideSwapColors.chathamsBlue,
        ),
        child: Center(
          child: Row(
            children: [
              icon,
              const SizedBox(width: 6),
              Text(asset?.ticker ?? ''),
              const Spacer(),
              Text(amountNamed),
            ],
          ),
        ),
      ),
    );
  }
}

class DPopupField extends StatelessWidget {
  const DPopupField({
    super.key,
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
              color: SideSwapColors.brightTurquoise,
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

class DPopupSeparator extends StatelessWidget {
  const DPopupSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color(0x805294B9),
    );
  }
}

class DPopupLinkButton extends StatelessWidget {
  const DPopupLinkButton({
    super.key,
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
