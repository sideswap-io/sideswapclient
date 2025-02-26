import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onboarding/onboarding.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/jade/jade_rescan_listener.dart';
import 'package:sideswap_permissions/sideswap_permissions.dart';

class JadeBluetoothPermission extends HookConsumerWidget {
  const JadeBluetoothPermission({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothPermissionState = ref.watch(
      jadeBluetoothPermissionStateNotifierProvider,
    );
    final jadeDeviceState = ref.watch(jadeDeviceNotifierProvider);

    useEffect(() {
      (switch (jadeDeviceState) {
        JadeDevicesStateUnavailable() => () {}(),
        _ => () {
          // has device port, remove listener
          Future.microtask(() {
            ref.invalidate(jadeBluetoothPermissionStateNotifierProvider);
            ref
                .read(pageStatusNotifierProvider.notifier)
                .setStatus(Status.jadeDevices);
          });
        }(),
      });

      return;
    }, [jadeDeviceState]);

    return SideSwapScaffold(
      onPopInvokedWithResult: (didPop, result) {
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
        child: Column(
          children: [
            ...switch (bluetoothPermissionState) {
              JadeBluetoothPermissionStateEmpty() => [const SizedBox()],
              _ => [const JadeRescanListener()],
            },
            SizedBox(
              height: 550,
              child: Onboarding(
                swipeableBody: const [
                  JadePermissionPageOne(),
                  JadePermissionPageTwo(),
                ],
                startIndex: 0,
                buildFooter: (
                  context,
                  dragDistance,
                  pagesLength,
                  currentIndex,
                  setIndex,
                  sd,
                ) {
                  return Indicator(
                    painter: CirclePainter(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      currentPageIndex: currentIndex,
                      slideDirection: SlideDirection.left_to_right,
                      activePainter:
                          Paint()
                            ..color = Colors.white
                            ..style = PaintingStyle.fill,
                      inactivePainter:
                          Paint()
                            ..color = Colors.grey
                            ..style = PaintingStyle.fill,
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'SideSwap needs access to Bluetooth in order to connect to hardware wallets. Location data is not used or keep by SideSwap.'
                        .tr()
                        .tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'More info'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: SideSwapColors.brightTurquoise,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JadePermissionPageTwo extends ConsumerWidget {
  const JadePermissionPageTwo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothPermissionState = ref.watch(
      jadeBluetoothPermissionStateNotifierProvider,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(width: 0, color: Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/instructions_jade.svg',
              width: 215,
              height: 155,
            ),
            const SizedBox(height: 30),
            Text(
              'Step 2'.tr(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Follow the instructions on Jade'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Select initialize and choose to create a New wallet'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 16),
            ),
            const Spacer(),
            ...switch (bluetoothPermissionState) {
              JadeBluetoothPermissionStateEmpty() => [const SizedBox()],
              _ => [const CircularProgressIndicator.adaptive()],
            },
            const SizedBox(height: 32),
            CustomBigButton(
              width: double.infinity,
              height: 54,
              text: 'GIVE BLUETOOTH PERMISSIONS'.tr(),
              onPressed: () async {
                ref.invalidate(jadeDeviceNotifierProvider);
                final plugin = SideswapPermissionsPlugin();
                var hasBluetoothScanPermission =
                    await plugin.hasBluetoothScanPermission();
                if (!hasBluetoothScanPermission) {
                  hasBluetoothScanPermission =
                      await plugin.requestBluetoothScanPermission();
                }

                if (!hasBluetoothScanPermission) {
                  return;
                }

                var hasBluetoothConnectPermission =
                    await plugin.hasBluetoothConnectPermission();
                if (!hasBluetoothConnectPermission) {
                  hasBluetoothConnectPermission =
                      await plugin.requestBluetoothConnectPermission();
                }

                if (!hasBluetoothConnectPermission) {
                  return;
                }

                ref
                    .read(jadeBluetoothPermissionStateNotifierProvider.notifier)
                    .setPermissionState(
                      const JadeBluetoothPermissionState.request(),
                    );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class JadePermissionPageOne extends HookConsumerWidget {
  const JadePermissionPageOne({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(width: 0, color: Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SvgPicture.asset('assets/power_jade.svg', width: 215, height: 155),
            const SizedBox(height: 30),
            Text(
              'Step 1'.tr(),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Power on Jade'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Hold the green button in the bottom of Jade until it boots up'
                  .tr(),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
