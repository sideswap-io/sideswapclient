import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DPinWelcome extends HookConsumerWidget {
  const DPinWelcome({
    super.key,
    this.onYesPressed,
    this.onNoPressed,
  });

  final void Function()? onYesPressed;
  final void Function()? onNoPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yesFocusNode = useFocusNode();

    useEffect(() {
      yesFocusNode.requestFocus();
      return null;
    }, [yesFocusNode]);

    return SideSwapScaffoldPage(
      onEscapeKey: () {
        ref.read(pinSetupProvider).isNewWallet = false;
        ref.read(pageStatusStateProvider.notifier).setStatus(Status.noWallet);
      },
      content: Center(
        child: SizedBox(
          height: 640,
          child: Column(
            children: [
              const DPinWelcomeLogo(),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Do you wish to set a PIN to protect your wallet?'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Protect your wallet with the PIN'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: DCustomFilledBigButton(
                  width: 266,
                  height: 49,
                  focusNode: yesFocusNode,
                  onPressed: onYesPressed ??
                      () {
                        ref.read(pinSetupProvider).initPinSetupPinWelcome();
                      },
                  child: Text('YES'.tr()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: DCustomTextBigButton(
                  width: 266,
                  height: 49,
                  onPressed: onNoPressed ??
                      () async {
                        await ref
                            .read(walletProvider)
                            .setImportWalletBiometricPrompt();
                      },
                  child: Text('NOT NOW'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DPinWelcomeLogo extends StatelessWidget {
  const DPinWelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 376,
      height: 202,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SvgPicture.asset(
            'assets/locker2.svg',
            width: 156,
            height: 202,
          ),
        ],
      ),
    );
  }
}
