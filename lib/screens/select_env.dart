import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/custom_scrollable_container.dart';

import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';

// TODO: fix that - new ui
class SelectEnv extends ConsumerStatefulWidget {
  const SelectEnv({super.key});

  @override
  SelectEnvState createState() => SelectEnvState();
}

class SelectEnvState extends ConsumerState<SelectEnv> {
  int selectedEnv = 0;

  @override
  Widget build(BuildContext context) {
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
                              groupValue: selectedEnv,
                              onChanged: (e) {
                                if (e == null) {
                                  return;
                                }

                                setState(() {
                                  selectedEnv = e;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  OutlinedButton(
                    onPressed: () async =>
                        await ref.read(walletProvider).setEnv(selectedEnv),
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
