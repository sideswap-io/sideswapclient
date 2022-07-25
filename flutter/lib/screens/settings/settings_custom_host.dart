import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/network_access_provider.dart';
import 'package:sideswap/models/wallet.dart';

class SettingsCustomHost extends ConsumerStatefulWidget {
  const SettingsCustomHost({super.key});

  @override
  SettingsCustomHostState createState() => SettingsCustomHostState();
}

class SettingsCustomHostState extends ConsumerState<SettingsCustomHost> {
  late TextStyle defaultTextStyle;

  late TextEditingController hostController;
  late TextEditingController portController;
  late bool useTls;

  bool saveEnabled = false;

  @override
  void initState() {
    super.initState();
    defaultTextStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Color(0xFF00B4E9),
    );

    hostController = TextEditingController()
      ..text = ref.read(configProvider).settingsHost
      ..addListener(() {
        validate();
      });

    portController = TextEditingController()
      ..text = ref.read(configProvider).settingsPort.toString()
      ..addListener(() {
        validate();
      });

    useTls = ref.read(configProvider).settingsUseTLS;

    validate();
  }

  @override
  void dispose() {
    hostController.dispose();
    portController.dispose();
    super.dispose();
  }

  void validate() {
    final host = hostController.text;
    final port = portController.text;

    if (host.isNotEmpty && port.isNotEmpty) {
      saveEnabled = true;
    } else {
      saveEnabled = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      appBar: CustomAppBar(
        title: 'Custom'.tr(),
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
                              value: useTls,
                              onChanged: (value) {
                                setState(() {
                                  useTls = value;
                                });
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
                          enabled: saveEnabled,
                          width: double.maxFinite,
                          height: 54,
                          text: 'SAVE AND APPLY'.tr(),
                          onPressed: () {
                            ref.read(networkAccessProvider).networkType =
                                SettingsNetworkType.custom;
                            ref
                                .read(configProvider)
                                .setSettingsHost(hostController.text);
                            ref.read(configProvider).setSettingsPort(
                                int.parse(portController.text));
                            ref.read(configProvider).setSettingsUseTLS(useTls);
                            Navigator.of(context).pop();
                            ref.read(walletProvider).applyNetworkChange();
                          },
                          backgroundColor: const Color(0xFF00C5FF),
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
