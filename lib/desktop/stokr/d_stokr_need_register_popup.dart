import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class DStokrNeedRegisterPopup extends ConsumerWidget {
  const DStokrNeedRegisterPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).defaultDialogTheme;

    final selectedAccountAsset =
        ref.watch(marketSelectedAccountAssetStateProvider);
    final asset = ref.watch(assetsStateProvider)[selectedAccountAsset.assetId];

    return DContentDialog(
      title: DContentDialogTitle(
        height: 28,
        onClose: () {
          ref.read(walletProvider).goBack();
        },
      ),
      style: const DContentDialogThemeData().merge(
        defaultDialogTheme.merge(
          const DContentDialogThemeData(
            titlePadding:
                EdgeInsets.only(top: 24, bottom: 0, left: 24, right: 24),
          ),
        ),
      ),
      content: SizedBox(
        height: 553,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const DStokrErrorIcon(),
              const SizedBox(height: 31),
              Text(
                'Please complete the following steps on STOKR:'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                    ),
              ),
              const SizedBox(height: 24),
              const DStokrStepsContainer(),
              const SizedBox(height: 16),
              WarningRowText('KYC verification may take up to 24 hours'.tr()),
              const Spacer(),
              DCustomFilledBigButton(
                width: 500,
                onPressed: () {
                  if (asset != null) {
                    openUrl(asset.domainAgentLink);
                  }
                },
                child: Text('REGISTER ON STOKR'.tr()),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
    );
  }
}

class DStokrStepsContainer extends StatelessWidget {
  const DStokrStepsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: SideSwapColors.chathamsBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DotRowText('KYC'.tr()),
            DotRowText('Risk questionnaire'.tr()),
            DotRowText('Register your AMP ID'.tr()),
            DotRowText('Tax ID'.tr()),
          ],
        ),
      ),
    );
  }
}

class DotRowText extends StatelessWidget {
  const DotRowText(
    this.text, {
    super.key,
    this.textStyle,
    this.color = SideSwapColors.brightTurquoise,
  });

  final String? text;
  final TextStyle? textStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SmallBlueDot(color: color),
        const SizedBox(width: 10),
        Text(
          text ?? '',
          style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class WarningRowText extends StatelessWidget {
  const WarningRowText(
    this.text, {
    super.key,
    this.textStyle,
  });

  final String? text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/warning.svg'),
        const SizedBox(width: 8),
        Text(
          text ?? '',
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: SideSwapColors.yellowOrange),
        )
      ],
    );
  }
}

class SmallBlueDot extends StatelessWidget {
  const SmallBlueDot({
    super.key,
    this.color = SideSwapColors.brightTurquoise,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 4,
      height: 4,
    );
  }
}

class DStokrErrorIcon extends StatelessWidget {
  const DStokrErrorIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: SideSwapColors.bitterSweet,
          width: 8,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/close.svg',
          width: 30,
          height: 30,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
