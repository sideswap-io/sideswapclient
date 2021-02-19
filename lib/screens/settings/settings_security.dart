import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';

class SettingsSecurity extends StatefulWidget {
  SettingsSecurity({Key key}) : super(key: key);

  @override
  _SettingsSecurityState createState() => _SettingsSecurityState();
}

class _SettingsSecurityState extends State<SettingsSecurity> {
  bool _settingsBiometricAvailable = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      _settingsBiometricAvailable =
          await context.read(walletProvider).isBiometricAvailable();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _isBiometricEnabled =
        context.read(walletProvider).isBiometricEnabled();

    return _settingsBiometricAvailable
        ? Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: InkWell(
              onTap: () {
                if (_isBiometricEnabled) {
                  context.read(walletProvider).settingsDisableBiometric();
                  return;
                }

                context.read(walletProvider).settingsEnableBiometric();
              },
              child: AbsorbPointer(
                child: Container(
                  height: 60.w,
                  child: TextButton(
                    onPressed: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: Icon(
                            Icons.fingerprint,
                            size: 24.h,
                            color: Color(0xFF00C5FF),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Text(
                            'Biometric protection'.tr(),
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 19.w),
                          child: FlutterSwitch(
                            value: _isBiometricEnabled,
                            onToggle: (val) {},
                            width: 51.h,
                            height: 31.h,
                            toggleSize: 27.h,
                            padding: 2.h,
                            activeColor: Color(0xFF00C5FF),
                            inactiveColor: Color(0xFF164D6A),
                            toggleColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Color(0xFF135579),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.w),
                        ),
                      ),
                      side: BorderSide(
                        color: Color(0xFF135579),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
