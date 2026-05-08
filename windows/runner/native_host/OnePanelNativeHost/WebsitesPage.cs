using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;

namespace OnePanelNativeHost;

public sealed class WebsitesPage : ModulePageBase
{
    public WebsitesPage()
    {
        PageTitle = "Websites";
    }

    protected override void OnNavigatedTo(NavigationEventArgs e)
    {
        base.OnNavigatedTo(e);
        SetState(PageState.Content);

        ModuleContentPresenter.Content = new TextBlock
        {
            Text = "Websites",
            FontSize = 28,
            Margin = new Thickness(24),
        };
    }
}
