using System;
using System.Collections.Generic;
using System.Text.Json;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;

namespace OnePanelNativeHost;

public sealed class FilesPage : ModulePageBase
{
    private string _currentPath = "/";
    private ListView? _listView;

    public FilesPage()
    {
        PageTitle = "Files";
    }

    protected override async void OnNavigatedTo(NavigationEventArgs e)
    {
        base.OnNavigatedTo(e);
        SetState(PageState.Loading);
        await LoadFilesAsync(_currentPath);
    }

    protected override async void OnRefreshClicked()
    {
        SetState(PageState.Loading);
        await LoadFilesAsync(_currentPath);
    }

    private async System.Threading.Tasks.Task LoadFilesAsync(string path)
    {
        _currentPath = path;
        var result = await WindowsBridge.GetFilesAsync(path);

        if (result == null)
        {
            SetState(PageState.Error);
            return;
        }

        var files = ParseFiles(result.Value);
        if (files.Count == 0)
        {
            SetState(PageState.Empty);
            return;
        }

        BuildFileList(files);
        SetState(PageState.Content);
    }

    private List<FileEntry> ParseFiles(JsonElement json)
    {
        var files = new List<FileEntry>();

        if (json.ValueKind == JsonValueKind.Array)
        {
            foreach (var item in json.EnumerateArray())
            {
                files.Add(new FileEntry
                {
                    Name = TryGetString(item, "name") ?? "Unknown",
                    Path = TryGetString(item, "path") ?? "",
                    IsDir = TryGetBool(item, "isDir"),
                    Size = TryGetInt64(item, "size"),
                    ModTime = TryGetInt64(item, "modTime"),
                });
            }
        }

        files.Sort((a, b) =>
        {
            if (a.IsDir != b.IsDir) return a.IsDir ? -1 : 1;
            return string.Compare(a.Name, b.Name, StringComparison.OrdinalIgnoreCase);
        });

        return files;
    }

    private void BuildFileList(List<FileEntry> files)
    {
        var rootPanel = new StackPanel
        {
            Orientation = Orientation.Vertical,
        };

        var breadcrumbBar = BuildBreadcrumbBar();
        rootPanel.Children.Add(breadcrumbBar);

        _listView = new ListView
        {
            SelectionMode = ListViewSelectionMode.Single,
            Margin = new Thickness(8, 0, 8, 8),
        };

        _listView.DoubleTapped += OnFileDoubleTapped;

        foreach (var file in files)
        {
            var item = CreateFileItem(file);
            _listView.Items.Add(item);
        }

        rootPanel.Children.Add(_listView);
        ModuleContentPresenter.Content = rootPanel;
    }

    private StackPanel BuildBreadcrumbBar()
    {
        var bar = new StackPanel
        {
            Orientation = Orientation.Horizontal,
            Padding = new Thickness(16, 12, 16, 8),
            Spacing = 4,
        };

        var upButton = new Button
        {
            Content = new FontIcon { Glyph = "\uE72B", FontSize = 14 },
            Margin = new Thickness(0, 0, 8, 0),
            IsEnabled = _currentPath != "/",
        };
        upButton.Click += OnNavigateUp;
        bar.Children.Add(upButton);

        var rootButton = new HyperlinkButton
        {
            Content = new TextBlock { Text = "/", FontSize = 14 },
            Padding = new Thickness(4, 0, 4, 0),
            Tag = "/",
        };
        rootButton.Click += OnBreadcrumbClick;
        bar.Children.Add(rootButton);

        if (_currentPath == "/") return bar;

        var segments = _currentPath.TrimStart('/').Split('/', StringSplitOptions.RemoveEmptyEntries);
        var accumulated = "";

        for (int i = 0; i < segments.Length; i++)
        {
            accumulated += "/" + segments[i];
            var isLast = i == segments.Length - 1;
            var segmentPath = accumulated;

            var separator = new TextBlock
            {
                Text = " \uE76C ",
                FontSize = 10,
                VerticalAlignment = VerticalAlignment.Center,
                Foreground = new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Gray),
            };
            bar.Children.Add(separator);

            if (isLast)
            {
                var currentBlock = new TextBlock
                {
                    Text = segments[i],
                    FontSize = 14,
                    FontWeight = Microsoft.UI.Text.FontWeights.SemiBold,
                    VerticalAlignment = VerticalAlignment.Center,
                };
                bar.Children.Add(currentBlock);
            }
            else
            {
                var segmentButton = new HyperlinkButton
                {
                    Content = new TextBlock { Text = segments[i], FontSize = 14 },
                    Padding = new Thickness(4, 0, 4, 0),
                    Tag = segmentPath,
                };
                segmentButton.Click += OnBreadcrumbClick;
                bar.Children.Add(segmentButton);
            }
        }

