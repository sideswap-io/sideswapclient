// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signer_acceptance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The acceptance attempts currently in flight, by request id.
///
/// An *acceptance attempt* — the acceptance gate, the pending re-check, the
/// send and the record — belongs to the request it answers, not to the widget
/// the press came from. Once the gate is crossed no widget is a party to the
/// outcome: an approval control that is unmounted, recreated or repurposed
/// mid-authentication changes nothing about the attempt it started.
/// ADR-0009 decisions 1 and 2.
///
/// The state is the set of request ids with an attempt outstanding. An approval
/// control renders busy by watching this set for **its own** request id, which
/// is why an element repurposed to another request shows that request's state
/// rather than the previous one's.
///
/// The lifetime is a contract rather than a framework guarantee, and each
/// clause below is load-bearing — ADR-0009 decision 3:
///
/// - It is `keepAlive` because the last watcher going away is precisely the
///   event this notifier defends against. An autodisposed guard would be
///   discarded at the moment it is needed and rebuilt empty.
/// - **Nothing invalidates it.** Not [Notifications.clearAll], which
///   invalidates only [notificationsProvider]; not a wallet reset, which resets
///   neither. Anyone adding an invalidation is changing this decision and must
///   say what happens to an attempt that is at the gate when it lands.
/// - **[build] watches nothing.** `ref.mounted` goes false when a rebuild
///   replaces the `Ref`, and a rebuild follows any watched dependency changing,
///   so a notifier that watched the notification list would invalidate its own
///   in-flight attempt every time a request arrived. Every collaborator is read
///   inside [accept]. Others watching *this* notifier are inbound listeners and
///   rebuild nothing here.

@ProviderFor(SignerAcceptance)
final signerAcceptanceProvider = SignerAcceptanceProvider._();

/// The acceptance attempts currently in flight, by request id.
///
/// An *acceptance attempt* — the acceptance gate, the pending re-check, the
/// send and the record — belongs to the request it answers, not to the widget
/// the press came from. Once the gate is crossed no widget is a party to the
/// outcome: an approval control that is unmounted, recreated or repurposed
/// mid-authentication changes nothing about the attempt it started.
/// ADR-0009 decisions 1 and 2.
///
/// The state is the set of request ids with an attempt outstanding. An approval
/// control renders busy by watching this set for **its own** request id, which
/// is why an element repurposed to another request shows that request's state
/// rather than the previous one's.
///
/// The lifetime is a contract rather than a framework guarantee, and each
/// clause below is load-bearing — ADR-0009 decision 3:
///
/// - It is `keepAlive` because the last watcher going away is precisely the
///   event this notifier defends against. An autodisposed guard would be
///   discarded at the moment it is needed and rebuilt empty.
/// - **Nothing invalidates it.** Not [Notifications.clearAll], which
///   invalidates only [notificationsProvider]; not a wallet reset, which resets
///   neither. Anyone adding an invalidation is changing this decision and must
///   say what happens to an attempt that is at the gate when it lands.
/// - **[build] watches nothing.** `ref.mounted` goes false when a rebuild
///   replaces the `Ref`, and a rebuild follows any watched dependency changing,
///   so a notifier that watched the notification list would invalidate its own
///   in-flight attempt every time a request arrived. Every collaborator is read
///   inside [accept]. Others watching *this* notifier are inbound listeners and
///   rebuild nothing here.
final class SignerAcceptanceProvider
    extends $NotifierProvider<SignerAcceptance, Set<String>> {
  /// The acceptance attempts currently in flight, by request id.
  ///
  /// An *acceptance attempt* — the acceptance gate, the pending re-check, the
  /// send and the record — belongs to the request it answers, not to the widget
  /// the press came from. Once the gate is crossed no widget is a party to the
  /// outcome: an approval control that is unmounted, recreated or repurposed
  /// mid-authentication changes nothing about the attempt it started.
  /// ADR-0009 decisions 1 and 2.
  ///
  /// The state is the set of request ids with an attempt outstanding. An approval
  /// control renders busy by watching this set for **its own** request id, which
  /// is why an element repurposed to another request shows that request's state
  /// rather than the previous one's.
  ///
  /// The lifetime is a contract rather than a framework guarantee, and each
  /// clause below is load-bearing — ADR-0009 decision 3:
  ///
  /// - It is `keepAlive` because the last watcher going away is precisely the
  ///   event this notifier defends against. An autodisposed guard would be
  ///   discarded at the moment it is needed and rebuilt empty.
  /// - **Nothing invalidates it.** Not [Notifications.clearAll], which
  ///   invalidates only [notificationsProvider]; not a wallet reset, which resets
  ///   neither. Anyone adding an invalidation is changing this decision and must
  ///   say what happens to an attempt that is at the gate when it lands.
  /// - **[build] watches nothing.** `ref.mounted` goes false when a rebuild
  ///   replaces the `Ref`, and a rebuild follows any watched dependency changing,
  ///   so a notifier that watched the notification list would invalidate its own
  ///   in-flight attempt every time a request arrived. Every collaborator is read
  ///   inside [accept]. Others watching *this* notifier are inbound listeners and
  ///   rebuild nothing here.
  SignerAcceptanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signerAcceptanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signerAcceptanceHash();

  @$internal
  @override
  SignerAcceptance create() => SignerAcceptance();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$signerAcceptanceHash() => r'd7577a395d89d1a254f60ff7bcf835f3fe912263';

/// The acceptance attempts currently in flight, by request id.
///
/// An *acceptance attempt* — the acceptance gate, the pending re-check, the
/// send and the record — belongs to the request it answers, not to the widget
/// the press came from. Once the gate is crossed no widget is a party to the
/// outcome: an approval control that is unmounted, recreated or repurposed
/// mid-authentication changes nothing about the attempt it started.
/// ADR-0009 decisions 1 and 2.
///
/// The state is the set of request ids with an attempt outstanding. An approval
/// control renders busy by watching this set for **its own** request id, which
/// is why an element repurposed to another request shows that request's state
/// rather than the previous one's.
///
/// The lifetime is a contract rather than a framework guarantee, and each
/// clause below is load-bearing — ADR-0009 decision 3:
///
/// - It is `keepAlive` because the last watcher going away is precisely the
///   event this notifier defends against. An autodisposed guard would be
///   discarded at the moment it is needed and rebuilt empty.
/// - **Nothing invalidates it.** Not [Notifications.clearAll], which
///   invalidates only [notificationsProvider]; not a wallet reset, which resets
///   neither. Anyone adding an invalidation is changing this decision and must
///   say what happens to an attempt that is at the gate when it lands.
/// - **[build] watches nothing.** `ref.mounted` goes false when a rebuild
///   replaces the `Ref`, and a rebuild follows any watched dependency changing,
///   so a notifier that watched the notification list would invalidate its own
///   in-flight attempt every time a request arrived. Every collaborator is read
///   inside [accept]. Others watching *this* notifier are inbound listeners and
///   rebuild nothing here.

abstract class _$SignerAcceptance extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
