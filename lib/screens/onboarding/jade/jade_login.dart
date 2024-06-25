import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/onboarding/jade/widgets/jade_circular_progress_indicator.dart';

class JadeLogin extends ConsumerWidget {
  const JadeLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 86,
              ),
              const JadeCircularProgressIndicator(
                showLogo: true,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Logging in...'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
