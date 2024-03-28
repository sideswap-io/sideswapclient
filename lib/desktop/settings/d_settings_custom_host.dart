import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/numerical_range_formatter.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class DSettingsCustomHost extends HookConsumerWidget {
  const DSettingsCustomHost({super.key});

  void goBack(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    ref
        .read(pageStatusNotifierProvider.notifier)
        .setStatus(Status.settingsNetwork);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).defaultDialogTheme;

    const textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.brightTurquoise,
    );

    final useTls = useState(false);
    final hostController = useTextEditingController(
        text: ref.read(configurationProvider).networkHost);
    final portController = useTextEditingController(
        text: ref.read(configurationProvider).networkPort.toString());
    final applyEnabled = useState(false);
    final networkSettingsModel = ref.watch(networkSettingsNotifierProvider);

    final validateCallback = useCallback(() {
      final host = hostController.text;
      final port = portController.text;

      if (host.isNotEmpty && port.isNotEmpty) {
        applyEnabled.value = true;
      } else {
        applyEnabled.value = false;
      }
    }, const []);

    useEffect(() {
      hostController.text = networkSettingsModel.host ?? '';
      portController.text = '${networkSettingsModel.port ?? ''}';
      useTls.value = networkSettingsModel.useTls ?? false;

      hostController.addListener(() {
        validateCallback();
      });
      portController.addListener(() {
        validateCallback();
      });

      return;
    }, [hostController, portController]);

    return PopScope(
      canPop: true,
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
                      NumericalRangeFormatter(min: 1, max: 65535),
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
                        ? () {
                            ref
                                .read(networkSettingsNotifierProvider.notifier)
                                .setModel(NetworkSettingsModelApply(
                                  settingsNetworkType:
                                      SettingsNetworkType.personal,
                                  env: SIDESWAP_ENV_PROD,
                                  host: hostController.text,
                                  port: int.parse(portController.text),
                                  useTls: useTls.value,
                                ));
                            goBack(context, ref);
                          }
                        : null,
                    child: Text('APPLY'.tr()),
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
              width: 266,
              onPressed: () {
                goBack(context, ref);
              },
              child: Text(
                'BACK'.tr(),
              ),
            ),
          ),
        ],
        style: const DContentDialogThemeData().merge(defaultDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      ),
    );
  }
}
