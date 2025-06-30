import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class TxMemo extends HookConsumerWidget {
  const TxMemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTxPopupItem = ref.watch(currentTxPopupItemNotifierProvider);

    final focusNode = useFocusNode();

    return SideSwapScaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: 176,
          child: currentTxPopupItem.match(() => const SizedBox(), (txid) {
            return Column(
              children: [
                CustomAppBar(
                  onPressed: () {
                    ref.read(walletProvider).goBack();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Row(
                          children: [
                            Text(
                              'My notes'.tr(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: SideSwapColors.brightTurquoise,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Only visible to you'.tr(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: SideSwapColors.airSuperiorityBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: HookConsumer(
                          builder: (context, ref, child) {
                            final allTxs = ref.watch(allTxsNotifierProvider);

                            final transItem = allTxs[txid];

                            if (transItem == null) {
                              return const SizedBox();
                            }

                            final controller = useTextEditingController(
                              text: transItem.tx.memo,
                            );

                            final updateMemoCallback = useCallback((
                              String value,
                            ) {
                              final msg = To();
                              msg.setMemo = To_SetMemo();
                              // FIXME someday: Use correct account type here
                              msg.setMemo.account = Account.REG;
                              msg.setMemo.txid = txid;
                              msg.setMemo.memo = value;
                              ref.read(walletProvider).sendMsg(msg);
                              transItem.tx.memo = value;
                              ref
                                  .read(allTxsNotifierProvider.notifier)
                                  .updateList(txs: [transItem]);
                            });

                            return TextFormField(
                              focusNode: focusNode,
                              controller: controller,
                              onChanged: (value) => updateMemoCallback(value),
                              onFieldSubmitted: (value) {
                                updateMemoCallback(value);
                                ref.read(walletProvider).goBack();
                              },
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF002241),
                              ),
                              decoration: const SideSwapInputDecoration(
                                hintText: '',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
