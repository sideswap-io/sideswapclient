import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/lang_selector.dart';
import 'package:sideswap/desktop/common/button/d_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';

import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/select_env_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';

class DFirstLaunch extends HookConsumerWidget {
  const DFirstLaunch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(selectEnvDialogProvider, (_, next) async {
      if (next) {
        ref.read(selectEnvDialogProvider.notifier).setSelectEnvDialog(false);

        await showDialog<void>(
          useRootNavigator: false,
          barrierDismissible: false,
          context: ref.read(navigatorKeyProvider).currentContext!,
          builder: (_) => DContentDialog(
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
                ...envValues().map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Consumer(
                      builder: (context, ref, _) {
                        final selectedEnv = ref.watch(selectedEnvProvider);

                        return DRadioButton(
                          checked: e == selectedEnv,
                          semanticLabel: envName(e),
                          content: Text(envName(e)),
                          onChanged: (value) async {
                            await ref
                                .read(selectedEnvProvider.notifier)
                                .setSelectedEnv(e);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              DCustomTextBigButton(
                width: 266,
                child: Consumer(
                  builder: ((context, ref, _) {
                    final env = ref.watch(envProvider);
                    final selectedEnv = ref.watch(selectedEnvProvider);
                    return env == selectedEnv
                        ? Text('CLOSE'.tr())
                        : Text('SWITCH AND EXIT'.tr());
                  }),
                ),
                onPressed: () async {
                  final selectedEnv = ref.read(selectedEnvProvider);
                  await ref.read(envProvider.notifier).setEnv(selectedEnv);

                  // and also reset network settings model
                  ref
                      .read(networkSettingsNotifierProvider.notifier)
                      .setModel(const NetworkSettingsModelEmpty());
                  await ref
                      .read(networkSettingsNotifierProvider.notifier)
                      .save();

                  exit(0);
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
          ),
        );
      }
    });

    final lang = ref.watch(localesProvider).selectedLang(context);

    useEffect(() {
      if (lang == 'zh') {
        ref
            .read(configProvider.notifier)
            .setSettingsNetworkType(SettingsNetworkType.sideswapChina);
      }

      return;
    }, [lang]);

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
                  onPressed: ref.read(selectEnvTapProvider.notifier).setTap,
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
                  'Settlement infrastructure for a digital era'.tr(),
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
                  width: 266,
                  onPressed: () {
                    ref.invalidate(mnemonicWordItemsNotifierProvider);
                    ref.read(walletProvider).setReviewLicenseImportWallet();
                  },
                  child: Text('IMPORT WALLET'.tr()),
                ),
              ),
              if (FlavorConfig.enableJade) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DCustomTextBigButton(
                    width: 266,
                    onPressed: () {
                      ref
                          .read(pageStatusStateProvider.notifier)
                          .setStatus(Status.jadeImport);
                      // desktopImportJade(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Spacer(),
                              SvgPicture.asset(
                                'assets/jade.svg',
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('JADE'),
                        const Spacer(),
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
