using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Windows.UI;

namespace OnePanelNativeHost;

/// <summary>
/// Native Security Gateway page: a read-only minimal set that aggregates
/// three security-related views of the active server - the panel SSL info
/// map, the website certificate expiry overview and the OpenResty load
/// status. This is a client enhancement module without a single direct
/// upstream page: the 1Panel web frontend surfaces these facts across the
/// panel settings (SSL info), the website certificate list and the website
/// OpenResty views, and the client joins them into one security overview.
///
/// READ-ONLY BOUNDARY: this batch intentionally exposes no write actions -
/// the CommandBar carries only Refresh. Gateway policy write operations
/// (creating/updating/deleting gateway policies, enforcement toggles,
/// certificate upload and binding) belong to a later batch.
///
/// Data flows through WindowsBridge (Dart business core over the method
/// channel); no direct HTTP from the native layer. The three sources are
/// fetched concurrently because each call crosses the method channel.
///
/// Bridge semantics (per call): null means the bridge itself failed; an
/// empty JSON object means no active server is configured. The page treats
/// the panel SSL map as the primary payload: null fails the page (full
/// error state on initial load, toast on refresh) and an empty map renders
/// the empty state (same rules as DashboardPage). Secondary sources degrade
/// per card instead of failing the whole page: unavailable certificates or
/// status collapse their card, and an OpenResty snapshot is reused for its
/// status map only.
///
/// Certificate rows show the primary domain, the provider as a neutral tag
/// pill and the validity range (startDate to expireDate). The expiry pill
/// turns red when the certificate is expired and orange when it expires
/// within 30 days; when expireDate cannot be parsed as a date the pill
/// stays neutral.
/// </summary>
public sealed class SecurityGatewayPage : ModulePageBase
{
    /// <summary>Certificates at or inside this many days count as expiring soon.</summary>
    private const int ExpiringSoonDays = 30;

    private readonly ErrorToast _errorToast = new();

    /// <summary>Re-entrancy guard shared by loads and refresh.</summary>
    private bool _isBusy;

    /// <summary>Expiry badge states for one website certificate.</summary>
    private enum CertificateExpiryState
    {
        Unknown,
        Valid,
        ExpiringSoon,
        Expired
    }

    public SecurityGatewayPage()
    {
        PageTitle = "Security Gateway";
    }

    protected override async void OnPageShown()
    {
        await LoadSnapshotAsync(showLoadingState: true);
    }

    protected override async void OnRefreshClicked()
    {
        await LoadSnapshotAsync(showLoadingState: true);
    }

    /// <summary>Guarded entry point used by page shown and the refresh action.</summary>
    private async Task LoadSnapshotAsync(bool showLoadingState)
    {
        if (_isBusy) return;
        _isBusy = true;

        try
        {
            await LoadSnapshotCoreAsync(showLoadingState);
        }
        finally
        {
            _isBusy = false;
        }
    }

    /// <summary>
    /// Unguarded load body. With <paramref name="showLoadingState"/> the page
    /// swaps to the loading spinner; otherwise the current content stays
    /// visible and failures surface via the error toast.
    /// </summary>
    private async Task LoadSnapshotCoreAsync(bool showLoadingState)
    {
        if (showLoadingState) SetState(PageState.Loading);

        // Fetch all three sources concurrently: each call crosses the method
        // channel into the Dart core, so parallel awaits cut the total wait.
        var panelSslTask = WindowsBridge.GetPanelSslInfoAsync();
        var certificatesTask = WindowsBridge.GetWebsiteCertificatesAsync();
        var openrestyTask = WindowsBridge.GetOpenrestySnapshotAsync();
        await Task.WhenAll(panelSslTask, certificatesTask, openrestyTask);

        var panelSsl = panelSslTask.Result;
        var certificates = ParseCertificates(certificatesTask.Result);
        var openrestyStatus = GetMapProperty(openrestyTask.Result ?? default, "status");

        if (panelSsl == null)
        {
            // Bridge failure: full error state on initial load, toast on
            // refresh. Secondary sources degrade per card (collapsed) and
            // never fail the page on their own.
            if (showLoadingState)
            {
                SetState(PageState.Error);
            }
            else
            {
                _errorToast.Show("Failed to refresh the security gateway snapshot.");
            }
            return;
        }

        // Bridge semantics: an empty panel SSL map means no active server is
        // configured, which maps to the empty state (same as DashboardPage).
        if (!HasAnyProperty(panelSsl.Value))
        {
            SetState(PageState.Empty);
            return;
        }

        BuildContent(panelSsl.Value, certificates, openrestyStatus);
        SetState(PageState.Content);
    }

