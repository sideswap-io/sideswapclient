import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/custom_check_box.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common/widgets/sideswap_text_field.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/network_access_provider.dart';
import 'package:sideswap/models/wallet.dart';

class SettingsCustomHost extends StatefulWidget {
  const SettingsCustomHost({Key? key}) : super(key: key);

  @override
  _SettingsCustomHostState createState() => _SettingsCustomHostState();
}

class _SettingsCustomHostState extends State<SettingsCustomHost> {
  late TextStyle defaultTextStyle;

  late TextEditingController hostController;
  late TextEditingController portController;
  late bool useTls;

  bool saveEnabled = false;

  @override
  void initState() {
    super.initState();
    defaultTextStyle = GoogleFonts.roboto(
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF00B4E9),
    );

    hostController = TextEditingController()
      ..text = context.read(configProvider).settingsHost
      ..addListener(() {
        validate();
      });

    portController = TextEditingController()
      ..text = context.read(configProvider).settingsPort.toString()
      ..addListener(() {
        validate();
      });

    useTls = context.read(configProvider).settingsUseTLS;

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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Text(
                          'Host'.tr(),
                          style: defaultTextStyle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: SideSwapTextField(
                          controller: hostController,
                          hintText: 'Hostname'.tr(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18.h),
                        child: Text(
                          'Port'.tr(),
                          style: defaultTextStyle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
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
                        padding: EdgeInsets.only(top: 10.h),
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
                                padding: EdgeInsets.only(left: 10.w),
                                child: Row(
                                  children: [
                                    Text(
                                      'Use TLS',
                                      style: defaultTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 40.h),
                          child: CustomBigButton(
                            enabled: saveEnabled,
                            width: double.maxFinite,
                            height: 54.h,
                            text: 'SAVE AND APPLY'.tr(),
                            onPressed: () {
                              context.read(networkAccessProvider).networkType =
                                  SettingsNetworkType.custom;
                              context
                                  .read(configProvider)
                                  .setSettingsHost(hostController.text);
                              context.read(configProvider).setSettingsPort(
                                  int.parse(portController.text));
                              context
                                  .read(configProvider)
                                  .setSettingsUseTLS(useTls);
                              Navigator.of(context).pop();
                              context.read(walletProvider).applyNetworkChange();
                            },
                            backgroundColor: const Color(0xFF00C5FF),
                            textColor: Colors.white,
                          ),
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
