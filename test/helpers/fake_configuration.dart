import 'package:sideswap/providers/config_provider.dart';

/// Shared fake for [Configuration] notifier.
///
/// Use with [configurationProvider.overrideWith]:
/// ```dart
/// configurationProvider.overrideWith(() => FakeConfiguration(settings))
/// ```
class FakeConfiguration extends Configuration {
  final SideswapSettings _settings;

  FakeConfiguration(this._settings);

  @override
  SideswapSettings build() => _settings;
}
