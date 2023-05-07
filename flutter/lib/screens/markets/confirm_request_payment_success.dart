import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/payment_requests_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ConfirmRequestPaymentSuccess extends ConsumerWidget {
  const ConfirmRequestPaymentSuccess({
    super.key,
    required this.request,
  });

  final PaymentRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = request.amount;
    final requestAsset = ref
        .watch(assetsStateProvider.select((value) => value[request.assetId]));
    final ticker = requestAsset?.ticker ?? '';

    return SideSwapPopup(
      onWillPop: () async {
        return false;
      },
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Success!'.tr(),
        descriptionWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'DONE_FRIEND_PAYMENT'.tr(args: [request.friend.contact.name]),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '$amount $ticker',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: SideSwapColors.brightTurquoise,
                ),
              ),
            ),
          ],
        ),
        buttonText: 'DONE'.tr(),
        onPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
