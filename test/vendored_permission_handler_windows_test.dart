import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

/// Guards the vendored copy of `permission_handler_windows`.
///
/// `permission_handler` comes from pub.dev; only its Windows implementation is
/// substituted, through `dependency_overrides` in the root `pubspec.yaml`. See
/// `docs/adr/0007-vendored-permission-handler-windows.md` and
/// `thirdparty/permission_handler_windows/UPSTREAM.md`.
///
/// Two independent failures are possible, and each has its own test below.
void main() {
  const vendored = 'thirdparty/permission_handler_windows';

  group('vendored permission_handler_windows', () {
    test('differs from the upstream reference by exactly the documented patch', () {
      final patched = File(
        '$vendored/windows/permission_handler_windows_plugin.cpp',
      ).readAsLinesSync();
      final upstream = File(
        '$vendored/upstream/permission_handler_windows_plugin.cpp',
      ).readAsLinesSync();

      // The patch removes the revoker member and the subscription that WinRT
      // treats as the trigger for starting location services, and adds a comment
      // explaining why. Nothing else may diverge: a resync with a newer upstream
      // rewrites both files together, so any other difference is an accident.
      //
      // Applying exactly that removal to the upstream reference must reproduce the
      // vendored file line for line, once the added comment lines are set aside.
      // Comparing positionally rather than as a set matters: `    });` occurs in
      // RegisterWithRegistrar too, so a set difference would not see it go.
      const memberLine =
          '  winrt::Windows::Devices::Geolocation::Geolocator::PositionChanged_revoker m_positionChangedRevoker;';
      const constructorLine =
          'PermissionHandlerWindowsPlugin::PermissionHandlerWindowsPlugin(){';

      final expected = [...upstream];
      expect(expected.remove(memberLine), isTrue, reason: 'no revoker member upstream');
      final constructor = expected.indexOf(constructorLine);
      expect(constructor, isNot(-1), reason: 'no constructor upstream');
      expect(expected.sublist(constructor + 1, constructor + 5), [
        '  m_positionChangedRevoker = geolocator.PositionChanged(winrt::auto_revoke,',
        '    [this](Geolocator const& geolocator, PositionChangedEventArgs e)',
        '    {',
        '    });',
      ]);
      expected.removeRange(constructor + 1, constructor + 5);

      final withoutAddedComments = patched
          .where((l) => !(l.trimLeft().startsWith('//') && !upstream.contains(l)))
          .toList();
      expect(withoutAddedComments, expected);

      // Belt and braces: whatever the surrounding prose says, the constructor
      // body has to be empty and no code line may mention PositionChanged.
      expect(
        patched.join('\n'),
        contains(
          'PermissionHandlerWindowsPlugin::PermissionHandlerWindowsPlugin(){\n}',
        ),
      );
      expect(
        patched.where(
          (l) => !l.trimLeft().startsWith('//') && l.contains('PositionChanged'),
        ),
        isEmpty,
      );
    });

    test('satisfies the constraint the resolved permission_handler asks for', () {
      // `dependency_overrides` substitutes this package silently, including for a
      // constraint it no longer meets. Read what the resolved `permission_handler`
      // actually requires and check it here, rather than discovering it as a
      // compile error after the next bump. This stays offline: the resolved
      // package is in the pub cache and `package_config.json` says where.
      final configFile = File('.dart_tool/package_config.json');
      final config =
          jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
      final packages = (config['packages'] as List).cast<Map<String, dynamic>>();

      var rootUri = packages.firstWhere(
        (p) => p['name'] == 'permission_handler',
      )['rootUri'] as String;
      if (!rootUri.endsWith('/')) {
        rootUri = '$rootUri/';
      }
      // `rootUri` may be absolute or relative to the package_config.json itself.
      final pubspecUri = configFile.absolute.uri.resolve(rootUri).resolve('pubspec.yaml');

      final permissionHandler =
          loadYaml(File.fromUri(pubspecUri).readAsStringSync()) as YamlMap;
      final constraint = VersionConstraint.parse(
        (permissionHandler['dependencies'] as YamlMap)['permission_handler_windows']
            as String,
      );

      final vendoredPubspec =
          loadYaml(File('$vendored/pubspec.yaml').readAsStringSync()) as YamlMap;
      final vendoredVersion = Version.parse(vendoredPubspec['version'] as String);

      expect(
        constraint.allows(vendoredVersion),
        isTrue,
        reason:
            'permission_handler requires permission_handler_windows $constraint, '
            'but the vendored copy declares $vendoredVersion. Resync it against '
            'the matching upstream release — see $vendored/UPSTREAM.md.',
      );
    });
  });
}
