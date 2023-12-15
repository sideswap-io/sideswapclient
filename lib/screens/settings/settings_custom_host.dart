import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class SettingsCustomHost extends HookConsumerWidget {
  const SettingsCustomHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultTextStyle = useMemoized(() => const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF00B4E9),
        ));

    final hostController = useTextEditingController();
    final portController = useTextEditingController();
    final useTls = useState(false);
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

    return SideSwapScaffold(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      appBar: CustomAppBar(
        title: 'Personal Electrum Server'.tr(),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          'Host'.tr(),
                          style: defaultTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SideSwapTextField(
                          controller: hostController,
                          hintText: 'Hostname'.tr(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: Text(
                          'Port'.tr(),
                          style: defaultTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SideSwapTextField(
                          controller: portController,
                          hintText: 'Range 1-65535'.tr(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Consumer(
                          builder: (context, watch, child) {
                            return CustomCheckBox(
                              value: useTls.value,
                              onChanged: (value) {
                                useTls.value = value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Use TLS'.tr(),
                                      style: defaultTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: CustomBigButton(
                          enabled: applyEnabled.value,
                          width: double.maxFinite,
                          height: 54,
                          text: 'APPLY'.tr(),
                          onPressed: () {
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

                            Navigator.of(context).pop();
                          },
                          backgroundColor: SideSwapColors.brightTurquoise,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
