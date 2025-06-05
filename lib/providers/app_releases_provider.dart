import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/app_releases.dart';
import 'package:sideswap/providers/config_provider.dart';

part 'app_releases_provider.g.dart';

@riverpod
class AppReleasesStateNotifier extends _$AppReleasesStateNotifier {
  @override
  FutureOr<AppReleasesModelState> build() async {
    var appReleasesState = await getAppRelease();
    final timer = Timer.periodic(const Duration(days: 1), (_) async {
      appReleasesState = await getAppRelease();
    });

    ref.onDispose(() {
      timer.cancel();
    });

    return appReleasesState;
  }

  Future<AppReleasesModelState> getAppRelease() async {
    try {
      final url = Uri.parse('https://app.sideswap.io/app_releases.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final appReleases = AppReleasesModel.fromJson(jsonData);
        return AppReleasesModelState.data(appReleases);
      }
    } catch (e) {
      logger.e(e);
    }

    return const AppReleasesModelState.empty();
  }

  bool newDesktopReleaseAvailable() {
    final knownNewReleaseBuild = ref
        .read(configurationProvider)
        .knownNewReleaseBuild;

    return switch (state) {
      AsyncValue(hasValue: true, value: AppReleasesModelState modelState)
          when modelState is AppReleasesModelStateData =>
        max(appBuildNumber, knownNewReleaseBuild) <
            (modelState.model.desktop?.build ?? 0),
      _ => false,
    };
  }

  void ackNewDesktopRelease() {
    return switch (state) {
      AsyncValue(hasValue: true, value: AppReleasesModelState modelState)
          when modelState is AppReleasesModelStateData =>
        () {
          final latestBuild = modelState.model.desktop?.build;
          if (latestBuild != null) {
            ref
                .read(configurationProvider.notifier)
                .setKnownNewReleaseBuild(latestBuild);
          }
        }(),
      _ => () {}(),
    };
  }
}

@riverpod
FutureOr<bool> showNewReleaseFuture(Ref ref) {
  final knownNewReleaseBuild = ref
      .watch(configurationProvider)
      .knownNewReleaseBuild;

  final appReleasesState = ref.watch(appReleasesStateNotifierProvider);

  return switch (appReleasesState) {
    AsyncValue(hasValue: true, value: AppReleasesModelState modelState)
        when modelState is AppReleasesModelStateData =>
      max(appBuildNumber, knownNewReleaseBuild) <
          (modelState.model.desktop?.build ?? 0),
    _ => false,
  };
}
