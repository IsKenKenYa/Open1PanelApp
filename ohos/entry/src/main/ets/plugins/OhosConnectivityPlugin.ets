import {
  FlutterPlugin,
  FlutterPluginBinding,
  Log,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  EventChannel,
  StreamHandler,
  EventSink,
} from '@ohos/flutter_ohos';

const TAG = 'OhosConnectivityPlugin';
const METHOD_CHANNEL = 'dev.fluttercommunity.plus/connectivity';
const EVENT_CHANNEL = 'dev.fluttercommunity.plus/connectivity_status';

class ConnectivityStreamHandler implements StreamHandler {
  private sink: EventSink | null = null;

  onListen(args: Object, events: EventSink): void {
    this.sink = events;
    // Emit a plausible default so the Dart stream doesn't stay empty forever.
    this.sendEvent(['wifi']);
  }

  onCancel(args: Object): void {
    this.sink = null;
  }

  sendEvent(data: Object): void {
    if (this.sink != null) {
      this.sink.success(data);
    }
  }
}

/**
 * Stub plugin for connectivity_plus on OHOS.
 * connectivity_plus has no OHOS support, so this returns safe defaults to prevent
 * MissingPluginException in the Dart layer. Actual network state should be obtained
 * through OHOS native APIs if needed in the future.
 */
export default class OhosConnectivityPlugin
  implements FlutterPlugin, MethodCallHandler
{
  private methodChannel: MethodChannel | null = null;
  private eventChannel: EventChannel | null = null;
  private streamHandler: ConnectivityStreamHandler = new ConnectivityStreamHandler();

  getUniqueClassName(): string {
    return 'OhosConnectivityPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.methodChannel = new MethodChannel(binding.getBinaryMessenger(), METHOD_CHANNEL);
    this.methodChannel.setMethodCallHandler(this);
    this.eventChannel = new EventChannel(binding.getBinaryMessenger(), EVENT_CHANNEL);
    this.eventChannel.setStreamHandler(this.streamHandler);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.methodChannel != null) {
      this.methodChannel.setMethodCallHandler(null);
      this.methodChannel = null;
    }
    this.eventChannel = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    try {
      switch (call.method) {
        case 'check':
        case 'checkConnectivity':
          // Hardcoded 'wifi': Dart app assumes connectivity is available and handles
          // actual request failures at the HTTP layer. Returning 'none' would block UI flows.
          result.success(['wifi']);
          return;
        case 'getWifiName':
        case 'getWifiBSSID':
          result.success('unknown');
          return;
        default:
          result.notImplemented();
      }
    } catch (error) {
      Log.e(TAG, `Failed to handle ${call.method}`, error);
      result.error('connectivity_error', `${error}`, null);
    }
  }
}
