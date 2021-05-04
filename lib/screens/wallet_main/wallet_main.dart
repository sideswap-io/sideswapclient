import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/ui_state_args_provider.dart';
import 'package:sideswap/screens/accounts/accounts.dart';
import 'package:sideswap/screens/accounts/asset_details.dart';
import 'package:sideswap/screens/accounts/assets_list.dart';
import 'package:sideswap/screens/home/home.dart';
import 'package:sideswap/screens/receive/asset_receive_popup.dart';
import 'package:sideswap/screens/swap/swap.dart';
import 'package:sideswap/screens/wallet_main/widgets/main_bottom_navigation_bar.dart';

class WalletMain extends StatefulWidget {
  @override
  _WalletMainState createState() => _WalletMainState();
}

class _WalletMainState extends State<WalletMain> {
  DateTime currentBackPressTime;

  Widget getChild(WalletMainNavigationItem navigationItem) {
    switch (navigationItem) {
      case WalletMainNavigationItem.home:
        return Home();
        break;
      case WalletMainNavigationItem.homeAssetReceive:
      case WalletMainNavigationItem.assetReceive:
        return AssetReceivePopup();
        break;
      case WalletMainNavigationItem.accounts:
        return Accounts();
        break;
      case WalletMainNavigationItem.assetSelect:
        return AssetSelectList();
        break;
      case WalletMainNavigationItem.assetDetails:
        return AssetDetails();
        break;
      case WalletMainNavigationItem.transactions:
        return Container();
        break;
      case WalletMainNavigationItem.requests:
        return Container();
        break;
      case WalletMainNavigationItem.swap:
        return SwapMain();
        break;
    }

    throw Exception('unexpected mainPage');
  }

  Future<bool> closeApp() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _currentPageIndex =
            watch(uiStateArgsProvider).walletMainArguments.currentIndex;
        final _navigationItem =
            watch(uiStateArgsProvider).walletMainArguments.navigationItem;

        return SideSwapScaffold(
          onWillPop: () async {
            if (_currentPageIndex == 0 &&
                _navigationItem == WalletMainNavigationItem.home) {
              final now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime) >
                      Duration(seconds: 2, milliseconds: 700)) {
                currentBackPressTime = now;
                final flushbar = Flushbar<Widget>(
                  messageText: Text(
                    'Press back again to exit'.tr(),
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  duration: Duration(seconds: 3),
                  animationDuration: Duration(milliseconds: 150),
                  backgroundColor: Color(0xFF0F4766),
                  onTap: (flushbar) {
                    flushbar.dismiss();
                    currentBackPressTime = null;
                    return false;
                  },
                  onStatusChanged: (status) {
                    if (status == FlushbarStatus.DISMISSED &&
                        currentBackPressTime != null) {
                      final now = DateTime.now();
                      if (now.difference(currentBackPressTime) <
                          Duration(seconds: 3)) {
                        return closeApp();
                      }
                    }
                  },
                );
                await flushbar.show(context);
              } else {
                return closeApp();
              }

              return false;
            }
            final uiStateArgs = context.read(uiStateArgsProvider);
            uiStateArgs.walletMainArguments =
                uiStateArgs.walletMainArguments.fromIndex(0);
            return false;
          },
          body: SafeArea(
            child: getChild(_navigationItem),
          ),
          bottomNavigationBar: MainBottomNavigationBar(
            currentIndex: _currentPageIndex,
            onTap: (index) {
              context.read(swapProvider).swapReset();
              final uiStateArgs = context.read(uiStateArgsProvider);
              uiStateArgs.walletMainArguments =
                  uiStateArgs.walletMainArguments.fromIndex(index);

              // TODO: fix current index when request tab will be ready
              // if (uiStateArgs.walletMainArguments.currentIndex == 2) {
              //   uiStateArgs.walletMainArguments.navigationItem =
              //       uiStateArgs.lastWalletMainArguments.navigationItem;
              //   context.read(swapProvider).selectSwapMain();
              // }
            },
          ),
        );
      },
    );
  }
}
