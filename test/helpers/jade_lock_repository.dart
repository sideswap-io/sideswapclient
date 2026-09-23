import 'dart:typed_data';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/misc.dart' show Override;
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';

import 'fake_configuration.dart';

class MockJadeLockRepository extends Mock
    implements AbstractJadeLockRepository {}

/// A repository that reports a jade sitting locked, and records the refresh a
/// jade-unlock button asks of it.
MockJadeLockRepository lockedJadeLockRepository() {
  final repository = MockJadeLockRepository();
  when(repository.isUnlocked).thenReturn(false);
  when(() => repository.lockState).thenReturn(const JadeLockState.locked());
  when(repository.refreshJadeLockState).thenReturn(null);
  return repository;
}

/// Selects which repository instance the overridden provider returns, so a test
/// can rebuild `jadeLockRepositoryProvider` the way production does.
class _RepositorySelector extends Notifier<bool> {
  @override
  bool build() => false;

  void useSecond() => state = true;
}

final _repositorySelectorProvider = NotifierProvider<_RepositorySelector, bool>(
  _RepositorySelector.new,
);

/// Puts a locked, jade-paired wallet in front of the widget under test.
///
/// `jadeLockRepositoryProvider` hands out [first] until
/// [useSecondJadeLockRepository] swaps in [second].
List<Override> lockedJadeOverrides({
  required MockJadeLockRepository first,
  required MockJadeLockRepository second,
}) => [
  configurationProvider.overrideWith(
    () => FakeConfiguration(
      SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
        jadeId: 'jade1',
      ),
    ),
  ),
  // Keeps JadeLockStateNotifier out of the tree; its build starts a
  // five-minute RestartableTimer the test would leave pending.
  jadeLockStateProvider.overrideWithValue(const JadeLockState.locked()),
  // Both instances report the same lock state, so the memo key the widget
  // under test uses does not change when the provider rebuilds.
  jadeLockRepositoryProvider.overrideWith(
    (ref) => ref.watch(_repositorySelectorProvider) ? second : first,
  ),
];

/// Rebuilds `jadeLockRepositoryProvider` so that it hands out the `second`
/// repository passed to [lockedJadeOverrides].
void useSecondJadeLockRepository(ProviderContainer container) {
  container.read(_repositorySelectorProvider.notifier).useSecond();
}
