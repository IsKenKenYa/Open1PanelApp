using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text.Json;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Windows.UI;

namespace OnePanelNativeHost;

/// <summary>
/// Native Websites module page.
/// Mirrors upstream 1Panel website list semantics (domain, status toggle,
/// delete with confirmation). Create-site wizard is intentionally out of
/// scope for this batch (no Dart-side create handler).
/// </summary>
public sealed class WebsitesPage : ModulePageBase
{
    private readonly List<WebsiteEntry> _websites = new();
    private readonly ErrorToast _errorToast = new();
    private bool _isBusy;

    public WebsitesPage()
    {
        PageTitle = "Websites";
    }

    protected override async void OnPageShown()
    {
        await RefreshAsync();
    }

    protected override async void OnRefreshClicked()
    {
        await RefreshAsync();
    }

    private async System.Threading.Tasks.Task RefreshAsync()
    {
        await LoadWebsitesAsync(showLoadingState: true);
    }

    /// <summary>
    /// Loads the website list through the Dart business core.
    /// With <paramref name="showLoadingState"/> the page swaps to the loading
    /// spinner; otherwise the current content stays visible (silent refresh
    /// after row operations) and failures surface via the error toast.
    /// </summary>
    private async System.Threading.Tasks.Task LoadWebsitesAsync(bool showLoadingState)
    {
        if (_isBusy) return;
        _isBusy = true;

        try
        {
            if (showLoadingState) SetState(PageState.Loading);

            var result = await WindowsBridge.GetWebsitesAsync();
            if (result == null)
            {
                // Bridge failure: full error state on initial load, toast on refresh.
                if (showLoadingState)
                {
                    SetState(PageState.Error);
                }
                else
                {
                    _errorToast.Show("Failed to refresh websites.");
                }
                return;
            }

            var websites = ParseWebsites(result.Value);
            if (websites.Count == 0)
            {
                SetState(PageState.Empty);
                return;
            }

            _websites.Clear();
            _websites.AddRange(websites);
            BuildContent(websites);
            SetState(PageState.Content);
        }
        finally
        {
            _isBusy = false;
        }
    }

    private List<WebsiteEntry> ParseWebsites(JsonElement json)
    {
        var websites = new List<WebsiteEntry>();

        if (json.ValueKind == JsonValueKind.Array)
        {
            foreach (var item in json.EnumerateArray())
            {
                websites.Add(new WebsiteEntry
                {
                    Id = TryGetInt64(item, "id"),
                    Domain = TryGetString(item, "primaryDomain") ?? "Unknown",
                    Status = TryGetString(item, "status") ?? "",
                    Remark = TryGetString(item, "remark") ?? "",
                    CreatedAt = TryGetString(item, "createdAt") ?? "",
                });
            }
        }

        return websites;
    }

