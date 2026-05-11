import common from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';

export default class OhosPreferenceStore {
  private readonly applicationContext: common.Context;
  private readonly storeName: string;
  private preferencesInstance: preferences.Preferences | null = null;

  constructor(applicationContext: common.Context, storeName: string) {
    this.applicationContext = applicationContext;
    this.storeName = storeName;
  }

  private async getPreferences(): Promise<preferences.Preferences> {
    if (this.preferencesInstance == null) {
      this.preferencesInstance = await preferences.getPreferences(
        this.applicationContext,
        { name: this.storeName },
      );
    }
    return this.preferencesInstance;
  }

  async getAll(): Promise<Object> {
    const store = await this.getPreferences();
    return store.getAll();
  }

  async has(key: string): Promise<boolean> {
    const store = await this.getPreferences();
    return store.has(key);
  }

  async put(key: string, value: preferences.ValueType): Promise<void> {
    const store = await this.getPreferences();
    await store.put(key, value);
    await store.flush();
  }

  async delete(key: string): Promise<void> {
    const store = await this.getPreferences();
    await store.delete(key);
    await store.flush();
  }

  async deleteKeys(keys: Array<string>): Promise<void> {
    if (keys.length === 0) {
      return;
    }
    const store = await this.getPreferences();
    for (const key of keys) {
      await store.delete(key);
    }
    await store.flush();
  }

  async clear(): Promise<void> {
    const store = await this.getPreferences();
    await store.clear();
    await store.flush();
  }
}
