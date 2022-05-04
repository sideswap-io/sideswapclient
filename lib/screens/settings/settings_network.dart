import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/network_access_provider.dart';
import 'package:sideswap/models/network_type_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/settings/settings_custom_host.dart';
import 'package:sideswap/screens/settings/widgets/settings_network_button.dart';

class SettingsNetwork extends ConsumerStatefulWidget {
  const SettingsNetwork({Key? key}) : super(key: key);

  @override
  _SettingsNetworkState createState() => _SettingsNetworkState();
}

class _SettingsNetworkState extends ConsumerState<SettingsNetwork> {
  void showRestartDialog() {
    ref.read(utilsProvider).settingsErrorDialog(
          title: 'Network changes will take effect on restart'.tr(),
          buttonText: 'RESTART APP'.tr(),
          onPressed: (context) {},
          secondButtonText: 'CANCEL'.tr(),
          onSecondPressed: (context) {
            Navigator.of(context).pop();
          },
        );
  }

  Widget buildButton(
    String name,
    SettingsNetworkType selectedNetwork,
    SettingsNetworkType buttonNetwork,
  ) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: SettingsNetworkButton(
        value: selectedNetwork == buttonNetwork,
        onChanged: (value) {
          setState(() {
            ref.read(networkAccessProvider).networkType = buttonNetwork;
            ref.read(walletProvider).applyNetworkChange();
          });
        },
        title: Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            name,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Network access'.tr(),
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
                  padding: EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final selectedNetwork = ref.watch(networkTypeProvider);
                      return Column(
                        children: [
                          buildButton('Blockstream'.tr(), selectedNetwork,
                              SettingsNetworkType.blockstream),
                          buildButton('SideSwap'.tr(), selectedNetwork,
                              SettingsNetworkType.sideswap),
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: SettingsNetworkButton(
                              trailingIconVisible: true,
                              value:
                                  selectedNetwork == SettingsNetworkType.custom,
                              onChanged: (value) {
                                Navigator.of(context, rootNavigator: true)
                                    .push<void>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsCustomHost(),
                                  ),
                                );
                              },
                              title: Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: Text(
                                  'Custom'.tr(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
