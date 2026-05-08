using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;

namespace OnePanelNativeHost;

public sealed class AIPage : ModulePageBase
{
    public AIPage()
    {
        PageTitle = "AI";
    }

    protected override void OnNavigatedTo(NavigationEventArgs e)
    {
        base.OnNavigatedTo(e);
        SetState(PageState.Content);

        ModuleContentPresenter.Content = new TextBlock
        {
            Text = "AI",
            FontSize = 28,
            Margin = new Thickness(24),
        };
    }
}
