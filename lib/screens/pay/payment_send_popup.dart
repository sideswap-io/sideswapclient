import 'package:dotted_line/dotted_line.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_detail.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_receiver.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class PaymentSendPopup extends ConsumerWidget {
  const PaymentSendPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createTxState = ref.watch(createTxStateNotifierProvider);
    final createdTx = switch (createTxState) {
      CreateTxStateCreated(createdTx: final createdTx) => createdTx,
      _ => null,
    };

    final createdTxHelper = ref.watch(createdTxHelperProvider(createdTx));

    return SideSwapPopup(
      onClose: () {
        if (createdTx != null && createdTx.addressees.length > 1) {
          // multiple outputs cleanup
          ref.invalidate(outputsReaderNotifierProvider);
          ref.invalidate(outputsCreatorProvider);
          ref.invalidate(selectedWalletAccountAssetNotifierProvider);
          ref.invalidate(paymentSendAmountParsedNotifierProvider);
          ref.invalidate(defaultCurrencyTickerProvider);
          ref.invalidate(createTxStateNotifierProvider);
          ref.invalidate(sendTxStateNotifierProvider);
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
          return;
        }

        ref.read(walletProvider).goBack();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirm transaction'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          switch (createdTx) {
            CreatedTx(addressees: final addresses) => () {
              final listHeight = (addresses.length * 79.0);
              final containerHeight = listHeight > 180 ? 180.0 : listHeight;
              return Container(
                height: containerHeight,
                constraints: const BoxConstraints(
                  minHeight: 44,
                  maxHeight: 180,
                ),
                decoration: const BoxDecoration(
                  color: SideSwapColors.prussianBlue,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemBuilder: (context, index) {
                        return RowTxReceiver(
                          address: addresses[index].address,
                          assetId: addresses[index].assetId,
                          amount: addresses[index].amount.toInt(),
                          index: index,
                        );
                      },
                      itemCount: addresses.length,
                    ),
                  ],
                ),
              );
            }(),
            _ => const SizedBox(),
          },
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: DottedLine(
              dashColor: SideSwapColors.jellyBean,
              dashGapColor: Colors.transparent,
              dashLength: 1.0,
              dashGapLength: 0.0,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: const BoxDecoration(
              color: SideSwapColors.chathamsBlue,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 10,
                top: 10,
              ),
              child: Column(
                children: [
                  RowTxDetail(
                    name: 'Fee per byte'.tr(),
                    value: createdTxHelper.feePerByte(),
                  ),
                  RowTxDetail(
                    name: 'Transaction size'.tr(),
                    value: createdTxHelper.txSize(),
                  ),
                  RowTxDetail(
                    name: 'Discount vsize'.tr(),
                    value: createdTxHelper.vsize(),
                  ),
                  RowTxDetail(
                    name: 'Network Fee'.tr(),
                    value: createdTxHelper.networkFee(),
                  ),
                  ...switch (createdTxHelper.hasServerFee()) {
                    true => [
                      RowTxDetail(
                        name: 'Server fee'.tr(),
                        value: createdTxHelper.serverFee(),
                      ),
                    ],
                    _ => [const SizedBox()],
                  },
                  RowTxDetail(
                    name: 'Number of inputs'.tr(),
                    value: createdTxHelper.inputCount(),
                  ),
                  RowTxDetail(
                    name: 'Number of outputs'.tr(),
                    value: createdTxHelper.outputCount(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 40),
            child: Consumer(
              builder: (context, ref, _) {
                final sendTxState = ref.watch(sendTxStateNotifierProvider);
                final buttonEnabled =
                    (sendTxState == const SendTxStateEmpty() &&
                        createdTx != null);

                return CustomBigButton(
                  width: MediaQuery.of(context).size.width,
                  height: 54,
                  backgroundColor: SideSwapColors.brightTurquoise,
                  text: 'SEND'.tr(),
                  onPressed:
                      buttonEnabled
                          ? () async {
                            if (await ref
                                .read(walletProvider)
                                .isAuthenticated()) {
                              ref
                                  .read(walletProvider)
                                  .assetSendConfirmCommon(createdTx);
                            }
                          }
                          : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
