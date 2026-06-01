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
import common from '@ohos.app.ability.common';
import http from '@ohos.net.http';
import fs from '@ohos.file.fs';

const TAG = 'OhosDownloadPlugin';
const METHOD_CHANNEL = 'onepanel/ohos_download';
const EVENT_CHANNEL = 'onepanel/ohos_download_progress';

function generateTaskId(): string {
  const hex = '0123456789abcdef';
  let result = '';
  for (let i = 0; i < 36; i++) {
    if (i === 8 || i === 13 || i === 18 || i === 23) {
      result += '-';
    } else if (i === 14) {
      result += '4';
    } else if (i === 19) {
      result += hex.charAt(8 + Math.floor(Math.random() * 4));
    } else {
      result += hex.charAt(Math.floor(Math.random() * 16));
    }
  }
  return result;
}

interface DownloadEntry {
  taskId: string;
  url: string;
  savedDir: string;
  fileName: string;
  headers: Record<string, string>;
  status: string;
  bytesReceived: number;
  totalBytes: number;
  filePath: string;
  httpRequest: http.HttpRequest | null;
}

class ProgressStreamHandler implements StreamHandler {
  private sink: EventSink | null = null;

  onListen(args: Object, events: EventSink): void {
    this.sink = events;
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

export default class OhosDownloadPlugin
  implements FlutterPlugin, MethodCallHandler
{
  private methodChannel: MethodChannel | null = null;
  private eventChannel: EventChannel | null = null;
  private streamHandler: ProgressStreamHandler = new ProgressStreamHandler();
  private applicationContext: common.Context | null = null;
  private downloads: Map<string, DownloadEntry> = new Map();

  getUniqueClassName(): string {
    return 'OhosDownloadPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.applicationContext = binding.getApplicationContext() as common.Context;
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
    this.applicationContext = null;
    this.downloads.forEach((entry) => {
      if (entry.httpRequest) {
        entry.httpRequest.destroy();
        entry.httpRequest = null;
      }
    });
    this.downloads.clear();
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
        case 'enqueue':
          result.success(await this.enqueue(call));
          return;
        case 'pause': {
          const taskId = call.argument('taskId') as string;
          this.pauseDownload(taskId);
          result.success(true);
          return;
        }
        case 'resume': {
          const taskId = call.argument('taskId') as string;
          await this.resumeDownload(taskId);
          result.success(true);
          return;
        }
        case 'cancel': {
          const taskId = call.argument('taskId') as string;
          this.cancelDownload(taskId);
          result.success(true);
          return;
        }
        case 'getProgress': {
          const taskId = call.argument('taskId') as string;
          const entry = this.downloads.get(taskId);
          if (entry) {
            const progress = entry.totalBytes > 0
              ? Math.floor((entry.bytesReceived / entry.totalBytes) * 100)
              : 0;
            const map: Record<string, Object> = {
              'taskId': entry.taskId,
              'bytesReceived': entry.bytesReceived,
              'totalBytes': entry.totalBytes,
              'status': entry.status,
              'progress': progress,
            };
            result.success(map);
          } else {
            result.success(null);
          }
          return;
        }
        case 'saveDownloadedFile': {
          const taskId = call.argument('taskId') as string;
          result.success(await this.saveDownloadedFile(taskId));
          return;
        }
        case 'listTasks': {
          const tasks: Record<string, Object>[] = [];
          this.downloads.forEach((entry) => {
            const progress = entry.totalBytes > 0
              ? Math.floor((entry.bytesReceived / entry.totalBytes) * 100)
              : 0;
            tasks.push({
              'taskId': entry.taskId,
              'url': entry.url,
              'savedDir': entry.savedDir,
              'fileName': entry.fileName,
              'status': entry.status,
              'bytesReceived': entry.bytesReceived,
              'totalBytes': entry.totalBytes,
              'progress': progress,
            });
          });
          result.success(tasks);
          return;
        }
        default:
          result.notImplemented();
      }
    } catch (error) {
      Log.e(TAG, `Failed to handle ${call.method}`, error);
      result.error('ohos_download_error', `${error}`, null);
    }
  }

  private async enqueue(call: MethodCall): Promise<string> {
    const context = this.requireContext();
    const url = this.requireNonEmptyStringArgument(call, 'url');
    const savedDir = call.argument('savedDir') as string || `${context.cacheDir}/downloads`;
    const fileName = call.argument('fileName') as string || this.extractFileName(url);
    const rawHeaders = call.argument('headers') as Record<string, string> || {};

    await this.ensureDirectory(savedDir);

    const filePath = await this.nextAvailablePath(savedDir, fileName);
    const taskId = generateTaskId();

    const entry: DownloadEntry = {
      taskId,
      url,
      savedDir,
      fileName,
      headers: rawHeaders,
      status: 'running',
      bytesReceived: 0,
      totalBytes: 0,
      filePath,
      httpRequest: null,
    };

    this.downloads.set(taskId, entry);

    this.executeDownload(entry).catch((error: Error) => {
      Log.e(TAG, `Download ${taskId} failed: ${error}`);
      entry.status = 'failed';
      this.sendProgress(entry);
    });

    return taskId;
  }

