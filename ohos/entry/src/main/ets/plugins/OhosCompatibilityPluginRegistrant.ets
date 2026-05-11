import { FlutterEngine, Log } from '@ohos/flutter_ohos';
import OhosPackageInfoPlugin from './OhosPackageInfoPlugin';
import OhosPathProviderPlugin from './OhosPathProviderPlugin';
import OhosSecureStoragePlugin from './OhosSecureStoragePlugin';
import OhosSharedPreferencesPlugin from './OhosSharedPreferencesPlugin';
import OhosLocalAuthPlugin from './OhosLocalAuthPlugin';

const TAG = 'OhosCompatibilityPluginRegistrant';

export class OhosCompatibilityPluginRegistrant {
  static registerWith(flutterEngine: FlutterEngine) {
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
  }

  private static registerPlugin(
    flutterEngine: FlutterEngine,
    pluginName: string,
    registerAction: () => void,
  ): void {
    try {
      registerAction();
    } catch (error) {
      Log.e(TAG, `Failed to register compatibility plugin: ${pluginName}`, error);
    }
  }
}
