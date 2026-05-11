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
import OhosPreferenceStore from './OhosPreferenceStore';

const TAG = 'OhosSecureStoragePlugin';
const CHANNEL = 'plugins.it_nomads.com/flutter_secure_storage';
const STORE_NAME = 'FlutterSecureStorage';

export default class OhosSecureStoragePlugin
  implements FlutterPlugin, MethodCallHandler
{
  private channel: MethodChannel | null = null;
  private store: OhosPreferenceStore | null = null;

  getUniqueClassName(): string {
    return 'OhosSecureStoragePlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.store = new OhosPreferenceStore(
      binding.getApplicationContext() as common.Context,
      STORE_NAME,
    );
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL);
    this.channel.setMethodCallHandler(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
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
        case 'containsKey': {
          const key = this.requireStringArgument(call, 'key');
          result.success(await this.store.has(key));
          return;
        }
        case 'read': {
          const key = this.requireStringArgument(call, 'key');
          const all = (await this.store.getAll()) as Record<string, Object>;
          const value = all[key];
          result.success(value == null ? null : `${value}`);
          return;
        }
        case 'readAll': {
          const all = (await this.store.getAll()) as Record<string, Object>;
          const serialized: Record<string, string> = {};
          for (const key of Object.keys(all)) {
            const value = all[key];
            if (value == null) {
              continue;
            }
            serialized[key] = `${value}`;
          }
          result.success(serialized);
          return;
        }
        case 'write': {
          const key = this.requireStringArgument(call, 'key');
          const value = this.requireStringArgument(call, 'value');
          await this.store.put(key, value);
          result.success(null);
          return;
        }
        case 'delete': {
          const key = this.requireStringArgument(call, 'key');
          await this.store.delete(key);
          result.success(null);
          return;
        }
        case 'deleteAll':
          await this.store.clear();
          result.success(null);
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
    const rawValue = call.argument(key) as Object | null;
    if (typeof rawValue === 'string' && rawValue.length > 0) {
      return rawValue;
    }
    throw new Error(`Missing required string argument: ${key}`);
  }
}
