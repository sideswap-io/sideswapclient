import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/providers/config_provider.dart';

final appReleasesProvider =
    ChangeNotifierProvider<AppReleasesChangeNotifier>((ref) {
  return AppReleasesChangeNotifier(ref);
});

class AppReleasesChangeNotifier with ChangeNotifier {
  final Ref ref;

  late final Timer _timer;

  String? versionDesktopLatest;
  int? buildDesktopLatest;
  String? changesDesktopLatest;

  AppReleasesChangeNotifier(this.ref) {
    reload();
    _timer = Timer.periodic(const Duration(days: 1), _onTick);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void reload() async {
    try {
      final url = Uri.parse('https://app.sideswap.io/app_releases.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final appReleases = jsonDecode(response.body) as Map<String, dynamic>;
        final desktop = (appReleases["desktop"] as Map<String, dynamic>);
        versionDesktopLatest = desktop['version'] as String;
        buildDesktopLatest = desktop['build'] as int;
        changesDesktopLatest = desktop['changes'] as String;

        notifyListeners();
      }
    } catch (e) {
      logger.e(e);
    }
  }

  bool newDesktopReleaseAvailable() {
    final knownNewReleaseBuild = ref.read(configProvider).knownNewReleaseBuild;
    return max(appBuildNumber, knownNewReleaseBuild) <
        (buildDesktopLatest ?? 0);
  }

  Future<void> ackNewDesktopRelease() async {
    final config = ref.read(configProvider);
    await config.setKnownNewReleaseBuild(buildDesktopLatest!);
    notifyListeners();
  }

  void _onTick(Timer timer) {
    reload();
  }
}
