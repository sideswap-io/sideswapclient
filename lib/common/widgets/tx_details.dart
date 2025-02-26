import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_bottom_buttons.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_column.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row.dart';
import 'package:sideswap/screens/tx/widgets/tx_details_row_notes.dart';
import 'package:sideswap/screens/tx/widgets/tx_image_small.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TxDetails extends ConsumerWidget {
  const TxDetails({super.key, required this.transItem});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountProvider = ref.watch(amountToStringProvider);
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final price = transItemHelper.txTargetPrice();
    final balances = transItemHelper.txBalances();
    final confs = transItemHelper.txConfs();
    final status = transItemHelper.txStatus();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TxImageSmall(assetName: transItemHelper.getTxImageAssetName()),
            const SizedBox(width: 8),
            Text(
              transItemHelper.txTypeName(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        Text(
          transItemHelper.txDateTimeStr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        ...switch (transItemHelper.txType()) {
          TxType.swap => [
            TxDetailsSwap(transItem: transItem),
            const SizedBox(height: 12),
            TxDetailsRow(description: 'Price per unit'.tr(), details: price),
          ],
          TxType.sent => [TxDetailsSent(transItem: transItem)],
          TxType.received => [TxDetailsReceive(transItem: transItem)],
          TxType.internal => [
            TxDetailsSideRow(leftText: 'Asset'.tr(), rightText: 'Amount'.tr()),
            const SizedBox(height: 8),
            TxDetailsBalancesList(transItem: transItem),
          ],
          _ => List<Widget>.generate(balances.length, (index) {
            final balance = balances[index];
            final asset = ref.watch(
              assetsStateProvider.select((value) => value[balance.assetId]),
            );
            final ticker = asset != null ? asset.ticker : kUnknownTicker;
            final balanceStr = amountProvider.amountToString(
              AmountToStringParameters(
                amount: balance.amount.toInt(),
                precision: asset?.precision ?? 8,
              ),
            );

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
          detailsColor:
              (confs.count != 0)
                  ? SideSwapColors.airSuperiorityBlue
                  : Colors.white,
        ),
        ...switch (transItemHelper.txType()) {
          TxType txType when txType != TxType.swap => [
            const SizedBox(height: 14),
            TxDetailsRowNotes(tx: transItem.tx),
          ],
          _ => [const SizedBox()],
        },
        const SizedBox(height: 20),
        const DottedLine(
          dashColor: Colors.white,
          dashGapColor: Colors.transparent,
        ),
        const SizedBox(height: 16),
        TxDetailsColumn(
          description: 'Transaction ID'.tr(),
          details: transItem.tx.txid,
          isCopyVisible: true,
        ),
        const Spacer(),
        SizedBox(
          width: double.maxFinite,
          height: 54,
          child: TxDetailsBottomButtons(id: transItem.tx.txid, isLiquid: true),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

@Deprecated('Not used')
class TxDetailsSwapAssetList extends StatelessWidget {
  const TxDetailsSwapAssetList({super.key, required this.transItem});

  final TransItem transItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TxDetailsSideRow(leftText: 'Asset'.tr(), rightText: 'Amount'.tr()),
        const SizedBox(height: 8),
        TxDetailsAllBalancesList(transItem: transItem),
      ],
    );
  }
}

class TxDetailsSwap extends ConsumerWidget {
  const TxDetailsSwap({super.key, required this.transItem});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TxDetailsSideRow(leftText: 'Delivered'.tr(), rightText: ''),
        const SizedBox(height: 8),
        TxDetailsSwapDelivered(transItem: transItem),
        const SizedBox(height: 12),
        TxDetailsSideRow(leftText: 'Received'.tr(), rightText: ''),
        const SizedBox(height: 8),
        TxDetailsSwapReceived(transItem: transItem),
      ],
    );
  }
}

class TxDetailsSwapReceived extends ConsumerWidget {
  const TxDetailsSwapReceived({super.key, required this.transItem});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final deliveredData = transItemHelper.getSwapReceivedAmount();
    final assetImageRepository = ref.watch(assetImageRepositoryProvider);
    final assetImage = assetImageRepository.getSmallImage(
      deliveredData.assetId,
    );
    final amountColor =
        deliveredData.amount.contains('+')
            ? SideSwapColors.menthol
            : SideSwapColors.bitterSweet;

    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 132),
      decoration: const BoxDecoration(
        color: SideSwapColors.prussianBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 20, height: 20, child: assetImage),
                  const SizedBox(width: 4),
                  Text(
                    deliveredData.ticker,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                  ),
                ],
              ),
              Text(
                deliveredData.amount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TxDetailsSwapDelivered extends ConsumerWidget {
  const TxDetailsSwapDelivered({super.key, required this.transItem});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final deliveredData = transItemHelper.getSwapDeliveredAmount();
    final assetImageRepository = ref.watch(assetImageRepositoryProvider);
    final assetImage = assetImageRepository.getSmallImage(
      deliveredData.assetId,
    );
    final amountColor =
        deliveredData.amount.contains('+')
            ? SideSwapColors.menthol
            : SideSwapColors.bitterSweet;

    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 132),
      decoration: const BoxDecoration(
        color: SideSwapColors.prussianBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 20, height: 20, child: assetImage),
                  const SizedBox(width: 4),
                  Text(
                    deliveredData.ticker,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                  ),
                ],
              ),
              Text(
                deliveredData.amount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TxDetailsReceive extends ConsumerWidget {
  const TxDetailsReceive({required this.transItem, super.key});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TxDetailsSideRow(leftText: 'Asset'.tr(), rightText: 'Amount'.tr()),
        const SizedBox(height: 8),
        TxDetailsBalancesList(transItem: transItem),
      ],
    );
  }
}

