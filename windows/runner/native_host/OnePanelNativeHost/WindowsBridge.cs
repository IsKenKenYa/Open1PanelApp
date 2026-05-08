using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace OnePanelNativeHost;

public static class WindowsBridge
{
    private const string ChannelName = "com.openpanel.windows/shell_bridge";
    private static readonly TimeSpan DefaultTimeout = TimeSpan.FromSeconds(30);
    private const int MaxRetries = 2;

    private static IntPtr _messengerHandle;
    private static bool _flutterAvailable = true;

    private static readonly HashSet<string> RetryableMethods = new()
    {
        "getServers",
        "getCurrentServer",
        "getFiles",
        "getSettingsSummary",
    };

    public static void Initialize(IntPtr messengerHandle)
    {
        _messengerHandle = messengerHandle;
        _flutterAvailable = true;
    }

    public static async Task<string?> InvokeAsync(string method, object? args = null)
    {
        if (!_flutterAvailable || _messengerHandle == IntPtr.Zero)
        {
            return null;
        }

        byte[] encoded;
        try
        {
            encoded = Codec.EncodeMethodCall(method, PrepareArgs(args));
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"[WindowsBridge] Encode failed for {method}: {ex.Message}");
            return null;
        }

        var responseBytes = await SendWithReplyAsync(encoded);
        if (responseBytes == null)
        {
            return null;
        }

