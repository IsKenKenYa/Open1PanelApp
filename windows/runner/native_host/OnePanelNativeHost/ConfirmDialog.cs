using System;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace OnePanelNativeHost;

public sealed class ConfirmDialog : ContentDialog
{
    private readonly TextBlock _messageBlock;

    public static readonly DependencyProperty IsDestructiveProperty =
        DependencyProperty.Register(
            nameof(IsDestructive),
            typeof(bool),
            typeof(ConfirmDialog),
            new PropertyMetadata(false, OnIsDestructiveChanged));

    public bool IsDestructive
    {
        get => (bool)GetValue(IsDestructiveProperty);
        set => SetValue(IsDestructiveProperty, value);
    }

    public string Message
    {
        get => _messageBlock.Text;
        set => _messageBlock.Text = value;
    }

    public ConfirmDialog()
    {
        PrimaryButtonText = "Confirm";
        SecondaryButtonText = "Cancel";
        DefaultButton = ContentDialogButton.Secondary;

        _messageBlock = new TextBlock
        {
            TextWrapping = TextWrapping.Wrap,
            FontSize = 14,
            Margin = new Thickness(0, 8, 0, 0),
        };

        Content = _messageBlock;
        ApplyStyle();
    }

    public ConfirmDialog(string title, string message,
        string primaryText = "Confirm", string secondaryText = "Cancel",
        bool isDestructive = false) : this()
    {
        Title = title;
        Message = message;
        PrimaryButtonText = primaryText;
        SecondaryButtonText = secondaryText;
        IsDestructive = isDestructive;
    }

    public static async Task<bool> ShowAsync(XamlRoot xamlRoot, string title, string message,
        string primaryText = "Confirm", string secondaryText = "Cancel",
        bool isDestructive = false)
    {
        var dialog = new ConfirmDialog(title, message, primaryText, secondaryText, isDestructive)
        {
            XamlRoot = xamlRoot,
        };

        var result = await dialog.ShowAsync();
        return result == ContentDialogResult.Primary;
    }

    private void ApplyStyle()
    {
        if (IsDestructive)
        {
            var style = new Style(typeof(Button));
            style.Setters.Add(new Setter(Button.BackgroundProperty,
                new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Red)));
            style.Setters.Add(new Setter(Button.ForegroundProperty,
                new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.White)));
            PrimaryButtonStyle = style;
        }
        else
        {
            PrimaryButtonStyle = null;
        }
    }

    private static void OnIsDestructiveChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        ((ConfirmDialog)d).ApplyStyle();
    }
}
