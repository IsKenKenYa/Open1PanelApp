import { Log } from '@ohos/flutter_ohos';
import common from '@ohos.app.ability.common';
import cryptoFramework from '@ohos.security.cryptoFramework';
import huks from '@ohos.security.huks';
import util from '@ohos.util';

import OhosPreferenceStore from './OhosPreferenceStore';

const TAG = 'OhosHuksSecureStore';

class SecureStoragePayload {
  v: number = 0;
  iv: string = '';
  data: string = '';

  constructor(v: number, iv: string, data: string) {
    this.v = v;
    this.iv = iv;
    this.data = data;
  }
}

const STORE_VERSION = 1; // Bump to trigger migration when payload format changes.
const MASTER_KEY_ALIAS = 'onepanel_secure_storage_master_key';

export default class OhosHuksSecureStore {
  private readonly store: OhosPreferenceStore;
  private readonly base64Helper = new util.Base64Helper();
  private readonly textEncoder = new util.TextEncoder();
  private readonly textDecoder = new util.TextDecoder('utf-8');

  constructor(applicationContext: common.Context, storeName: string) {
    this.store = new OhosPreferenceStore(applicationContext, storeName);
  }

  async ping(): Promise<boolean> {
    await this.ensureMasterKey();
    return true;
  }

  async containsKey(key: string): Promise<boolean> {
    return this.store.has(key);
  }

  async read(key: string): Promise<string | null> {
    const all = (await this.store.getAll()) as Record<string, string | null>;
    const rawValue = all[key];
    if (rawValue == null || rawValue.length === 0) {
      Log.w(TAG, `read: key=${key} not found in preferences store`);
      return null;
    }

    // Backward compat: if value isn't valid encrypted JSON, return it as-is.
    // This handles data written before HUKS encryption was enabled.
    const payload = this.tryParsePayload(rawValue);
    if (payload == null) {
      Log.d(TAG, `read: key=${key} returned raw (non-encrypted) value`);
      return rawValue;
    }

    try {
      const decrypted = await this.decrypt(payload);
      Log.d(TAG, `read: key=${key} decrypted successfully`);
      return decrypted;
    } catch (error) {
      Log.e(TAG, `read: key=${key} HUKS decryption failed, error=${error}`, error);
      return null;
    }
  }

  async readAll(): Promise<Record<string, string>> {
    const all = (await this.store.getAll()) as Record<string, string | null>;
    const decrypted: Record<string, string> = {};
    for (const key of Object.keys(all)) {
      const rawValue = all[key];
      if (rawValue == null || rawValue.length === 0) {
        continue;
      }

      // Same backward-compat logic as read(): non-JSON values pass through as plaintext.
      const payload = this.tryParsePayload(rawValue);
      if (payload == null) {
        decrypted[key] = rawValue;
        continue;
      }

      decrypted[key] = await this.decrypt(payload);
    }
    return decrypted;
  }

  async write(key: string, value: string): Promise<void> {
    await this.ensureMasterKey();
    const payload = await this.encrypt(value);
    await this.store.put(key, JSON.stringify(payload));
  }

  async delete(key: string): Promise<void> {
    await this.store.delete(key);
  }

  async deleteAll(): Promise<void> {
    await this.store.clear();
    // Master key lives in HUKS hardware keystore, not in preferences — must be deleted separately.
    await this.deleteMasterKey();
  }

  // Lazy init: master key is only generated on first write or ping, not at construction time.
  private async ensureMasterKey(): Promise<void> {
    const emptyOptions: huks.HuksOptions = { properties: [] };
    const exists = await huks.isKeyItemExist(MASTER_KEY_ALIAS, emptyOptions);
    if (exists) {
      return;
    }

    await huks.generateKeyItem(MASTER_KEY_ALIAS, {
      properties: [
        {
          tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
          value: huks.HuksKeyAlg.HUKS_ALG_AES,
        },
        {
          tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
          value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256,
        },
        {
          tag: huks.HuksTag.HUKS_TAG_PURPOSE,
          value:
            huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT |
            huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT,
        },
        {
          tag: huks.HuksTag.HUKS_TAG_PADDING,
          value: huks.HuksKeyPadding.HUKS_PADDING_PKCS7,
        },
        {
          tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
          value: huks.HuksCipherMode.HUKS_MODE_CBC,
        },
      ],
      inData: new Uint8Array(0),
    });
  }

