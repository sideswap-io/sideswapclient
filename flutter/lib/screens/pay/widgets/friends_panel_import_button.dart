import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/contact_provider.dart';
import 'package:sideswap/screens/pay/widgets/friends_panel_import_button_painter.dart';

class FriendsPanelImportButton extends ConsumerStatefulWidget {
  const FriendsPanelImportButton({
    super.key,
    this.width,
    this.height,
    this.onPressed,
  });

  final double? width;
  final double? height;
  final VoidCallback? onPressed;

  @override
  FriendsPanelImportButtonState createState() =>
      FriendsPanelImportButtonState();
}

class FriendsPanelImportButtonState
    extends ConsumerState<FriendsPanelImportButton> {
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
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8.w)),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        child: InkWell(
          onTap: () {
            ref.read(contactProvider).loadContacts();
          },
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Consumer(
              builder: (context, ref, child) {
                final contactsLoadingState = ref.watch(
                    contactProvider.select((p) => p.contactsLoadingState));
                if (contactsLoadingState != ContactsLoadingState.running) {
                  percent = 0;
                }

                return CustomPaint(
                  painter: FriendsPanelImportButtonPainter(
                    percent: percent,
                  ),
                  child: Center(
                    child: Text(
                      '+ IMPORT'.tr(),
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
