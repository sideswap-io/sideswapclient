import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/contact_provider.dart';
import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/import_contacts_image.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class ImportContacts extends ConsumerStatefulWidget {
  const ImportContacts({super.key});

  @override
  ImportContactsState createState() => ImportContactsState();
}

class ImportContactsState extends ConsumerState<ImportContacts> {
  StreamSubscription<int>? percentageLoadedSubscription;
  int percent = 0;

  @override
  void initState() {
    super.initState();

    percentageLoadedSubscription =
        ref.read(contactProvider).percentageLoaded.listen(onPercentageLoaded);
  }

  @override
  void dispose() {
    percentageLoadedSubscription?.cancel();
    super.dispose();
  }

  void onPercentageLoaded(int value) {
    setState(() {
      percent = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () async {
        return false;
      },
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final contactsLoadingState =
                ref.watch(contactProvider).contactsLoadingState;
            if (contactsLoadingState == ContactsLoadingState.done) {
              Future.microtask(() async {
                final confirmPhoneData =
                    ref.read(phoneProvider).getConfirmPhoneData();
                await confirmPhoneData.onImportContactsSuccess!(context);
              });
            }
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 56),
                  child: ImportContactsImage(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Want to import contacts?'.tr(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Visibility(
                  visible: contactsLoadingState == ContactsLoadingState.running,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 32, right: 16, left: 16),
                    child: SideSwapProgressBar(
                      percent: percent,
                    ),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: PageDots(
                    maxSelectedDots: 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
                    backgroundColor: SideSwapColors.brightTurquoise,
                    text: 'YES'.tr(),
                    enabled:
                        contactsLoadingState != ContactsLoadingState.running,
                    onPressed: () {
                      ref.read(contactProvider).loadContacts();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54,
                      backgroundColor: Colors.transparent,
                      text: 'NOT NOW'.tr(),
                      textColor: SideSwapColors.brightTurquoise,
                      enabled:
                          contactsLoadingState != ContactsLoadingState.running,
                      onPressed: () async {
                        final confirmPhoneData =
                            ref.read(phoneProvider).getConfirmPhoneData();
                        await confirmPhoneData.onImportContactsDone!(context);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