class TxDetailsSent extends ConsumerWidget {
  const TxDetailsSent({required this.transItem, super.key});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TxDetailsSideRow(leftText: 'Asset'.tr(), rightText: 'Amount'.tr()),
        const SizedBox(height: 8),
        TxDetailsBalancesList(transItem: transItem, removeFeeAsset: true),
        const SizedBox(height: 18),
        TxDetailsSideRow(leftText: 'Network Fee'.tr(), rightText: ''),
        const SizedBox(height: 8),
        TxDetailsNetworkFee(transItem: transItem),
      ],
    );
  }
}

class TxDetailsNetworkFee extends ConsumerWidget {
  const TxDetailsNetworkFee({super.key, required this.transItem});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final networkFeeData = transItemHelper.getNetworkFee();
    final assetImageRepository = ref.watch(assetImageRepositoryProvider);
    final assetImage = assetImageRepository.getSmallImage(
      networkFeeData.assetId,
    );
    final amountColor =
        networkFeeData.networkFeeAmount.contains('+')
            ? SideSwapColors.menthol
            : SideSwapColors.bitterSweet;

    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 132),
      decoration: const BoxDecoration(
        color: SideSwapColors.prussianBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 20, height: 20, child: assetImage),
                  const SizedBox(width: 4),
                  Text(
                    networkFeeData.ticker,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                  ),
                ],
              ),
              Text(
                networkFeeData.networkFeeAmount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: amountColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TxDetailsSideRow extends StatelessWidget {
  const TxDetailsSideRow({
    required this.leftText,
    required this.rightText,
    super.key,
  });

  final String leftText;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leftText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        Text(
          rightText,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
      ],
    );
  }
}

class TxDetailsBalancesList extends ConsumerWidget {
  const TxDetailsBalancesList({
    super.key,
    required this.transItem,
    this.removeFeeAsset = false,
  });

  final TransItem transItem;
  final bool removeFeeAsset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final assetImageRepository = ref.watch(assetImageRepositoryProvider);

    final balancesData = transItemHelper.getBalances(
      removeFeeAsset: removeFeeAsset,
    );

    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 132),
      decoration: const BoxDecoration(
        color: SideSwapColors.prussianBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverList.builder(
            itemBuilder: (context, index) {
              final amount = balancesData[index].amount;
              final ticker = balancesData[index].ticker;
              final assetId = balancesData[index].assetId;
              final amountColor =
                  amount.contains('+')
                      ? SideSwapColors.menthol
                      : SideSwapColors.bitterSweet;
              final assetImage = assetImageRepository.getSmallImage(assetId);
              return TxDetailsAssetListItem(
                index: index,
                assetImage: assetImage,
                ticker: ticker,
                amount: amount,
                amountColor: amountColor,
              );
            },
            itemCount: balancesData.length,
          ),
        ],
      ),
    );
  }
}

@Deprecated('Not used')
class TxDetailsAllBalancesList extends ConsumerWidget {
  const TxDetailsAllBalancesList({required this.transItem, super.key});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final assetImageRepository = ref.watch(assetImageRepositoryProvider);

    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 132),
      decoration: const BoxDecoration(
        color: SideSwapColors.prussianBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverList.builder(
            itemBuilder: (context, index) {
              final amount = transItemHelper.getBalancesAll()[index].amount;
              final ticker = transItemHelper.getBalancesAll()[index].ticker;
              final assetId = transItemHelper.getBalancesAll()[index].assetId;
              final amountColor =
                  amount.contains('+')
                      ? SideSwapColors.menthol
                      : SideSwapColors.bitterSweet;
              final assetImage = assetImageRepository.getSmallImage(assetId);
              return TxDetailsAssetListItem(
                index: index,
                assetImage: assetImage,
                ticker: ticker,
                amount: amount,
                amountColor: amountColor,
              );
            },
            itemCount: transItemHelper.getBalancesAll().length,
          ),
        ],
      ),
    );
  }
}

class TxDetailsAssetListItem extends StatelessWidget {
  const TxDetailsAssetListItem({
    super.key,
    required this.index,
    required this.assetImage,
    required this.ticker,
    required this.amount,
    required this.amountColor,
  });

  final int index;
  final Widget assetImage;
  final String ticker;
  final String amount;
  final MaterialColor amountColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 44,
        child: Column(
          children: [
            const SizedBox(height: 1),
            switch (index) {
              0 => const SizedBox(),
              _ => Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.glacier.withValues(alpha: 0.4),
              ),
            },
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20, height: 20, child: assetImage),
                    const SizedBox(width: 4),
                    Text(
                      ticker,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
