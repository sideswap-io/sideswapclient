import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';

class SettingsLicenses extends StatefulWidget {
  const SettingsLicenses({Key? key}) : super(key: key);

  @override
  _SettingsLicensesState createState() => _SettingsLicensesState();
}

class _SettingsLicensesState extends State<SettingsLicenses> {
  final List<Widget> _licenses = <Widget>[];
  final Map<String, List<Widget>> _licenseContent = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _initLicenses();
  }

  Future<void> _initLicenses() async {
    // most of these part are taken from flutter showLicensePage
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      var tempSubWidget = <Widget>[];
      final paragraphs =
          await SchedulerBinding.instance?.scheduleTask<List<LicenseParagraph>>(
        license.paragraphs.toList,
        Priority.animation,
        debugLabel: 'License',
      );

      if (_licenseContent.containsKey(license.packages.join(', '))) {
        tempSubWidget = _licenseContent[license.packages.join(', ')] ?? [];
      }

      tempSubWidget.add(const Padding(
        padding: EdgeInsets.symmetric(vertical: 18.0),
        child: Text(
          '🍀‬', // That's U+1F340. Could also use U+2766 (❦) if U+1F340 doesn't work everywhere.
          textAlign: TextAlign.center,
        ),
      ));

      if (paragraphs != null) {
        for (var paragraph in paragraphs) {
          if (paragraph.indent == LicenseParagraph.centeredIndent) {
            tempSubWidget.add(
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text(
                  paragraph.text,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            tempSubWidget.add(
              Padding(
                padding: EdgeInsetsDirectional.only(
                    top: 8.0, start: 16.0 * paragraph.indent),
                child: Text(
                  paragraph.text,
                ),
              ),
            );
          }
        }
      }

      tempSubWidget.add(const Divider());
      _licenseContent[license.packages.join(', ')] = tempSubWidget;
    }

    _licenseContent.keys.toList().sort();

    for (var packageName in _licenseContent.keys.toList()) {
      var count = 0;
      final value = _licenseContent[packageName];

      if (value != null) {
        for (var element in value) {
          if (element.runtimeType == Divider) count += 1;
        }
      }

      final widget = Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          accentColor: const Color(0xFF00C5FF),
        ),
        child: ExpansionTile(
          title: Text(
            packageName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            '$count licenses',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          children: value != null
              ? <Widget>[
                  ...value,
                ]
              : [],
        ),
      );

      setState(() {
        if (packageName == kPackageLibwally ||
            packageName == kPackageGdk ||
            packageName == kPackageSideswap) {
          _licenses.insert(0, widget);
        } else {
          _licenses.add(widget);
        }
      });
    }

    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.h),
                        child: Text(
                          'SideSwap',
                          style: GoogleFonts.roboto(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: FutureBuilder(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final packageInfo = snapshot.data as PackageInfo;
                              return Text(
                                'VERSION'.tr(args: [packageInfo.version]),
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              );
                            }

                            return Container();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          'Copyright © 2021 SideSwap',
                          style: GoogleFonts.roboto(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                      if (!_loaded) ...[
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 32.h),
                              child: SpinKitThreeBounce(
                                color: Colors.white,
                                size: 24.w,
                              ),
                            ),
                          ),
                        )
                      ],
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16.h),
                            child: ListView.separated(
                              itemCount: _licenses.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                color: Color(0xFF135579),
                              ),
                              itemBuilder: (context, index) {
                                return _licenses.elementAt(index);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
