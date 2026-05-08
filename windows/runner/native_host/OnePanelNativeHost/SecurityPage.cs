using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;

namespace OnePanelNativeHost;

public sealed class SecurityPage : ModulePageBase
{
    public SecurityPage()
    {
        PageTitle = "Security";
    }

    protected override void OnNavigatedTo(NavigationEventArgs e)
    {
        base.OnNavigatedTo(e);
        SetState(PageState.Content);

        ModuleContentPresenter.Content = new TextBlock
        {
            Text = "Security",
            FontSize = 28,
            Margin = new Thickness(24),
        };
    }
}
