import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/app_version.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/models/wallet.dart';

class DLicenses {
  LicenseEntry licenseEntry;
  List<LicenseParagraph> paragraphs;

  DLicenses({
    required this.licenseEntry,
    required this.paragraphs,
  });
}

class DSettingsLicenses extends HookConsumerWidget {
  const DSettingsLicenses({super.key});

  void goBack(WidgetRef ref) {
    ref.read(walletProvider).setRegistered();
    ref.read(walletProvider).settingsViewAboutUs();
  }

  Future<List<DLicenses>> getLicenseEntries() async {
    final licenses = <DLicenses>[];
    await for (final LicenseEntry license in LicenseRegistry.licenses) {
      licenses.add(DLicenses(
          licenseEntry: license, paragraphs: license.paragraphs.toList()));
    }

    return licenses;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeProvider).settingsDialogTheme;

    final licenses = useState(<Widget>[]);
    final licenseContent = useState(<String, List<Widget>>{});
    final licenseEntries = useMemoized(() => getLicenseEntries());
    final licenseSnapshot = useFuture(licenseEntries);
    final controller = useScrollController();

    useEffect(() {
      if (!licenseSnapshot.hasData) {
        return;
      }

      final List<Widget> newLicenses = [];
      final Map<String, List<Widget>> newLicenseContent = {};
      for (var license in licenseSnapshot.data!) {
        var tempSubWidget = <Widget>[];

        if (newLicenseContent
            .containsKey(license.licenseEntry.packages.join(', '))) {
          tempSubWidget =
              newLicenseContent[license.licenseEntry.packages.join(', ')] ?? [];
        }

        tempSubWidget.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            '\u2618',
            textAlign: TextAlign.center,
          ),
        ));

        for (var paragraph in license.paragraphs) {
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
        newLicenseContent[license.licenseEntry.packages.join(', ')] =
            tempSubWidget;
      }

      newLicenseContent.keys.toList().sort();

      for (var packageName in newLicenseContent.keys.toList()) {
        var count = 0;
        final value = newLicenseContent[packageName];

        if (value != null) {
          for (var element in value) {
            if (element.runtimeType == Divider) count += 1;
          }
        }

        final widget = Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            collapsedIconColor: Colors.white,
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

        if (packageName == kPackageGdk || packageName == kPackageSideswap) {
          newLicenses.insert(0, widget);
        } else {
          newLicenses.add(widget);
        }
      }

      licenses.value = newLicenses;
      licenseContent.value = newLicenseContent;

      return;
    }, [licenseSnapshot.data]);

    return WillPopScope(
      onWillPop: () async {
        goBack(ref);
        return false;
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          onClose: () {
            goBack(ref);
          },
          content: Text('SideSwap'.tr()),
        ),
        content: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Text(
                  'VERSION'.tr(args: [appVersionFull]),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Copyright © 2022 SideSwap',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
                // if (_licenses.value.isEmpty) ...[],
                SizedBox(
                  height: 467,
                  child: ValueListenableBuilder(
                    valueListenable: licenses,
                    builder: (context, List<Widget> licenses, __) {
                      if (licenses.isEmpty) {
                        return const Padding(
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
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: controller,
                          child: ListView.separated(
                            controller: controller,
                            itemCount: licenses.length,
                            separatorBuilder: (context, index) => const Divider(
                              color: Color(0xFF135579),
                            ),
                            itemBuilder: (context, index) {
                              return licenses.elementAt(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: DCustomTextBigButton(
              onPressed: () {
                goBack(ref);
              },
              child: Text(
                'BACK'.tr(),
              ),
            ),
          ),
        ],
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 693),
      ),
    );
  }
}
