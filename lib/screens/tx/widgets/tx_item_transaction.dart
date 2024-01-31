import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/markets/widgets/regular_flag.dart';
import 'package:sideswap/screens/markets/widgets/sideswap_chip.dart';
import 'package:sideswap/screens/tx/widgets/multiple_outputs_icon.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TxItemTransaction extends ConsumerWidget {
  const TxItemTransaction({
    super.key,
    required this.transItem,
    required this.accountType,
  });

  final TransItem transItem;
  final AccountType accountType;
  static const double itemHeight = 50.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final txImageAssetName = transItemHelper.getTxImageAssetName();
    final status = transItemHelper.txStatus();
    final confsColor = transItem.hasConfs()
        ? SideSwapColors.cornFlower
        : SideSwapColors.brightTurquoise;

    return SizedBox(
      height: 108,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      txImageAssetName,
                      width: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      transItemHelper.txTypeName(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const Spacer(),
                switch (transItem) {
                  TransItem transItem
                      when transItem.hasTx() &&
                              transItem.account.id == AccountType.reg.id ||
                          transItem.hasPeg() =>
                    const RegularFlag(
                      textStyle: TextStyle(
                        color: SideSwapColors.brightTurquoise,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.12,
                      ),
                    ),
                  TransItem transItem
                      when transItem.hasTx() &&
                          transItem.account.id == AccountType.amp.id =>
                    const AmpFlag(
                      textStyle: TextStyle(
                        color: SideSwapColors.brightTurquoise,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.12,
                      ),
                    ),
                  _ => const SizedBox(),
                },
                const SizedBox(width: 10),
                Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: confsColor,
                      ),
                ),
                SizedBox(
                  width: 16,
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: confsColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                return switch (transItemHelper.txType()) {
                  TxType.swap ||
                  TxType.unknown =>
                    TxItemSwapBalance(transItem: transItem),
                  TxType.internal =>
                    TxItemInternalSwapBalance(transItem: transItem),
                  TxType.sent => TxItemSendBalance(transItem: transItem),
                  TxType.received =>
                    TxItemReceivedBalance(transItem: transItem),
                  TxType.pegOut => TxItemPegOutBalance(transItem: transItem),
                  TxType.pegIn => TxItemPegInBalance(transItem: transItem),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

// On mobile, we could show the sent and received amounts, which should be the same with an internal label
class TxItemInternalSwapBalance extends ConsumerWidget {
  const TxItemInternalSwapBalance({
    required this.transItem,
    super.key,
  });

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox();
    // FIXME (malcolmpl): balancesAll in transItem can hold multiple assets
    // final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    // final balances = transItemHelper.txSwapBalancesString();
    // final balanceColor = balances.recvBalance.contains('+')
    //     ? SideSwapColors.menthol
    //     : Colors.white;

    // return Column(
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Text(
    //           '',
    //           style: Theme.of(context)
    //               .textTheme
    //               .bodyMedium
    //               ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
    //         ),
    //         switch (balances.recvBalance.isEmpty) {
    //           true => const SizedBox(),
    //           _ => Text(
    //               transItemHelper.txToAction(),
    //               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    //                   fontSize: 14, color: SideSwapColors.cornFlower),
    //             ),
    //         },
    //       ],
    //     ),
    //     Row(
    //       children: [
    //         const Spacer(),
    //         Text(
    //           balances.recvBalance,
    //           style: Theme.of(context)
    //               .textTheme
    //               .bodyLarge
    //               ?.copyWith(color: balanceColor),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}

class TxItemOutputsChip extends StatelessWidget {
  const TxItemOutputsChip({
    super.key,
    required this.amount,
  });

  final int amount;

  @override
  Widget build(BuildContext context) {
    return SideSwapChip(
      decoration: ShapeDecoration(
        color: SideSwapColors.bitterSweet,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      text: '$amount outputs',
      padding: const EdgeInsets.symmetric(horizontal: 6),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        letterSpacing: 0.12,
      ),
    );
  }
}

class TxItemSwapBalance extends ConsumerWidget {
  const TxItemSwapBalance({
    required this.transItem,
    super.key,
  });

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final balances = transItemHelper.txSwapBalancesString();
    final balanceColor = balances.recvBalance.contains('+')
        ? SideSwapColors.menthol
        : Colors.white;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transItemHelper.txFromAction(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
            ),
            switch (balances.recvBalance.isEmpty) {
              true => const SizedBox(),
              _ => Text(
                  transItemHelper.txToAction(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14, color: SideSwapColors.cornFlower),
                ),
            },
          ],
        ),
        Row(
          children: [
            Text(
              balances.sendBalance,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Text(
              balances.recvBalance,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: balanceColor),
            ),
          ],
        ),
      ],
    );
  }
}

class TxItemSendBalance extends ConsumerWidget {
  const TxItemSendBalance({
    required this.transItem,
    super.key,
  });

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final balanceStr = transItemHelper.txSendBalance();
    final balanceColor =
        balanceStr.contains('+') ? SideSwapColors.menthol : Colors.white;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transItemHelper.txFromAction(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              balanceStr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: balanceColor),
            ),
          ],
        ),
      ],
    );
  }
}

class TxItemReceivedBalance extends ConsumerWidget {
  const TxItemReceivedBalance({super.key, required this.transItem});

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final balance = transItemHelper.txReceivedBalance();
    final balanceColor =
        balance.recvBalance.contains('+') || balance.multipleOutputs
            ? SideSwapColors.menthol
            : Colors.white;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              transItemHelper.txToAction(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              balance.recvBalance,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: balanceColor),
            ),
            ...switch (balance.multipleOutputs) {
              true => [const SizedBox(width: 9), const MultipleOutputsIcon()],
              _ => [const SizedBox()],
            }
          ],
        ),
      ],
    );
  }
}

class TxItemPegOutBalance extends ConsumerWidget {
  const TxItemPegOutBalance({
    required this.transItem,
    super.key,
  });

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final balanceStr = transItemHelper.txPegOutBalance();
    final balanceColor =
        balanceStr.contains('+') ? SideSwapColors.menthol : Colors.white;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transItemHelper.txFromAction(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
            ),
            Text(
              transItemHelper.txToAction(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              balanceStr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: balanceColor),
            ),
            SizedBox(
              width: 100,
              child: ExtendedText(
                transItemHelper.txPegOutAddress(),
                maxLines: 1,
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
                overflowWidget: TextOverflowWidget(
                  position: TextOverflowPosition.middle,
                  align: TextOverflowAlign.center,
                  child: Text(
                    '...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14, color: SideSwapColors.cornFlower),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TxItemPegInBalance extends ConsumerWidget {
  const TxItemPegInBalance({
    required this.transItem,
    super.key,
  });

  final TransItem transItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));
    final balanceStr = transItemHelper.txPegInBalance();
    final balanceColor =
        balanceStr.contains('+') ? SideSwapColors.menthol : Colors.white;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transItemHelper.txFromAction(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
            ),
            Text(
              transItemHelper.txToAction(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              balanceStr,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: balanceColor),
            ),
            SizedBox(
              width: 100,
              child: ExtendedText(
                transItemHelper.txPegInAddress(),
                textAlign: TextAlign.end,
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14, color: SideSwapColors.cornFlower),
                overflowWidget: TextOverflowWidget(
                  position: TextOverflowPosition.middle,
                  align: TextOverflowAlign.center,
                  child: Text(
                    '...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14, color: SideSwapColors.cornFlower),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
