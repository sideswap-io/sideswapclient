import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/main/d_send_popup.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/widgets/payment_send_popup_address_amount_item.dart';

class RowTxReceiver extends ConsumerWidget {
  const RowTxReceiver({
    super.key,
    required this.address,
    required this.assetId,
    required this.amount,
    required this.index,
  });

  final String address;
  final String assetId;
  final int amount;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetsStateProvider)[assetId];
    final icon = ref
        .watch(assetImageRepositoryProvider)
        .getCustomImage(assetId, width: 24, height: 24);
    final amountProvider = ref.watch(amountToStringProvider);
    final amountStr = amountProvider.amountToString(
      AmountToStringParameters(
        amount: amount,
        precision: asset?.precision ?? 8,
      ),
    );

    final isMobile = (!FlavorConfig.isDesktop);

    return switch (isMobile) {
      true => PaymentSendPopupAddressAmountItem(
        address: address,
        amount: amountStr,
        ticker: asset?.ticker ?? '',
        index: index,
        icon: icon,
      ),
      _ => DSendPopupAddressAmountItem(
        address: address,
        amount: amountStr,
        ticker: asset?.ticker ?? '',
        index: index,
        icon: icon,
      ),
    };
  }
}
