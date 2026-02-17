import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/desktop_root_widget.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';

class DesktopAppMain extends StatelessWidget {
  const DesktopAppMain({super.key});

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

class DesktopApp extends HookConsumerWidget {
  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(universalLinkProvider).handleIncomingLinks();
      ref.read(universalLinkProvider).handleInitialUri();

      return;
    }, const []);

    return Consumer(
      builder: (context, ref, _) {
        final desktopAppTheme = ref.watch(desktopAppThemeProvider);

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
            extensions: desktopAppTheme.themeExtensions,
          ),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
          home: const Material(child: DesktopRootWidget()),
        );
      },
    );
  }
}
