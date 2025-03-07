import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/pegx_bottom_panel.dart';
import 'package:sideswap/screens/onboarding/widgets/pegx_login_autheid_info.dart';
import 'package:url_launcher/url_launcher.dart';

class PegxRegister extends HookConsumerWidget {
  const PegxRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(pegxWebsocketClientProvider, (previous, next) {});

    ref.listen(pegxLoginStateNotifierProvider, (previous, next) async {
      (switch (next) {
        PegxLoginStateLogin(requestId: String requestId) => () async {
          await openUrl(
            '$pegxIntraAutheIdUrl$requestId',
            mode: LaunchMode.externalNonBrowserApplication,
          );
        },
        _ => () {},
      }());
    });

    final pegxLoginState = ref.watch(pegxLoginStateNotifierProvider);

    useEffect(() {
      Future.microtask(
        () =>
            (switch (pegxLoginState) {
              PegxLoginStateLogged() => () {
                ref
                    .read(pageStatusNotifierProvider.notifier)
                    .setStatus(Status.pegxSubmitAmp);
              },
              PegxLoginStateGaidAdded() => () {
                ref
                    .read(pageStatusNotifierProvider.notifier)
                    .setStatus(Status.pegxSubmitAmp);
              },
              _ => () {},
            }()),
      );

      return;
    }, [pegxLoginState]);

    useEffect(() {
      ref.read(pegxWebsocketClientProvider).connectToSocket();

      return;
    }, const []);

    final textTheme = Theme.of(context).textTheme;

    return SideSwapPopup(
      onClose: () {
        ref.invalidate(stokrGaidNotifierProvider);
        ref.invalidate(pegxGaidNotifierProvider);
        ref
            .read(pegxLoginStateNotifierProvider.notifier)
            .setState(const PegxLoginStateLoading());
        ref.read(walletProvider).goBack();
      },
      bottomNavigationBar: const PegxBottomPanel(),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/pegx_logo.svg', width: 104, height: 24),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Register in your AMP ID with PEGx using Auth eID'.tr(),
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(fontSize: 17),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: PegxLoginAutheIDInfo(),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: CustomBigButton(
                width: double.infinity,
                height: 54,
                backgroundColor: SideSwapColors.brightTurquoise,
                onPressed: () {
                  ref.read(pegxWebsocketClientProvider).login();
                },
                child: Text(
                  'REGISTER'.tr(),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
