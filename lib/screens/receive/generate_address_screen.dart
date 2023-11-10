import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/receive/widgets/option_generate_widget.dart';

class GenerateAddressScreen extends HookConsumerWidget {
  const GenerateAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountType = ref.watch(walletRecvAddressAccount);
    useEffect(() {
      ref.read(walletProvider).toggleRecvAddrType(accountType);
      return;
    }, const []);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: "Generate address".tr(),
        onPressed: () => ref.read(walletProvider).goBack(),
      ),
      body: Column(
        children: [
          Text("Select address type".tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              )),
          const SizedBox(
            height: 16,
          ),
          Consumer(builder: (context, ref, child) {
            return OptionGenerateWidget(
                isSelected: ref
                    .watch(walletRecvAddressAccount)
                    .isRegular,
                assetIcon: 'assets/regular_wallet.svg',
                title: 'Regular wallet'.tr(),
                subTitle: 'Single-signature wallet'.tr(),
                message:
                'Your default wallet which contains asset are secured by a single key under your control'
                    .tr(),
                onPressed: () {
                  ref.read(walletProvider).toggleRecvAddrType(AccountType.reg);
                });
          }),
          Consumer(builder: (context, ref, child) {
            return OptionGenerateWidget(
                isSelected: ref
                    .watch(walletRecvAddressAccount)
                    .isAmp,
                assetIcon: 'assets/amp_wallet.svg',
                title: 'AMP Securities wallet'.tr(),
                subTitle: '2-of-2 multi-signature wallet'.tr(),
                message:
                'Your securities wallet which may hold Transfer Restricted assets, such as BMN or SSWP, which require the issuer to co-sign and approve transactions.'
                    .tr(),
                onPressed: () {
                  ref.read(walletProvider).toggleRecvAddrType(AccountType.amp);
                });
          }),
          const Spacer(),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              width: double.infinity,
              height: 44,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: SideSwapColors.brightTurquoise,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'GENERATE'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            onTap: () {
              ref
                  .read(pageStatusStateProvider.notifier)
                  .setStatus(Status.walletAddressDetail);
            },
          )
        ],
      ),
    );
  }
}
