import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/lang_selector.dart';
import 'package:sideswap/desktop/common/button/d_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';

import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/locales_provider.dart';
import 'package:sideswap/models/mnemonic_table_provider.dart';
import 'package:sideswap/models/select_env_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

class DFirstLaunch extends ConsumerWidget {
  const DFirstLaunch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SelectEnvProvider>(selectEnvProvider, (_, next) async {
      if (next.showSelectEnvDialog) {
        ref.read(selectEnvProvider).showSelectEnvDialog = false;

        await showDialog<void>(
          useRootNavigator: false,
          barrierDismissible: false,
          context: ref.read(walletProvider).navigatorKey.currentContext!,
          builder: (_) => Consumer(
            builder: (context, ref, _) {
              final currentEnv = ref.watch(selectEnvProvider).currentEnv;
              return DContentDialog(
                constraints: const BoxConstraints(maxWidth: 628),
                title: Center(child: Text('Select env'.tr())),
                content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Changes will take effect after application restart.'
                                  .tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ...envValues()
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DRadioButton(
                                  checked: e == currentEnv,
                                  semanticLabel: envName(e),
                                  content: Text(envName(e)),
                                  onChanged: (value) async {
                                    await ref
                                        .read(selectEnvProvider)
                                        .setCurrentEnv(e);
                                  },
                                ),
                              ))
                          .toList(),
                    ]),
                actions: [
                  DCustomTextBigButton(
                    child: Consumer(
                      builder: ((context, ref, _) {
                        final env =
                            ref.watch(configProvider.select((p) => p.env));
                        final currentEnv = ref.watch(
                            selectEnvProvider.select((p) => p.currentEnv));
                        return env == currentEnv
                            ? Text('CLOSE'.tr())
                            : Text('SWITCH AND EXIT'.tr());
                      }),
                    ),
                    onPressed: () async {
                      ref.read(selectEnvProvider).saveEnv();
                      Navigator.pop(context);
                      ref.read(walletProvider).goBack();
                    },
                  ),
                  DCustomFilledBigButton(
                    child: Text('CANCEL'.tr()),
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(walletProvider).goBack();
                    },
                  ),
                ],
              );
            },
          ),
        );
      }
    });

    final lang = ref.watch(localesProvider).selectedLang(context);

    return Stack(
      key: ValueKey(lang),
      children: [
        SideSwapScaffoldPage(
          content: Column(
            children: [
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: FirstLaunchClickableLogo(
                  onPressed: ref.read(selectEnvProvider).handleTap,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Welcome in SideSwap'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Payments infrastructure for a digital era'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 126),
                child: DCustomFilledBigButton(
                  onPressed: () async {
                    await ref
                        .read(walletProvider)
                        .setReviewLicenseCreateWallet();
                  },
                  child: Text('CREATE NEW WALLET'.tr()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: DCustomTextBigButton(
                  onPressed: () {
                    ref.invalidate(mnemonicWordItemsProvider);
                    ref.read(walletProvider).setReviewLicenseImportWallet();
                  },
                  child: Text('IMPORT WALLET'.tr()),
                ),
              ),
              if (FlavorConfig.enableJade) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DCustomTextBigButton(
                    onPressed: () {
                      desktopImportJade(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/jade.svg',
                        ),
                        const SizedBox(width: 10),
                        Text('JADE'.tr()),
                      ],
                    ),
                  ),
                ),
              ],
              Expanded(child: Container()),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: LangSelector(),
          ),
        ),
      ],
    );
  }
}

class FirstLaunchClickableLogo extends StatelessWidget {
  final VoidCallback? onPressed;

  const FirstLaunchClickableLogo({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      label: 'SideSwap logo image',
      hint: 'Change environment',
      child: FocusableActionDetector(
        actions: <Type, Action<Intent>>{
          ActivateIntent:
              CallbackAction<Intent>(onInvoke: (intent) => onPressed?.call()),
        },
        child: GestureDetector(
          onTap: onPressed,
          child: SvgPicture.asset(
            'assets/logo.svg',
            width: 110,
            height: 108,
          ),
        ),
      ),
    );
  }
}