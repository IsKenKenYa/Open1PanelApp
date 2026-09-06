using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace OnePanelNativeHost;

public sealed partial class MainWindow : Window
{
    private static readonly Dictionary<string, Func<Page>> _pageFactories = new()
    {
        { "Servers", () => new ServersPage() },
        { "Files", () => new FilesPage() },
        { "Containers", () => new ContainersPage() },
        { "Apps", () => new AppsPage() },
        { "Websites", () => new WebsitesPage() },
        { "AI", () => new AIPage() },
        { "Security", () => new SecurityPage() },
        { "Settings", () => new SettingsPage() },
    };

    private readonly Dictionary<string, Page> _pageCache = new();

    public MainWindow()
    {
        InitializeComponent();
        WindowBackdrop.Apply(this, WindowBackdrop.LoadPreferred());
        RootNavigationView.SelectionChanged += OnNavigationSelectionChanged;
        // 导航必须在模板应用(Frame 就绪)后触发，构造期间赋值会触发 native 崩溃。
        RootNavigationView.Loaded += (sender, _) =>
        {
            if (RootNavigationView.SelectedItem == null)
            {
                RootNavigationView.SelectedItem = RootNavigationView.MenuItems[0];
            }
        };
    }

    // 本环境(self-contained unpackaged)下 Frame.Navigate 存在 native 崩溃缺陷，
    // 采用单例页面 + Content 直赋：桌面左导航场景无需 back stack，页面自身缓存。
    private void OnNavigationSelectionChanged(
        NavigationView sender,
        NavigationViewSelectionChangedEventArgs args)
    {
        if (args.SelectedItem is not NavigationViewItem item)
        {
            return;
        }

        var tag = item.Content?.ToString();
        if (tag is null || !_pageFactories.TryGetValue(tag, out var factory))
        {
            return;
        }

        if (!_pageCache.TryGetValue(tag, out var page))
        {
            page = factory();
            _pageCache[tag] = page;
        }

        ContentFrame.Content = page;
        if (page is ModulePageBase modulePage)
        {
            modulePage.ActivatePage();
        }
    }
}
