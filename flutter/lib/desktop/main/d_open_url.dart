import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/desktop/widgets/d_side_swap_input_decoration.dart';
import 'package:sideswap/models/universal_link_provider.dart';
import 'package:sideswap/models/utils_provider.dart';

class DOpenUrl extends ConsumerStatefulWidget {
  const DOpenUrl({super.key});

  @override
  ConsumerState<DOpenUrl> createState() => _DOpenUrlState();
}

class _DOpenUrlState extends ConsumerState<DOpenUrl> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleSubmit() {
    Navigator.pop(context);
    final handleResult =
        ref.read(universalLinkProvider).handleAppUrlStr(controller.text);
    if (handleResult != HandleResult.success) {
      ref.read(utilsProvider).showErrorDialog(
            'Invalid URL'.tr(),
            buttonText: 'OK'.tr(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DPopupWithClose(
      width: 580,
      height: 320,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              'Paste private swap URL'.tr(),
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: controller,
              decoration: DSideSwapInputDecoration(
                hintText: 'URL',
                errorText: null,
                onPastePressed: () async {
                  await handlePasteSingleLine(controller);
                  setState(() {});
                },
              ),
              onChanged: (value) {},
              autofocus: true,
              style: const TextStyle(color: Colors.black),
            ),
            const Spacer(),
            DCustomButton(
              height: 44,
              isFilled: true,
              onPressed: handleSubmit,
              child: Text('OK'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
