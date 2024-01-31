import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/app_version.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/licenses_provider.dart';

class SettingsLicenses extends HookConsumerWidget {
  const SettingsLicenses({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final licenseEntries = ref.watch(licensesEntriesProvider);

    final licenses = useState(<Widget>[]);
    final licenseContent = useState(<String, List<Widget>>{});

    useEffect(() {
      licenseEntries.whenData((value) {
        final List<Widget> newLicenses = [];
        final Map<String, List<Widget>> newLicenseContent = {};
        for (var license in value) {
          var tempSubWidget = <Widget>[];

          if (newLicenseContent
              .containsKey(license.licenseEntry.packages.join(', '))) {
            tempSubWidget =
                newLicenseContent[license.licenseEntry.packages.join(', ')] ??
                    [];
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
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
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
      });

      return;
    }, [licenseEntries]);

    return SideSwapScaffold(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          Navigator.of(context).pop();
        }
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
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: ValueListenableBuilder(
                            valueListenable: licenses,
                            builder: (context, value, child) {
                              if (value.isEmpty) {
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
                                child: ListView.separated(
                                  itemCount: value.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(
                                    color: SideSwapColors.chathamsBlue,
                                  ),
                                  itemBuilder: (context, index) {
                                    return value.elementAt(index);
                                  },
                                ),
                              );
                            },
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
