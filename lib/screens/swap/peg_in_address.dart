import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/receive/widgets/peg_in_widget.dart';

class PegInAddress extends HookConsumerWidget {
  const PegInAddress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Send BTC to this address'.tr(),
        centerTitle: true,
        onPressed: () {
          ref.read(pageStatusProvider.notifier).setStatus(Status.registered);
        },
      ),
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(child: PegInWidet()),
    );
  }
}
