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
import preferences from '@ohos.data.preferences';
import OhosPreferenceStore from './OhosPreferenceStore';

const TAG = 'OhosSharedPreferencesPlugin';
const CHANNEL = 'plugins.flutter.io/shared_preferences';
const STORE_NAME = 'FlutterSharedPreferences';

export default class OhosSharedPreferencesPlugin
  implements FlutterPlugin, MethodCallHandler
{
  private channel: MethodChannel | null = null;
  private store: OhosPreferenceStore | null = null;

  getUniqueClassName(): string {
    return 'OhosSharedPreferencesPlugin';
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
      result.error('shared_preferences_unavailable', 'Store is not ready', null);
      return;
    }

    try {
      switch (call.method) {
        case 'getAll':
          result.success(await this.store.getAll());
          return;
        case 'getAllWithParameters': {
          const filter = this.filterEntries(
            await this.store.getAll(),
            this.toNullableString(call.argument('prefix')),
            this.toStringArray(call.argument('allowList')),
          );
          result.success(filter);
          return;
        }
        case 'setBool':
        case 'setInt':
        case 'setDouble':
        case 'setString':
        case 'setStringList': {
          const key = this.requireStringArgument(call, 'key');
          const value = call.argument('value') as preferences.ValueType;
          await this.store.put(key, value);
          result.success(true);
          return;
        }
        case 'remove': {
          const key = this.requireStringArgument(call, 'key');
          await this.store.delete(key);
          result.success(true);
          return;
        }
        case 'clear':
          await this.store.clear();
          result.success(true);
          return;
        case 'clearWithParameters': {
          const keys = Object.keys(
            this.filterEntries(
              await this.store.getAll(),
              this.toNullableString(call.argument('prefix')),
              this.toStringArray(call.argument('allowList')),
            ),
          );
          await this.store.deleteKeys(keys);
          result.success(true);
          return;
        }
        default:
          result.notImplemented();
      }
    } catch (error) {
      Log.e(TAG, `Failed to handle ${call.method}`, error);
      result.error(
        'shared_preferences_error',
        `${error}`,
        null,
      );
    }
  }

  private filterEntries(
    source: Object,
    prefix: string | null,
    allowList: Array<string> | null,
  ): Object {
    const entries = source as Record<string, Object>;
    const filtered: Record<string, Object> = {};
    for (const key of Object.keys(entries)) {
      if (prefix != null && prefix.length > 0 && !key.startsWith(prefix)) {
        continue;
      }
      if (allowList != null && allowList.length > 0 && !allowList.includes(key)) {
        continue;
      }
      filtered[key] = entries[key];
    }
    return filtered;
  }

  private requireStringArgument(call: MethodCall, key: string): string {
    const rawValue = call.argument(key) as Object | null;
    if (typeof rawValue === 'string' && rawValue.length > 0) {
      return rawValue;
    }
    throw new Error(`Missing required string argument: ${key}`);
  }

  private toNullableString(value: Object | null): string | null {
    if (value == null) {
      return null;
    }
    if (typeof value === 'string') {
      return value;
    }
    return `${value}`;
  }

  private toStringArray(value: Object | null): Array<string> | null {
    if (value == null || !Array.isArray(value)) {
      return null;
    }
    const result: Array<string> = [];
    const items = value as Array<Object | null>;
    for (let index = 0; index < items.length; index++) {
      const entry = items[index];
      if (entry == null) {
        continue;
      }
      result.push(`${entry}`);
    }
    return result;
  }
}
