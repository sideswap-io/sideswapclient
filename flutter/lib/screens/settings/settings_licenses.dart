import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sideswap/app_version.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';

class SettingsLicenses extends StatefulWidget {
  const SettingsLicenses({super.key});

  @override
  SettingsLicensesState createState() => SettingsLicensesState();
}

class SettingsLicensesState extends State<SettingsLicenses> {
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
    final theme = Theme.of(context);
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      var tempSubWidget = <Widget>[];
      final paragraphs =
          await SchedulerBinding.instance.scheduleTask<List<LicenseParagraph>>(
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
          '\u202C',
          textAlign: TextAlign.center,
        ),
      ));

      for (var paragraph in paragraphs) {
        if (paragraph.indent == LicenseParagraph.centeredIndent) {
          tempSubWidget.add(
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                paragraph.text,
                style: const TextStyle(
                  fontSize: 12,
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
        data: theme.copyWith(
          dividerColor: Colors.transparent,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xFF00C5FF)),
        ),
        child: ExpansionTile(
          title: Text(
            packageName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'licenses'.plural(count),
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
        if (packageName == kPackageGdk || packageName == kPackageSideswap) {
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
                      const Text(
                        'SideSwap',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'VERSION'.tr(args: [appVersion]),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Copyright © 2021 SideSwap',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                      if (!_loaded) ...[
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 32),
                              child: SpinKitThreeBounce(
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      ],
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
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
