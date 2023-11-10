import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/main/widgets/option_generate_widget.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet.dart';

class DGenerateAddressPopup extends HookConsumerWidget {
  const DGenerateAddressPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountType = ref.watch(walletRecvAddressAccount);
    useEffect(() {
      ref.read(walletProvider).toggleRecvAddrType(accountType);
      return;
    }, const []);

    return DPopupWithClose(
      width: 580,
      height: 473,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text("Generate address".tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('Select address type'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: SideSwapColors.tarawera),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer(builder: (context, ref, child) {
                      return OptionGenerateWidget(
                          isSelected:
                              ref.watch(walletRecvAddressAccount).isRegular,
                          assetIcon: 'assets/regular_wallet.svg',
                          title: 'Regular wallet'.tr(),
                          subTitle: 'Single-signature wallet'.tr(),
                          message:
                              'Your default wallet which contains asset are secured by a single key under your control'
                                  .tr(),
                          onPressed: () => ref
                              .read(walletProvider)
                              .toggleRecvAddrType(AccountType.reg));
                    }),
                    Consumer(builder: (context, ref, child) {
                      return OptionGenerateWidget(
                          isSelected: ref.watch(walletRecvAddressAccount).isAmp,
                          assetIcon: 'assets/amp_wallet.svg',
                          title: 'AMP Securities wallet'.tr(),
                          subTitle: '2-of-2 multi-signature wallet'.tr(),
                          message:
                              'Your securities wallet which may hold Transfer Restricted assets, such as BMN or SSWP, which require the issuer to co-sign and approve transactions.'
                                  .tr(),
                          onPressed: () => ref
                              .read(walletProvider)
                              .toggleRecvAddrType(AccountType.amp));
                    })
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Consumer(builder: (context, ref, child) {
              return InkWell(
                child: Container(
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
                  Navigator.pop(context);
                  desktopShowRecvAddress(context, ref);
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
