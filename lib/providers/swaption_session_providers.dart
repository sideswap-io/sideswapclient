import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart' show Session;

part 'swaption_session_providers.g.dart';
part 'swaption_session_providers.freezed.dart';

@freezed
sealed class SwaptionSession with _$SwaptionSession {
  const factory SwaptionSession({
    required String sessionId,
    required String domain,
  }) = _SwaptionSession;

  factory SwaptionSession.fromJson(Map<String, dynamic> json) =>
      _$SwaptionSessionFromJson(json);
}

@Riverpod(keepAlive: true)
class SwaptionSessionNotifier extends _$SwaptionSessionNotifier {
  @override
  List<SwaptionSession> build() {
    return [];
  }

  void addSession(Session session) {
    if (state.any((element) => element.sessionId == session.sessionId)) {
      return;
    }

    logger.d('SwaptionSessionNotifier::addSession: $session');
    state = [
      ...state,
      SwaptionSession(sessionId: session.sessionId, domain: session.domain),
    ];
  }

  void removeSessions(String sessionId) {
    logger.d('SwaptionSessionNotifier::removeSession: $sessionId');
    state = state.where((element) => element.sessionId != sessionId).toList();
  }

  void replaceSessions(List<Session> sessions) {
    final newList = sessions
        .map((e) => SwaptionSession(sessionId: e.sessionId, domain: e.domain))
        .toList();

    logger.d('SwaptionSessionNotifier::replaceSessions: $newList');
    state = newList;
  }
}
