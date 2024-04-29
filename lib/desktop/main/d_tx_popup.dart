import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/tx_details.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxPopup extends HookConsumerWidget {
  const DTxPopup({
    super.key,
    required this.transItem,
  });

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountProvider = ref.watch(amountToStringProvider);

    final transItemHelper = ref.watch(transItemHelperProvider(transItem));

    final balances = transItemHelper.txBalances();
    final confs = transItemHelper.txConfs();
    final status = transItemHelper.txStatus();

    final openTxCallback = useCallback(({bool unblinded = false}) {
      openTxidUrl(ref, transItem.tx.txid, true, unblinded);
    });

    return DPopupWithClose(
      width: 634,
      height: 660,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TxImageSmall(
                        assetName: transItemHelper.getTxImageAssetName()),
                    const SizedBox(width: 8),
                    Text(
                      transItemHelper.txTypeName(),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    transItemHelper.txDateTimeStr(),
                    style: const TextStyle(
                      color: SideSwapColors.halfBaked,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ...switch (transItemHelper.txType()) {
                  TxType.swap => [
                      TxDetailsSwap(transItem: transItem),
                      const SizedBox(height: 14),
                      TxDetailsRow(
                        description: 'Price per unit'.tr(),
                        details: transItemHelper.txTargetPrice(),
                      ),
                    ],
                  TxType.sent => [
                      TxDetailsSent(transItem: transItem),
                    ],
                  TxType.received => [
                      TxDetailsReceive(transItem: transItem),
                    ],
                  TxType.internal => [
                      TxDetailsSideRow(
                          leftText: 'Asset'.tr(), rightText: 'Amount'.tr()),
                      const SizedBox(height: 8),
                      TxDetailsBalancesList(transItem: transItem),
                    ],
                  _ => List<Widget>.generate(balances.length, (index) {
                      final balance = balances[index];
                      final asset = ref.watch(assetsStateProvider
                          .select((value) => value[balance.assetId]));
                      final ticker =
                          asset != null ? asset.ticker : kUnknownTicker;
                      final balanceStr = amountProvider.amountToString(
                          AmountToStringParameters(
                              amount: balance.amount.toInt(),
                              precision: asset?.precision ?? 8));

                      return TxDetailsRow(
                        description: 'Amount'.tr(),
                        details: '$balanceStr $ticker',
                      );
                    }),
                },
                const SizedBox(height: 14),
                TxDetailsRow(
                  description: 'Status'.tr(),
                  details: status,
                  detailsColor: (confs.count != 0)
                      ? SideSwapColors.airSuperiorityBlue
                      : Colors.white,
                ),
                const SizedBox(height: 14),
                const DPopupSeparator(),
                const SizedBox(height: 14),
                DPopupField(name: 'Transaction ID'.tr(), value: ''),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transItem.tx.txid,
                      ),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () =>
                          copyToClipboard(context, transItem.tx.txid),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DPopupLinkButton(
                    text: 'Link to explorer\n(blinded data)'.tr(),
                    onPressed: () => openTxCallback(),
                  ),
                  const SizedBox(width: 10),
                  DPopupLinkButton(
                    text: 'Link to explorer\n(unblinded data)'.tr(),
                    onPressed: () => openTxCallback(unblinded: true),
                  ),
                ],
              ),
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
    required this.transItem,
  });

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

    final typeName = transItem.peg.isPegIn ? 'Peg-in'.tr() : 'Peg-out'.tr();
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final count = transItem.confs.count;
    final total = transItem.confs.total;
    final isPegIn = transItem.peg.isPegIn;
    final sendAsset = isPegIn ? bitcoinAssetId : liquidAssetId;
    final recvAsset = isPegIn ? liquidAssetId : bitcoinAssetId;
    final confsStr = transItem.hasConfs() ? '$count/$total' : 'Complete'.tr();
    final amountSend = transItem.peg.amountSend.toInt();
    final amountRecv = transItem.peg.amountRecv.toInt();
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
              PegImageSmall(isPegIn: transItem.peg.isPegIn),
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
              transItemHelper.txDateTimeStr(),
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
                  amount: -transItem.peg.amountSend.toInt(),
                ),
                DPopupBalance(
                  assetId: recvAsset,
                  amount: transItem.peg.amountRecv.toInt(),
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
                        transItem.peg.txidSend,
                      ),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () =>
                          copyToClipboard(context, transItem.peg.txidRecv),
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
                  onPressed: () => openTxidUrl(ref, transItem.peg.txidSend,
                      !transItem.peg.isPegIn, false),
                ),
                const SizedBox(width: 10),
                DPopupLinkButton(
                  text: 'Link to explorer\n(pay-out)'.tr(),
                  onPressed: transItem.peg.hasTxidRecv()
                      ? () => openTxidUrl(ref, transItem.peg.txidRecv,
                          transItem.peg.isPegIn, true)
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
          color: SideSwapColors.prussianBlue,
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
    return Row(
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
    this.width = 280,
    this.height = 60,
  });

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return DCustomTextBigButton(
      width: width,
      height: height,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/share3.svg',
            width: 22,
            height: 22,
          ),
          const Spacer(),
          Text(text.toUpperCase(), textAlign: TextAlign.start),
          const Spacer(),
        ],
      ),
    );
  }
}
