import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/widgets/confirm_phone_bottom_panel.dart';
import 'package:sideswap/screens/pay/widgets/friends_panel.dart';
import 'package:sideswap/screens/pay/widgets/payment_continue_button.dart';
import 'package:sideswap/screens/pay/widgets/whom_to_pay_text_field.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage>
    with WidgetsBindingObserver {
  late TextEditingController addressController;
  String? errorText;
  AddrType addrType = AddrType.elements;
  bool continueEnabled = false;
  Friend? friend;
  double overlap = .0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    addressController = TextEditingController()..addListener(onAddressChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    addressController.dispose();
    super.dispose();
  }

  void onAddressChanged() {
    if (addressController.text.isEmpty) {
      setState(() {
        errorText = null;
        continueEnabled = false;
        friend = null;
      });
    }
  }

  bool validate() {
    final newErrorText = ref
        .read(walletProvider)
        .commonAddrErrorStr(addressController.text, addrType);
    if (newErrorText.isNotEmpty) {
      friend =
          ref.read(friendsProvider).getFriendByName(addressController.text);
      if (friend != null) {
        // friend found
        setState(() {
          errorText = null;
          continueEnabled = false;
        });
        return true;
      }

      setState(() {
        errorText = newErrorText;
        continueEnabled = false;
      });
    } else if (addressController.text.isNotEmpty) {
      setState(() {
        errorText = null;
        continueEnabled = true;
      });
      return true;
    }

    if (newErrorText.isEmpty) {
      setState(() {
        errorText = null;
      });
      return false;
    }

    return false;
  }

  @override
  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    overlap = widgetRect.bottom - keyboardTopPoints;
    if (overlap >= 0) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Whom to pay'.tr(),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final isPhoneRegistered =
                ref.watch(configProvider.select((p) => p.phoneKey.isNotEmpty));

            if (FlavorConfig.isProduction &&
                FlavorConfig.enableOnboardingUserFeatures) {
              if (isPhoneRegistered) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
                        child: WhomToPayTextField(
                          validator: validate,
                          addressController: addressController,
                          errorText: errorText,
                          addrType: addrType,
                        ),
                      ),
                      if (continueEnabled) ...[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 24.h, left: 16.w, right: 16.w),
                          child: PaymentContinueButton(
                            enabled: continueEnabled,
                            errorText: errorText,
                            addressController: addressController,
                          ),
                        ),
                      ],
                      FriendsPanel(
                        searchString:
                            friend != null ? addressController.text : null,
                      ),
                    ],
                  ),
                );
              } else {
                return Builder(
                  builder: (context) {
                    var bodyHeight = MediaQuery.of(context).size.height -
                        Scaffold.of(context).appBarMaxHeight!.toDouble();
                    return SingleChildScrollView(
                      child: SizedBox(
                        height: bodyHeight,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 32.h, left: 16.w, right: 16.w),
                              child: WhomToPayTextField(
                                validator: validate,
                                addressController: addressController,
                                errorText: errorText,
                              ),
                            ),
                            if (continueEnabled) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 24.h, left: 16.w, right: 16.w),
                                child: PaymentContinueButton(
                                  enabled: continueEnabled,
                                  errorText: errorText,
                                  addressController: addressController,
                                ),
                              ),
                            ],
                            const Spacer(),
                            const ConfirmPhoneBottomPanel(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
                    child: WhomToPayTextField(
                      validator: validate,
                      addressController: addressController,
                      errorText: errorText,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                    child: PaymentContinueButton(
                      enabled: continueEnabled,
                      errorText: errorText,
                      addressController: addressController,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
