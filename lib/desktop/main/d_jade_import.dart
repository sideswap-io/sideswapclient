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
    final jadeDevicesState = ref.watch(jadeDeviceProvider);

    final desktopAppTheme = ref.watch(desktopAppThemeProvider);

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
            // The navigation row above stays pinned; everything below it
            // scrolls. ADR-0014 decisions 8 and 10. Both halves decision 8
            // requires are here -- the flex and the scroll view -- and the
            // tree shape never switches on a height threshold, so decision 10
            // holds. Decision 11 is not cited: it names four other pages
            // (`DHome`, `DMarkets`, `DInstantSwap`, `DPegInOut`) and this one
            // is not among them.
            //
            // The flex is tight where decision 8 writes `FlexFit.loose`,
            // because this page's `Column` fills the whole client area rather
            // than shrink-wrapping its slots. A loose fit would let the body
            // take its natural height and collapse the leftover below it; a
            // tight fit gives the leftover to the viewport, which is where the
            // fixed spacers below hold it today. Nothing sits under the body,
            // so the choice moves no control either way; the tight fit is what
            // keeps the scroll region the full height of what is left.
            //
            // At the design height the body fits and the extent is zero, so no
            // scrollbar and no scroll gesture appear. At the floor the default
            // state -- no Jade connected, `Padding(top: 200)` above the
            // spinner -- scrolls by what the `Column` used to overflow by.
            //
            // REGISTER is inside the scroll body, not pinned below it, and
            // that is deliberate. The button belongs to `JadeDevice`, one card
            // per connected device, so there is no single control to pin: two
            // Jades render two REGISTERs. On desktop the device list is kept
            // whole -- `JadeDeviceNotifier.setState` returns early for
            // `FlavorConfig.isDesktop` (lib/providers/jade_provider.dart:61)
            // where the mobile path collapses it to one -- so the multi-device
            // case is reachable, and at the floor the second card's REGISTER
            // sits below the fold. Before this change it was clipped by an
            // overflow with no way to reach it at all; now it scrolls. Prior
            // art records the same limitation for the register boxes of
            // `DAmpRegister`. Pinning it would mean lifting the button out of
            // `JadeDevice`, which `DSettingsJadeDevice` also mounts, and that
            // is a different issue.
            Expanded(
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    SvgPicture.asset(
                      'assets/jade_front_idle.svg',
                      width: 178,
                      height: 91,
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        Text(
                          switch (jadeDevicesState) {
                            JadeDevicesStateAvailable() =>
                              'Jade is ready to start'.tr(),
                            _ => 'Please connect your Jade device'.tr(),
                          },
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        switch (jadeDevicesState) {
                          JadeDevicesStateAvailable() => const SizedBox(),
                          _ => Text(
                            'Before using Jade with Sideswap, you should stop Blockstream Green and any other programs that may be using it.'
                                .tr(),
                          ),
                        },
                        switch (jadeDevicesState) {
                          JadeDevicesStateAvailable(
                            devices: List<From_JadePorts_Port> devices,
                          ) =>
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Column(
                                children: devices
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
                            ),
                          _ => const Padding(
                            padding: EdgeInsets.only(top: 200),
                            child: SpinKitFadingCircle(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                        },
                      ],
                    ),
                  ],
                ),
              ),
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
                onPressed: registrationButtonEnabled
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
