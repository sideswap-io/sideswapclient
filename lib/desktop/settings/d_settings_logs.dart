import 'package:easy_localization/easy_localization.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/wallet.dart';

class DSettingsLogs extends ConsumerWidget {
  const DSettingsLogs({super.key});

  Future<void> saveLog(String filename) async {
    final dir = (await getApplicationSupportDirectory()).path;
    final filePath = '$dir/$filename.log';

    final file = XFile(filePath, mimeType: "text/plain");

    final defaultPath = await getApplicationDocumentsDirectory();
    final saveLocation = await getSaveLocation(
      initialDirectory: defaultPath.path,
      suggestedName: '$filename.txt',
    );

    (switch (saveLocation) {
      final saveLocation? => () async {
          await file.saveTo(saveLocation.path);
        }(),
      _ => () {}(),
    });
  }

  void showDesktopExportLogMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    const buttonOffset = Offset(244, 46);

    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(buttonOffset, ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero) + Offset.zero,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Text('Export log'.tr()),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text('Export previous log'.tr()),
        ),
      ],
    );

    (switch (result) {
      1 => saveLog("sideswap"),
      2 => saveLog("sideswap_prev"),
      _ => () {}(),
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).settingsDialogTheme;
    final defaultButtonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .buttonThemeData
        .defaultButtonStyle;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          content: Text('Logs'.tr()),
          onClose: () {
            ref.read(walletProvider).goBack();
          },
        ),
        content: Center(
          child: SizedBox(
            height: 206,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Builder(
                    builder: (context) {
                      return DButton(
                        onPressed: () {
                          showDesktopExportLogMenu(context);
                        },
                        style: defaultButtonStyle,
                        child: SizedBox(
                          width: 344,
                          height: 44,
                          child: Center(
                            child: Text(
                              'Export'.tr(),
                              style: Theme.of(context).textTheme.titleSmall,
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
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 693),
      ),
    );
  }
}
