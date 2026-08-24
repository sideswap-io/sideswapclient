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

String _$notificationsHash() => r'8c2ba6a18141ae2511a421949ea54199ab730565';

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
    r'8a5d38b39ae4a76e32362a7a7a1f1a8ac8163e50';

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
