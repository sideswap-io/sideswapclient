import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class DJadeImport extends ConsumerWidget {
  const DJadeImport({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final hasJade = wallet.jades.isNotEmpty;
    final unlocking = wallet.jades.any((jade) =>
        jade.state == From_JadePorts_State.UNLOCKING ||
        jade.state == From_JadePorts_State.CONNECTED);
    return SideSwapScaffoldPage(
      content: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                _TopButton(
                  text: 'Back'.tr(),
                  icon: 'assets/arrow_back3.svg',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                _TopButton(
                  text: 'Quick start guide'.tr(),
                  icon: 'assets/question_mark.svg',
                ),
                const SizedBox(width: 12),
                _TopButton(
                  text: 'Get Jade'.tr(),
                  icon: 'assets/jade.svg',
                ),
              ],
            ),
            const SizedBox(height: 100),
            SvgPicture.asset(unlocking
                ? 'assets/jade_front_unlock.svg'
                : 'assets/jade_front_idle.svg'),
            const SizedBox(height: 32),
            Text(
              hasJade
                  ? (unlocking
                      ? 'Enter PIN on your Jade device'.tr()
                      : 'Jade is ready to start'.tr())
                  : 'Please connect your Jade device'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasJade && !unlocking)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: wallet.jades
                      .map(
                        (port) => _JadeDevice(
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
                  color: Color(0xFF00C5FF),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String getStateText(From_JadePorts_State state) {
  switch (state) {
    case From_JadePorts_State.IDLE:
      return 'Idle'.tr();
    case From_JadePorts_State.CONNECTING:
      return 'Connecting'.tr();
    case From_JadePorts_State.UNLOCKING:
      return 'Unlocking'.tr();
    case From_JadePorts_State.CONNECTED:
      return 'Connected'.tr();
  }
  return 'Invalid'.tr();
}

class _JadeDevice extends ConsumerWidget {
  const _JadeDevice({
    super.key,
    required this.port,
  });

  final From_JadePorts_Port port;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      color: Color(0xFF00C5FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _DetailsLine(
                title: 'Status',
                value: getStateText(port.state),
              ),
              _DetailsLine(
                title: 'Port',
                value: port.port,
              ),
              if (port.hasSerial())
                _DetailsLine(
                  title: 'Serial',
                  value: port.serial,
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        DCustomFilledBigButton(
          onPressed: () {
            ref.read(walletProvider).jadeLogin(port.port);
          },
          child: Text('UNLOCK'.tr()),
        ),
      ],
    );
  }
}

class _DetailsLine extends StatelessWidget {
  const _DetailsLine({
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

class _TopButton extends StatelessWidget {
  const _TopButton({
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
              color: const Color(0xFF00C5FF),
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
