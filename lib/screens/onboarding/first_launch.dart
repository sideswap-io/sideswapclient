import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/lang_selector.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/locales_provider.dart';
import 'package:sideswap/models/select_env_provider.dart';
import 'package:sideswap/models/wallet.dart';

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
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                Padding(
                                  padding: EdgeInsets.only(top: 0.h),
                                  child: SizedBox(
                                    width: 132.w,
                                    height: 130.h,
                                    child: SvgPicture.asset('assets/logo.svg'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 40.h),
                                  child: Text(
                                    'Welcome in SideSwap'.tr(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ).tr(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12.h),
                                  child: Text(
                                    'SideSwap is the easiest way to send, receive and swap on the Liquid network.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16.sp,
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
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: CustomBigButton(
                              width: double.infinity,
                              height: 54.h,
                              text: 'CREATE NEW WALLET'.tr(),
                              textStyle: GoogleFonts.roboto(
                                fontSize: 16.sp,
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
                            padding: EdgeInsets.only(bottom: 23.h),
                            child: CustomBigButton(
                              width: double.infinity,
                              height: 54.h,
                              text: 'IMPORT WALLET'.tr(),
                              textStyle: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.transparent,
                              textColor: const Color(0xFF00C5FF),
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
