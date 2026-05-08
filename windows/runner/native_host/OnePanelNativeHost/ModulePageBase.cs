using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace OnePanelNativeHost;

public enum PageState
{
    Loading,
    Content,
    Empty,
    Error
}

public class ModulePageBase : Page
{
    private readonly ProgressRing _progressRing;
    private readonly ContentPresenter _contentPresenter;
    private readonly StackPanel _emptyPanel;
    private readonly StackPanel _errorPanel;

    protected ContentPresenter ModuleContentPresenter => _contentPresenter;
    protected string PageTitle { get; set; } = string.Empty;

    public ModulePageBase()
    {
        NavigationCacheMode = NavigationCacheMode.Enabled;

        var rootGrid = new Grid();

        _progressRing = new ProgressRing
        {
            IsActive = true,
            Width = 40,
            Height = 40,
            HorizontalAlignment = HorizontalAlignment.Center,
            VerticalAlignment = VerticalAlignment.Center,
        };

        _contentPresenter = new ContentPresenter
        {
            Name = "ModuleContent",
            HorizontalAlignment = HorizontalAlignment.Stretch,
            VerticalAlignment = VerticalAlignment.Stretch,
        };

        _emptyPanel = new StackPanel
        {
            HorizontalAlignment = HorizontalAlignment.Center,
            VerticalAlignment = VerticalAlignment.Center,
            Spacing = 12,
            Orientation = Orientation.Vertical,
            Visibility = Visibility.Collapsed,
        };

        var emptyIcon = new FontIcon
        {
            Glyph = "\uE894",
            FontSize = 36,
            HorizontalAlignment = HorizontalAlignment.Center,
        };
        var emptyText = new TextBlock
        {
            Text = "No data available",
            FontSize = 16,
            HorizontalAlignment = HorizontalAlignment.Center,
        };
        var refreshButton = new Button
        {
            Content = "Refresh",
            HorizontalAlignment = HorizontalAlignment.Center,
        };
        refreshButton.Click += (s, e) => OnRefreshClicked();

        _emptyPanel.Children.Add(emptyIcon);
        _emptyPanel.Children.Add(emptyText);
        _emptyPanel.Children.Add(refreshButton);

        _errorPanel = new StackPanel
        {
            HorizontalAlignment = HorizontalAlignment.Center,
            VerticalAlignment = VerticalAlignment.Center,
            Spacing = 12,
            Orientation = Orientation.Vertical,
            Visibility = Visibility.Collapsed,
        };

        var errorIcon = new FontIcon
        {
            Glyph = "\uE783",
            FontSize = 36,
            HorizontalAlignment = HorizontalAlignment.Center,
        };
        var errorText = new TextBlock
        {
            Text = "Failed to load data",
            FontSize = 16,
            HorizontalAlignment = HorizontalAlignment.Center,
        };
        var retryButton = new Button
        {
            Content = "Retry",
            HorizontalAlignment = HorizontalAlignment.Center,
        };
        retryButton.Click += (s, e) => OnRefreshClicked();

        _errorPanel.Children.Add(errorIcon);
        _errorPanel.Children.Add(errorText);
        _errorPanel.Children.Add(retryButton);

        rootGrid.Children.Add(_progressRing);
        rootGrid.Children.Add(_contentPresenter);
        rootGrid.Children.Add(_emptyPanel);
        rootGrid.Children.Add(_errorPanel);

        Content = rootGrid;
        SetState(PageState.Loading);
    }

    public void SetState(PageState state)
    {
        _progressRing.IsActive = state == PageState.Loading;
        _progressRing.Visibility = state == PageState.Loading ? Visibility.Visible : Visibility.Collapsed;
        _contentPresenter.Visibility = state == PageState.Content ? Visibility.Visible : Visibility.Collapsed;
        _emptyPanel.Visibility = state == PageState.Empty ? Visibility.Visible : Visibility.Collapsed;
        _errorPanel.Visibility = state == PageState.Error ? Visibility.Visible : Visibility.Collapsed;
    }

    protected virtual void OnRefreshClicked()
    {
    }
}
