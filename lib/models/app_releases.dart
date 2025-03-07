import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_releases.g.dart';
part 'app_releases.freezed.dart';

@freezed
sealed class AppReleasesDesktop with _$AppReleasesDesktop {
  const factory AppReleasesDesktop({
    String? version,
    int? build,
    String? changes,
  }) = _AppReleasesDesktop;

  factory AppReleasesDesktop.fromJson(Map<String, dynamic> json) =>
      _$AppReleasesDesktopFromJson(json);
}

@freezed
sealed class AppReleasesModel with _$AppReleasesModel {
  const factory AppReleasesModel({AppReleasesDesktop? desktop}) =
      _AppReleasesModel;

  factory AppReleasesModel.fromJson(Map<String, dynamic> json) =>
      _$AppReleasesModelFromJson(json);
}

@freezed
sealed class AppReleasesModelState with _$AppReleasesModelState {
  const factory AppReleasesModelState.data(AppReleasesModel model) =
      AppReleasesModelStateData;
  const factory AppReleasesModelState.empty() = AppReleasesModelStateEmpty;
}