  private async encrypt(value: string): Promise<SecureStoragePayload> {
    // Fresh random IV per encryption — CBC mode requires unique IVs to prevent
    // identical plaintexts from producing identical ciphertexts.
    const iv = cryptoFramework.createRandom().generateRandomSync(16).data;
    const properties = this.buildCryptoProperties(
      huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_ENCRYPT,
      iv,
    );
    const session = await huks.initSession(MASTER_KEY_ALIAS, {
      properties,
      inData: new Uint8Array(0),
    });
    const result = await huks.finishSession(session.handle, {
      properties,
      inData: this.textEncoder.encodeInto(value),
    });

    return new SecureStoragePayload(
      STORE_VERSION,
      this.base64Helper.encodeToStringSync(iv, util.Type.BASIC),
      this.base64Helper.encodeToStringSync(
        result.outData as Uint8Array,
        util.Type.BASIC,
      ),
    );
  }

  private async decrypt(payload: SecureStoragePayload): Promise<string> {
    const iv = this.base64Helper.decodeSync(payload.iv, util.Type.BASIC);
    const encrypted =
      this.base64Helper.decodeSync(payload.data, util.Type.BASIC);
    const properties = this.buildCryptoProperties(
      huks.HuksKeyPurpose.HUKS_KEY_PURPOSE_DECRYPT,
      iv,
    );
    const session = await huks.initSession(MASTER_KEY_ALIAS, {
      properties,
      inData: new Uint8Array(0),
    });
    const result = await huks.finishSession(session.handle, {
      properties,
      inData: encrypted,
    });

    return this.textDecoder.decodeWithStream(
      result.outData as Uint8Array,
    );
  }

  private buildCryptoProperties(
    purpose: number,
    iv: Uint8Array,
  ): huks.HuksParam[] {
    return [
      {
        tag: huks.HuksTag.HUKS_TAG_ALGORITHM,
        value: huks.HuksKeyAlg.HUKS_ALG_AES,
      },
      {
        tag: huks.HuksTag.HUKS_TAG_KEY_SIZE,
        value: huks.HuksKeySize.HUKS_AES_KEY_SIZE_256,
      },
      {
        tag: huks.HuksTag.HUKS_TAG_PURPOSE,
        value: purpose,
      },
      {
        tag: huks.HuksTag.HUKS_TAG_PADDING,
        value: huks.HuksKeyPadding.HUKS_PADDING_PKCS7,
      },
      {
        tag: huks.HuksTag.HUKS_TAG_BLOCK_MODE,
        value: huks.HuksCipherMode.HUKS_MODE_CBC,
      },
      {
        tag: huks.HuksTag.HUKS_TAG_IV,
        value: iv,
      },
    ];
  }

  // Returns null for non-JSON or non-matching version — signals caller to treat value as plaintext.
  private tryParsePayload(value: string): SecureStoragePayload | null {
    try {
      const parsed = JSON.parse(value) as SecureStoragePayload;
      if (
        parsed != null &&
        parsed.v === STORE_VERSION &&
        typeof parsed.iv === 'string' &&
        typeof parsed.data === 'string'
      ) {
        return new SecureStoragePayload(parsed.v, parsed.iv, parsed.data);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  private async deleteMasterKey(): Promise<void> {
    try {
      await huks.deleteKeyItem(MASTER_KEY_ALIAS, {
        properties: [],
      });
    } catch (_) {
      // Swallowed: key may already be absent after a partial cleanup or app reinstall.
    }
  }
}
