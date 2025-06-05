import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/send_asset_provider.dart';

class SendAssetIdListener extends ConsumerWidget {
  const SendAssetIdListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sendAssetIdNotifierProvider, (_, _) {});

    return Container();
  }
}
