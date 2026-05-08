using System;
using System.Collections.Generic;
using System.Text.Json;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;

namespace OnePanelNativeHost;

public sealed class SettingsPage : ModulePageBase
{
    private readonly ErrorToast _errorToast = new();

    public SettingsPage()
    {
        PageTitle = "Settings";
    }

    protected override async void OnNavigatedTo(NavigationEventArgs e)
    {
        base.OnNavigatedTo(e);
        SetState(PageState.Loading);
        await LoadSettingsAsync();
    }

    protected override async void OnRefreshClicked()
    {
        SetState(PageState.Loading);
        await LoadSettingsAsync();
    }

    private async System.Threading.Tasks.Task LoadSettingsAsync()
    {
        var result = await WindowsBridge.GetSettingsSummaryAsync();

        if (result == null)
        {
            SetState(PageState.Error);
            return;
        }

        var settings = ParseSettings(result.Value);
        if (settings.Count == 0)
        {
            SetState(PageState.Empty);
            return;
        }

        BuildSettingsPanel(settings);
        SetState(PageState.Content);
    }

    private List<SettingEntry> ParseSettings(JsonElement json)
    {
        var settings = new List<SettingEntry>();

        if (json.ValueKind == JsonValueKind.Object)
        {
            foreach (var prop in json.EnumerateObject())
            {
                settings.Add(new SettingEntry
                {
                    RawKey = prop.Name,
                    Key = FormatLabel(prop.Name),
                    Value = FormatValue(prop.Value),
                    Category = Categorize(prop.Name),
                    IsBool = prop.Value.ValueKind is JsonValueKind.True or JsonValueKind.False,
                    BoolValue = prop.Value.ValueKind == JsonValueKind.True,
                });
            }
        }

        return settings;
    }

    private void BuildSettingsPanel(List<SettingEntry> settings)
    {
        var scrollViewer = new ScrollViewer
        {
            HorizontalScrollBarVisibility = ScrollBarVisibility.Disabled,
            VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
        };

        var rootPanel = new StackPanel
        {
            Orientation = Orientation.Vertical,
            Margin = new Thickness(24, 16, 24, 16),
            Spacing = 4,
        };

        var currentCategory = "";
        foreach (var setting in settings)
        {
            if (setting.Category != currentCategory)
            {
                currentCategory = setting.Category;
                var categoryHeader = new TextBlock
                {
                    Text = currentCategory,
                    FontSize = 18,
                    FontWeight = Microsoft.UI.Text.FontWeights.SemiBold,
                    Margin = new Thickness(0, 16, 0, 8),
                };
                rootPanel.Children.Add(categoryHeader);

                var separator = new StackPanel
                {
                    Height = 1,
                    Background = new Microsoft.UI.Xaml.Media.SolidColorBrush(
                        Microsoft.UI.Colors.LightGray),
                    Margin = new Thickness(0, 0, 0, 8),
                };
                rootPanel.Children.Add(separator);
            }

            var row = new Grid
            {
                Padding = new Thickness(0, 8, 0, 8),
            };

            row.ColumnDefinitions.Add(new ColumnDefinition
                { Width = new GridLength(1, GridUnitType.Star) });
            row.ColumnDefinitions.Add(new ColumnDefinition
                { Width = GridLength.Auto });

            var keyBlock = new TextBlock
            {
                Text = setting.Key,
                FontSize = 14,
                VerticalAlignment = VerticalAlignment.Center,
            };
            Grid.SetColumn(keyBlock, 0);
            row.Children.Add(keyBlock);

            if (setting.IsBool)
            {
                var toggle = new ToggleSwitch
                {
                    IsOn = setting.BoolValue,
                    Tag = setting.RawKey,
                    OnContent = "",
                    OffContent = "",
                };
                toggle.Toggled += OnSettingToggled;
                Grid.SetColumn(toggle, 1);
                row.Children.Add(toggle);
            }
            else
            {
                var valueBlock = new TextBlock
                {
                    Text = setting.Value,
                    FontSize = 14,
                    VerticalAlignment = VerticalAlignment.Center,
                    Foreground = new Microsoft.UI.Xaml.Media.SolidColorBrush(
                        Microsoft.UI.Colors.Gray),
                };
                Grid.SetColumn(valueBlock, 1);
                row.Children.Add(valueBlock);
            }

            rootPanel.Children.Add(row);
        }

        scrollViewer.Content = rootPanel;
        ModuleContentPresenter.Content = scrollViewer;
    }

    private static string FormatLabel(string key)
    {
        if (string.IsNullOrEmpty(key)) return key;

        var result = new System.Text.StringBuilder();
        for (int i = 0; i < key.Length; i++)
        {
            var c = key[i];
            if (i > 0 && char.IsUpper(c))
            {
                result.Append(' ');
            }
            result.Append(i == 0 ? char.ToUpper(c) : c);
        }

        return result.ToString();
    }

    private static string FormatValue(JsonElement value)
    {
        return value.ValueKind switch
        {
            JsonValueKind.String => value.GetString() ?? "",
            JsonValueKind.Number => value.TryGetInt64(out var l) ? l.ToString() : value.GetDouble().ToString("F2"),
            JsonValueKind.True => "Yes",
            JsonValueKind.False => "No",
            JsonValueKind.Null => "—",
            JsonValueKind.Array => $"[{value.GetArrayLength()} items]",
            JsonValueKind.Object => $"{{{value.EnumerateObject().Count()} properties}}",
            _ => value.ToString(),
        };
    }

    private static string Categorize(string key)
    {
        return key switch
        {
            "renderMode" or "language" or "theme" => "Appearance",
            "version" or "buildNumber" or "channel" => "About",
            _ => "General",
        };
    }

    private async void OnSettingToggled(object? sender, RoutedEventArgs e)
    {
        if (sender is not ToggleSwitch toggle) return;
        var key = toggle.Tag as string;
        if (string.IsNullOrEmpty(key)) return;

        var success = await WindowsBridge.UpdateSettingAsync(key, toggle.IsOn);
        if (!success)
        {
            _errorToast.Show($"Failed to update \"{FormatLabel(key)}\".");
            toggle.IsOn = !toggle.IsOn;
        }
    }

    private sealed class SettingEntry
    {
        public string RawKey { get; set; } = "";
        public string Key { get; set; } = "";
        public string Value { get; set; } = "";
        public string Category { get; set; } = "General";
        public bool IsBool { get; set; }
        public bool BoolValue { get; set; }
    }
}
