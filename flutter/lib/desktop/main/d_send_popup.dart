import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_detail.dart';
import 'package:sideswap/desktop/main/widgets/row_tx_receiver.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_addr_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/send_asset_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/swap/widgets/swap_side_amount.dart';

class DSendPopup extends ConsumerWidget {
  const DSendPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payment = ref.watch(paymentProvider);
    // Use Stack to simplify Back press processing
    return Stack(
      children: [
        const DSendPopupCreate(),
        if (payment.createdTx != null) const DSendPopupReview(),
      ],
    );
  }
}

class DSendPopupCreate extends ConsumerStatefulWidget {
  const DSendPopupCreate({super.key});

  @override
  ConsumerState<DSendPopupCreate> createState() => DSendPopupState();
}

class DSendPopupState extends ConsumerState<DSendPopupCreate> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FocusNode addressFocusNode = FocusNode();
  FocusNode amountFocusNode = FocusNode();

  String receiveConversion = '';
  bool enabled = false;
  bool showInsufficientFunds = false;

  @override
  void dispose() {
    amountController.dispose();
    addressController.dispose();
    addressFocusNode.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  String getBalanceStr(AccountAsset account) {
    final selected = ref.read(sendAssetProvider);
    final asset = ref.read(assetsStateProvider)[account.asset];
    final assetPrecision = ref
        .read(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);
    final balance = ref.read(balancesProvider).balances[selected] ?? 0;
    final amountProvider = ref.watch(amountToStringProvider);
    final balanceStr = amountProvider.amountToString(
        AmountToStringParameters(amount: balance, precision: assetPrecision));
    return balanceStr;
  }

  void validate({bool requestFocus = false}) {
    final selected = ref.read(sendAssetProvider);
    setState(() {
      receiveConversion = ref
          .read(requestOrderProvider)
          .dollarConversionFromString(selected.asset, amountController.text);
      final addressValid = ref
          .read(walletProvider)
          .isAddrValid(addressController.text, AddrType.elements);
      final amount = double.tryParse(amountController.text) ?? 0.0;
      final balance = double.tryParse(getBalanceStr(selected)) ?? 0.0;
      showInsufficientFunds = amount > balance;
      enabled = addressValid && amount > 0 && amount <= balance;
      if (requestFocus) {
        if (addressValid) {
          amountFocusNode.requestFocus();
        } else {
          addressFocusNode.requestFocus();
        }
      }
    });
  }

  void submitReview() {
    final wallet = ref.read(walletProvider);
    final selected = ref.read(sendAssetProvider);
    if (enabled && !wallet.isCreatingTx) {
      ref.read(paymentProvider).selectPaymentSend(
            amountController.text,
            selected,
            address: addressController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = ref.watch(walletProvider);
    final balances = ref.watch(balancesProvider);
    final liquidAssetId = ref.watch(liquidAssetIdProvider);
    final defaultAccount = AccountAsset(AccountType.reg, liquidAssetId);
    final allAccounts = ref.watch(allAccountsProvider);
    final accounts = allAccounts
        .where((account) =>
            (balances.balances[account] ?? 0) != 0 || account == defaultAccount)
        .toList();
    final selected = ref.watch(sendAssetProvider);

    return DPopupWithClose(
      width: 580,
      height: 606,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text(
              'Create transaction'.tr(),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address'.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: SideSwapColors.brightTurquoise,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: Column(
                children: [
                  DAddrTextField(
                    focusNode: addressFocusNode,
                    autofocus: true,
                    onChanged: (value) {
                      setState(
                        () {
                          validate(requestFocus: true);
                        },
                      );
                    },
                    controller: addressController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SwapSideAmount(
              showInsufficientFunds: showInsufficientFunds,
              dollarConversion2:
                  showInsufficientFunds ? null : receiveConversion,
              focusNode: amountFocusNode,
              availableAssets: accounts,
              dropdownValue: selected,
              swapType: SwapType.atomic,
              text: 'Send',
              isMaxVisible: true,
              showAccountsInPopup: true,
              controller: amountController,
              balance: getBalanceStr(selected),
              onSubmitted: (_) {
                submitReview();
              },
              onDropdownChanged: (value) {
                if (selected != value) {
                  ref.read(sendAssetProvider.notifier).setSendAsset(value);
                  amountController.clear();
                }
                validate(requestFocus: true);
              },
              onChanged: (_) {
                validate();
              },
              onMaxPressed: () {
                amountController.text = getBalanceStr(selected);
                validate();
              },
            ),
            const Spacer(),
            DCustomButton(
              height: 44,
              isFilled: true,
              onPressed: enabled && !wallet.isCreatingTx ? submitReview : null,
              child: Text('Review'.tr().toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}

class DSendPopupReview extends ConsumerWidget {
  const DSendPopupReview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final payment = ref.watch(paymentProvider);
    final createdTx = payment.createdTx!;

    final feePerByteStr = '${createdTx.feePerByte.toStringAsFixed(3)} s/b';
    final txSizeStr =
        '${createdTx.size.toString()} Bytes / ${createdTx.vsize.toString()} VBytes';
    final amountProvider = ref.watch(amountToStringProvider);
    final feeStr = amountProvider.amountToStringNamed(
        AmountToStringNamedParameters(
            amount: createdTx.networkFee.toInt(), ticker: 'L-BTC'));

    const headerStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.brightTurquoise,
    );

    return DPopupWithClose(
      width: 580,
      height: 605,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
              child: Column(
                children: [
                  Text(
                    'Confirm transaction'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Address'.tr(), style: headerStyle),
                      Text('Amount'.tr(), style: headerStyle),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Column(
                    children: createdTx.addressees
                        .map((e) => RowTxReceiver(
                              address: e.address,
                              assetId: e.assetId,
                              amount: e.amount.toInt(),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: SideSwapColors.chathamsBlue,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  RowTxDetail(name: 'Fee per byte'.tr(), value: feePerByteStr),
                  RowTxDetail(name: 'Transaction size'.tr(), value: txSizeStr),
                  RowTxDetail(name: 'Network Fee'.tr(), value: feeStr),
                  RowTxDetail(
                      name: 'Number of inputs'.tr(),
                      value: createdTx.inputCount.toString()),
                  RowTxDetail(
                      name: 'Number of outputs'.tr(),
                      value: createdTx.outputCount.toString()),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      DCustomButton(
                        width: 245,
                        height: 44,
                        onPressed: !wallet.isSendingTx
                            ? () {
                                ref.read(paymentProvider).createdTx = null;
                              }
                            : null,
                        child: Text('Back'.tr().toUpperCase()),
                      ),
                      const Spacer(),
                      DCustomButton(
                        width: 245,
                        height: 44,
                        autofocus: true,
                        isFilled: true,
                        onPressed: !wallet.isSendingTx
                            ? () async {
                                if (await ref
                                    .read(walletProvider)
                                    .isAuthenticated()) {
                                  ref
                                      .read(walletProvider)
                                      .assetSendConfirmCommon(
                                          payment.createdTx!.req.account);
                                }
                              }
                            : null,
                        child: Row(
                          children: [
                            const Spacer(),
                            Text('Broadcast'.tr().toUpperCase()),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  Visibility(
                                    visible: wallet.isSendingTx,
                                    child: const SpinKitCircle(
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
