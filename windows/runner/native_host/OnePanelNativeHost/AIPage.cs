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
/// date, create by model name, recreate of an existing model, delete with
/// confirmation naming the model).
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

        // Create model (upstream add-model drawer): opens the create dialog.
        var createButton = new AppBarButton
        {
            Icon = new FontIcon { Glyph = "\uE710" },
            Label = "Create model",
        };
        createButton.Click += (s, e) => _ = ShowCreateModelDialogAsync();

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
        commandBar.PrimaryCommands.Add(createButton);
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

        // Row actions: "more" menu holding recreate (re-pull, upstream row
        // retry) and the destructive delete, mirroring the upstream row
        // buttons ordering (retry before delete).
        var moreButton = new Button
        {
            Content = new FontIcon { Glyph = "\uE712", FontSize = 14 },
            Background = null,
            BorderThickness = new Thickness(0),
            Padding = new Thickness(8, 4, 8, 4),
            VerticalAlignment = VerticalAlignment.Center,
            Margin = new Thickness(16, 0, 0, 0),
        };
        ToolTipService.SetToolTip(moreButton, "Model actions");
        moreButton.Flyout = BuildRowFlyout(model);
        Grid.SetColumn(moreButton, 4);
        grid.Children.Add(moreButton);

        return grid;
    }

    private MenuFlyout BuildRowFlyout(AIModelEntry model)
    {
        var flyout = new MenuFlyout();

        var recreateItem = new MenuFlyoutItem
        {
            Text = "Recreate",
            Icon = new FontIcon { Glyph = "\uE72C" },
        };
        recreateItem.Click += (s, e) => _ = RecreateModelAsync(model);
        flyout.Items.Add(recreateItem);

        var deleteItem = new MenuFlyoutItem
        {
            Text = "Delete",
            Icon = new FontIcon { Glyph = "\uE74D" },
        };
        deleteItem.Click += (s, e) => _ = DeleteModelAsync(model);
        flyout.Items.Add(deleteItem);

        return flyout;
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

    /// <summary>
    /// Recreates (re-pulls) an existing model. Non-destructive confirmation
    /// naming the model, matching the upstream per-row retry action; success
    /// silently refreshes the list.
    /// </summary>
    private async System.Threading.Tasks.Task RecreateModelAsync(AIModelEntry model)
    {
        if (_isBusy) return;

        // Non-destructive confirmation; the message carries the model name
        // and states that the model will be rebuilt.
        var confirmed = await ConfirmDialog.ShowAsync(
            XamlRoot,
            "Recreate AI Model",
            $"Are you sure you want to recreate model \"{model.Name}\"?\nThe model will be pulled again and rebuilt.",
            "Recreate",
            "Cancel",
            isDestructive: false);

        if (!confirmed) return;

        _isBusy = true;
        try
        {
            var success = await WindowsBridge.RecreateAIModelAsync(model.Name);
            if (success)
            {
                await LoadModelsAsync(showLoadingState: false);
            }
            else
            {
                _errorToast.Show($"Failed to recreate \"{model.Name}\".");
            }
        }
        finally
        {
            _isBusy = false;
        }
    }

    /// <summary>
    /// Create-model form dialog, mirroring the upstream add-model drawer: a
    /// single required "Ollama model name" input (e.g. llama3:8b). _isBusy is
    /// held across the whole dialog lifetime so the CommandBar button cannot
    /// open a second dialog and row operations stay blocked. The dialog stays
    /// open while the bridge call runs and only closes on success; on failure
    /// the toast shows and the form stays editable.
    /// </summary>
    private async System.Threading.Tasks.Task ShowCreateModelDialogAsync()
    {
        if (_isBusy) return;
        _isBusy = true;

        try
        {
            var nameBox = new TextBox
            {
                Header = "Ollama model name",
                PlaceholderText = "llama3:8b",
            };

            var errorText = new TextBlock
            {
                FontSize = 12,
                TextWrapping = TextWrapping.Wrap,
                Foreground = TryGetThemeBrush("SystemFillColorCriticalBrush", Microsoft.UI.Colors.Red),
                Visibility = Visibility.Collapsed,
            };

            // Any edit clears the pending inline validation error.
            nameBox.TextChanged += (s, e) => SetFormError(errorText, null);

            var form = new StackPanel { Orientation = Orientation.Vertical, Spacing = 12 };
            form.Children.Add(nameBox);
            form.Children.Add(errorText);

            var dialog = new ContentDialog
            {
                Title = "Create model",
                Content = form,
                PrimaryButtonText = "Create",
                CloseButtonText = "Cancel",
                DefaultButton = ContentDialogButton.Primary,
                XamlRoot = XamlRoot,
            };

            bool submitting = false;
            bool createSucceeded = false;

            async System.Threading.Tasks.Task SubmitCreateAsync()
            {
                var success = await WindowsBridge.CreateAIModelAsync(nameBox.Text.Trim());
                if (success)
                {
                    createSucceeded = true;
                    dialog.Hide(); // Closing lets this programmatic close pass.
                }
                else
                {
                    submitting = false;
                    _errorToast.Show("Failed to create model.");
                    SetFormError(errorText, "Create failed. Adjust the input and try again.");
                }
            }

            dialog.Closing += (s, args) =>
            {
                // Programmatic close after a successful create passes through.
                if (createSucceeded) return;

                // Swallow every close attempt while the bridge call is in
                // flight so the dialog cannot outlive the submit result.
                if (submitting)
                {
                    args.Cancel = true;
                    return;
                }

                if (args.Result != ContentDialogResult.Primary) return;

                // Inline validation: on an empty name cancel the close so the
                // dialog stays open and the error shows next to the field.
                if (string.IsNullOrWhiteSpace(nameBox.Text))
                {
                    args.Cancel = true;
                    SetFormError(errorText, "Model name is required.");
                    return;
                }

                // Keep the dialog open during submission; close only on success.
                args.Cancel = true;
                submitting = true;
                _ = SubmitCreateAsync();
            };

            await dialog.ShowAsync();
            if (!createSucceeded) return;

            // The dialog is closed; release the dialog-lifetime guard so the
            // _isBusy-guarded silent refresh below can actually run.
            _isBusy = false;
            await LoadModelsAsync(showLoadingState: false);
        }
        finally
        {
            _isBusy = false;
        }
    }

    private static void SetFormError(TextBlock target, string? message)
    {
        if (string.IsNullOrEmpty(message))
        {
            target.Text = string.Empty;
            target.Visibility = Visibility.Collapsed;
        }
        else
        {
            target.Text = message;
            target.Visibility = Visibility.Visible;
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
