using Microsoft.UI.Xaml;

namespace OnePanelNativeHost;

public partial class App : Application
{
    private Window? _window;

    public App()
    {
        InitializeComponent();
        UnhandledException += (_, e) =>
        {
            try
            {
                System.IO.File.WriteAllText(
                    Path.Combine(AppContext.BaseDirectory, "crash.log"),
                    $"{e.Message}\n{e.Exception}");
            }
            catch
            {
                // 诊断兜底失败时无进一步处理
            }
        };
    }

    protected override void OnLaunched(LaunchActivatedEventArgs args)
    {
        // Dart 业务核心（headless 引擎）先行；引擎未就绪或启动失败时，
        // 页面按既有四态降级（Loading → 错误态 + 重试）。
        var hostDirectory = AppContext.BaseDirectory;
        if (FlutterEngineHost.IsEnginePresent(hostDirectory))
        {
            // Dart 侧 main.dart 依据该环境变量进入 headless/引擎-only 模式。
            Environment.SetEnvironmentVariable("ONEPANEL_NATIVE_HOST_ACTIVE", "1");
            var messenger = FlutterEngineHost.Start(hostDirectory);
            WindowsBridge.Initialize(messenger);
        }

        _window = new MainWindow();
        _window.Activate();
    }
}
