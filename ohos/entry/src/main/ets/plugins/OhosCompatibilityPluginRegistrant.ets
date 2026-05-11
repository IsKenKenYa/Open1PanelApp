import { FlutterEngine, Log } from '@ohos/flutter_ohos';
import OhosPackageInfoPlugin from './OhosPackageInfoPlugin';
import OhosPathProviderPlugin from './OhosPathProviderPlugin';
import OhosSecureStoragePlugin from './OhosSecureStoragePlugin';
import OhosSharedPreferencesPlugin from './OhosSharedPreferencesPlugin';

const TAG = 'OhosCompatibilityPluginRegistrant';

export class OhosCompatibilityPluginRegistrant {
  static registerWith(flutterEngine: FlutterEngine) {
    try {
      flutterEngine.getPlugins()?.add(new OhosSharedPreferencesPlugin());
      flutterEngine.getPlugins()?.add(new OhosPackageInfoPlugin());
      flutterEngine.getPlugins()?.add(new OhosPathProviderPlugin());
      flutterEngine.getPlugins()?.add(new OhosSecureStoragePlugin());
    } catch (error) {
      Log.e(TAG, 'Failed to register compatibility plugins', error);
    }
  }
}
