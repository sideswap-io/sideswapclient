import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_addr_field.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/balances_provider.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
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
  ConsumerState<DSendPopupCreate> createState() => _DSendPopupState();
}

class _DSendPopupState extends ConsumerState<DSendPopupCreate> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();

  late AccountAsset selected;
  String receiveConversion = '';
  bool enabled = false;
  bool showInsufficientFunds = false;

  @override
  void initState() {
    final wallet = ref.read(walletProvider);
    selected = AccountAsset(AccountType.regular, wallet.liquidAssetId());
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    addressController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  String getBalanceStr(AccountAsset account) {
    final asset = ref.read(walletProvider).assets[account.asset]!;
    final balance = ref.read(balancesProvider).balances[selected] ?? 0;
    final balanceStr = amountStr(balance, precision: asset.precision);
    return balanceStr;
  }

  void validate({bool requestAmountFocus = false}) {
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
      if (requestAmountFocus && addressValid) {
        amountFocusNode.requestFocus();
      }
    });
  }

  void submitReview() {
    final wallet = ref.read(walletProvider);
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
    final defaultAccount =
        AccountAsset(AccountType.regular, wallet.liquidAssetId());
    final accounts = wallet
        .getAllAccounts()
        .where((account) =>
            (balances.balances[account] ?? 0) != 0 || account == defaultAccount)
        .toList();

    return DPopupWithClose(
      width: 580,
      height: 606,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Text(
              'Create transaction'.tr(),
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Address'.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF00C5FF),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: Column(
                children: [
                  DAddrTextField(
                    autofocus: true,
                    onChanged: (value) {
                      setState(
                        () {
                          validate(requestAmountFocus: true);
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
                setState(() {
                  if (selected != value) {
                    selected = value;
                    amountController.clear();
                    validate(requestAmountFocus: true);
                  }
                });
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
            // Row(
            //   children: [
            //     DCustomButton(
            //       width: 245,
            //       height: 44,
            //       child: Text('Add more outputs'.tr().toUpperCase()),
            //       // TODO: Check wallet.isCreatingTx here
            //       // onPressed: () {},
            //     ),
            //     const Spacer(),
            //     DCustomButton(
            //       width: 245,
            //       height: 44,
            //       child: Text('Review'.tr().toUpperCase()),
            //       isFilled: true,
            //       onPressed:
            //           enabled && !wallet.isCreatingTx ? submitReview : null,
            //     ),
            //   ],
            // )
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
    final feeStr = amountStrNamed(createdTx.networkFee.toInt(), 'L-BTC');

    const headerStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Color(0xFF00C5FF),
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
                        .map((e) => _RowTxReceiver(
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
            color: const Color(0xFF135579),
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _RowTxDetail(name: 'Fee per byte'.tr(), value: feePerByteStr),
                  _RowTxDetail(name: 'Transaction size'.tr(), value: txSizeStr),
                  _RowTxDetail(name: 'Network Fee'.tr(), value: feeStr),
                  _RowTxDetail(
                      name: 'Number of inputs'.tr(),
                      value: createdTx.inputCount.toString()),
                  _RowTxDetail(
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

class _RowTxReceiver extends ConsumerWidget {
  const _RowTxReceiver({
    required this.address,
    required this.assetId,
    required this.amount,
  });

  final String address;
  final String assetId;
  final int amount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.read(walletProvider);
    final asset = wallet.assets[assetId]!;
    final amountStr =
        amountStrNamed(amount, asset.ticker, precision: asset.precision);
    final icon = wallet.assetImagesSmall[assetId]!;

    return Row(
      children: [
        Expanded(child: Text(address)),
        const SizedBox(width: 116),
        Text(amountStr),
        const SizedBox(width: 8),
        icon,
      ],
    );
  }
}

class _RowTxDetail extends StatelessWidget {
  const _RowTxDetail({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(value),
        ],
      ),
    );
  }
}
