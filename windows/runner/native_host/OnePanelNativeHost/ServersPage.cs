using System;
using System.Collections.Generic;
using System.Text.Json;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;
using Microsoft.UI.Xaml.Shapes;

namespace OnePanelNativeHost;

public sealed class ServersPage : ModulePageBase
{
    private ListView? _listView;
    private readonly List<ServerEntry> _servers = new();
    private readonly ErrorToast _errorToast = new();

    public ServersPage()
    {
        PageTitle = "Servers";
    }

    protected override async void OnPageShown()
    {
        SetState(PageState.Loading);
        await LoadServersAsync();
    }

    protected override async void OnRefreshClicked()
    {
        SetState(PageState.Loading);
        await LoadServersAsync();
    }

    private async System.Threading.Tasks.Task LoadServersAsync()
    {
        var result = await WindowsBridge.GetServersAsync();

        if (result == null)
        {
            SetState(PageState.Error);
            return;
        }

        var servers = ParseServers(result.Value);
        if (servers.Count == 0)
        {
            SetState(PageState.Empty);
            return;
        }

        _servers.Clear();
        _servers.AddRange(servers);
        BuildServerList(servers);
        SetState(PageState.Content);
    }

    private List<ServerEntry> ParseServers(JsonElement json)
    {
        var servers = new List<ServerEntry>();

        if (json.ValueKind == JsonValueKind.Array)
        {
            foreach (var item in json.EnumerateArray())
            {
                servers.Add(new ServerEntry
                {
                    Id = TryGetString(item, "id"),
                    Name = TryGetString(item, "name") ?? "Unknown",
                    Url = TryGetString(item, "url") ?? "",
                    IsCurrent = TryGetBool(item, "isCurrent"),
                    Cpu = TryGetDouble(item, "cpu"),
                    Memory = TryGetDouble(item, "memory"),
                });
            }
        }

        return servers;
    }

    private void BuildServerList(List<ServerEntry> servers)
    {
        _listView = new ListView
        {
            SelectionMode = ListViewSelectionMode.Single,
            Margin = new Thickness(16, 8, 16, 8),
        };

        _listView.SelectionChanged += OnServerSelected;

        foreach (var server in servers)
        {
            var item = CreateServerItem(server);
            _listView.Items.Add(item);
        }

        ModuleContentPresenter.Content = _listView;
    }

    private StackPanel CreateServerItem(ServerEntry server)
    {
        var panel = new StackPanel
        {
            Orientation = Orientation.Horizontal,
            Spacing = 16,
            Padding = new Thickness(12, 8, 12, 8),
            Tag = server.Id,
        };

        var statusEllipse = new Ellipse
        {
            Width = 12,
            Height = 12,
            Fill = server.IsCurrent
                ? new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Green)
                : new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Gray),
            VerticalAlignment = VerticalAlignment.Center,
        };

        var infoPanel = new StackPanel
        {
            Orientation = Orientation.Vertical,
            Spacing = 4,
        };

        var nameBlock = new TextBlock
        {
            Text = server.Name,
            FontSize = 16,
            FontWeight = Microsoft.UI.Text.FontWeights.SemiBold,
        };

        var urlBlock = new TextBlock
        {
            Text = server.Url,
            FontSize = 13,
            Foreground = new Microsoft.UI.Xaml.Media.SolidColorBrush(
                Microsoft.UI.Colors.Gray),
        };

        var metricsText = server.Cpu >= 0 || server.Memory >= 0
            ? $"CPU: {server.Cpu:F1}%  Mem: {server.Memory:F1}%"
            : "";

        infoPanel.Children.Add(nameBlock);
        infoPanel.Children.Add(urlBlock);

        if (!string.IsNullOrEmpty(metricsText))
        {
            var metricsBlock = new TextBlock
            {
                Text = metricsText,
                FontSize = 12,
                Foreground = new Microsoft.UI.Xaml.Media.SolidColorBrush(
                    Microsoft.UI.Colors.DimGray),
            };
            infoPanel.Children.Add(metricsBlock);
        }

        if (server.IsCurrent)
        {
            var badge = new TextBlock
            {
                Text = "Current",
                FontSize = 12,
                Foreground = new Microsoft.UI.Xaml.Media.SolidColorBrush(Microsoft.UI.Colors.Green),
                VerticalAlignment = VerticalAlignment.Center,
                Margin = new Thickness(8, 0, 0, 0),
            };
            panel.Children.Add(statusEllipse);
            panel.Children.Add(infoPanel);
            panel.Children.Add(badge);
        }
        else
        {
            panel.Children.Add(statusEllipse);
            panel.Children.Add(infoPanel);
        }

        return panel;
    }

    private async void OnServerSelected(object? sender, SelectionChangedEventArgs e)
    {
        if (_listView?.SelectedItem is not StackPanel panel) return;
        var serverId = panel.Tag as string;
        if (string.IsNullOrEmpty(serverId)) return;

        var server = _servers.Find(s => s.Id == serverId);
        if (server == null) return;

        var confirmed = await ConfirmDialog.ShowAsync(
            XamlRoot,
            "Switch Server",
            $"Switch to \"{server.Name}\"?\n\nURL: {server.Url}",
            "Switch",
            "Cancel");

        if (!confirmed) return;

        var success = await WindowsBridge.SwitchServerAsync(serverId);
        if (!success)
        {
            _errorToast.Show($"Failed to switch to \"{server.Name}\".");
        }
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

    private static double TryGetDouble(JsonElement element, string property)
    {
        if (element.ValueKind == JsonValueKind.Object &&
            element.TryGetProperty(property, out var prop) &&
            prop.ValueKind == JsonValueKind.Number)
        {
            return prop.GetDouble();
        }
        return -1;
    }

    private sealed class ServerEntry
    {
        public string? Id { get; set; }
        public string Name { get; set; } = "";
        public string Url { get; set; } = "";
        public bool IsCurrent { get; set; }
        public double Cpu { get; set; } = -1;
        public double Memory { get; set; } = -1;
    }
}
