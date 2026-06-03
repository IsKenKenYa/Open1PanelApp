import { FlutterEngine, Log } from '@ohos/flutter_ohos';
import common from '@ohos.app.ability.common';
import OhosPackageInfoPlugin from './OhosPackageInfoPlugin';
import OhosPathProviderPlugin from './OhosPathProviderPlugin';
import OhosSecureStoragePlugin from './OhosSecureStoragePlugin';
import OhosSharedPreferencesPlugin from './OhosSharedPreferencesPlugin';
import OhosLocalAuthPlugin from './OhosLocalAuthPlugin';
import OhosPlatformPlugin from './OhosPlatformPlugin';
import OhosConnectivityPlugin from './OhosConnectivityPlugin';

const TAG = 'OhosCompatibilityPluginRegistrant';

export class OhosCompatibilityPluginRegistrant {
  // The UIAbility context is required for picker-aware plugins
  // (OhosPlatformPlugin, OhosDownloadPlugin). Application context lacks the
  // UI token needed to launch system picker dialogs.
  static registerWith(
    flutterEngine: FlutterEngine,
    uiAbilityContext: common.UIAbilityContext,
  ) {
    OhosCompatibilityPluginRegistrant.registerPlugin(flutterEngine, 'shared_preferences', () => {
      flutterEngine.getPlugins()?.add(new OhosSharedPreferencesPlugin());
    });
    OhosCompatibilityPluginRegistrant.registerPlugin(flutterEngine, 'package_info_plus', () => {
      flutterEngine.getPlugins()?.add(new OhosPackageInfoPlugin());
    });
    OhosCompatibilityPluginRegistrant.registerPlugin(flutterEngine, 'path_provider', () => {
      flutterEngine.getPlugins()?.add(new OhosPathProviderPlugin());
    });
    OhosCompatibilityPluginRegistrant.registerPlugin(flutterEngine, 'flutter_secure_storage', () => {
      flutterEngine.getPlugins()?.add(new OhosSecureStoragePlugin());
    });
    OhosCompatibilityPluginRegistrant.registerPlugin(flutterEngine, 'local_auth', () => {
      flutterEngine.getPlugins()?.add(new OhosLocalAuthPlugin());
    });
    OhosCompatibilityPluginRegistrant.registerPlugin(flutterEngine, 'onepanel_ohos_platform', () => {
      // Inject the UIAbility context so OhosPlatformPlugin can resolve it
      // directly via getUIAbilityContext() when calling picker APIs.
      flutterEngine.getPlugins()?.add(new OhosPlatformPlugin(uiAbilityContext));
    });
    OhosCompatibilityPluginRegistrant.registerPlugin(flutterEngine, 'connectivity_plus', () => {
      flutterEngine.getPlugins()?.add(new OhosConnectivityPlugin());
    });
  }

  private static registerPlugin(
    flutterEngine: FlutterEngine,
    pluginName: string,
    registerAction: () => void,
  ): void {
    // Isolate each plugin: one failure must not prevent other plugins from loading.
    try {
      registerAction();
    } catch (error) {
      Log.e(TAG, `Failed to register compatibility plugin: ${pluginName}`, error);
    }
  }
}
