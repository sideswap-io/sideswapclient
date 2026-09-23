// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Notifications)
final notificationsProvider = NotificationsProvider._();

final class NotificationsProvider
    extends $NotifierProvider<Notifications, List<NotificationData>> {
  NotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationsHash();

  @$internal
  @override
  Notifications create() => Notifications();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NotificationData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NotificationData>>(value),
    );
  }
}

String _$notificationsHash() => r'5e081b3e0ec901e114d22ab5617b97bc24029683';

abstract class _$Notifications extends $Notifier<List<NotificationData>> {
  List<NotificationData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<NotificationData>, List<NotificationData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<NotificationData>, List<NotificationData>>,
              List<NotificationData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(activeNotifications)
final activeNotificationsProvider = ActiveNotificationsProvider._();

final class ActiveNotificationsProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ActiveNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeNotificationsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return activeNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$activeNotificationsHash() =>
    r'1c813c9007b18c0f03431457a8865220698728e2';

/// The entry [notificationId] addresses while its request is still pending, and
/// nothing once it is gone, cancelled, or addresses a different request.
///
/// [reqId] is what separates requests rather than entries: the local id is an
/// arrival counter whose uniqueness is a property of one notifier instance and
/// not of the protocol. It is not even one entry per id — a request carrying
/// both payloads files two under the same one, as the next paragraph says — so
/// matching the integer alone establishes nothing about *which request* the
/// entry belongs to, and comparing the request id is what does. That argument
/// holds whatever the counter happens to do, which is why the counter not
/// starting over at [Notifications.clearAll] (#211) costs it nothing.
/// ADR-0006 decision 3.
///
/// It does not separate the two entries of a request carrying both a connect
/// and a sign payload — [Notifications.addNotification] gives those one id and
/// one request id between them, so this answers with whichever the list holds
/// first. That is the same entry the lookup this replaced would have found, and
/// narrowing it needs an identity the protocol does not currently carry.

@ProviderFor(pendingRequest)
final pendingRequestProvider = PendingRequestFamily._();

/// The entry [notificationId] addresses while its request is still pending, and
/// nothing once it is gone, cancelled, or addresses a different request.
///
/// [reqId] is what separates requests rather than entries: the local id is an
/// arrival counter whose uniqueness is a property of one notifier instance and
/// not of the protocol. It is not even one entry per id — a request carrying
/// both payloads files two under the same one, as the next paragraph says — so
/// matching the integer alone establishes nothing about *which request* the
/// entry belongs to, and comparing the request id is what does. That argument
/// holds whatever the counter happens to do, which is why the counter not
/// starting over at [Notifications.clearAll] (#211) costs it nothing.
/// ADR-0006 decision 3.
///
/// It does not separate the two entries of a request carrying both a connect
/// and a sign payload — [Notifications.addNotification] gives those one id and
/// one request id between them, so this answers with whichever the list holds
/// first. That is the same entry the lookup this replaced would have found, and
/// narrowing it needs an identity the protocol does not currently carry.

final class PendingRequestProvider
    extends
        $FunctionalProvider<
          Option<NotificationData>,
          Option<NotificationData>,
          Option<NotificationData>
        >
    with $Provider<Option<NotificationData>> {
  /// The entry [notificationId] addresses while its request is still pending, and
  /// nothing once it is gone, cancelled, or addresses a different request.
  ///
  /// [reqId] is what separates requests rather than entries: the local id is an
  /// arrival counter whose uniqueness is a property of one notifier instance and
  /// not of the protocol. It is not even one entry per id — a request carrying
  /// both payloads files two under the same one, as the next paragraph says — so
  /// matching the integer alone establishes nothing about *which request* the
  /// entry belongs to, and comparing the request id is what does. That argument
  /// holds whatever the counter happens to do, which is why the counter not
  /// starting over at [Notifications.clearAll] (#211) costs it nothing.
  /// ADR-0006 decision 3.
  ///
  /// It does not separate the two entries of a request carrying both a connect
  /// and a sign payload — [Notifications.addNotification] gives those one id and
  /// one request id between them, so this answers with whichever the list holds
  /// first. That is the same entry the lookup this replaced would have found, and
  /// narrowing it needs an identity the protocol does not currently carry.
  PendingRequestProvider._({
    required PendingRequestFamily super.from,
    required (int, String) super.argument,
  }) : super(
         retry: null,
         name: r'pendingRequestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingRequestHash();

  @override
  String toString() {
    return r'pendingRequestProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<Option<NotificationData>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<NotificationData> create(Ref ref) {
    final argument = this.argument as (int, String);
    return pendingRequest(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<NotificationData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<NotificationData>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PendingRequestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingRequestHash() => r'5460298e1073407ff61ddb266e2e70a0e13ec519';

/// The entry [notificationId] addresses while its request is still pending, and
/// nothing once it is gone, cancelled, or addresses a different request.
///
/// [reqId] is what separates requests rather than entries: the local id is an
/// arrival counter whose uniqueness is a property of one notifier instance and
/// not of the protocol. It is not even one entry per id — a request carrying
/// both payloads files two under the same one, as the next paragraph says — so
/// matching the integer alone establishes nothing about *which request* the
/// entry belongs to, and comparing the request id is what does. That argument
/// holds whatever the counter happens to do, which is why the counter not
/// starting over at [Notifications.clearAll] (#211) costs it nothing.
/// ADR-0006 decision 3.
///
/// It does not separate the two entries of a request carrying both a connect
/// and a sign payload — [Notifications.addNotification] gives those one id and
/// one request id between them, so this answers with whichever the list holds
/// first. That is the same entry the lookup this replaced would have found, and
/// narrowing it needs an identity the protocol does not currently carry.

final class PendingRequestFamily extends $Family
    with $FunctionalFamilyOverride<Option<NotificationData>, (int, String)> {
  PendingRequestFamily._()
    : super(
        retry: null,
        name: r'pendingRequestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The entry [notificationId] addresses while its request is still pending, and
  /// nothing once it is gone, cancelled, or addresses a different request.
  ///
  /// [reqId] is what separates requests rather than entries: the local id is an
  /// arrival counter whose uniqueness is a property of one notifier instance and
  /// not of the protocol. It is not even one entry per id — a request carrying
  /// both payloads files two under the same one, as the next paragraph says — so
  /// matching the integer alone establishes nothing about *which request* the
  /// entry belongs to, and comparing the request id is what does. That argument
  /// holds whatever the counter happens to do, which is why the counter not
  /// starting over at [Notifications.clearAll] (#211) costs it nothing.
  /// ADR-0006 decision 3.
  ///
  /// It does not separate the two entries of a request carrying both a connect
  /// and a sign payload — [Notifications.addNotification] gives those one id and
  /// one request id between them, so this answers with whichever the list holds
  /// first. That is the same entry the lookup this replaced would have found, and
  /// narrowing it needs an identity the protocol does not currently carry.

  PendingRequestProvider call(int notificationId, String reqId) =>
      PendingRequestProvider._(argument: (notificationId, reqId), from: this);

  @override
  String toString() => r'pendingRequestProvider';
}

/// The request to present next on mobile: the oldest one still waiting, and
/// nothing while none is.
///
/// Mobile presents one request at a time, so this is the queue — derived from
/// the pending set rather than held beside it. A request that has to wait its
/// turn therefore stays in [notificationsProvider] the whole time, and keeps
/// counting towards everything read off that list, instead of being moved into
/// a holding pen where it would silently stop being pending. ADR-0006
/// decision 5.
///
/// Oldest first, because a queue served newest-first starves the request with
/// the least time left on it. Order is by id — the arrival counter — rather
/// than by `createdAt`, which [Notifications.addNotification] stamps from a
/// separate `DateTime.now()` call per payload branch.
///
/// The answer is folded out of the list rather than read off one end of it, so
/// it does not depend on the order the list happens to be held in. Ties are
/// settled in favour of the entry the list holds first, which is the entry
/// [pendingRequest] answers with for that id — the two have to agree about
/// which entry an id addresses. A tie needs two entries under one id, which
/// `addNotification` would produce for a request carrying both a connect and a
/// sign payload; the wire makes that impossible today, because the two are a
/// protobuf `oneof`. Both the tie-break and the append-order independence are
/// therefore defensive, and stated here so neither is mistaken for a property
/// the list guarantees.

@ProviderFor(nextPendingRequest)
final nextPendingRequestProvider = NextPendingRequestProvider._();

/// The request to present next on mobile: the oldest one still waiting, and
/// nothing while none is.
///
/// Mobile presents one request at a time, so this is the queue — derived from
/// the pending set rather than held beside it. A request that has to wait its
/// turn therefore stays in [notificationsProvider] the whole time, and keeps
/// counting towards everything read off that list, instead of being moved into
/// a holding pen where it would silently stop being pending. ADR-0006
/// decision 5.
///
/// Oldest first, because a queue served newest-first starves the request with
/// the least time left on it. Order is by id — the arrival counter — rather
/// than by `createdAt`, which [Notifications.addNotification] stamps from a
/// separate `DateTime.now()` call per payload branch.
///
/// The answer is folded out of the list rather than read off one end of it, so
/// it does not depend on the order the list happens to be held in. Ties are
/// settled in favour of the entry the list holds first, which is the entry
/// [pendingRequest] answers with for that id — the two have to agree about
/// which entry an id addresses. A tie needs two entries under one id, which
/// `addNotification` would produce for a request carrying both a connect and a
/// sign payload; the wire makes that impossible today, because the two are a
/// protobuf `oneof`. Both the tie-break and the append-order independence are
/// therefore defensive, and stated here so neither is mistaken for a property
/// the list guarantees.

final class NextPendingRequestProvider
    extends
        $FunctionalProvider<
          Option<NotificationData>,
          Option<NotificationData>,
          Option<NotificationData>
        >
    with $Provider<Option<NotificationData>> {
  /// The request to present next on mobile: the oldest one still waiting, and
  /// nothing while none is.
  ///
  /// Mobile presents one request at a time, so this is the queue — derived from
  /// the pending set rather than held beside it. A request that has to wait its
  /// turn therefore stays in [notificationsProvider] the whole time, and keeps
  /// counting towards everything read off that list, instead of being moved into
  /// a holding pen where it would silently stop being pending. ADR-0006
  /// decision 5.
  ///
  /// Oldest first, because a queue served newest-first starves the request with
  /// the least time left on it. Order is by id — the arrival counter — rather
  /// than by `createdAt`, which [Notifications.addNotification] stamps from a
  /// separate `DateTime.now()` call per payload branch.
  ///
  /// The answer is folded out of the list rather than read off one end of it, so
  /// it does not depend on the order the list happens to be held in. Ties are
  /// settled in favour of the entry the list holds first, which is the entry
  /// [pendingRequest] answers with for that id — the two have to agree about
  /// which entry an id addresses. A tie needs two entries under one id, which
  /// `addNotification` would produce for a request carrying both a connect and a
  /// sign payload; the wire makes that impossible today, because the two are a
  /// protobuf `oneof`. Both the tie-break and the append-order independence are
  /// therefore defensive, and stated here so neither is mistaken for a property
  /// the list guarantees.
  NextPendingRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextPendingRequestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextPendingRequestHash();

  @$internal
  @override
  $ProviderElement<Option<NotificationData>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Option<NotificationData> create(Ref ref) {
    return nextPendingRequest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<NotificationData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<NotificationData>>(value),
    );
  }
}

String _$nextPendingRequestHash() =>
    r'1412d32545b43399a187bce79f48ef9d672cfdb9';

@ProviderFor(ShowNotificationMenu)
final showNotificationMenuProvider = ShowNotificationMenuProvider._();

final class ShowNotificationMenuProvider
    extends $NotifierProvider<ShowNotificationMenu, Option<int>> {
  ShowNotificationMenuProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showNotificationMenuProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showNotificationMenuHash();

  @$internal
  @override
  ShowNotificationMenu create() => ShowNotificationMenu();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<int>>(value),
    );
  }
}

String _$showNotificationMenuHash() =>
    r'4a8cf1d148f86752afe91afb0172cb9b03bc78e9';

abstract class _$ShowNotificationMenu extends $Notifier<Option<int>> {
  Option<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Option<int>, Option<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<int>, Option<int>>,
              Option<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SignRequestNotificationTtl)
final signRequestNotificationTtlProvider = SignRequestNotificationTtlFamily._();

final class SignRequestNotificationTtlProvider
    extends $NotifierProvider<SignRequestNotificationTtl, Option<int>> {
  SignRequestNotificationTtlProvider._({
    required SignRequestNotificationTtlFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'signRequestNotificationTtlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$signRequestNotificationTtlHash();

  @override
  String toString() {
    return r'signRequestNotificationTtlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SignRequestNotificationTtl create() => SignRequestNotificationTtl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Option<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Option<int>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SignRequestNotificationTtlProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signRequestNotificationTtlHash() =>
    r'd851e28c4d4be769936a95b17d85c0177c925c0f';

final class SignRequestNotificationTtlFamily extends $Family
    with
        $ClassFamilyOverride<
          SignRequestNotificationTtl,
          Option<int>,
          Option<int>,
          Option<int>,
          int
        > {
  SignRequestNotificationTtlFamily._()
    : super(
        retry: null,
        name: r'signRequestNotificationTtlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SignRequestNotificationTtlProvider call(int notificationId) =>
      SignRequestNotificationTtlProvider._(
        argument: notificationId,
        from: this,
      );

  @override
  String toString() => r'signRequestNotificationTtlProvider';
}

abstract class _$SignRequestNotificationTtl extends $Notifier<Option<int>> {
  late final _$args = ref.$arg as int;
  int get notificationId => _$args;

  Option<int> build(int notificationId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Option<int>, Option<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Option<int>, Option<int>>,
              Option<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