    private void BuildContent(List<WebsiteEntry> websites)
    {
        // Root layout: CommandBar on top, scrollable list below (relative rows).
        var root = new Grid();
        root.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
        root.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });

        var refreshButton = new AppBarButton
        {
            Icon = new FontIcon { Glyph = "\uE72C" },
            Label = "Refresh",
        };
        refreshButton.Click += async (s, e) => await LoadWebsitesAsync(showLoadingState: true);

        var commandBar = new CommandBar
        {
            DefaultLabelPosition = CommandBarDefaultLabelPosition.Right,
            Margin = new Thickness(4, 0, 4, 0),
        };
        commandBar.PrimaryCommands.Add(refreshButton);
        Grid.SetRow(commandBar, 0);
        root.Children.Add(commandBar);

        var scrollViewer = new ScrollViewer
        {
            HorizontalScrollBarVisibility = ScrollBarVisibility.Disabled,
            VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
            Padding = new Thickness(0, 0, 0, 8),
        };
        Grid.SetRow(scrollViewer, 1);

        var list = new ListView
        {
            SelectionMode = ListViewSelectionMode.None,
            Margin = new Thickness(8, 0, 8, 0),
            IsItemClickEnabled = false,
        };

        foreach (var website in websites)
        {
            list.Items.Add(CreateWebsiteItem(website));
        }

        scrollViewer.Content = list;
        root.Children.Add(scrollViewer);

        // Failure toast floats above the list, bottom-aligned (kept in the
        // visual tree so Show() actually renders).
        _errorToast.VerticalAlignment = VerticalAlignment.Bottom;
        Grid.SetRow(_errorToast, 1);
        root.Children.Add(_errorToast);

        ModuleContentPresenter.Content = root;
    }

    private FrameworkElement CreateWebsiteItem(WebsiteEntry website)
    {
        var grid = new Grid
        {
            Padding = new Thickness(16, 10, 16, 10),
            Tag = website,
        };

        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

        // Status badge: Running = success green, Stopped = neutral, others = caution.
        var badge = CreateStatusBadge(website.Status);
        Grid.SetColumn(badge, 0);
        grid.Children.Add(badge);

        // Domain (primary) + optional remark (secondary, omitted when empty).
        var infoPanel = new StackPanel
        {
            Orientation = Orientation.Vertical,
            Spacing = 2,
            VerticalAlignment = VerticalAlignment.Center,
            Margin = new Thickness(12, 0, 0, 0),
        };
        infoPanel.Children.Add(new TextBlock
        {
            Text = website.Domain,
            FontSize = 14,
            FontWeight = Microsoft.UI.Text.FontWeights.SemiBold,
            TextTrimming = TextTrimming.CharacterEllipsis,
            TextWrapping = TextWrapping.NoWrap,
        });
        if (!string.IsNullOrWhiteSpace(website.Remark))
        {
            infoPanel.Children.Add(new TextBlock
            {
                Text = website.Remark,
                FontSize = 12,
                Foreground = TryGetThemeBrush("TextFillColorSecondaryBrush", Microsoft.UI.Colors.Gray),
                TextTrimming = TextTrimming.CharacterEllipsis,
                TextWrapping = TextWrapping.NoWrap,
            });
        }
        Grid.SetColumn(infoPanel, 1);
        grid.Children.Add(infoPanel);

        // Creation date-time (right aligned, secondary color).
        var createdText = FormatDateString(website.CreatedAt);
        if (!string.IsNullOrEmpty(createdText))
        {
            var createdBlock = new TextBlock
            {
                Text = createdText,
                FontSize = 12,
                VerticalAlignment = VerticalAlignment.Center,
                HorizontalAlignment = HorizontalAlignment.Right,
                Foreground = TryGetThemeBrush("TextFillColorSecondaryBrush", Microsoft.UI.Colors.Gray),
                Margin = new Thickness(16, 0, 0, 0),
                MinWidth = 120,
            };
            Grid.SetColumn(createdBlock, 2);
            grid.Children.Add(createdBlock);
        }

        // Row actions: start/stop toggle (label follows status) + delete.
        var actions = new StackPanel
        {
            Orientation = Orientation.Horizontal,
            Spacing = 8,
            VerticalAlignment = VerticalAlignment.Center,
            Margin = new Thickness(16, 0, 0, 0),
        };

        var isRunning = IsRunning(website.Status);
        var toggleButton = new Button
        {
            Content = isRunning ? "Stop" : "Start",
            MinWidth = 68,
            VerticalAlignment = VerticalAlignment.Center,
        };
        ToolTipService.SetToolTip(toggleButton, isRunning ? "Stop website" : "Start website");
        toggleButton.Click += async (s, e) => await ToggleWebsiteAsync(website);
        actions.Children.Add(toggleButton);

        var deleteButton = new Button
        {
            Content = new FontIcon { Glyph = "\uE74D", FontSize = 14 },
            Padding = new Thickness(8, 4, 8, 4),
            VerticalAlignment = VerticalAlignment.Center,
        };
        ToolTipService.SetToolTip(deleteButton, "Delete website");
        deleteButton.Click += async (s, e) => await DeleteWebsiteAsync(website);
        actions.Children.Add(deleteButton);

        Grid.SetColumn(actions, 3);
        grid.Children.Add(actions);

        return grid;
    }

    private Border CreateStatusBadge(string status)
    {
        bool running = IsRunning(status);
        bool stopped = string.Equals(status, "Stopped", StringComparison.OrdinalIgnoreCase);

        // Theme-aware accents with hardcoded fallbacks for missing resources.
        var accentBrush = running
            ? TryGetThemeBrush("SystemFillColorSuccessBrush", Microsoft.UI.Colors.Green)
            : stopped
                ? TryGetThemeBrush("SystemFillColorNeutralBrush", Microsoft.UI.Colors.Gray)
                : TryGetThemeBrush("SystemFillColorCautionBrush", Microsoft.UI.Colors.DarkOrange);
        var accentColor = GetBrushColor(accentBrush, Microsoft.UI.Colors.Gray);

        var badgeText = new TextBlock
        {
            Text = string.IsNullOrEmpty(status) ? "Unknown" : status,
            FontSize = 12,
            Foreground = accentBrush,
            VerticalAlignment = VerticalAlignment.Center,
        };

        var dot = new Microsoft.UI.Xaml.Shapes.Ellipse
        {
            Width = 8,
            Height = 8,
            Fill = accentBrush,
            VerticalAlignment = VerticalAlignment.Center,
        };

        var badgeContent = new StackPanel
        {
            Orientation = Orientation.Horizontal,
            Spacing = 6,
        };
        badgeContent.Children.Add(dot);
        badgeContent.Children.Add(badgeText);

        // Translucent tint keeps the pill readable over Mica/LayerFill.
        return new Border
        {
            CornerRadius = new CornerRadius(10),
            Padding = new Thickness(10, 3, 10, 3),
            Background = new SolidColorBrush(Microsoft.UI.ColorHelper.FromArgb(26, accentColor.R, accentColor.G, accentColor.B)),
            VerticalAlignment = VerticalAlignment.Center,
            Child = badgeContent,
        };
    }

    private async System.Threading.Tasks.Task ToggleWebsiteAsync(WebsiteEntry website)
    {
        if (_isBusy) return;
        _isBusy = true;

        try
        {
            var running = IsRunning(website.Status);
            // Bridge semantics: Running -> stop, anything else -> start.
            var success = await WindowsBridge.ToggleWebsiteStatusAsync(website.Id, website.Status);
            if (success)
            {
                await LoadWebsitesAsync(showLoadingState: false);
            }
            else
            {
                _errorToast.Show($"Failed to {(running ? "stop" : "start")} \"{website.Domain}\".");
            }
        }
        finally
        {
            _isBusy = false;
        }
    }

    private async System.Threading.Tasks.Task DeleteWebsiteAsync(WebsiteEntry website)
    {
        if (_isBusy) return;

        // Destructive confirmation; the message carries the domain, matching
        // the upstream delete dialog that names the primary domain.
        var confirmed = await ConfirmDialog.ShowAsync(
            XamlRoot,
            "Delete Website",
            $"Are you sure you want to delete website \"{website.Domain}\"?\nThis action cannot be undone.",
            "Delete",
            "Cancel",
            isDestructive: true);

        if (!confirmed) return;

        _isBusy = true;
        try
        {
            var success = await WindowsBridge.DeleteWebsiteAsync(website.Id);
            if (success)
            {
                await LoadWebsitesAsync(showLoadingState: false);
            }
            else
            {
                _errorToast.Show($"Failed to delete \"{website.Domain}\".");
            }
        }
        finally
        {
            _isBusy = false;
        }
    }

    private static bool IsRunning(string status)
        => string.Equals(status, "Running", StringComparison.OrdinalIgnoreCase);

    private static Brush TryGetThemeBrush(string key, Color fallback)
    {
        if (Application.Current.Resources.TryGetValue(key, out var value) && value is Brush brush)
        {
            return brush;
        }
        return new SolidColorBrush(fallback);
    }

    private static Color GetBrushColor(Brush brush, Color fallback)
        => brush is SolidColorBrush solid ? solid.Color : fallback;

    /// <summary>
    /// Formats an ISO-style date string for display; falls back to the raw
    /// value when unparsable (handles Go-style 9-digit fractional seconds).
    /// </summary>
    private static string FormatDateString(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw)) return "";

        if (DateTimeOffset.TryParse(raw, CultureInfo.InvariantCulture, DateTimeStyles.None, out var parsed))
        {
            return parsed.ToLocalTime().ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture);
        }

        // Normalize ".123456789Z" fractional precision before retrying.
        var dotIndex = raw.IndexOf('.');
        if (dotIndex > 0)
        {
            var end = dotIndex + 1;
            while (end < raw.Length && char.IsDigit(raw[end])) end++;
            var normalized = raw[..dotIndex] + raw[end..];
            if (DateTimeOffset.TryParse(normalized, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsed))
            {
                return parsed.ToLocalTime().ToString("yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture);
            }
        }

        return raw;
    }

    private static string? TryGetString(JsonElement element, string property)
    {
        if (element.ValueKind == JsonValueKind.Object &&
            element.TryGetProperty(property, out var prop) &&
            prop.ValueKind == JsonValueKind.String)
        {
            return prop.GetString();
        }
        return null;
    }

    private static long TryGetInt64(JsonElement element, string property)
    {
        if (element.ValueKind == JsonValueKind.Object &&
            element.TryGetProperty(property, out var prop) &&
            prop.ValueKind == JsonValueKind.Number)
        {
            return prop.TryGetInt64(out var value) ? value : (long)prop.GetDouble();
        }
        return 0;
    }

    private sealed class WebsiteEntry
    {
        public long Id { get; set; }
        public string Domain { get; set; } = "";
        public string Status { get; set; } = "";
        public string Remark { get; set; } = "";
        public string CreatedAt { get; set; } = "";
    }
}
