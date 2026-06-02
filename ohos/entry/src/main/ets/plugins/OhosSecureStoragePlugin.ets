import {
  FlutterPlugin,
  FlutterPluginBinding,
  Log,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import common from '@ohos.app.ability.common';
import OhosHuksSecureStore from './OhosHuksSecureStore';

const TAG = 'OhosSecureStoragePlugin';
const CHANNEL = 'plugins.it_nomads.com/flutter_secure_storage';
const CUSTOM_CHANNEL = 'onepanel/secure_storage';
const STORE_NAME = 'FlutterSecureStorage';

export default class OhosSecureStoragePlugin
  implements FlutterPlugin, MethodCallHandler
{
  private channels: Array<MethodChannel> = [];
  private store: OhosHuksSecureStore | null = null;

  getUniqueClassName(): string {
    return 'OhosSecureStoragePlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.store = new OhosHuksSecureStore(
      binding.getApplicationContext() as common.Context,
      STORE_NAME,
    );
    // Dual channels: CHANNEL matches flutter_secure_storage's expected name so the Dart
    // plugin resolves without modification; CUSTOM_CHANNEL is for onepanel-specific extensions.
    this.channels = [
      new MethodChannel(binding.getBinaryMessenger(), CHANNEL),
      new MethodChannel(binding.getBinaryMessenger(), CUSTOM_CHANNEL),
    ];
    for (const channel of this.channels) {
      channel.setMethodCallHandler(this);
    }
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    for (const channel of this.channels) {
      channel.setMethodCallHandler(null);
    }
    this.channels = [];
    this.store = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    this.handleMethodCall(call, result);
  }

  private async handleMethodCall(
    call: MethodCall,
    result: MethodResult,
  ): Promise<void> {
    if (this.store == null) {
      result.error('secure_storage_unavailable', 'Store is not ready', null);
      return;
    }

    try {
      switch (call.method) {
        case 'ping':
          result.success(await this.store.ping());
          return;
        case 'containsKey': {
          const key = this.requireNonEmptyStringArgument(call, 'key');
          result.success(await this.store.containsKey(key));
          return;
        }
        case 'read': {
          const key = this.requireNonEmptyStringArgument(call, 'key');
          const value = await this.store.read(key);
          if (value == null || value.length === 0) {
            Log.w(TAG, `read: key=${key} returned null/empty`);
          }
          result.success(value);
          return;
        }
        case 'readAll':
          result.success(await this.store.readAll());
          return;
        case 'write': {
          const key = this.requireNonEmptyStringArgument(call, 'key');
          const value = this.requireStringArgument(call, 'value');
          await this.store.write(key, value);
          result.success(true);
          return;
        }
        case 'delete': {
          const key = this.requireNonEmptyStringArgument(call, 'key');
          await this.store.delete(key);
          result.success(true);
          return;
        }
        case 'deleteAll':
          await this.store.deleteAll();
          result.success(true);
          return;
        default:
          result.notImplemented();
      }
    } catch (error) {
      Log.e(TAG, `Failed to handle ${call.method}`, error);
      result.error('secure_storage_error', `${error}`, null);
    }
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
