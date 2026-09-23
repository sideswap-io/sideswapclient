import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

import 'fake_shared_preferences.dart';

/// A container whose [configurationProvider] persists into [prefs].
///
/// Pass [overrides] for anything the test needs on top of the three the
/// configuration itself depends on.
ProviderContainer settingsContainer(
  FakeSharedPreferences prefs, {
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer.test(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
      localesProvider.overrideWithValue('en'),
      ...overrides,
    ],
  );
  // `configurationProvider` auto-disposes, and these tests keep a notifier
  // across an await. Hold it open for the length of the test.
  final subscription = container.listen(configurationProvider, (_, _) {});
  addTearDown(subscription.close);
  return container;
}

/// What the next app start loads out of [prefs]. The copy matters: a container
/// built over the live store persists its own state too, so reading through
/// one would make the reload a second writer racing the container under test.
SideswapSettings reloadSettings(FakeSharedPreferences prefs) {
  return settingsContainer(
    FakeSharedPreferences(prefs.snapshot),
  ).read(configurationProvider);
}
