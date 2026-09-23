// Cross-platform replacement for the old coverage.bat / showcoverage.bat.
//
//   dart run tools/coverage.dart            # run tests, filter, build HTML report
//   dart run tools/coverage.dart --open     # ... and open the report
//
// Requires lcov (provides `lcov` and `genhtml`):
//   macOS    brew install lcov
//   Linux    apt install lcov     (or the distro equivalent)
//   Windows  choco install lcov
//
// The 100% provider-coverage gate in docs/TESTING.md is authoritative on
// Windows: a run on any other OS skips the `testOn: 'windows'` tests, so
// platform-gated branches are under-reported there.

import 'dart:io';

Future<void> main(List<String> args) async {
  final open = args.contains('--open');
  final unknown = args.where((a) => a != '--open').toList();
  if (unknown.isNotEmpty) {
    stderr.writeln('Unknown argument(s): ${unknown.join(' ')}');
    stderr.writeln('Usage: dart run tools/coverage.dart [--open]');
    exit(64);
  }

  final lcov = _resolveTool('lcov');
  final genhtml = _resolveTool('genhtml');

  await _run('flutter', ['pub', 'get']);
  // A failing test still gets a report built (the old .bat did too, because
  // `call` does not abort a batch file); the exit code is propagated at the end
  // so this stays the "all tests pass" gate.
  final testExitCode = await _run('flutter', [
    'test',
    '--concurrency=16',
    '--test-randomize-ordering-seed=random',
    '--no-test-assets',
    '--coverage',
    '--branch-coverage',
  ], fatal: false);

  // Forward slashes on every platform: perl-based lcov on Windows takes `/`
  // arguments fine.
  const info = 'coverage/lcov.info';
  const html = 'coverage/html';
  const index = 'coverage/html/index.html';

  // The glob is passed as a single argv entry so no shell expands it, and it
  // deliberately carries no path separator: lcov turns a `/` in the pattern
  // into a regex that demands a literal `/`, but `flutter test --coverage`
  // writes `SF:` records with the host separator — `lib\foo.g.dart` on
  // Windows. A `**/*.g.dart` glob therefore matches nothing there and every
  // generated file is silently counted against the 100% provider gate.
  // `*.g.dart` is separator-free, so it matches on all three platforms.
  await _run(lcov.executable, [
    ...lcov.prefixArgs,
    // lcov 1.x drops BRDA records from every operation unless branch coverage
    // is switched on explicitly, so `--remove` would strip the branch data the
    // test run just produced.
    '--rc',
    'lcov_branch_coverage=1',
    '--remove',
    info,
    '*.g.dart',
    '-o',
    info,
    // `flutter test --coverage` emits no FN/FNDA records, which lcov 2.x
    // treats as a fatal "no corresponding coverpoints" error. The category
    // does not exist in lcov 1.x, hence the version gate.
    if (_majorVersion(lcov) >= 2) ...['--ignore-errors', 'empty'],
  ]);
  _verifyGeneratedFilesRemoved(info);
  _verifyBranchRecordsSurvived(info);
  await _run(genhtml.executable, [
    ...genhtml.prefixArgs,
    // Same switch on the rendering side: without it genhtml omits the branch
    // column even when the tracefile carries BRDA records.
    '--rc',
    'genhtml_branch_coverage=1',
    info,
    '-o',
    html,
  ]);

  stdout.writeln('Coverage report: $index');

  if (open) {
    if (Platform.isWindows) {
      await _run('cmd', ['/c', 'start', '', index]);
    } else if (Platform.isMacOS) {
      await _run('open', [index]);
    } else {
      await _run('xdg-open', [index]);
    }
  }

  if (testExitCode != 0) {
    stderr.writeln('Some tests failed (flutter test exit code $testExitCode).');
    exit(testExitCode);
  }
}

