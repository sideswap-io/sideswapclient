import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/custom_scrollable_container.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';

class SelectEnv extends HookConsumerWidget {
  const SelectEnv({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedEnv = useState(0);

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
                  const Text(
                    'Select env',
                    style: TextStyle(fontSize: 18),
                  ).tr(),
                  const SizedBox(height: 20),
                  Column(
                    children: envValues()
                        .map((e) => RadioListTile<int>(
                              title: Text(envName(e)),
                              value: e,
                              groupValue: selectedEnv.value,
                              onChanged: (e) {
                                if (e == null) {
                                  return;
                                }

                                selectedEnv.value = e;
                              },
                            ))
                        .toList(),
                  ),
                  OutlinedButton(
                    onPressed: () async => await ref
                        .read(walletProvider)
                        .setEnv(selectedEnv.value),
                    child: SizedBox(
                      width: 100,
                      height: 40,
                      child: Center(
                          child: const Text(
                        'Switch',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ).tr()),
                    ),
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
