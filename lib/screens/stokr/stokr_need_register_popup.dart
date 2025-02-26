import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/desktop/stokr/d_stokr_need_register_popup.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class StokrNeedRegisterPopup extends HookConsumerWidget {
  const StokrNeedRegisterPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO (malcolmpl): Old markets
    // final selectedAccountAsset =
    //     ref.watch(marketSelectedAccountAssetStateProvider);
    final AccountAsset? selectedAccountAsset = null;

    final asset = ref.watch(assetsStateProvider)[selectedAccountAsset?.assetId];

    return SideSwapPopup(
      onClose: () {
        ref.read(walletProvider).goBack();
      },
      child: Center(
        child: Column(
          children: [
            const StokrErrorIcon(),
            const SizedBox(height: 32),
            Text(
              'Please complete the following steps on STOKR:'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const StokrStepsContainer(),
            const SizedBox(height: 16),
            WarningRowText('KYC verification may take up to 24 hours'.tr()),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: CustomBigButton(
                width: double.infinity,
                height: 54,
                backgroundColor: SideSwapColors.brightTurquoise,
                onPressed: () {
                  if (asset != null) {
                    openUrl(asset.domainAgentLink);
                  }
                },
                child: Text(
                  'REGISTER ON STOKR'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StokrErrorIcon extends StatelessWidget {
  const StokrErrorIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: SideSwapColors.bitterSweet, width: 3),
        color: SideSwapColors.chathamsBlue,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/close.svg',
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(
            SideSwapColors.bitterSweet,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class StokrStepsContainer extends StatelessWidget {
  const StokrStepsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SideSwapColors.chathamsBlue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DotRowText(
              'KYC'.tr(),
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            DotRowText(
              'Risk questionnaire'.tr(),
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            DotRowText(
              'Register your AMP ID'.tr(),
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
            DotRowText(
              'Tax ID'.tr(),
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