  private async executeDownload(entry: DownloadEntry): Promise<void> {
    const httpRequest = http.createHttp();
    entry.httpRequest = httpRequest;

    try {
      const response = await httpRequest.request(entry.url, {
        method: http.RequestMethod.GET,
        header: entry.headers,
        expectDataType: http.HttpDataType.ARRAY_BUFFER,
        connectTimeout: 15000,
        readTimeout: 30000,
      });

      if (response.responseCode !== 200) {
        entry.status = 'failed';
        this.sendProgress(entry);
        return;
      }

      const headerObj = response.header as Record<string, string>;
      const contentLength = headerObj['content-length'];
      entry.totalBytes = contentLength ? parseInt(contentLength, 10) : 0;

      const file = fs.openSync(
        entry.filePath,
        fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC,
      );

      try {
        const buffer = response.result as ArrayBuffer;
        const uint8 = new Uint8Array(buffer);
        const chunkSize = 64 * 1024;
        for (let offset = 0; offset < uint8.length; offset += chunkSize) {
          while (entry.status === 'paused') {
            await new Promise<void>((resolve: () => void) => setTimeout(resolve, 500));
          }
          if (entry.status === 'cancelled') break;
          if (entry.status !== 'running') break;

          const end = Math.min(offset + chunkSize, uint8.length);
          const chunk = uint8.slice(offset, end);
          fs.writeSync(file.fd, chunk.buffer as ArrayBuffer);
          entry.bytesReceived = offset + chunk.byteLength;
          this.sendProgress(entry);
        }
        fs.fsyncSync(file.fd);
      } finally {
        fs.closeSync(file);
      }

      if (entry.status === 'cancelled') {
        try { fs.unlinkSync(entry.filePath); } catch (_) {}
        entry.status = 'cancelled';
      } else {
        entry.status = 'completed';
      }
      this.sendProgress(entry);
    } catch (error) {
      Log.e(TAG, `Download execution error: ${error}`);
      entry.status = 'failed';
      this.sendProgress(entry);
    } finally {
      httpRequest.destroy();
      entry.httpRequest = null;
    }
  }

  private pauseDownload(taskId: string): void {
    const entry = this.downloads.get(taskId);
    if (entry && entry.status === 'running') {
      entry.status = 'paused';
      this.sendProgress(entry);
    }
  }

  private async resumeDownload(taskId: string): Promise<void> {
    const entry = this.downloads.get(taskId);
    if (entry && entry.status === 'paused') {
      entry.status = 'running';
      this.sendProgress(entry);
      await this.executeDownload(entry);
    }
  }

  private cancelDownload(taskId: string): void {
    const entry = this.downloads.get(taskId);
    if (entry) {
      entry.status = 'cancelled';
      if (entry.httpRequest) {
        entry.httpRequest.destroy();
        entry.httpRequest = null;
      }
      try { fs.unlinkSync(entry.filePath); } catch (_) {}
      this.sendProgress(entry);
      this.downloads.delete(taskId);
    }
  }

  private async saveDownloadedFile(taskId: string): Promise<string | null> {
    const entry = this.downloads.get(taskId);
    if (!entry || entry.status !== 'completed') return null;
    return entry.filePath;
  }

  private sendProgress(entry: DownloadEntry): void {
    const progress = entry.totalBytes > 0
      ? Math.floor((entry.bytesReceived / entry.totalBytes) * 100)
      : 0;
    const map: Record<string, Object> = {
      'taskId': entry.taskId,
      'bytesReceived': entry.bytesReceived,
      'totalBytes': entry.totalBytes,
      'status': entry.status,
      'progress': progress,
    };
    this.streamHandler.sendEvent(map);
  }

  private extractFileName(url: string): string {
    try {
      const lastSlash = url.lastIndexOf('/');
      const queryIndex = url.indexOf('?', lastSlash);
      const end = queryIndex > 0 ? queryIndex : url.length;
      const name = url.substring(lastSlash + 1, end);
      return name.length > 0 ? name : 'download';
    } catch (_) {
      return 'download';
    }
  }

  private async ensureDirectory(path: string): Promise<void> {
    try {
      if (fs.accessSync(path)) return;
    } catch (_) {}
    fs.mkdirSync(path, true);
  }

  private async nextAvailablePath(directory: string, fileName: string): Promise<string> {
    const first = `${directory}/${fileName}`;
    if (!this.exists(first)) return first;

    const lastDot = fileName.lastIndexOf('.');
    const baseName = lastDot > 0 ? fileName.substring(0, lastDot) : fileName;
    const extension = lastDot > 0 ? fileName.substring(lastDot) : '';
    for (let counter = 1; counter <= 9999; counter++) {
      const candidate = `${directory}/${baseName}_${counter}${extension}`;
      if (!this.exists(candidate)) return candidate;
    }
    throw new Error(`Failed to generate unique file name: ${fileName}`);
  }

  private exists(path: string): boolean {
    try { return fs.accessSync(path); } catch (_) { return false; }
  }

  private requireContext(): common.Context {
    if (this.applicationContext == null) {
      throw new Error('Application context is not ready');
    }
    return this.applicationContext;
  }

  private requireNonEmptyStringArgument(call: MethodCall, key: string): string {
    const value = call.argument(key) as string | null;
    if (value != null && value.length > 0) return value;
    throw new Error(`Missing required string argument: ${key}`);
  }
}
