import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_settings_radio_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/select_env_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class DSettingsEnv extends ConsumerWidget {
  const DSettingsEnv({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;
    final startupEnv = ref.watch(selectEnvProvider).startupEnv;
    final selectedEnv = ref.watch(selectEnvProvider).currentEnv;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          onClose: () {
            Navigator.of(context).pop();
          },
          content: Text('Environment'.tr()),
        ),
        content: Center(
          child: SizedBox(
            width: 344,
            height: 509,
            child: Column(
              children: [
                EnvButton(
                  name: 'Liquid Network'.tr(),
                  env: SIDESWAP_ENV_PROD,
                ),
                EnvButton(
                  name: 'Testnet Network'.tr(),
                  env: SIDESWAP_ENV_TESTNET,
                ),
                if (startupEnv != selectedEnv)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                        'Please restart SideSwap to apply the change'.tr()),
                  ),
              ],
            ),
          ),
        ),
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      ),
    );
  }
}

class EnvButton extends ConsumerWidget {
  const EnvButton({
    super.key,
    required this.name,
    required this.env,
  });

  final String name;
  final int env;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectEnv = ref.watch(selectEnvProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DSettingsRadioButton(
        checked: selectEnv.currentEnv == env,
        onChanged: (value) async {
          await selectEnv.setCurrentEnv(env);
          selectEnv.saveEnv(restart: false);
        },
        content: Text(name),
      ),
    );
  }
}
