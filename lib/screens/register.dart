import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';

// TODO: fix that - new ui
class SelectEnv extends StatefulWidget {
  @override
  _SelectEnvState createState() => _SelectEnvState();
}

class _SelectEnvState extends State<SelectEnv> {
  int selectedEnv;

  @override
  Widget build(BuildContext context) {
    final wallet = context.read(walletProvider);
    var env = selectedEnv ?? wallet.env();
    return SideSwapScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => context.read(walletProvider).goBack(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  'Select env',
                  style: TextStyle(fontSize: 18),
                ).tr(),
                SizedBox(height: 20),
                Column(
                  children: envValues
                      .map((e) => RadioListTile<int>(
                            title: Text(envName(e)),
                            value: e,
                            groupValue: env,
                            onChanged: (e) {
                              setState(() {
                                selectedEnv = e;
                              });
                            },
                          ))
                      .toList(),
                ),
                OutlineButton(
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Center(child: Text('Switch').tr()),
                  ),
                  onPressed: () async => await wallet.setEnv(env),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
