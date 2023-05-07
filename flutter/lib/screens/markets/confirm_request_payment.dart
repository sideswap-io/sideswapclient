import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/payment_requests_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/pay/widgets/friend_widget.dart';
import 'package:sideswap/screens/markets/confirm_request_payment_success.dart';

class ConfirmRequestPayment extends ConsumerWidget {
  const ConfirmRequestPayment({super.key, required this.request});

  final PaymentRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = request.amount;
    final requestAsset = ref
        .watch(assetsStateProvider.select((value) => value[request.assetId]));
    final ticker = requestAsset?.ticker ?? '';

    return SideSwapPopup(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      onClose: () {
        Navigator.of(context).pop();
      },
      backgroundColor: SideSwapColors.blumine,
      enableInsideTopPadding: false,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Column(
              children: [
                Text(
                  'Confirm the payment'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: FriendWidget(
                    friend: request.friend,
                    backgroundColor: SideSwapColors.chathamsBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    '$amount $ticker',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                CustomBigButton(
                  width: double.maxFinite,
                  height: 54,
                  text: 'CONFIRM'.tr(),
                  backgroundColor: SideSwapColors.brightTurquoise,
                  textColor: Colors.white,
                  onPressed: () async {
                    final navigator =
                        Navigator.of(context, rootNavigator: true);
                    final authenticated =
                        await ref.read(walletProvider).isAuthenticated();
                    if (authenticated) {
                      await navigator.push<void>(
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmRequestPaymentSuccess(request: request),
                        ),
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
                    text: 'CANCEL'.tr(),
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
