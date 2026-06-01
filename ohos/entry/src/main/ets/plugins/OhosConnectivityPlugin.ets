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
    // Emit initial connectivity state
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
 * Graceful fallback plugin for connectivity_plus on OHOS.
 * Returns reasonable defaults since OHOS has its own network management.
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
          // Return ['wifi'] as default — OHOS emulator typically has WiFi.
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
