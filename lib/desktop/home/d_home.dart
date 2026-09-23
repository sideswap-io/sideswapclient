import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_wallet_assets_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_top_overview_toolbar.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/providers/wallet.dart';

/// The least height the wallet assets panel is squeezed to: its 58 px header,
/// the list's 8 + 8 of padding, and three 53 px rows.
///
/// The wallet showed two assets at the supported floor before ADR-0014
/// decision 11, because the transactions panel took its whole height out of
/// the page column first and left the assets panel about 199 px.
const double _walletAssetsPanelMinHeight = 58 + 16 + 3 * 53;

class DHome extends HookConsumerWidget {
  const DHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Column(
            children: [
              DTopOverviewToolbar(),
              SizedBox(height: 16),
              // The transactions panel is the one that yields: it is capped at
              // what is left once the assets list has its lower bound, so a
              // short window costs the transaction tabs their tab-body height
              // instead of costing the wallet its assets.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final txMaxHeight = txAndOrdersPanelMaxHeight(
                      available: constraints.maxHeight,
                      gap: kTxAndOrdersPanelGap,
                      companionMinHeight: _walletAssetsPanelMinHeight,
                    );
                    return Column(
                      children: [
                        const Expanded(child: DWalletAssetsPanel()),
                        const SizedBox(height: kTxAndOrdersPanelGap),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: txMaxHeight),
                          child: const DTxAndOrdersPanel(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final syncComplete = ref.watch(syncCompleteStateProvider);
            return switch (syncComplete) {
              false => const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              _ => const SizedBox(),
            };
          },
        ),
      ],
    );
  }
}