        return bar;
    }

    private async void OnBreadcrumbClick(object? sender, RoutedEventArgs e)
    {
        if (sender is not HyperlinkButton button) return;
        var targetPath = button.Tag as string ?? "/";
        SetState(PageState.Loading);
        await LoadFilesAsync(targetPath);
    }

    private Grid CreateFileItem(FileEntry file)
    {
        var grid = new Grid
        {
            Padding = new Thickness(12, 6, 12, 6),
            Tag = file,
        };

        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(32) });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

        var icon = new FontIcon
        {
            Glyph = file.IsDir ? "\uE8B7" : "\uE7C3",
            FontSize = 18,
            HorizontalAlignment = HorizontalAlignment.Center,
            VerticalAlignment = VerticalAlignment.Center,
            Foreground = file.IsDir
                ? new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Goldenrod)
                : new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.DimGray),
        };
        Grid.SetColumn(icon, 0);
        grid.Children.Add(icon);

        var nameBlock = new TextBlock
        {
            Text = file.Name,
            FontSize = 14,
            VerticalAlignment = VerticalAlignment.Center,
            Margin = new Thickness(8, 0, 0, 0),
        };
        Grid.SetColumn(nameBlock, 1);
        grid.Children.Add(nameBlock);

        var sizeText = !file.IsDir && file.Size >= 0 ? FormatFileSize(file.Size) : "";
        var sizeBlock = new TextBlock
        {
            Text = sizeText,
            FontSize = 12,
            VerticalAlignment = VerticalAlignment.Center,
            HorizontalAlignment = HorizontalAlignment.Right,
            Foreground = new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Gray),
            Margin = new Thickness(16, 0, 0, 0),
            MinWidth = 80,
        };
        Grid.SetColumn(sizeBlock, 2);
        grid.Children.Add(sizeBlock);

        var dateText = file.ModTime > 0
            ? DateTimeOffset.FromUnixTimeMilliseconds(file.ModTime).ToLocalTime()
                .ToString("yyyy-MM-dd HH:mm")
            : "";
        var dateBlock = new TextBlock
        {
            Text = dateText,
            FontSize = 12,
            VerticalAlignment = VerticalAlignment.Center,
            HorizontalAlignment = HorizontalAlignment.Right,
            Foreground = new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Gray),
            Margin = new Thickness(16, 0, 0, 0),
            MinWidth = 120,
        };
        Grid.SetColumn(dateBlock, 3);
        grid.Children.Add(dateBlock);

        return grid;
    }

    private async void OnFileDoubleTapped(object? sender, DoubleTappedRoutedEventArgs e)
    {
        if (_listView?.SelectedItem is not Grid grid) return;
        if (grid.Tag is not FileEntry file) return;
        if (!file.IsDir) return;

        SetState(PageState.Loading);
        await LoadFilesAsync(string.IsNullOrEmpty(file.Path) ? $"/{file.Name}" : file.Path);
    }

    private async void OnNavigateUp(object? sender, RoutedEventArgs e)
    {
        if (_currentPath == "/") return;

        var parentPath = _currentPath.TrimEnd('/');
        var lastSlash = parentPath.LastIndexOf('/');
        parentPath = lastSlash <= 0 ? "/" : parentPath[..lastSlash];

        SetState(PageState.Loading);
        await LoadFilesAsync(parentPath);
    }

    private static string FormatFileSize(long bytes)
    {
        string[] units = { "B", "KB", "MB", "GB", "TB" };
        var size = (double)bytes;
        var unitIndex = 0;

        while (size >= 1024 && unitIndex < units.Length - 1)
        {
            size /= 1024;
            unitIndex++;
        }

        return $"{size:F1} {units[unitIndex]}";
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

    private static bool TryGetBool(JsonElement element, string property)
    {
        if (element.ValueKind == JsonValueKind.Object &&
            element.TryGetProperty(property, out var prop) &&
            prop.ValueKind == JsonValueKind.True)
        {
            return true;
        }
        return false;
    }

    private static long TryGetInt64(JsonElement element, string property)
    {
        if (element.ValueKind == JsonValueKind.Object &&
            element.TryGetProperty(property, out var prop) &&
            prop.ValueKind == JsonValueKind.Number)
        {
            return prop.TryGetInt64(out var v) ? v : (long)prop.GetDouble();
        }
        return -1;
    }

    private sealed class FileEntry
    {
        public string Name { get; set; } = "";
        public string Path { get; set; } = "";
        public bool IsDir { get; set; }
        public long Size { get; set; } = -1;
        public long ModTime { get; set; }
    }
}
