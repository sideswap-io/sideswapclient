import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/screens/pay/payment_select_asset.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DPaymentSelectAsset extends HookConsumerWidget {
  const DPaymentSelectAsset({
    super.key,
    required this.availableAssets,
    required this.disabledAssets,
    this.onSelected,
  });

  final Iterable<String> availableAssets;
  final Iterable<String> disabledAssets;
  final ValueChanged<Asset>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAsyncEffect(() async {
      ref
          .read(paymentAvailableAssetsProvider.notifier)
          .setAvailableAssets(availableAssets);
      ref
          .read(paymentDisabledAssetsProvider.notifier)
          .setDisabledAssets(disabledAssets);

      return;
    }, const []);

    return DPopupWithClose(
      width: 580,
      height: 710,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Text(
              'Select currency'.tr(),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 32),
            Flexible(child: PaymentSelectAssetTabBar(onSelected: onSelected)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