        try
        {
            return Codec.DecodeResponse(responseBytes);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"[WindowsBridge] Decode failed for {method}: {ex.Message}");
            return null;
        }
    }

    public static async Task<JsonElement?> GetServersAsync()
    {
        return await InvokeWithRetryAsync("getServers");
    }

    public static async Task<JsonElement?> GetCurrentServerAsync()
    {
        return await InvokeWithRetryAsync("getCurrentServer");
    }

    public static async Task<bool> SwitchServerAsync(string serverId)
    {
        var result = await InvokeAsync("switchServer", new Dictionary<string, object?> { ["id"] = serverId });
        if (result == null) return false;
        try
        {
            return bool.TryParse(result, out var ok) && ok;
        }
        catch
        {
            return false;
        }
    }

    public static async Task<JsonElement?> GetFilesAsync(string path)
    {
        return await InvokeWithRetryAsync("getFiles", new Dictionary<string, object?> { ["path"] = path });
    }

    public static async Task<JsonElement?> GetSettingsSummaryAsync()
    {
        return await InvokeWithRetryAsync("getSettingsSummary");
    }

    public static async Task<bool> UpdateSettingAsync(string key, object? value)
    {
        var result = await InvokeAsync("updateSetting", new Dictionary<string, object?> { ["key"] = key, ["value"] = value });
        if (result == null) return false;
        try
        {
            return bool.TryParse(result, out var ok) && ok;
        }
        catch
        {
            return false;
        }
    }

    private static async Task<JsonElement?> InvokeWithRetryAsync(string method, object? args = null)
    {
        for (int attempt = 0; attempt <= MaxRetries; attempt++)
        {
            try
            {
                var json = await InvokeAsync(method, args);
                if (json != null)
                {
                    using var doc = JsonDocument.Parse(json);
                    return doc.RootElement.Clone();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"[WindowsBridge] {method} attempt {attempt} failed: {ex.Message}");
            }

            if (attempt < MaxRetries && RetryableMethods.Contains(method))
            {
                await Task.Delay(500 * (attempt + 1));
            }
            else if (!RetryableMethods.Contains(method))
            {
                break;
            }
        }

        return null;
    }

    private static object? PrepareArgs(object? args)
    {
        if (args == null) return null;
        if (args is IDictionary dict) return ConvertDictionary(dict);
        if (args is IDictionary<string, object?> sd) return sd;
        var json = JsonSerializer.Serialize(args);
        using var doc = JsonDocument.Parse(json);
        return ConvertJsonElement(doc.RootElement);
    }

    private static Dictionary<string, object?> ConvertDictionary(IDictionary dict)
    {
        var result = new Dictionary<string, object?>();
        foreach (DictionaryEntry entry in dict)
        {
            result[entry.Key?.ToString() ?? ""] = entry.Value;
        }
        return result;
    }

    private static object? ConvertJsonElement(JsonElement element)
    {
        return element.ValueKind switch
        {
            JsonValueKind.Null => null,
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            JsonValueKind.Number => element.TryGetInt64(out var l) ? l : element.GetDouble(),
            JsonValueKind.String => element.GetString(),
            JsonValueKind.Array => element.EnumerateArray().Select(ConvertJsonElement).ToList(),
            JsonValueKind.Object => element.EnumerateObject()
                .ToDictionary(p => p.Name, p => ConvertJsonElement(p.Value)),
            _ => null,
        };
    }

    private static async Task<byte[]?> SendWithReplyAsync(byte[] message)
    {
        if (!_flutterAvailable || _messengerHandle == IntPtr.Zero)
        {
            return null;
        }

        var pending = new PendingCall();

        pending.Callback = (data, dataSize, userData) =>
        {
            try
            {
                if (data == IntPtr.Zero || dataSize == 0)
                {
                    pending.Tcs.TrySetResult(null);
                    return;
                }

                var bytes = new byte[dataSize];
                Marshal.Copy(data, bytes, 0, (int)dataSize);
                pending.Tcs.TrySetResult(bytes);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"[WindowsBridge] Reply callback error: {ex.Message}");
                pending.Tcs.TrySetResult(null);
            }
            finally
            {
                if (userData != IntPtr.Zero)
                {
                    GCHandle.FromIntPtr(userData).Free();
                }
            }
        };

        var handle = GCHandle.Alloc(pending);

        try
        {
            bool sent = FlutterDesktopMessengerSendWithReply(
                _messengerHandle,
                ChannelName,
                message,
                (ulong)message.Length,
                pending.Callback,
                GCHandle.ToIntPtr(handle));

            if (!sent)
            {
                handle.Free();
                return null;
            }
        }
        catch (DllNotFoundException)
        {
            _flutterAvailable = false;
            handle.Free();
            System.Diagnostics.Debug.WriteLine("[WindowsBridge] Flutter engine DLL not found.");
            return null;
        }
        catch (EntryPointNotFoundException)
        {
            _flutterAvailable = false;
            handle.Free();
            System.Diagnostics.Debug.WriteLine("[WindowsBridge] FlutterMessengerSendWithReply not found.");
            return null;
        }
        catch (Exception ex)
        {
            handle.Free();
            System.Diagnostics.Debug.WriteLine($"[WindowsBridge] Send failed: {ex.Message}");
            return null;
        }

        using var cts = new CancellationTokenSource(DefaultTimeout);
        using (cts.Token.Register(() => pending.Tcs.TrySetResult(null)))
        {
            var result = await pending.Tcs.Task;
            return result;
        }
    }

    private sealed class PendingCall
    {
        public TaskCompletionSource<byte[]?> Tcs { get; } = new();
        public FlutterDesktopBinaryReply? Callback { get; set; }
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate void FlutterDesktopBinaryReply(IntPtr data, ulong dataSize, IntPtr userData);

    [DllImport("flutter_windows.dll", CallingConvention = CallingConvention.Cdecl)]
    private static extern bool FlutterDesktopMessengerSendWithReply(
        IntPtr messenger,
        [MarshalAs(UnmanagedType.LPStr)] string channel,
        byte[] message,
        ulong messageSize,
        FlutterDesktopBinaryReply callback,
        IntPtr userData);

    private static class Codec
    {
        private const byte TypeNull = 0;
        private const byte TypeTrue = 1;
        private const byte TypeFalse = 2;
        private const byte TypeInt32 = 3;
        private const byte TypeInt64 = 4;
        private const byte TypeFloat64 = 6;
        private const byte TypeString = 7;
        private const byte TypeUInt8List = 8;
        private const byte TypeInt32List = 9;
        private const byte TypeFloat64List = 10;
        private const byte TypeList = 11;
        private const byte TypeMap = 12;

        private const byte EnvelopeCall = 0;
        private const byte EnvelopeSuccess = 0;
        private const byte EnvelopeError = 1;
        private const byte EnvelopeNotImplemented = 2;

        public static byte[] EncodeMethodCall(string method, object? args)
        {
            using var stream = new MemoryStream();
            using var writer = new BinaryWriter(stream);
            writer.Write(EnvelopeCall);
            WriteValue(writer, method);
            WriteValue(writer, args);
            return stream.ToArray();
        }

        public static string? DecodeResponse(byte[] data)
        {
            using var stream = new MemoryStream(data);
            using var reader = new BinaryReader(stream);
            var type = reader.ReadByte();
            switch (type)
            {
                case EnvelopeSuccess:
                    var result = ReadValue(reader);
                    return JsonSerializer.Serialize(ToJsonSerializable(result));
                case EnvelopeError:
                    var code = ReadValue(reader) as string ?? "unknown";
                    var message = ReadValue(reader) as string;
                    System.Diagnostics.Debug.WriteLine($"[WindowsBridge] Method error: {code} - {message}");
                    return null;
                case EnvelopeNotImplemented:
                    System.Diagnostics.Debug.WriteLine("[WindowsBridge] Method not implemented.");
                    return null;
                default:
                    return null;
            }
        }

        private static void WriteValue(BinaryWriter writer, object? value)
        {
            switch (value)
            {
                case null:
                    writer.Write(TypeNull);
                    break;
                case bool b:
                    writer.Write(b ? TypeTrue : TypeFalse);
                    break;
                case int i:
                    writer.Write(TypeInt32);
                    writer.Write(BigEndian(i));
                    break;
                case long l:
                    writer.Write(TypeInt64);
                    writer.Write(BigEndian(l));
                    break;
                case double d:
                    writer.Write(TypeFloat64);
                    writer.Write(BigEndian(d));
                    break;
                case string s:
                    writer.Write(TypeString);
                    var bytes = Encoding.UTF8.GetBytes(s);
                    writer.Write(BigEndian(bytes.Length));
                    writer.Write(bytes);
                    break;
                case byte[] arr:
                    writer.Write(TypeUInt8List);
                    writer.Write(BigEndian(arr.Length));
                    writer.Write(arr);
                    break;
                case IDictionary<string, object?> dict:
                    writer.Write(TypeMap);
                    writer.Write(BigEndian(dict.Count));
                    foreach (var kvp in dict)
                    {
                        WriteValue(writer, kvp.Key);
                        WriteValue(writer, kvp.Value);
                    }
                    break;
                case IDictionary dict:
                    writer.Write(TypeMap);
                    writer.Write(BigEndian(dict.Count));
                    foreach (DictionaryEntry entry in dict)
                    {
                        WriteValue(writer, entry.Key?.ToString());
                        WriteValue(writer, entry.Value);
                    }
                    break;
                case IList list:
                    writer.Write(TypeList);
                    writer.Write(BigEndian(list.Count));
                    foreach (var item in list)
                    {
                        WriteValue(writer, item);
                    }
                    break;
                default:
                    writer.Write(TypeNull);
                    break;
            }
        }

        private static object? ReadValue(BinaryReader reader)
        {
            if (reader.BaseStream.Position >= reader.BaseStream.Length)
            {
                return null;
            }

            var type = reader.ReadByte();
            switch (type)
            {
                case TypeNull:
                    return null;
                case TypeTrue:
                    return true;
                case TypeFalse:
                    return false;
                case TypeInt32:
                    return ReadInt32BigEndian(reader);
                case TypeInt64:
                    return ReadInt64BigEndian(reader);
                case TypeFloat64:
                    return ReadFloat64BigEndian(reader);
                case TypeString:
                    var strLen = ReadInt32BigEndian(reader);
                    return Encoding.UTF8.GetString(reader.ReadBytes(strLen));
                case TypeUInt8List:
                    var byteLen = ReadInt32BigEndian(reader);
                    return reader.ReadBytes(byteLen);
                case TypeInt32List:
                    var intLen = ReadInt32BigEndian(reader);
                    var ints = new int[intLen];
                    for (int i = 0; i < intLen; i++)
                        ints[i] = ReadInt32BigEndian(reader);
                    return ints;
                case TypeFloat64List:
                    var doubleLen = ReadInt32BigEndian(reader);
                    var doubles = new double[doubleLen];
                    for (int i = 0; i < doubleLen; i++)
                        doubles[i] = ReadFloat64BigEndian(reader);
                    return doubles;
                case TypeList:
                    var listLen = ReadInt32BigEndian(reader);
                    var list = new List<object?>(listLen);
                    for (int i = 0; i < listLen; i++)
                        list.Add(ReadValue(reader));
                    return list;
                case TypeMap:
                    var mapLen = ReadInt32BigEndian(reader);
                    var map = new Dictionary<string, object?>(mapLen);
                    for (int i = 0; i < mapLen; i++)
                    {
                        var key = ReadValue(reader)?.ToString() ?? "";
                        var val = ReadValue(reader);
                        map[key] = val;
                    }
                    return map;
                default:
                    return null;
            }
        }

        private static object? ToJsonSerializable(object? value)
        {
            return value switch
            {
                null => null,
                IDictionary<string, object?> dict => dict.ToDictionary(
                    kvp => kvp.Key,
                    kvp => ToJsonSerializable(kvp.Value)),
                IDictionary dict => dict.Keys.Cast<object?>()
                    .ToDictionary(k => k?.ToString() ?? "", k => ToJsonSerializable(dict[k])),
                IList list => list.Cast<object?>().Select(ToJsonSerializable).ToList(),
                _ => value,
            };
        }

        private static byte[] BigEndian(int value)
        {
            var bytes = BitConverter.GetBytes(value);
            if (BitConverter.IsLittleEndian) Array.Reverse(bytes);
            return bytes;
        }

        private static byte[] BigEndian(long value)
        {
            var bytes = BitConverter.GetBytes(value);
            if (BitConverter.IsLittleEndian) Array.Reverse(bytes);
            return bytes;
        }

        private static byte[] BigEndian(double value)
        {
            var bytes = BitConverter.GetBytes(value);
            if (BitConverter.IsLittleEndian) Array.Reverse(bytes);
            return bytes;
        }

        private static int ReadInt32BigEndian(BinaryReader reader)
        {
            var bytes = reader.ReadBytes(4);
            if (BitConverter.IsLittleEndian) Array.Reverse(bytes);
            return BitConverter.ToInt32(bytes, 0);
        }

        private static long ReadInt64BigEndian(BinaryReader reader)
        {
            var bytes = reader.ReadBytes(8);
            if (BitConverter.IsLittleEndian) Array.Reverse(bytes);
            return BitConverter.ToInt64(bytes, 0);
        }

        private static double ReadFloat64BigEndian(BinaryReader reader)
        {
            var bytes = reader.ReadBytes(8);
            if (BitConverter.IsLittleEndian) Array.Reverse(bytes);
            return BitConverter.ToDouble(bytes, 0);
        }
    }
}
