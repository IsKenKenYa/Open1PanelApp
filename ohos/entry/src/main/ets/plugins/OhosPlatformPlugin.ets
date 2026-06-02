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
import picker from '@ohos.file.picker';
import OhosDownloadPlugin from './OhosDownloadPlugin';

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

  private downloadPlugin: OhosDownloadPlugin | null = null;

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.applicationContext = binding.getApplicationContext() as common.Context;
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
    this.channel.setMethodCallHandler(this);
    // Download plugin registers its own channels, so it's wired as a sub-plugin here
    // rather than in the registrant — avoids double-registration.
    this.downloadPlugin = new OhosDownloadPlugin();
    this.downloadPlugin.onAttachedToEngine(binding);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.downloadPlugin) {
      this.downloadPlugin.onDetachedFromEngine(binding);
      this.downloadPlugin = null;
    }
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
          result.success(await this.openPath(call));
          return;
        case 'pickSaveDirectory':
          result.success(await this.pickSaveDirectory());
          return;
        case 'pickAndSaveBytes':
          result.success(await this.pickAndSaveBytes(call));
          return;
        case 'saveBytesToDownload':
          result.success(await this.saveBytesToDownload(call));
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
    const appContext = this.requireContext();
    const path = this.requireNonEmptyStringArgument(call, 'path');
    // Standard OHOS intent to open a file with the system's default viewer for its MIME type.
    const want: Want = {
      action: 'ohos.want.action.viewData',
      uri: `file://${path}`,
    };
    try {
      const uiAbility = FlutterManager.getInstance().getUIAbility(appContext);
      if (uiAbility == null) {
        Log.w(TAG, 'openPath: UIAbility not found');
        return false;
      }
      const abilityContext = uiAbility.context as common.UIAbilityContext;
      await abilityContext.startAbility(want);
      return true;
    } catch (error) {
      Log.w(TAG, `openPath failed: ${error}`);
      return false;
    }
  }

  private async pickSaveDirectory(): Promise<string | null> {
    try {
      const pickerContext = this.getUIAbilityContext();
      // DocumentViewPicker.select returns content URIs, not filesystem paths.
      const documentPicker = new picker.DocumentViewPicker(pickerContext);
      const result = await documentPicker.select({
        maxSelectNumber: 1,
        fileSuffixFilters: ['.txt', '.log', '.pdf', '.zip'],
      });
      if (result && result.length > 0) {
        return result[0];
      }
      return null;
    } catch (error) {
      Log.w(TAG, `pickSaveDirectory failed: ${error}`);
      return null;
    }
  }

  private async pickAndSaveBytes(call: MethodCall): Promise<string | null> {
    try {
      const pickerContext = this.getUIAbilityContext();
      const fileName = this.sanitizeFileName(
        this.requireNonEmptyStringArgument(call, 'fileName'),
      );
      const bytes = call.argument('bytes') as Uint8Array | null;
      if (bytes == null) {
        throw new Error('Missing required bytes argument: bytes');
      }

      // Step 1: Let user pick a save location
      const documentPicker = new picker.DocumentViewPicker(pickerContext);
      const saveResult = await documentPicker.save({ newFileNames: [fileName] });
      if (!saveResult || saveResult.length === 0) {
        return null;
      }

      const targetUri = saveResult[0];
      // Step 2: Write bytes to the picked URI
      const file = fs.openSync(targetUri, fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
      try {
        fs.writeSync(
          file.fd,
          bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength),
        );
        fs.fsyncSync(file.fd);
      } finally {
        fs.closeSync(file);
      }

      Log.i(TAG, `pickAndSaveBytes: saved to ${targetUri}`);
      return targetUri;
    } catch (error) {
      Log.e(TAG, `pickAndSaveBytes failed: ${error}, falling back to private dir`);
      // Fallback: DocumentViewPicker may fail on headless/background contexts or permission denial.
      // Private app directory is the only safe location on OHOS scoped storage without user consent.
      return await this.saveBytes(call);
    }
  }

  private async saveBytesToDownload(call: MethodCall): Promise<string> {
    const context = this.requireContext();
    const fileName = this.sanitizeFileName(
      this.requireNonEmptyStringArgument(call, 'fileName'),
    );
    const bytes = call.argument('bytes') as Uint8Array | null;
    if (bytes == null) {
      throw new Error('Missing required bytes argument: bytes');
    }

    // Save to exports directory in app files
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

    Log.i(TAG, `saveBytesToDownload: saved to ${filePath}`);
    return filePath;
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

  // OHOS picker APIs (DocumentViewPicker, etc.) require UIAbility context, not application context.
  // Application context lacks the UI token needed to launch system picker dialogs.
  private getUIAbilityContext(): common.UIAbilityContext {
    const appContext = this.requireContext();
    const uiAbility = FlutterManager.getInstance().getUIAbility(appContext);
    if (uiAbility == null) {
      throw new Error('UIAbility not found — picker requires ability context');
    }
    return uiAbility.context as common.UIAbilityContext;
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
