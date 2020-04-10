<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="SitefinityWebApp.App_Code" %>

<asp:Button runat="server" Text="Toggle iris" OnClick="ToggleIrisClick" />
Iris status:
<asp:Literal runat="server" ID="irisStatusLiteral"></asp:Literal>
<script runat="server">
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);

        var irisStatus = UnrestrictedBackendServicesClient.SendRequest("GET", "/RestApi/adminapp/backend-status").Content.ReadAsString();
        this.irisStatusLiteral.Text = irisStatus.Contains("true") ? "Enabled" : "Disbled";
    }

    protected void ToggleIrisClick(object sender, EventArgs e)
    {
        UnrestrictedBackendServicesClient.SendRequest("PUT", "/RestApi/adminapp/toggle-backend");
    }

</script>
