import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class JadeRescanTimer extends ConsumerStatefulWidget {
  const JadeRescanTimer({super.key});

  @override
  ConsumerState<JadeRescanTimer> createState() => JadeRescanTimerState();
}

class JadeRescanTimerState extends ConsumerState<JadeRescanTimer> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(walletProvider).jadeRescan();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DJadeImport extends ConsumerWidget {
  const DJadeImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final hasJade = wallet.jades.isNotEmpty;
    return SideSwapScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const JadeRescanTimer(),
            Row(
              children: [
                DJadeImportTopButton(
                  text: 'Back'.tr(),
                  icon: 'assets/arrow_back3.svg',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                DJadeImportTopButton(
                  text: 'Quick start guide'.tr(),
                  icon: 'assets/question_mark.svg',
                ),
                const SizedBox(width: 12),
                DJadeImportTopButton(
                  text: 'Get Jade'.tr(),
                  icon: 'assets/jade.svg',
                  onPressed: () {
                    openUrl(
                        'https://store.blockstream.com/product/blockstream-jade-hardware-wallet/');
                  },
                ),
              ],
            ),
            const SizedBox(height: 100),
            SvgPicture.asset('assets/jade_front_idle.svg'),
            const SizedBox(height: 32),
            Text(
              hasJade
                  ? ('Jade is ready to start'.tr())
                  : 'Please connect your Jade device'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasJade)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: wallet.jades
                      .map(
                        (port) => JadeDevice(
                          key: ValueKey(port.port),
                          port: port,
                        ),
                      )
                      .toList(),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(top: 200),
                child: SpinKitFadingCircle(
                  color: SideSwapColors.brightTurquoise,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class JadeDevice extends ConsumerWidget {
  const JadeDevice({
    super.key,
    required this.port,
  });

  final From_JadePorts_Port port;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeRegistering = ref.watch(walletProvider).jadeRegistering;
    return Column(
      children: [
        Container(
          width: 285,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: const Color(0xFF165071),
            ),
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
              JadeDeviceDetailsLine(
                title: 'Port',
                value: port.port,
              ),
              if (port.hasSerial())
                JadeDeviceDetailsLine(
                  title: 'Serial',
                  value: port.serial,
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        DCustomFilledBigButton(
          onPressed: jadeRegistering
              ? null
              : () {
                  ref.read(walletProvider).jadeRegister(port.jadeId);
                },
          child: Text('REGISTER'.tr()),
        ),
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
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}

class DJadeImportTopButton extends StatelessWidget {
  const DJadeImportTopButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });

  final String text;
  final String icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(icon),
              const SizedBox(width: 7),
              Text(text),
            ],
          ),
        );
      },
      onPressed: onPressed,
    );
  }
}
