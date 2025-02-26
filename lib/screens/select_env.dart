import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/custom_scrollable_container.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/select_env_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class SelectEnv extends HookConsumerWidget {
  const SelectEnv({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      body: SafeArea(
        child: CustomScrollableContainer(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => ref.read(walletProvider).goBack(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Text('Select env', style: TextStyle(fontSize: 18)).tr(),
                  const SizedBox(height: 20),
                  Column(
                    children:
                        envValues()
                            .map(
                              (e) => Consumer(
                                builder: (context, ref, _) {
                                  final selectedEnv = ref.watch(
                                    selectedEnvProvider,
                                  );

                                  return RadioListTile<int>(
                                    title: Text(envName(e)),
                                    value: e,
                                    groupValue: selectedEnv,
                                    onChanged: (e) async {
                                      if (e == null) {
                                        return;
                                      }
                                      await ref
                                          .read(selectedEnvProvider.notifier)
                                          .setSelectedEnv(e);
                                    },
                                  );
                                },
                              ),
                            )
                            .toList(),
                  ),
                  Consumer(
                    builder: (context, ref, _) {
                      final env = ref.watch(envProvider);
                      final selectedEnv = ref.watch(selectedEnvProvider);
                      final buttonText =
                          env == selectedEnv
                              ? 'CLOSE'.tr()
                              : 'SWITCH AND EXIT'.tr();

                      return OutlinedButton(
                        onPressed: () {
                          final selectedEnv = ref.read(selectedEnvProvider);
                          ref.read(envProvider.notifier).setEnv(selectedEnv);
                          // and also reset network settings model
                          ref
                              .read(networkSettingsNotifierProvider.notifier)
                              .setModel(const NetworkSettingsModelEmpty());

                          exit(0);
                        },
                        child: SizedBox(
                          width: 140,
                          height: 40,
                          child: Center(
                            child: Text(
                              buttonText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
