import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/enums.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/widgets/payment_continue_button.dart';
import 'package:sideswap/screens/pay/widgets/whom_to_pay_text_field.dart';

class PaymentPage extends HookConsumerWidget {
  const PaymentPage({super.key});

  bool validate(String addressText, String newErrorText) {
    if (newErrorText.isNotEmpty) {
      return false;
    }

    if (addressText.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressController = useTextEditingController();
    final continueEnabled = useState(false);
    final errorText = useState<String?>(null);
    const addrType = AddrType.elements;

    final addressText = useValueListenable(addressController);

    useEffect(() {
      if (addressController.text.isEmpty) {
        errorText.value = null;
        continueEnabled.value = false;
      }

      final newErrorText = ref
          .read(walletProvider)
          .commonAddrErrorStr(addressController.text, addrType);

      if (newErrorText.isNotEmpty) {
        errorText.value = newErrorText;
        continueEnabled.value = false;
      } else {
        errorText.value = null;
        if (addressController.text.isNotEmpty) {
          continueEnabled.value = true;
        }
      }

      return;
    }, [addressText]);

    final paymentHelper = ref.watch(paymentHelperProvider);

    ref.listen<QrCodeResultModel>(qrCodeResultModelNotifierProvider, (_, next) {
      next.when(
        empty: () {},
        data: (result) {
          if (result?.outputsData != null) {
            // go to the confirm transaction page directly
            ref.invalidate(paymentAmountPageArgumentsNotifierProvider);
            paymentHelper.outputsPaymentSend();
            return;
          }
          addressController.text = result?.address ?? '';

          final newErrorText = ref
              .read(walletProvider)
              .commonAddrErrorStr(addressController.text, addrType);

          if (validate(addressController.text, newErrorText)) {
            ref
                .read(paymentAmountPageArgumentsNotifierProvider.notifier)
                .setPaymentAmountPageArguments(
                  PaymentAmountPageArguments(result: result),
                );
            ref
                .read(pageStatusNotifierProvider.notifier)
                .setStatus(Status.paymentAmountPage);

            return;
          }
        },
      );
    });

    // go to the next page as soon as the address is correct
    useEffect(() {
      if (continueEnabled.value) {
        Future.microtask(() {
          ref
              .read(paymentAmountPageArgumentsNotifierProvider.notifier)
              .setPaymentAmountPageArguments(
                PaymentAmountPageArguments(
                  result: QrCodeResult(address: addressController.text),
                ),
              );
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.paymentAmountPage);
        });
      }

      return;
    }, [continueEnabled.value]);

    return SideSwapScaffold(
      appBar: CustomAppBar(title: 'Whom to pay'.tr()),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
              child: HookBuilder(
                builder: (_) {
                  final errorTextField = useValueListenable(errorText);
                  return WhomToPayTextField(
                    addressController: addressController,
                    errorText: errorTextField,
                  );
                },
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
              child: HookBuilder(
                builder: (_) {
                  final buttonContinueEnabled = useValueListenable(
                    continueEnabled,
                  );
                  final buttonErrorText = useValueListenable(errorText);
                  return PaymentContinueButton(
                    enabled: buttonContinueEnabled,
                    errorText: buttonErrorText,
                    addressController: addressController,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
