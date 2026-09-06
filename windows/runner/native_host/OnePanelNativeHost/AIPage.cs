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
/// Native AI module page: local model list (Ollama).
/// Mirrors upstream 1Panel AI model list semantics (name, size, modified
/// date, delete with confirmation naming the model).
/// </summary>
public sealed class AIPage : ModulePageBase
{
    private readonly List<AIModelEntry> _models = new();
    private readonly ErrorToast _errorToast = new();
    private bool _isBusy;

    public AIPage()
    {
        PageTitle = "AI";
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
        await LoadModelsAsync(showLoadingState: true);
    }

    /// <summary>
    /// Loads the model list through the Dart business core. With
    /// <paramref name="showLoadingState"/> the page swaps to the loading
    /// spinner; otherwise the current content stays visible (silent refresh
    /// after row operations) and failures surface via the error toast.
    /// </summary>
    private async System.Threading.Tasks.Task LoadModelsAsync(bool showLoadingState)
    {
        if (_isBusy) return;
        _isBusy = true;

        try
        {
            if (showLoadingState) SetState(PageState.Loading);

            var result = await WindowsBridge.GetAIModelsAsync();
            if (result == null)
            {
                // Bridge failure: full error state on initial load, toast on refresh.
                if (showLoadingState)
                {
                    SetState(PageState.Error);
                }
                else
                {
                    _errorToast.Show("Failed to refresh AI models.");
                }
                return;
            }

            var models = ParseModels(result.Value);
            if (models.Count == 0)
            {
                SetState(PageState.Empty);
                return;
            }

            _models.Clear();
            _models.AddRange(models);
            BuildContent(models);
            SetState(PageState.Content);
        }
        finally
        {
            _isBusy = false;
        }
    }

    private List<AIModelEntry> ParseModels(JsonElement json)
    {
        var models = new List<AIModelEntry>();

        if (json.ValueKind == JsonValueKind.Array)
        {
            foreach (var item in json.EnumerateArray())
            {
                models.Add(new AIModelEntry
                {
                    Id = TryGetInt64(item, "id"),
                    Name = TryGetString(item, "name") ?? "Unknown",
                    Size = TryGetString(item, "size") ?? "",
                    Modified = TryGetString(item, "modified") ?? "",
                });
            }
        }

        return models;
    }

    private void BuildContent(List<AIModelEntry> models)
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
        refreshButton.Click += async (s, e) => await LoadModelsAsync(showLoadingState: true);

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

        foreach (var model in models)
        {
            list.Items.Add(CreateModelItem(model));
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

    private FrameworkElement CreateModelItem(AIModelEntry model)
    {
        var grid = new Grid
        {
            Padding = new Thickness(16, 10, 16, 10),
            Tag = model,
        };

        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

        // AI/robot glyph identifies the row as a local model.
        var icon = new FontIcon
        {
            Glyph = "\uE99A",
            FontSize = 16,
            VerticalAlignment = VerticalAlignment.Center,
        };
        Grid.SetColumn(icon, 0);
        grid.Children.Add(icon);

        // Model name (primary text, elides instead of forcing wide windows).
        var nameBlock = new TextBlock
        {
            Text = model.Name,
            FontSize = 14,
            FontWeight = Microsoft.UI.Text.FontWeights.SemiBold,
            VerticalAlignment = VerticalAlignment.Center,
            Margin = new Thickness(12, 0, 0, 0),
            TextTrimming = TextTrimming.CharacterEllipsis,
            TextWrapping = TextWrapping.NoWrap,
        };
        ToolTipService.SetToolTip(nameBlock, model.Name);
        Grid.SetColumn(nameBlock, 1);
        grid.Children.Add(nameBlock);

        // Model size, "-" when unknown (upstream shows row.size || '-').
        var sizeBlock = new TextBlock
        {
            Text = string.IsNullOrWhiteSpace(model.Size) ? "-" : model.Size,
            FontSize = 12,
            VerticalAlignment = VerticalAlignment.Center,
            HorizontalAlignment = HorizontalAlignment.Right,
            Foreground = TryGetThemeBrush("TextFillColorSecondaryBrush", Microsoft.UI.Colors.Gray),
            Margin = new Thickness(16, 0, 0, 0),
            MinWidth = 64,
        };
        Grid.SetColumn(sizeBlock, 2);
        grid.Children.Add(sizeBlock);

        // Last modified date-time (right aligned, secondary color).
        var modifiedText = FormatDateString(model.Modified);
        if (!string.IsNullOrEmpty(modifiedText))
        {
            var modifiedBlock = new TextBlock
            {
                Text = modifiedText,
                FontSize = 12,
                VerticalAlignment = VerticalAlignment.Center,
                HorizontalAlignment = HorizontalAlignment.Right,
                Foreground = TryGetThemeBrush("TextFillColorSecondaryBrush", Microsoft.UI.Colors.Gray),
                Margin = new Thickness(16, 0, 0, 0),
                MinWidth = 120,
            };
            Grid.SetColumn(modifiedBlock, 3);
            grid.Children.Add(modifiedBlock);
        }

        // Row action: destructive delete with model name in the confirmation.
        var deleteButton = new Button
        {
            Content = new FontIcon { Glyph = "\uE74D", FontSize = 14 },
            Padding = new Thickness(8, 4, 8, 4),
            VerticalAlignment = VerticalAlignment.Center,
            Margin = new Thickness(16, 0, 0, 0),
        };
        ToolTipService.SetToolTip(deleteButton, "Delete model");
        deleteButton.Click += async (s, e) => await DeleteModelAsync(model);
        Grid.SetColumn(deleteButton, 4);
        grid.Children.Add(deleteButton);

        return grid;
    }

    private async System.Threading.Tasks.Task DeleteModelAsync(AIModelEntry model)
    {
        if (_isBusy) return;

        // Destructive confirmation; the message carries the model name,
        // matching the upstream delete dialog that lists selected models.
        var confirmed = await ConfirmDialog.ShowAsync(
            XamlRoot,
            "Delete AI Model",
            $"Are you sure you want to delete model \"{model.Name}\"?\nThis action cannot be undone.",
            "Delete",
            "Cancel",
            isDestructive: true);

        if (!confirmed) return;

        _isBusy = true;
        try
        {
            var success = await WindowsBridge.DeleteAIModelAsync(model.Id);
            if (success)
            {
                await LoadModelsAsync(showLoadingState: false);
            }
            else
            {
                _errorToast.Show($"Failed to delete \"{model.Name}\".");
            }
        }
        finally
        {
            _isBusy = false;
        }
    }

    private static Brush TryGetThemeBrush(string key, Color fallback)
    {
        if (Application.Current.Resources.TryGetValue(key, out var value) && value is Brush brush)
        {
            return brush;
        }
        return new SolidColorBrush(fallback);
    }

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

    private sealed class AIModelEntry
    {
        public long Id { get; set; }
        public string Name { get; set; } = "";
        public string Size { get; set; } = "";
        public string Modified { get; set; } = "";
    }
}
