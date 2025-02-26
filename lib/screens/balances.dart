import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';

String pegTypeName(bool isPegIn) {
  if (isPegIn) {
    return 'Peg-In'.tr();
  }
  return 'Peg-Out'.tr();
}

class WalletTxMemo extends StatefulWidget {
  const WalletTxMemo({super.key});

  @override
  WalletTxMemoState createState() => WalletTxMemoState();
}

class WalletTxMemoState extends State<WalletTxMemo> {
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void afterBuild(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          height: 176,
          child: Column(
            children: [
              const CustomAppBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        children: [
                          Text(
                            'My notes'.tr(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Only visible to you'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: SideSwapColors.airSuperiorityBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final tx = ref.watch(walletProvider).txDetails.tx;
                          final initialValue = ref
                              .watch(walletProvider)
                              .txMemo(tx);
                          return TextFormField(
                            focusNode: _focusNode,
                            initialValue: initialValue,
                            onChanged:
                                (value) => ref
                                    .read(walletProvider)
                                    .onTxMemoChanged(value),
                            onFieldSubmitted: (value) {
                              ref.read(walletProvider).goBack();
                            },
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF002241),
                            ),
                            decoration: const SideSwapInputDecoration(
                              hintText: '',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
