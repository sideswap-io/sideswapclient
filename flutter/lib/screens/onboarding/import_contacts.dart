import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/contact_provider.dart';
import 'package:sideswap/models/phone_provider.dart';
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
                Padding(
                  padding: EdgeInsets.only(top: 56.h),
                  child: const ImportContactsImage(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Text(
                    'Want to import contacts?'.tr(),
                    style: GoogleFonts.roboto(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Visibility(
                  visible: contactsLoadingState == ContactsLoadingState.running,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 32.w, right: 16.w, left: 16.w),
                    child: SideSwapProgressBar(
                      percent: percent,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 32.h),
                  child: const PageDots(
                    maxSelectedDots: 4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54.h,
                    backgroundColor: const Color(0xFF00C5FF),
                    text: 'YES'.tr(),
                    enabled:
                        contactsLoadingState != ContactsLoadingState.running,
                    onPressed: () {
                      ref.read(contactProvider).loadContacts();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                    child: CustomBigButton(
                      width: double.maxFinite,
                      height: 54.h,
                      backgroundColor: Colors.transparent,
                      text: 'NOT NOW'.tr(),
                      textColor: const Color(0xFF00C5FF),
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
