<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="Telerik.Sitefinity.TestArrangementService.Core" %>
<%@ Import Namespace="Telerik.Sitefinity.TestUtilities.CommonOperations" %>
<%@ Import Namespace="Telerik.Sitefinity.Services" %>

<asp:Button runat="server" Text="Create ML site" OnClick="CreateMLSiteClick" />
<asp:Button runat="server" Text="Remove ML site" OnClick="DeleteMlSiteClick" />
ML site status:
            <asp:Literal runat="server" ID="mlSiteStatusLiteral"></asp:Literal>

<script runat="server">
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        var site = SystemManager.CurrentContext.GetSites().FirstOrDefault(x => x.Name == ArrangementConfig.GetArrangementSite());
        this.mlSiteStatusLiteral.Text = site != null ? "Enabled" : "Disabled";
    }


    protected void CreateMLSiteClick(object sender, EventArgs e)
    {
        (new Telerik.Sitefinity.TestUI.Arrangements.SetupSitefinityForMultisiteMultilingual()).CreateMultilingualSite();
        var siteName = ArrangementConfig.GetArrangementSite();
        var site = SystemManager.CurrentContext.GetSites().First(x => x.Name == siteName);
        SystemManager.CurrentContext.MultisiteContext.ChangeCurrentSite(site, Telerik.Sitefinity.Multisite.SiteContextResolutionTypes.ExplicitlySet);
        var siteId = site.Id;
        ServerOperations.MultiSite().SetSiteUrl(siteId, this.Request.Url.Authority);
    }

    protected void DeleteMlSiteClick(object sender, EventArgs e)
    {
        (new Telerik.Sitefinity.TestUI.Arrangements.SetupSitefinityForMultisiteMultilingual()).DeleteSite();
    }


</script>