/// Fails loudly when generated sources survived the `--remove` pass. They would
/// otherwise be counted against the 100% provider gate in docs/TESTING.md,
/// which reads as a coverage regression in hand-written code that does not
/// exist. This silently held for the `**/*.g.dart` glob it replaced, so the
/// check is the point rather than a formality.
void _verifyGeneratedFilesRemoved(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('$path not found — did `flutter test --coverage` run?');
    exit(70);
  }
  final survivors = file
      .readAsLinesSync()
      .where((line) => line.startsWith('SF:') && line.endsWith('.g.dart'))
      .toList();
  if (survivors.isEmpty) {
    return;
  }
  stderr.writeln(
    '${survivors.length} generated file(s) survived `lcov --remove`, '
    'e.g. ${survivors.first}',
  );
  exit(70);
}

/// Fails loudly when the branch records the test run produced did not survive
/// `lcov --remove`. lcov 1.x silently discards BRDA records unless
/// `lcov_branch_coverage=1` is set, and the resulting report looks healthy
/// while carrying no branch figure at all. Existence is all this checks; the
/// figure itself is a review criterion, not a threshold the tool enforces.
void _verifyBranchRecordsSurvived(String path) {
  final hasBranchRecords = File(path)
      .readAsLinesSync()
      .any((line) => line.startsWith('BRDA:'));
  if (hasBranchRecords) {
    return;
  }
  stderr.writeln(
    'No BRDA records in $path — branch coverage was lost. Check that '
    '`flutter test --branch-coverage` ran and that `lcov --remove` was given '
    '`--rc lcov_branch_coverage=1`.',
  );
  exit(70);
}

/// A resolved external tool: the executable to launch plus any leading
/// arguments it needs (chocolatey ships lcov as perl scripts, so there the
/// executable is `perl` and the script path is a prefix argument).
class _Tool {
  const _Tool(this.executable, this.prefixArgs);

  final String executable;
  final List<String> prefixArgs;
}

/// Major version of [tool], or 1 when it cannot be determined (the older
/// syntax is the conservative default).
int _majorVersion(_Tool tool) {
  final result = Process.runSync(
    tool.executable,
    [...tool.prefixArgs, '--version'],
    runInShell: Platform.isWindows,
  );
  final output = '${result.stdout}${result.stderr}';
  final match = RegExp(r'version (\d+)', caseSensitive: false).firstMatch(output);
  return int.tryParse(match?.group(1) ?? '') ?? 1;
}

_Tool _resolveTool(String name) {
  if (Platform.isWindows) {
    for (final script in _windowsScriptCandidates(name)) {
      if (File(script).existsSync()) {
        return _Tool('perl', [script]);
      }
    }
  }
  if (_onPath(name)) {
    return _Tool(name, const []);
  }
  stderr.writeln('`$name` not found. Install lcov first:');
  stderr.writeln('  macOS    brew install lcov');
  stderr.writeln('  Linux    apt install lcov');
  stderr.writeln('  Windows  choco install lcov');
  exit(69);
}

Iterable<String> _windowsScriptCandidates(String name) {
  final home = Platform.environment['LCOV_HOME'];
  return [
    // Windows-only branch, so a backslash join is correct here.
    if (home != null && home.isNotEmpty) '$home\\bin\\$name',
    r'C:\ProgramData\chocolatey\lib\lcov\tools\bin\' + name,
  ];
}

bool _onPath(String name) {
  final result = Process.runSync(
    Platform.isWindows ? 'where' : 'which',
    [name],
    runInShell: Platform.isWindows,
  );
  return result.exitCode == 0;
}

/// Runs [executable] and returns its exit code. Exits the script on a nonzero
/// code unless [fatal] is false.
Future<int> _run(
  String executable,
  List<String> arguments, {
  bool fatal = true,
}) async {
  stdout.writeln('\$ $executable ${arguments.join(' ')}');
  final process = await Process.start(
    executable,
    arguments,
    // `flutter` is a shell script / .bat, so on Windows it needs the shell.
    runInShell: Platform.isWindows,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await process.exitCode;
  if (code != 0 && fatal) {
    stderr.writeln('$executable failed with exit code $code');
    exit(code);
  }
  return code;
}
