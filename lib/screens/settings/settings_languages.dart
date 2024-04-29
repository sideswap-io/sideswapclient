import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/providers/locales_provider.dart';

class Languages extends ConsumerWidget {
  const Languages({
    super.key,
  });

  VoidCallback close(BuildContext context) {
    return () {
      Navigator.of(context).pop();
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = supportedLanguages();
    final selectedLang = ref.watch(localesNotifierProvider);

    return SideSwapScaffold(
      canPop: true,
      appBar: CustomAppBar(
        title: 'Language'.tr(),
        onPressed: close(context),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 18),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = lang == selectedLang;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color:
                              isSelected ? SideSwapColors.chathamsBlue : null,
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: const Color(0xFF327FA9), width: 1),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            onTap: () {
                              ref
                                  .read(localesNotifierProvider.notifier)
                                  .setSelectedLang(lang);
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    localeIconFile(lang),
                                    const SizedBox(width: 8),
                                    Text(
                                      localeName(lang),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              decoration: DContentDialogThemeData.standard().actionsDecoration,
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 118),
              child: DCustomTextBigButton(
                width: 266,
                onPressed: close(context),
                child: Text(
                  'BACK'.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
