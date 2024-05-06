import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_releases.g.dart';
part 'app_releases.freezed.dart';

@freezed
class AppReleasesDesktop with _$AppReleasesDesktop {
  const factory AppReleasesDesktop({
    String? version,
    int? build,
    String? changes,
  }) = _AppReleasesDesktop;

  factory AppReleasesDesktop.fromJson(Map<String, dynamic> json) =>
      _$AppReleasesDesktopFromJson(json);
}

@freezed
class AppReleasesModel with _$AppReleasesModel {
  const factory AppReleasesModel({
    AppReleasesDesktop? desktop,
  }) = _AppReleasesModel;

  factory AppReleasesModel.fromJson(Map<String, dynamic> json) =>
      _$AppReleasesModelFromJson(json);
}

@freezed
sealed class AppReleasesModelState {
  const factory AppReleasesModelState.data(AppReleasesModel model) =
      AppReleasesModelStateData;
  const factory AppReleasesModelState.empty() = AppReleasesModelStateEmpty;
}
