using System;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace OnePanelNativeHost;

public sealed class ErrorToast : UserControl
{
    private readonly DispatcherTimer _dismissTimer;
    private readonly InfoBar _infoBar;

    public static readonly DependencyProperty MessageProperty =
        DependencyProperty.Register(
            nameof(Message),
            typeof(string),
            typeof(ErrorToast),
            new PropertyMetadata(string.Empty, OnMessageChanged));

    public string Message
    {
        get => (string)GetValue(MessageProperty);
        set => SetValue(MessageProperty, value);
    }

    public ErrorToast()
    {
        _infoBar = new InfoBar
        {
            Severity = InfoBarSeverity.Error,
            IsClosable = true,
            IsOpen = false,
            Margin = new Thickness(16, 0, 16, 8),
            HorizontalAlignment = HorizontalAlignment.Stretch,
        };

        _infoBar.CloseButtonClick += OnClose;

        _dismissTimer = new DispatcherTimer
        {
            Interval = TimeSpan.FromSeconds(5),
        };
        _dismissTimer.Tick += OnDismissTimerTick;

        var root = new Grid
        {
            VerticalAlignment = VerticalAlignment.Bottom,
            HorizontalAlignment = HorizontalAlignment.Stretch,
        };

        root.Children.Add(_infoBar);
        Content = root;
    }

    public void Show(string message)
    {
        Message = message;
        _infoBar.Message = message;
        _infoBar.IsOpen = true;

        _dismissTimer.Stop();
        _dismissTimer.Start();
    }

    public void Dismiss()
    {
        _dismissTimer.Stop();
        _infoBar.IsOpen = false;
    }

    private void OnClose(InfoBar sender, object args)
    {
        _dismissTimer.Stop();
    }

    private void OnDismissTimerTick(object? sender, object e)
    {
        _dismissTimer.Stop();
        _infoBar.IsOpen = false;
    }

    private static void OnMessageChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        var toast = (ErrorToast)d;
        toast._infoBar.Message = e.NewValue as string ?? string.Empty;
    }
}
