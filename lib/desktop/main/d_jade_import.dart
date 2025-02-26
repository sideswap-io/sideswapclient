import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/jade/jade_rescan_listener.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DJadeImport extends ConsumerWidget {
  const DJadeImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeDevicesState = ref.watch(jadeDeviceNotifierProvider);

    final desktopAppTheme = ref.watch(desktopAppThemeNotifierProvider);

    return SideSwapScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ...switch (jadeDevicesState) {
              JadeDevicesStateAvailable(
                devices: List<From_JadePorts_Port> devices,
              )
                  when devices.isNotEmpty =>
                [const SizedBox()],
              _ => [const JadeRescanListener()],
            },
            Row(
              children: [
                DCustomTextBigButton(
                  height: 40,
                  onPressed: () {
                    ref.read(walletProvider).goBack();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/arrow_back3.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Back'.tr(),
                        style: desktopAppTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                DCustomTextBigButton(
                  height: 40,
                  onPressed: () {
                    openUrl(
                      'https://help.blockstream.com/hc/en-us/sections/900000124103-Getting-Started',
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/question_mark.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Quick start guide'.tr(),
                        style: desktopAppTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                DCustomTextBigButton(
                  height: 40,
                  onPressed: () {
                    openUrl(
                      'https://store.blockstream.com/product/blockstream-jade-hardware-wallet/',
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/jade.svg',
                        width: 16,
                        height: 16,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Get Jade'.tr(),
                        style: desktopAppTheme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            SvgPicture.asset(
              'assets/jade_front_idle.svg',
              width: 178,
              height: 91,
            ),
            const SizedBox(height: 32),
            Consumer(
              builder: (context, ref, child) {
                final jadeDevicesState = ref.watch(jadeDeviceNotifierProvider);

                return Column(
                  children: [
                    Text(
                      jadeDevicesState.maybeWhen(
                        available: (devices) => 'Jade is ready to start'.tr(),
                        orElse: () => 'Please connect your Jade device'.tr(),
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
    );
  }
}

class JadeDevice extends StatelessWidget {
  const JadeDevice({super.key, required this.jadePort, this.register = true});

  final JadePort jadePort;
  final bool register;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 285,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: const Color(0xFF165071)),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Details'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              JadeDeviceDetailsLine(title: 'Port', value: jadePort.port),
            ],
          ),
        ),
        if (register) ...[
          const SizedBox(height: 32),
          Consumer(
            builder: (context, ref, child) {
              final registrationButtonEnabled = ref.watch(
                jadeRegistrationButtonEnabledProvider,
              );
              return DCustomFilledBigButton(
                onPressed:
                    registrationButtonEnabled
                        ? () {
                          ref.read(walletProvider).jadeLogin(jadePort.jadeId);
                        }
                        : null,
                child: Text('REGISTER'.tr()),
              );
            },
          ),
        ],
      ],
    );
  }
}

class JadeDeviceDetailsLine extends StatelessWidget {
  const JadeDeviceDetailsLine({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value)],
      ),
    );
  }
}
