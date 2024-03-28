import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_mnemonic_table.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/mnemonic_table_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:window_manager/window_manager.dart';

part 'd_settings_view_backup.g.dart';

@riverpod
class IsCopyEnabled extends _$IsCopyEnabled {
  @override
  bool build() {
    return true;
  }

  void setCopyEnabled(bool value) {
    state = value;
  }
}

class CopyMnemonicIntent extends Intent {
  const CopyMnemonicIntent();
}

class CopyMnemonicAction extends Action<CopyMnemonicIntent> {
  CopyMnemonicAction(this.context, this.words);

  final String words;
  final BuildContext context;

  @override
  void invoke(covariant CopyMnemonicIntent intent) {
    copyToClipboard(context, words, displaySnackbar: true, suffix: 'mnemonic');
  }
}

class DSettingsViewBackup extends StatefulHookConsumerWidget {
  const DSettingsViewBackup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DSettingsViewBackupState();
}

class _DSettingsViewBackupState extends ConsumerState<DSettingsViewBackup>
    with WindowListener {
  @override
  void onWindowEvent(String eventName) {
    if (eventName == 'blur') {
      ref.read(isCopyEnabledProvider.notifier).setCopyEnabled(false);
    }

    if (eventName == 'focus') {
      ref.read(isCopyEnabledProvider.notifier).setCopyEnabled(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).defaultDialogTheme;

    useEffect(() {
      WindowManager.instance.addListener(this);

      return () {
        WindowManager.instance.removeListener(this);
      };
    }, const []);

    final wordCount = ref.watch(mnemonicWordItemsNotifierProvider).length;
    final words = ref.watch(walletProvider).getMnemonicWords();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          if (Platform.isLinux || Platform.isFuchsia) ...{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
                LogicalKeyboardKey.keyC): const CopyMnemonicIntent(),
          },
          if (Platform.isWindows) ...{
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
                const CopyMnemonicIntent(),
          },
          if (Platform.isMacOS) ...{
            LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyC):
                const CopyMnemonicIntent(),
          },
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            CopyMnemonicIntent: CopyMnemonicAction(context, words.join(' ')),
          },
          child: Builder(
            builder: (context) {
              return Focus(
                autofocus: true,
                child: DContentDialog(
                  title: DContentDialogTitle(
                    content: Text('Recovery phrase'.tr()),
                    onClose: () {
                      ref.read(walletProvider).goBack();
                    },
                  ),
                  content: Center(
                    child: SizedBox(
                      height: 430,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            Text(
                                'Your $wordCount word recovery phrase is your wallets backup. Write it down and store it somewhere safe, preferably offline.'
                                    .tr()),
                            Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: DMnemonicTable(
                                enabled: false,
                                itemsCount: wordCount,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final enabled =
                                      ref.watch(isCopyEnabledProvider);

                                  return DButton(
                                    onPressed: enabled
                                        ? () {
                                            Actions.maybeInvoke<
                                                    CopyMnemonicIntent>(context,
                                                const CopyMnemonicIntent());
                                          }
                                        : null,
                                    child: SizedBox(
                                      height: 34,
                                      width: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/copy3.svg',
                                              width: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Copy mnemonic'.tr(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Center(
                      child: DCustomTextBigButton(
                        width: 266,
                        onPressed: () {
                          ref.read(walletProvider).goBack();
                        },
                        child: Text(
                          'BACK'.tr(),
                        ),
                      ),
                    ),
                  ],
                  style:
                      const DContentDialogThemeData().merge(defaultDialogTheme),
                  constraints: const BoxConstraints(maxWidth: 580),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
