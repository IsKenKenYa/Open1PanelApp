import {
  FlutterPlugin,
  FlutterPluginBinding,
  FlutterManager,
  Log,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import common from '@ohos.app.ability.common';
import bundleManager from '@ohos.bundle.bundleManager';
import deviceInfo from '@ohos.deviceInfo';
import fs from '@ohos.file.fs';
import Want from '@ohos.app.ability.Want';

const TAG = 'OhosPlatformPlugin';
const CHANNEL = 'onepanel/ohos_platform';

interface OhosRuntimeInfo {
  deviceType: string;
  brand: string;
  productModel: string;
  osFullName: string;
  displayVersion: string;
  sdkApiVersion: number;
  appFilesDir: string;
  appCacheDir: string;
  bundleName: string;
  hapCommit: string;
  flutterOhosVersion: string;
}

export default class OhosPlatformPlugin
  implements FlutterPlugin, MethodCallHandler
{
  private channel: MethodChannel | null = null;
  private applicationContext: common.Context | null = null;

  getUniqueClassName(): string {
    return 'OhosPlatformPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.applicationContext = binding.getApplicationContext() as common.Context;
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
    this.channel.setMethodCallHandler(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
    this.applicationContext = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    this.handleMethodCall(call, result);
  }

  private async handleMethodCall(
    call: MethodCall,
    result: MethodResult,
  ): Promise<void> {
    try {
      switch (call.method) {
        case 'getRuntimeInfo':
          result.success(await this.getRuntimeInfo());
          return;
        case 'saveBytes':
          result.success(await this.saveBytes(call));
          return;
        case 'openPath':
        case 'openDirectory':
          // Both methods share the same implementation because HarmonyOS
          // 'ohos.want.action.viewData' handles files and directories identically.
          result.success(await this.openPath(call));
          return;
        default:
          result.notImplemented();
      }
    } catch (error) {
      Log.e(TAG, `Failed to handle ${call.method}`, error);
      result.error('ohos_platform_error', `${error}`, null);
    }
  }

  private async getRuntimeInfo(): Promise<OhosRuntimeInfo> {
    const context = this.requireContext();
    const bundleInfo = await bundleManager.getBundleInfoForSelf(
      bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT,
    );
    return {
      deviceType: deviceInfo.deviceType,
      brand: deviceInfo.brand,
      productModel: deviceInfo.productModel,
      osFullName: deviceInfo.osFullName,
      displayVersion: deviceInfo.displayVersion,
      sdkApiVersion: deviceInfo.sdkApiVersion,
      appFilesDir: context.filesDir,
      appCacheDir: context.cacheDir,
      bundleName: bundleInfo.name,
      hapCommit: '',
      flutterOhosVersion: '',
    };
  }

  private async saveBytes(call: MethodCall): Promise<string> {
    const context = this.requireContext();
    const fileName = this.sanitizeFileName(
      this.requireNonEmptyStringArgument(call, 'fileName'),
    );
    const bytes = call.argument('bytes') as Uint8Array | null;
    if (bytes == null) {
      throw new Error('Missing required bytes argument: bytes');
    }

    const exportDir = `${context.filesDir}/exports`;
    await this.ensureDirectory(exportDir);
    const filePath = await this.nextAvailablePath(exportDir, fileName);
    const file = fs.openSync(
      filePath,
      fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC,
    );
    try {
      fs.writeSync(
        file.fd,
        bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength),
      );
      fs.fsyncSync(file.fd);
    } finally {
      fs.closeSync(file);
    }
    return filePath;
  }

  private async openPath(call: MethodCall): Promise<boolean> {
    const context = this.requireContext();
    const path = this.requireNonEmptyStringArgument(call, 'path');
    const want: Want = {
      action: 'ohos.want.action.viewData',
      uri: `file://${path}`,
    };
    try {
      await FlutterManager.getInstance()
        .getUIAbility(context)
        .context.startAbility(want);
      return true;
    } catch (error) {
      Log.w(TAG, `openPath failed: ${error}`);
      return false;
    }
  }

  private async ensureDirectory(path: string): Promise<void> {
    try {
      if (fs.accessSync(path)) {
        return;
      }
    } catch (_) {
      // Directory does not exist.
    }
    fs.mkdirSync(path, true);
  }

  private async nextAvailablePath(
    directory: string,
    fileName: string,
  ): Promise<string> {
    const first = `${directory}/${fileName}`;
    if (!this.exists(first)) {
      return first;
    }

    const lastDot = fileName.lastIndexOf('.');
    const baseName = lastDot > 0 ? fileName.substring(0, lastDot) : fileName;
    const extension = lastDot > 0 ? fileName.substring(lastDot) : '';
    const maxAttempts = 9999;
    let counter = 1;
    while (counter <= maxAttempts) {
      const candidate = `${directory}/${baseName}_${counter}${extension}`;
      if (!this.exists(candidate)) {
        return candidate;
      }
      counter += 1;
    }
    throw new Error(
      `Failed to generate unique file name after ${maxAttempts} attempts: ${fileName}`,
    );
  }

  private exists(path: string): boolean {
    try {
      return fs.accessSync(path);
    } catch (_) {
      return false;
    }
  }

  private sanitizeFileName(fileName: string): string {
    return fileName.replace(/[<>:"/\\|?*]/g, '_');
  }

  private requireContext(): common.Context {
    if (this.applicationContext == null) {
      throw new Error('Application context is not ready');
    }
    return this.applicationContext;
  }

  private requireStringArgument(call: MethodCall, key: string): string {
    const rawValue = call.argument(key) as string | null;
    if (rawValue != null) {
      return rawValue;
    }
    throw new Error(`Missing required string argument: ${key}`);
  }

  private requireNonEmptyStringArgument(call: MethodCall, key: string): string {
    const value = this.requireStringArgument(call, key);
    if (value.length > 0) {
      return value;
    }
    throw new Error(`Missing required string argument: ${key}`);
  }
}
