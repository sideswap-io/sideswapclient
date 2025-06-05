import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/home/widgets/d_wallet_assets_panel.dart';
import 'package:sideswap/desktop/home/widgets/d_top_overview_toolbar.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';
import 'package:sideswap/providers/wallet.dart';

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
              Flexible(child: DWalletAssetsPanel()),
              SizedBox(height: 16),
              DTxAndOrdersPanel(),
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
