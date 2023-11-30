import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_amp_login_dialog_bottom_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class DPegxLoginDialogBody extends HookConsumerWidget {
  const DPegxLoginDialogBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = ref.watch(desktopAppThemeProvider).textTheme;
    final pegxLoginState = ref.watch(pegxLoginStateNotifierProvider);
    final env = ref.watch(envProvider);

    return SizedBox(
      width: 628,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                'Scan QR code in Auth eID App to login'.tr(),
                style: textTheme.bodyMedium,
              ),
              pegxLoginState.maybeWhen(
                login: (requestId) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.white,
                      ),
                      child: QrImageView(
                        data: env == SIDESWAP_ENV_TESTNET ||
                                env == SIDESWAP_ENV_LOCAL_TESTNET
                            ? '$pegxStagingAuthIdUrl$requestId'
                            : '$pegxAuthIdUrl$requestId',
                        size: 150,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  );
                },
                loginDialog: () {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                },
                orElse: () {
                  return const SizedBox();
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  height: 114,
                  color: SideSwapColors.chathamsBlue,
                  child: Row(
                    children: [
                      const Spacer(),
                      SvgPicture.asset(
                        'assets/autheid_logo.svg',
                        width: 64,
                        height: 64,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '1. Open the Auth eID App on your mobile phone.\n2. Tap the QR symbol on the Auth eID App.\n3. Point the camera at the QR code in this field.'
                                  .tr(),
                              style: textTheme.bodyMedium?.merge(
                                const TextStyle(
                                  fontSize: 15,
                                  height: 1.22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DAmpLoginDialogBottomPanel(
              prefix: RichText(
                text: TextSpan(
                  text: 'Don\'t have the Auth eID App? '.tr(),
                  style: textTheme.titleSmall,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Get started here'.tr(),
                      style: textTheme.titleSmall?.merge(
                        const TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      mouseCursor: SystemMouseCursors.click,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => openUrl('https://autheid.com/'),
                    ),
                  ],
                ),
              ),
              url: 'https://pegx.io',
              urlText: 'pegx.io',
            ),
          )
        ],
      ),
    );
  }
}
