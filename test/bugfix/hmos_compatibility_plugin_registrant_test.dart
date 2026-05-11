import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HarmonyOS compatibility registrant keeps startup-critical plugins wired', () async {
    final registrantFile = File(
      'ohos/entry/src/main/ets/plugins/OhosCompatibilityPluginRegistrant.ets',
    );
    final entryAbilityFile = File(
      'ohos/entry/src/main/ets/entryability/EntryAbility.ets',
    );

    expect(await registrantFile.exists(), isTrue);
    expect(await entryAbilityFile.exists(), isTrue);

    final registrant = await registrantFile.readAsString();
    final entryAbility = await entryAbilityFile.readAsString();

    expect(
      registrant,
      contains('new OhosSharedPreferencesPlugin()'),
    );
    expect(
      registrant,
      contains('new OhosPackageInfoPlugin()'),
    );
    expect(
      registrant,
      contains('new OhosPathProviderPlugin()'),
    );
    expect(
      registrant,
      contains('new OhosSecureStoragePlugin()'),
    );
    expect(
      registrant,
      contains('new OhosLocalAuthPlugin()'),
    );
    expect(
      entryAbility,
      contains('OhosCompatibilityPluginRegistrant.registerWith(flutterEngine)'),
    );
  });
}
