using Microsoft.UI.Xaml.Controls;

namespace OnePanelNativeHost;

public sealed partial class MainWindow : Window
{
    private static readonly Dictionary<string, Type> _pageMap = new()
    {
        { "Servers", typeof(ServersPage) },
        { "Files", typeof(FilesPage) },
        { "Containers", typeof(ContainersPage) },
        { "Apps", typeof(AppsPage) },
        { "Websites", typeof(WebsitesPage) },
        { "AI", typeof(AIPage) },
        { "Security", typeof(SecurityPage) },
        { "Settings", typeof(SettingsPage) },
    };

    public MainWindow()
    {
        InitializeComponent();
        RootNavigationView.SelectionChanged += OnNavigationSelectionChanged;
        RootNavigationView.SelectedItem = RootNavigationView.MenuItems[0];
    }

    private void OnNavigationSelectionChanged(
        NavigationView sender,
        NavigationViewSelectionChangedEventArgs args)
    {
        if (args.SelectedItem is not NavigationViewItem item)
        {
            return;
        }

        var tag = item.Content?.ToString();

        if (tag is not null && _pageMap.TryGetValue(tag, out var pageType))
        {
            ContentFrame.Navigate(pageType);
        }
    }
}
