import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/main/d_jade_import.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/jade_provider.dart';

class DSettingsJadeDevice extends HookConsumerWidget {
  const DSettingsJadeDevice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final desktopAppTheme = ref.watch(desktopAppThemeNotifierProvider);
    ref.listen(jadeRescanProvider, (_, __) {});

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          content: Text('Jade device'.tr()),
          onClose: () {
            Navigator.of(context).pop();
          },
        ),
        style: const DContentDialogThemeData().merge(
          desktopAppTheme.defaultDialogTheme,
        ),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
        content: Center(
          child: SizedBox(
            width: 344,
            height: 509,
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/jade_front_idle.svg',
                  width: 178,
                  height: 91,
                ),
                const SizedBox(height: 32),
                Consumer(
                  builder: (context, ref, child) {
                    final jadeDevicesState = ref.watch(
                      jadeDeviceNotifierProvider,
                    );

                    return Column(
                      children: [
                        Text(
                          jadeDevicesState.maybeWhen(
                            available:
                                (devices) => 'Jade is ready to start'.tr(),
                            orElse:
                                () => 'Please connect your Jade device'.tr(),
                          ),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        jadeDevicesState.maybeWhen(
                          available: (devices) => SizedBox(),
                          orElse:
                              () => Text(
                                'Before using Jade with Sideswap, you should stop Blockstream Green and any other programs that may be using it.'
                                    .tr(),
                              ),
                        ),
                        jadeDevicesState.maybeWhen(
                          available: (devices) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Column(
                                children:
                                    devices
                                        .map(
                                          (port) => JadeDevice(
                                            key: ValueKey(port.port),
                                            jadePort: JadePort(
                                              fromJadePortsPort: port,
                                            ),
                                            register: false,
                                          ),
                                        )
                                        .toList(),
                              ),
                            );
                          },
                          orElse: () {
                            return const Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: SpinKitFadingCircle(
                                color: SideSwapColors.brightTurquoise,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
