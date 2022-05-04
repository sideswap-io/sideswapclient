import 'dart:math';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/d_tx_history.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/utils_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/models/account_asset.dart';

class DesktopHome extends ConsumerStatefulWidget {
  const DesktopHome({Key? key}) : super(key: key);

  @override
  _DesktopHomeState createState() => _DesktopHomeState();
}

class _DesktopHomeState extends ConsumerState<DesktopHome> {
  Future<void> handleExport(WalletChangeNotifier wallet) async {
    final list = exportTxList(wallet.allTxs.values, wallet.assets);
    final csv = convertToCsv(list);

    try {
      final defaultPath = await getApplicationDocumentsDirectory();
      const defaultName = 'transactions.csv';
      final path = await getSavePath(
        initialDirectory: defaultPath.path,
        suggestedName: defaultName,
      );
      if (path != null) {
        final data = Uint8List.fromList(csv.codeUnits);
        final file =
            XFile.fromData(data, name: defaultName, mimeType: 'text/plain');
        await file.saveTo(path);
      }
    } catch (e) {
      ref.read(utilsProvider).showErrorDialog(
            e.toString(),
            buttonText: 'OK'.tr(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final wallet = ref.watch(walletProvider);
        final regularAccounts = wallet
            .getAllAccounts()
            .where((e) => e.account.isRegular())
            .toList();
        final ampAccounts =
            wallet.getAllAccounts().where((e) => e.account.isAmp()).toList();
        final allNewTxs = wallet.getAllNewTxsSorted();
        final showUnconfirmed = allNewTxs.isNotEmpty && wallet.syncComplete;
        final unconfirmedHeight = min(allNewTxs.length, 3) * 40 + 50;
        final ampId = wallet.ampId;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Row(
                        children: [
                          const Text('Wallet view',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
                          const Spacer(),
                          if (ampId != null)
                            Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF1C6086),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  const Text(
                                    'AMP ID:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    ampId,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      await copyToClipboard(
                                        context,
                                        ampId,
                                      );
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/copy2.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          const SizedBox(width: 16),
                          DHoverButton(
                            builder: (context, states) {
                              return SvgPicture.asset('assets/export.svg');
                            },
                            onPressed: () => handleExport(wallet),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(children: [
                        const Expanded(
                          child: _Headeritem(text: 'Type of asset'),
                        ),
                        SizedBox(
                          width: 577,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              _Headeritem(text: 'Asset'),
                              _Headeritem(text: 'Balance'),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    _SubAccount(
                      isAmp: false,
                      accounts: regularAccounts,
                    ),
                    _SubAccount(
                      isAmp: true,
                      accounts: ampAccounts,
                    ),
                  ],
                ),
              ),
            ),
            if (showUnconfirmed)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Unconfirmed transactions'.tr(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: unconfirmedHeight.toDouble(),
                        child: const DesktopTxHistory(
                          horizontalPadding: 16,
                          newTxsOnly: true,
                        ),
                      ),
                    ],
                  ),
                  decoration: const BoxDecoration(
                      color: Color(0xFF1C6086),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      )),
                ),
              )
          ],
        );
      },
    );
  }
}

class _Headeritem extends StatelessWidget {
  const _Headeritem({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF87C1E1),
      ),
    );
  }
}

class _SubAccount extends StatefulWidget {
  const _SubAccount({Key? key, required this.isAmp, required this.accounts})
      : super(key: key);

  final bool isAmp;
  final List<AccountAsset> accounts;

  @override
  State<_SubAccount> createState() => _SubAccountState();
}

class _SubAccountState extends State<_SubAccount> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final text = widget.isAmp ? 'AMP assets'.tr() : 'Regular assets'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    _expanded ? 'assets/arrow_down.svg' : 'assets/arrow_up.svg',
                  ),
                  const Spacer(),
                ],
              ),
            ),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          decoration: BoxDecoration(
            color: _expanded ? const Color(0xB50F577A) : Colors.transparent,
            border: Border.all(
              color: const Color(0xFF2E7CA7),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ),
        if (_expanded)
          Center(
            child: SizedBox(
              width: 577,
              child: Column(
                children: withDivider(
                    List.generate(widget.accounts.length, (index) {
                      return Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final wallet = ref.watch(walletProvider);
                          final balances = ref.watch(balancesProvider);
                          final account = widget.accounts[index];
                          final asset = wallet.assets[account.asset];
                          final icon = wallet.assetImagesSmall[account.asset];
                          final balance = balances.balances[account] ?? 0;
                          final balanceStr = amountStr(balance,
                              precision: asset?.precision ?? 0);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                icon ?? Container(),
                                const SizedBox(width: 8),
                                Text(
                                  asset?.ticker ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                Text(
                                  balanceStr,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                    Container(
                      height: 1,
                      color: const Color(0xFF2B6F95),
                    )),
              ),
            ),
          ),
        if (!_expanded || widget.accounts.isEmpty) const SizedBox(height: 10),
      ],
    );
  }
}
