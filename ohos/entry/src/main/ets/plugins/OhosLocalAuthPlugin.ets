import {
  FlutterPlugin,
  FlutterPluginBinding,
  Log,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

const TAG = 'OhosLocalAuthPlugin';
const CHANNEL = 'plugins.flutter.io/local_auth';

export default class OhosLocalAuthPlugin
  implements FlutterPlugin, MethodCallHandler
{
  private channel: MethodChannel | null = null;

  getUniqueClassName(): string {
    return 'OhosLocalAuthPlugin';
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
      switch (call.method) {
        case 'authenticate':
          // Graceful fallback: keep startup/auth flow non-blocking on HMOS.
          result.success(false);
          return;
        case 'getAvailableBiometrics':
          result.success([]);
          return;
        case 'isDeviceSupported':
        case 'deviceSupportsBiometrics':
          result.success(false);
          return;
        case 'stopAuthentication':
          result.success(false);
          return;
        default:
          result.notImplemented();
      }
    } catch (error) {
      Log.e(TAG, `Failed to handle ${call.method}`, error);
      result.error('local_auth_error', `${error}`, null);
    }
  }
}