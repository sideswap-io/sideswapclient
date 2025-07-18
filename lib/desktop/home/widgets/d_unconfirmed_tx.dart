import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/widgets/d_transparent_button.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_amount.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_confs.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_date.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_header.dart';
import 'package:sideswap/desktop/widgets/d_tx_blinded_url_icon_button.dart';
import 'package:sideswap/desktop/widgets/d_flexes_row.dart';
import 'package:sideswap/desktop/widgets/d_tx_history_type.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DUnconfirmedTx extends StatelessWidget {
  const DUnconfirmedTx({super.key});

  static DateFormat dateFormatDate = DateFormat('y-MM-dd ');
  static DateFormat dateFormatTime = DateFormat('HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 43,
          child: DefaultTextStyle(
            style: const TextStyle().merge(
              Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: SideSwapColors.glacier),
            ),
            child: DFlexesRow(
              flexes: const [183, 97, 205, 205, 125, 26],
              children: [
                DTxHistoryHeader(text: 'Date'.tr()),
                DTxHistoryHeader(text: 'Type'.tr()),
                DTxHistoryHeader(text: 'Sent'.tr()),
                DTxHistoryHeader(text: 'Received'.tr()),
                DTxHistoryHeader(text: 'Confirmations'.tr()),
                DTxHistoryHeader(text: 'Link'.tr()),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 0, color: SideSwapColors.jellyBean),
        Consumer(
          builder: (context, ref, _) {
            final updatedTxs = ref.watch(updatedTxsNotifierProvider);
            final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
            final bitcoinAssetId = ref.watch(bitcoinAssetIdProvider);

            return switch (updatedTxs.isEmpty) {
              true => Padding(
                padding: const EdgeInsets.only(top: 63),
                child: Text(
                  'No unconfirmed transactions'.tr(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: SideSwapColors.glacier,
                  ),
                ),
              ),
              false => Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CustomScrollView(
                    slivers: [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          final transItem = updatedTxs[index];

                          return Consumer(
                            builder: (context, ref, child) {
                              final transItemHelper = ref.watch(
                                transItemHelperProvider(transItem),
                              );

                              return DTransparentButton(
                                onPressed: () {
                                  final allPegsById = ref.read(
                                    allPegsByIdProvider,
                                  );
                                  ref
                                      .read(desktopDialogProvider)
                                      .showTx(
                                        transItem,
                                        isPeg: allPegsById.containsKey(
                                          transItem.id,
                                        ),
                                      );
                                },
                                child: DFlexesRow(
                                  flexes: const [183, 97, 205, 205, 125, 26],
                                  children: [
                                    DTxHistoryDate(
                                      dateFormatDate: dateFormatDate,
                                      dateFormatTime: dateFormatTime,
                                      tx: transItem,
                                      dateTextStyle: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                      timeTextStyle: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: SideSwapColors
                                                .airSuperiorityBlue,
                                          ),
                                    ),
                                    DTxHistoryType(
                                      transItem: transItem,
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    DTxHistoryAmount(
                                      balance: transItemHelper.getSentBalance(
                                        liquidAssetId,
                                        bitcoinAssetId,
                                      ),
                                      multipleOutputs: transItemHelper
                                          .getSentMultipleOutputs(),
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    DTxHistoryAmount(
                                      balance: transItemHelper.getRecvBalance(
                                        liquidAssetId,
                                        bitcoinAssetId,
                                      ),
                                      multipleOutputs: transItemHelper
                                          .getRecvMultipleOutputs(),
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    DTxHistoryConfs(
                                      tx: transItem,
                                      textStyle: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                    DTxBlindedUrlIconButton(
                                      txid: transItem.tx.txid,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        itemCount: updatedTxs.length,
                      ),
                    ],
                  ),
                ),
              ),
            };
          },
        ),
      ],
    );
  }
}
