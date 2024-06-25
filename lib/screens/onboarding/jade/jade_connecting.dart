import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/screens/onboarding/jade/widgets/jade_circular_progress_indicator.dart';

class JadeConnecting extends HookConsumerWidget {
  const JadeConnecting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadePort = ref.read(jadeSelectedDeviceProvider);

    return SideSwapScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset('assets/jade_device.svg'),
              const SizedBox(height: 56),
              Text(
                'JADE {}'.tr(args: [jadePort?.jadeId ?? '']),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 76),
              const JadeCircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
