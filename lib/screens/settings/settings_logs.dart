import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';

class SettingsLogs extends HookWidget {
  const SettingsLogs({super.key});

  void showExportLogMenu(BuildContext context, GlobalKey buttonKey) async {
    final box = buttonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonOffset = box.localToGlobal(Offset.zero);

    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(Offset(0, buttonOffset.dy), ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero) + Offset.zero,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu(
      context: context,
      position: position,
      color: SideSwapColors.chathamsBlue,
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
      1 => shareLogFile("sideswap.log", box),
      2 => shareLogFile("sideswap_prev.log", box),
      _ => () {}(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonKey = useMemoized(() => GlobalKey());

    return SideSwapScaffold(
      canPop: true,
      appBar: CustomAppBar(
        title: 'Logs'.tr(),
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: TextButton(
                    key: buttonKey,
                    onPressed: () {
                      showExportLogMenu(context, buttonKey);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: SideSwapColors.chathamsBlue,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    child: Text(
                      'Export'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
