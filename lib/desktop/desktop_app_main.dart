import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/desktop_root_widget.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/locales_provider.dart';

class DSideSwapScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class DesktopAppMain extends StatelessWidget {
  const DesktopAppMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: supportedLocales(),
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const DesktopApp(),
    );
  }
}

class DesktopApp extends StatelessWidget {
  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final desktopAppTheme = ref.watch(desktopAppThemeNotifierProvider);

        return MaterialApp(
          title: 'SideSwap',
          showSemanticsDebugger: false,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: desktopAppTheme.mode,
          darkTheme: ThemeData(
            brightness: desktopAppTheme.brightness,
            textTheme: desktopAppTheme.textTheme,
            colorScheme: desktopAppTheme.darkScheme,
            scaffoldBackgroundColor: desktopAppTheme.scaffoldBackgroundColor,
            visualDensity: desktopAppTheme.visualDensity,
            fontFamily: desktopAppTheme.fontFamily,
            scrollbarTheme: desktopAppTheme.scrollbarTheme,
            textSelectionTheme: desktopAppTheme.textSelectionTheme,
          ),
          scrollBehavior: DSideSwapScrollBehavior(),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
          home: const Material(child: DesktopRootWidget()),
        );
      },
    );
  }
}
