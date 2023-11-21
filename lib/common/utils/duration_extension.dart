import 'package:sideswap/common/helpers.dart';

extension DurationExtensions on Duration? {
  String toStringCustom() {
    final duration = this;
    if (duration == null || duration.inSeconds == 0) {
      return unlimitedTtl;
    }

    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    }
    return '${duration.inSeconds}s';
  }

  String toStringCustomShort() {
    final duration = this;
    if (duration == null || duration.inSeconds == 0) {
      return unlimitedTtl;
    }

    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}s';
  }
}
