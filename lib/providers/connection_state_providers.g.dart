// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serverConnectionNotifierHash() =>
    r'8906d799f7a94be534d8826d5136606744105529';

/// See also [ServerConnectionNotifier].
@ProviderFor(ServerConnectionNotifier)
final serverConnectionNotifierProvider =
    NotifierProvider<ServerConnectionNotifier, bool>.internal(
      ServerConnectionNotifier.new,
      name: r'serverConnectionNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$serverConnectionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ServerConnectionNotifier = Notifier<bool>;
String _$serverLoginNotifierHash() =>
    r'378f9bc8e4e463729a3789980bcfdaea255c85fd';

/// See also [ServerLoginNotifier].
@ProviderFor(ServerLoginNotifier)
final serverLoginNotifierProvider =
    NotifierProvider<ServerLoginNotifier, ServerLoginState>.internal(
      ServerLoginNotifier.new,
      name: r'serverLoginNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$serverLoginNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ServerLoginNotifier = Notifier<ServerLoginState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
