import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/custom_button.dart';
import 'package:sideswap/models/wallet.dart';

class ShareTxidButtons extends ConsumerWidget {
  final bool isLiquid;
  final String txid;

  const ShareTxidButtons({
    super.key,
    required this.isLiquid,
    required this.txid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () =>
                  ref.read(walletProvider).openTxUrl(txid, isLiquid, false),
              child: const Text('LINK TO EXTERNAL EXPLORER').tr(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: SizedBox(
            height: 50,
            child: CustomButton(
              onPressed: () => shareTxid(txid),
              text: 'SHARE'.tr(),
            ),
          ),
        ),
      ],
    );
  }
}

class ShareAddress extends StatelessWidget {
  const ShareAddress({
    super.key,
    required this.addr,
  });

  final String addr;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
          text: 'Copy'.tr(),
          onPressed: () => copyToClipboard(context, addr),
        ),
        CustomButton(
          text: 'Share'.tr(),
          onPressed: () => shareAddress(addr),
        ),
      ],
    );
  }
}

class CopyButton extends StatelessWidget {
  final String value;

  const CopyButton({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.copy,
        size: 32,
      ),
      onPressed: () => copyToClipboard(context, value),
    );
  }
}
