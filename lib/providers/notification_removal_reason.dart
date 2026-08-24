/// Why a Liquid Connect request left the pending list.
///
/// Every removal carries one: the desktop window is put back only for a
/// resolution the user actually performed. See ADR-0004 decision 3.
enum NotificationRemovalReason {
  /// The user accepted the request.
  acceptedByUser,

  /// The user rejected the request, or dismissed the dialog showing it.
  rejectedByUser,

  /// The request's time-to-live ran out with no user action.
  expired,

  /// The origin that sent the request withdrew it.
  remoteCancel,
}
