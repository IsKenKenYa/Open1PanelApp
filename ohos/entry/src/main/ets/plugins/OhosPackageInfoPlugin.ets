import {
  FlutterPlugin,
  FlutterPluginBinding,
  Log,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import bundleManager from '@ohos.bundle.bundleManager';

const TAG = 'OhosPackageInfoPlugin';
const CHANNEL = 'dev.fluttercommunity.plus/package_info';

export default class OhosPackageInfoPlugin
  implements FlutterPlugin, MethodCallHandler
{
  private channel: MethodChannel | null = null;

  getUniqueClassName(): string {
    return 'OhosPackageInfoPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
    this.channel.setMethodCallHandler(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    try {
      if (call.method !== 'getAll') {
        result.notImplemented();
        return;
      }

      const bundleInfo = bundleManager.getBundleInfoForSelfSync(
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION,
      );
      const appInfo = bundleInfo.appInfo;
      result.success({
        appName: appInfo?.label ?? bundleInfo.name,
        packageName: bundleInfo.name ?? '',
        version: bundleInfo.versionName ?? '',
        buildNumber: `${bundleInfo.versionCode ?? ''}`,
        buildSignature: '',
        installerStore: null,
        installTime:
          bundleInfo.installTime != null ? `${bundleInfo.installTime}` : null,
        updateTime:
          bundleInfo.updateTime != null ? `${bundleInfo.updateTime}` : null,
      });
    } catch (error) {
      Log.e(TAG, `Failed to handle ${call.method}`, error);
      result.error('package_info_error', `${error}`, null);
    }
  }
}
