import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/network_access_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DSettingsCustomHost extends HookConsumerWidget {
  const DSettingsCustomHost({super.key});

  void goBack(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    ref.read(walletProvider).settingsNetwork();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;

    final textStyle = GoogleFonts.roboto(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF00C5FF),
    );

    final useTls = useState(false);
    final hostController =
        useTextEditingController(text: ref.read(configProvider).settingsHost);
    final portController = useTextEditingController(
        text: ref.read(configProvider).settingsPort.toString());
    final applyEnabled = useState(false);

    void validate() {
      if (hostController.text.isNotEmpty && portController.text.isNotEmpty) {
        applyEnabled.value = true;
      } else {
        applyEnabled.value = false;
      }
    }

    useEffect(() {
      hostController.addListener(() {
        validate();
      });
      portController.addListener(() {
        validate();
      });

      useTls.value = ref.read(configProvider).settingsUseTLS;

      validate();

      return () {
        hostController.removeListener(validate);
        portController.removeListener(validate);
      };
    }, [hostController, portController, useTls]);

    return WillPopScope(
      onWillPop: () async {
        goBack(context, ref);
        return false;
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          onClose: () {
            goBack(context, ref);
          },
          content: Text('Personal Electrum Server'.tr()),
        ),
        content: Center(
          child: SizedBox(
            width: 344,
            height: 418,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Host'.tr(),
                  style: textStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SideSwapTextField(
                    hintText: 'Hostname'.tr(),
                    controller: hostController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Text(
                    'Port'.tr(),
                    style: textStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SideSwapTextField(
                    hintText: 'Range 1-65535'.tr(),
                    controller: portController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: CustomCheckBox(
                    value: useTls.value,
                    onChanged: (value) {
                      useTls.value = value;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Use TLS'.tr(),
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: DCustomFilledBigButton(
                    width: 343,
                    height: 44,
                    onPressed: applyEnabled.value
                        ? () async {
                            if (await ref
                                .read(walletProvider)
                                .isAuthenticated()) {
                              ref.read(networkAccessProvider).networkType =
                                  SettingsNetworkType.custom;
                              ref
                                  .read(configProvider)
                                  .setSettingsHost(hostController.text);
                              ref.read(configProvider).setSettingsPort(
                                  int.tryParse(portController.text) ?? 0);
                              ref
                                  .read(configProvider)
                                  .setSettingsUseTLS(useTls.value);

                              goBack(context, ref);

                              ref.read(walletProvider).applyNetworkChange();
                            }
                          }
                        : null,
                    child: Text('SAVE AND APPLY'.tr()),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: DCustomTextBigButton(
              onPressed: () {
                goBack(context, ref);
              },
              child: Text(
                'BACK'.tr(),
              ),
            ),
          ),
        ],
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      ),
    );
  }
}
