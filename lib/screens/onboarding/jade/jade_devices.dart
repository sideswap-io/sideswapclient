import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class JadeDevices extends HookConsumerWidget {
  const JadeDevices({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeDeviceState = ref.watch(jadeDeviceNotifierProvider);

    return SideSwapScaffold(
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      appBar: CustomAppBar(
        onPressed: () {
          ref.read(walletProvider).goBack();
        },
      ),
      body: SafeArea(
        child: switch (jadeDeviceState) {
          JadeDevicesStateAvailable(
            devices: List<From_JadePorts_Port> devices
          ) =>
            CustomScrollView(
              slivers: [
                SliverList.builder(
                  itemBuilder: (context, index) {
                    return JadeDeviceItem(jadePort: devices[index]);
                  },
                  itemCount: devices.length,
                ),
              ],
            ),
          _ => const SizedBox(),
        },
      ),
    );
  }
}

class JadeDeviceItem extends ConsumerWidget {
  const JadeDeviceItem({super.key, required this.jadePort});

  final From_JadePorts_Port jadePort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeOnboardingRegistration =
        ref.watch(jadeOnboardingRegistrationNotifierProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomBigButton(
            width: double.infinity,
            height: 78,
            backgroundColor: SideSwapColors.blueSapphire,
            onPressed: jadeOnboardingRegistration !=
                    const JadeOnboardingRegistrationStateIdle()
                ? null
                : () {
                    ref
                        .read(jadeSelectedDeviceProvider.notifier)
                        .setJadePortsPort(jadePort);
                    ref
                        .read(pageStatusNotifierProvider.notifier)
                        .setStatus(Status.jadeConnecting);
                    ref.read(walletProvider).jadeLogin(jadePort.jadeId);
                  },
            child: SizedBox(
              height: 78,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SvgPicture.asset(
                    'assets/jade_connection_icon.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        jadePort.port,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/jade.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