    private void BuildContent(
        JsonElement panelSslMap,
        List<CertificateEntry>? certificates,
        JsonElement openrestyStatusMap)
    {
        // Root layout: CommandBar on top, scrollable content below (relative rows).
        var root = new Grid();
        root.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
        root.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });

        var commandBar = BuildCommandBar();
        Grid.SetRow(commandBar, 0);
        root.Children.Add(commandBar);

        var scrollViewer = new ScrollViewer
        {
            HorizontalScrollBarVisibility = ScrollBarVisibility.Disabled,
            VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
            Padding = new Thickness(0, 0, 0, 8),
        };
        Grid.SetRow(scrollViewer, 1);

        var content = new StackPanel
        {
            Orientation = Orientation.Vertical,
            Margin = new Thickness(8, 0, 8, 0),
            Spacing = 12,
        };
        content.Children.Add(BuildPanelSslCard(panelSslMap));
        content.Children.Add(BuildCertificatesCard(certificates));
        content.Children.Add(BuildOpenRestyStatusCard(openrestyStatusMap));
        scrollViewer.Content = content;
        root.Children.Add(scrollViewer);

        // Failure toast floats above the content, bottom-aligned (kept in the
        // visual tree so Show() actually renders).
        _errorToast.VerticalAlignment = VerticalAlignment.Bottom;
        Grid.SetRow(_errorToast, 1);
        root.Children.Add(_errorToast);

        ModuleContentPresenter.Content = root;
    }

    private CommandBar BuildCommandBar()
    {
        var bar = new CommandBar
        {
            HorizontalAlignment = HorizontalAlignment.Left,
            DefaultLabelPosition = CommandBarDefaultLabelPosition.Right,
            Background = null, // Stay transparent on the LayerFill card surface.
        };

        // Read-only batch: Refresh is the only command; policy write actions
        // are deferred to a later batch (see the class header).
        var refreshButton = new AppBarButton
        {
            Label = "Refresh",
            Icon = new FontIcon { Glyph = "\uE72C" },
        };
        refreshButton.Click += (s, e) => _ = LoadSnapshotAsync(showLoadingState: true);
        bar.PrimaryCommands.Add(refreshButton);

        return bar;
    }

    /// <summary>
    /// Panel SSL card: the server-side dynamic key/value map rendered as an
    /// InfoBag-style label/value grid (blank values as "--", booleans as
    /// Yes/No). The whole card collapses when the map is empty.
    /// </summary>
    private FrameworkElement BuildPanelSslCard(JsonElement panelSslMap)
    {
        var card = CreateCard("Panel SSL", out var panel);

        if (!HasAnyProperty(panelSslMap))
        {
            card.Visibility = Visibility.Collapsed;
            return card;
        }

        panel.Children.Add(BuildInfoBag(panelSslMap));
        return card;
    }

    /// <summary>
    /// Website certificates card: one row per certificate with the primary
    /// domain as the main text, the provider as a neutral tag pill and the
    /// expiry state as a colored pill. Unavailable (null) collapses the
    /// card; an empty list keeps the card and shows a "no certificates"
    /// hint so an empty but reachable source stays distinguishable.
    /// </summary>
    private FrameworkElement BuildCertificatesCard(List<CertificateEntry>? certificates)
    {
        var card = CreateCard("Website Certificates", out var panel);

        if (certificates == null)
        {
            card.Visibility = Visibility.Collapsed;
            return card;
        }

        if (certificates.Count == 0)
        {
            panel.Children.Add(new TextBlock
            {
                Text = "No certificates yet.",
                FontSize = 12,
                Foreground = TryGetThemeBrush("TextFillColorSecondaryBrush", Microsoft.UI.Colors.Gray),
                TextWrapping = TextWrapping.Wrap,
            });
            return card;
        }

        foreach (var certificate in certificates)
        {
            panel.Children.Add(BuildCertificateRow(certificate));
        }

        return card;
    }

    /// <summary>
    /// OpenResty status card: reuses the OpenResty snapshot bridge and takes
    /// only its status map, rendered as an InfoBag grid like the upstream
    /// website views. The whole card collapses when the map is empty or the
    /// snapshot was unavailable.
    /// </summary>
    private FrameworkElement BuildOpenRestyStatusCard(JsonElement statusMap)
    {
        var card = CreateCard("OpenResty Status", out var panel);

        if (!HasAnyProperty(statusMap))
        {
            card.Visibility = Visibility.Collapsed;
            return card;
        }

        panel.Children.Add(BuildInfoBag(statusMap));
        return card;
    }

    /// <summary>
    /// One certificate row: relative columns only - the domain stretches in
    /// a Star column, the provider and expiry pills sit in Auto columns at
    /// the trailing edge, and the validity range spans the full width below.
    /// </summary>
    private static FrameworkElement BuildCertificateRow(CertificateEntry certificate)
    {
        var (expiryState, daysLeft) = EvaluateExpiry(certificate.ExpireDate);

        var row = new Grid { ColumnSpacing = 8, RowSpacing = 2, Margin = new Thickness(0, 0, 0, 6) };
        row.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
        row.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        row.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        row.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
        row.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });

        var domainBlock = new TextBlock
        {
            Text = string.IsNullOrWhiteSpace(certificate.PrimaryDomain)
                ? "--"
                : certificate.PrimaryDomain.Trim(),
            FontSize = 14,
            FontWeight = Microsoft.UI.Text.FontWeights.SemiBold,
            TextTrimming = TextTrimming.CharacterEllipsis,
            VerticalAlignment = VerticalAlignment.Center,
        };
        Grid.SetRow(domainBlock, 0);
        Grid.SetColumn(domainBlock, 0);
        row.Children.Add(domainBlock);

        if (!string.IsNullOrWhiteSpace(certificate.Provider))
        {
            var providerPill = CreatePill(
                certificate.Provider.Trim(),
                TryGetThemeBrush("SystemFillColorNeutralBrush", Microsoft.UI.Colors.Gray));
            Grid.SetRow(providerPill, 0);
            Grid.SetColumn(providerPill, 1);
            row.Children.Add(providerPill);
        }

        var expiryPill = CreatePill(
            FormatExpiryLabel(expiryState, daysLeft),
            GetExpiryBrush(expiryState));
        Grid.SetRow(expiryPill, 0);
        Grid.SetColumn(expiryPill, 2);
        row.Children.Add(expiryPill);

        var validityBlock = new TextBlock
        {
            Text = FormatValidityRange(certificate.StartDate, certificate.ExpireDate),
            FontSize = 12,
            Foreground = TryGetThemeBrush("TextFillColorSecondaryBrush", Microsoft.UI.Colors.Gray),
            TextTrimming = TextTrimming.CharacterEllipsis,
        };
        Grid.SetRow(validityBlock, 1);
        Grid.SetColumn(validityBlock, 0);
        Grid.SetColumnSpan(validityBlock, 3);
        row.Children.Add(validityBlock);

        return row;
    }

    /// <summary>
    /// Classifies the certificate expiry: expired turns the badge red,
    /// within the expiring-soon window turns it orange, everything else
    /// (including an unparsable date) stays neutral.
    /// </summary>
    private static (CertificateExpiryState State, int DaysLeft) EvaluateExpiry(string expireDate)
    {
        if (TryParseDate(expireDate, out var expiry))
        {
            // Day-granularity comparison so a certificate expiring today is
            // "expiring soon", not "expired".
            var daysLeft = (int)Math.Floor((expiry.Date - DateTime.Now.Date).TotalDays);
            if (daysLeft < 0)
            {
                return (CertificateExpiryState.Expired, daysLeft);
            }
            if (daysLeft <= ExpiringSoonDays)
            {
                return (CertificateExpiryState.ExpiringSoon, daysLeft);
            }
            return (CertificateExpiryState.Valid, daysLeft);
        }

        return (CertificateExpiryState.Unknown, 0);
    }

    /// <summary>
    /// Date parsing for bridge-provided timestamps: invariant culture first
    /// (covers ISO 8601 and "yyyy-MM-dd HH:mm:ss"), current culture as the
    /// fallback. Any failure keeps the badge neutral.
    /// </summary>
    private static bool TryParseDate(string? text, out DateTime value)
    {
        value = default;
        if (string.IsNullOrWhiteSpace(text)) return false;

        return DateTime.TryParse(
                   text.Trim(),
                   CultureInfo.InvariantCulture,
                   DateTimeStyles.AllowWhiteSpaces | DateTimeStyles.AssumeLocal,
                   out value)
               || DateTime.TryParse(text.Trim(), out value);
    }

    private static Brush GetExpiryBrush(CertificateExpiryState state)
    {
        return state switch
        {
            CertificateExpiryState.Expired
                => TryGetThemeBrush("SystemFillColorCriticalBrush", Microsoft.UI.Colors.IndianRed),
            CertificateExpiryState.ExpiringSoon
                => TryGetThemeBrush("SystemFillColorCautionBrush", Microsoft.UI.Colors.DarkOrange),
            _ => TryGetThemeBrush("SystemFillColorNeutralBrush", Microsoft.UI.Colors.Gray),
        };
    }

    private static string FormatExpiryLabel(CertificateExpiryState state, int daysLeft)
    {
        return state switch
        {
            CertificateExpiryState.Expired => "Expired",
            CertificateExpiryState.ExpiringSoon
                => daysLeft == 0 ? "Expires today" : $"Expires in {daysLeft}d",
            CertificateExpiryState.Valid => "Valid",
            _ => "Unknown",
        };
    }

    /// <summary>Validity line "startDate → expireDate"; blanks render "--".</summary>
    private static string FormatValidityRange(string startDate, string expireDate)
    {
        var start = string.IsNullOrWhiteSpace(startDate) ? "--" : startDate.Trim();
        var expire = string.IsNullOrWhiteSpace(expireDate) ? "--" : expireDate.Trim();
        return $"{start} \u2192 {expire}";
    }

    /// <summary>
    /// Colored tag pill with a translucent tint of the accent so it stays
    /// readable over Mica/LayerFill in both themes.
    /// </summary>
    private static FrameworkElement CreatePill(string text, Brush accent)
    {
        var accentColor = GetBrushColor(accent, Microsoft.UI.Colors.Gray);

        return new Border
        {
            CornerRadius = new CornerRadius(10),
            Padding = new Thickness(10, 3, 10, 3),
            VerticalAlignment = VerticalAlignment.Center,
            Background = new SolidColorBrush(Microsoft.UI.ColorHelper.FromArgb(26, accentColor.R, accentColor.G, accentColor.B)),
            Child = new TextBlock
            {
                Text = text,
                FontSize = 12,
                Foreground = accent,
                VerticalAlignment = VerticalAlignment.Center,
            },
        };
    }

    /// <summary>
    /// Card shell shared by all cards: rounded border with a faint translucent
    /// tint of the theme card stroke plus a semi-bold title line. The caller
    /// fills <paramref name="panel"/> with the card body.
    /// </summary>
    private static FrameworkElement CreateCard(string title, out StackPanel panel)
    {
        var card = new Border
        {
            CornerRadius = new CornerRadius(8),
            Padding = new Thickness(16, 12, 16, 12),
            BorderBrush = TryGetThemeBrush("CardStrokeColorDefaultBrush", Microsoft.UI.Colors.Gray),
            BorderThickness = new Thickness(1),
            Background = CreateSubtleFill(),
        };

        panel = new StackPanel
        {
            Orientation = Orientation.Vertical,
            Spacing = 10,
        };

        panel.Children.Add(new TextBlock
        {
            Text = title,
            FontSize = 14,
            FontWeight = Microsoft.UI.Text.FontWeights.SemiBold,
        });

        card.Child = panel;
        return card;
    }

    /// <summary>
    /// InfoBag grid over a dynamic map: two label+value pairs per row with
    /// relative columns only. Blank values render "--", booleans render as
    /// Yes/No.
    /// </summary>
    private static Grid BuildInfoBag(JsonElement map)
    {
        var bag = new Grid();
        bag.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        bag.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
        bag.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(24) });
        bag.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        bag.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });

        var entries = new List<KeyValuePair<string, string>>();
        foreach (var property in EnumerateMapProperties(map))
        {
            entries.Add(new KeyValuePair<string, string>(property.Name, FormatScalar(property.Value)));
        }

        for (int i = 0; i < entries.Count; i += 2)
        {
            var rowIndex = bag.RowDefinitions.Count;
            bag.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
            AddInfoPair(bag, rowIndex, 0, entries[i].Key, entries[i].Value);
            if (i + 1 < entries.Count)
            {
                AddInfoPair(bag, rowIndex, 1, entries[i + 1].Key, entries[i + 1].Value);
            }
        }

        return bag;
    }

    /// <summary>
    /// Places one label+value pair into the InfoBag grid.
    /// <paramref name="pairIndex"/> 0 uses columns 0/1, 1 uses columns 3/4.
    /// Blank values render "--".
    /// </summary>
    private static void AddInfoPair(Grid bag, int row, int pairIndex, string label, string value)
    {
        var labelColumn = pairIndex == 0 ? 0 : 3;
        var valueColumn = pairIndex == 0 ? 1 : 4;

        var labelBlock = new TextBlock
        {
            Text = label,
            FontSize = 12,
            Foreground = TryGetThemeBrush("TextFillColorSecondaryBrush", Microsoft.UI.Colors.Gray),
            VerticalAlignment = VerticalAlignment.Top,
            Margin = new Thickness(0, 0, 12, 0),
        };
        Grid.SetRow(labelBlock, row);
        Grid.SetColumn(labelBlock, labelColumn);
        bag.Children.Add(labelBlock);

        var valueBlock = new TextBlock
        {
            Text = string.IsNullOrWhiteSpace(value) ? "--" : value,
            FontSize = 13,
            TextWrapping = TextWrapping.Wrap,
            TextTrimming = TextTrimming.CharacterEllipsis,
            VerticalAlignment = VerticalAlignment.Top,
            Margin = new Thickness(0, 0, 0, 8),
        };
        Grid.SetRow(valueBlock, row);
        Grid.SetColumn(valueBlock, valueColumn);
        bag.Children.Add(valueBlock);
    }

    /// <summary>
    /// Parses the website certificate array from the bridge. Returns null
    /// when the source is unavailable (not an array) so the card collapses;
    /// an empty array yields an empty list so the card can show its
    /// "no certificates" hint. Non-object entries are skipped.
    /// </summary>
    private static List<CertificateEntry>? ParseCertificates(JsonElement? element)
    {
        if (element == null || element.Value.ValueKind != JsonValueKind.Array)
        {
            return null;
        }

        var certificates = new List<CertificateEntry>();
        foreach (var item in element.Value.EnumerateArray())
        {
            if (item.ValueKind != JsonValueKind.Object) continue;

            certificates.Add(new CertificateEntry
            {
                Id = TryGetLong(item, "id"),
                PrimaryDomain = TryGetString(item, "primaryDomain") ?? "",
                Provider = TryGetString(item, "provider") ?? "",
                StartDate = TryGetString(item, "startDate") ?? "",
                ExpireDate = TryGetString(item, "expireDate") ?? "",
            });
        }

        return certificates;
    }

    /// <summary>
    /// Translucent card fill derived from the theme card stroke (~4% alpha)
    /// so cards read over Mica/LayerFill in both light and dark themes
    /// without an opaque background.
    /// </summary>
    private static Brush CreateSubtleFill()
    {
        var stroke = TryGetThemeBrush("CardStrokeColorDefaultBrush", Microsoft.UI.Colors.Gray);
        var color = GetBrushColor(stroke, Microsoft.UI.Colors.Gray);
        return new SolidColorBrush(Microsoft.UI.ColorHelper.FromArgb(10, color.R, color.G, color.B));
    }

    /// <summary>Scalar rendering for dynamic map values: strings pass through
    /// ("--" when blank), numbers use their raw text, booleans render as
    /// Yes/No, and nested arrays/objects fall back to their raw JSON text.</summary>
    private static string FormatScalar(JsonElement value)
    {
        switch (value.ValueKind)
        {
            case JsonValueKind.String:
                var text = value.GetString();
                return string.IsNullOrWhiteSpace(text) ? "--" : text.Trim();
            case JsonValueKind.Number:
                return value.GetRawText();
            case JsonValueKind.True:
                return "Yes";
            case JsonValueKind.False:
                return "No";
            case JsonValueKind.Array:
            case JsonValueKind.Object:
                return value.GetRawText();
            default:
                return "--";
        }
    }

    /// <summary>Returns the named object property, or a default (Undefined)
    /// element when absent or malformed. Callers guard on HasAnyProperty /
    /// EnumerateMapProperties, so an Undefined element simply collapses the
    /// card instead of being dereferenced.</summary>
    private static JsonElement GetMapProperty(JsonElement root, string property)
    {
        if (root.ValueKind == JsonValueKind.Object &&
            root.TryGetProperty(property, out var value) &&
            value.ValueKind == JsonValueKind.Object)
        {
            return value;
        }
        return default;
    }

    /// <summary>Enumerates the map as dynamic key/value pairs; safe on non-objects.</summary>
    private static IEnumerable<JsonProperty> EnumerateMapProperties(JsonElement map)
    {
        if (map.ValueKind != JsonValueKind.Object) yield break;

        using var enumerator = map.EnumerateObject();
        while (enumerator.MoveNext())
        {
            yield return enumerator.Current;
        }
    }

    private static bool HasAnyProperty(JsonElement json)
    {
        if (json.ValueKind != JsonValueKind.Object) return false;

        using var enumerator = json.EnumerateObject();
        return enumerator.MoveNext();
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

    private static long TryGetLong(JsonElement element, string property)
    {
        if (element.ValueKind == JsonValueKind.Object &&
            element.TryGetProperty(property, out var prop) &&
            prop.ValueKind == JsonValueKind.Number &&
            prop.TryGetInt64(out var value))
        {
            return value;
        }
        return -1;
    }

    private static Brush TryGetThemeBrush(string key, Color fallback)
    {
        if (Application.Current.Resources.TryGetValue(key, out var value) && value is Brush brush)
        {
            return brush;
        }
        return new SolidColorBrush(fallback);
    }

    private static Color GetBrushColor(Brush brush, Color fallback)
        => brush is SolidColorBrush solid ? solid.Color : fallback;
}

/// <summary>Immutable view over one website certificate from the bridge.</summary>
internal sealed class CertificateEntry
{
    public long Id { get; set; } = -1;
    public string PrimaryDomain { get; set; } = "";
    public string Provider { get; set; } = "";
    public string StartDate { get; set; } = "";
    public string ExpireDate { get; set; } = "";
}
