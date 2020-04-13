<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="Telerik.Sitefinity.Abstractions" %>
<%@ Import Namespace="SitefinityWebApp.SfDevExt" %>

<asp:Button runat="server" Text="Enable localization" OnClick="EnableLocalizationClick" />
            <asp:Button runat="server" Text="Disable localization" OnClick="DisableLocalizationClick" />
            Localization status:
            <asp:Literal runat="server" ID="localizationStatusLiteral"></asp:Literal>

<script runat="server">
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);

        this.localizationStatusLiteral.Text = AppSettings.CurrentSettings.DefinedFrontendLanguages.Count() > 1 ? "Enabled" : "Disabled";
    }
    
    protected void EnableLocalizationClick(object sender, EventArgs e)
    {
        (new Telerik.Sitefinity.TestUI.Arrangements.SetupSitefinityForMultilingual()).EnableLocalization();
    }

    protected void DisableLocalizationClick(object sender, EventArgs e)
    {
        (new Telerik.Sitefinity.TestUI.Arrangements.SetupSitefinityForMultilingual()).DisableLocalization();
    }

</script>
