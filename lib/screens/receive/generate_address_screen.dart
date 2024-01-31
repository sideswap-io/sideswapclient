import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/receive/widgets/option_generate_widget.dart';

class GenerateAddressScreen extends HookConsumerWidget {
  const GenerateAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);

    useEffect(() {
      Future.microtask(() {
        ref.invalidate(currentReceiveAddressProvider);
        ref.invalidate(selectedAccountTypeNotifierProvider);
      });

      return;
    }, const []);

    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Generate address'.tr(),
        onPressed: () => ref.read(walletProvider).goBack(),
      ),
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                'Select address type'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Consumer(
                builder: (context, ref, _) {
                  return OptionGenerateWidget(
                    isSelected: selectedAccountType.isRegular,
                    assetIcon: 'assets/regular_wallet.svg',
                    title: 'Regular wallet'.tr(),
                    subTitle: 'Single-signature wallet'.tr(),
                    message:
                        'Your default wallet which contains asset are secured by a single key under your control.'
                            .tr(),
                    onPressed: () {
                      if (selectedAccountType.isRegular) {
                        ref
                            .read(pageStatusStateProvider.notifier)
                            .setStatus(Status.walletAddressDetail);
                        return;
                      }

                      ref
                          .read(selectedAccountTypeNotifierProvider.notifier)
                          .setAccountType(AccountType.reg);
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  return OptionGenerateWidget(
                    isSelected: selectedAccountType.isAmp,
                    assetIcon: 'assets/amp_wallet.svg',
                    title: 'AMP Securities wallet'.tr(),
                    subTitle: '2-of-2 multi-signature wallet'.tr(),
                    message:
                        'Your securities wallet which may hold Transfer Restricted assets, such as BMN or SSWP, which require the issuer to co-sign and approve transactions.'
                            .tr(),
                    onPressed: () {
                      if (selectedAccountType.isAmp) {
                        ref
                            .read(pageStatusStateProvider.notifier)
                            .setStatus(Status.walletAddressDetail);
                        return;
                      }

                      ref
                          .read(selectedAccountTypeNotifierProvider.notifier)
                          .setAccountType(AccountType.amp);
                    },
                  );
                },
              ),
              const Spacer(),
              CustomBigButton(
                width: double.maxFinite,
                height: 54,
                text: 'GENERATE'.tr(),
                backgroundColor: SideSwapColors.brightTurquoise,
                textColor: Colors.white,
                onPressed: () {
                  ref
                      .read(pageStatusStateProvider.notifier)
                      .setStatus(Status.walletAddressDetail);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
