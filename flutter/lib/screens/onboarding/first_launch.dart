import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/lang_selector.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/select_env_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class FirstLaunch extends ConsumerStatefulWidget {
  const FirstLaunch({super.key});

  @override
  FirstLaunchState createState() => FirstLaunchState();
}

class FirstLaunchState extends ConsumerState<FirstLaunch> {
  var tapCount = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen<SelectEnvProvider>(selectEnvProvider, (_, next) async {
      if (next.showSelectEnvDialog) {
        ref.read(selectEnvProvider).showSelectEnvDialog = false;
        ref.read(walletProvider).selectEnv();
      }
    });

    final lang = ref.watch(localesProvider).selectedLang(context);

    return SideSwapScaffold(
      key: ValueKey(lang),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: ref.read(selectEnvProvider).handleTap,
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: LangSelector(),
                                  ),
                                ),
                                SizedBox(
                                  width: 132,
                                  height: 130,
                                  child: SvgPicture.asset('assets/logo.svg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Text(
                                    'Welcome in SideSwap'.tr(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ).tr(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: const Text(
                                    'SideSwap is the easiest way to send, receive and swap on the Liquid network.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ).tr(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: CustomBigButton(
                              width: double.infinity,
                              height: 54,
                              text: 'CREATE NEW WALLET'.tr(),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              onPressed: () async {
                                await ref
                                    .read(walletProvider)
                                    .setReviewLicenseCreateWallet();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 23),
                            child: CustomBigButton(
                              width: double.infinity,
                              height: 54,
                              text: 'IMPORT WALLET'.tr(),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.transparent,
                              textColor: SideSwapColors.brightTurquoise,
                              onPressed: () {
                                ref
                                    .read(walletProvider)
                                    .setReviewLicenseImportWallet();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
