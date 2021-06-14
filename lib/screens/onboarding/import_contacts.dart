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
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/import_contacts_image.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class ImportContacts extends StatefulWidget {
  ImportContacts({Key? key}) : super(key: key);

  @override
  _ImportContactsState createState() => _ImportContactsState();
}

class _ImportContactsState extends State<ImportContacts> {
  StreamSubscription<int>? percentageLoadedSubscription;
  int percent = 0;

  @override
  void initState() {
    super.initState();

    percentageLoadedSubscription = context
        .read(contactProvider)
        .percentageLoaded
        .listen(onPercentageLoaded);
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
      body: Center(
        child: Consumer(
          builder: (context, watch, child) {
            final contactsLoadingState =
                watch(contactProvider).contactsLoadingState;
            if (contactsLoadingState == ContactsLoadingState.done) {
              Future.microtask(() {
                context.read(walletProvider).setImportContactsSuccess();
              });
            }
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 56.h),
                  child: ImportContactsImage(),
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
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: 32.h),
                  child: PageDots(
                    maxSelectedDots: 4,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54.h,
                    backgroundColor: Color(0xFF00C5FF),
                    text: 'YES'.tr(),
                    enabled:
                        contactsLoadingState != ContactsLoadingState.running,
                    onPressed: () {
                      context.read(contactProvider).loadContacts();
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
                      textColor: Color(0xFF00C5FF),
                      enabled:
                          contactsLoadingState != ContactsLoadingState.running,
                      onPressed: () async {
                        await context
                            .read(walletProvider)
                            .loginAndLoadMainPage();
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
