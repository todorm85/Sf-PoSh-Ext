<%@ Control Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="SitefinityWebApp.SfDevExt" %>

Arrangement class:
<asp:TextBox runat="server" ID="arngTp" Text="Telerik.Sitefinity.TestUI.Arrangements., Telerik.Sitefinity.TestUI.Arrangements" Width="1200px"></asp:TextBox>
<br />
<asp:Button runat="server" Text="ServerSetup" OnClick="ServerSetupClick" />
<asp:Button runat="server" Text="ServerTearDown" OnClick="OnServerTearDownClick" />

<script runat="server">
    protected void ServerSetupClick(object sender, EventArgs e)
    {
        CallMethodWithAttribute("Telerik.Sitefinity.TestArrangementService.Attributes.ServerSetUpAttribute, Telerik.Sitefinity.TestArrangementService.Attributes", this.arngTp.Text);
    }

    protected void OnServerTearDownClick(object sender, EventArgs e)
    {
        CallMethodWithAttribute("Telerik.Sitefinity.TestArrangementService.Attributes.ServerTearDownAttribute, Telerik.Sitefinity.TestArrangementService.Attributes", this.arngTp.Text);
    }

    private void CallMethodWithAttribute(string attributeTypeName, string instanceTypeName)
    {
        var attributeType = Type.GetType(attributeTypeName, true);
        var instanceType = Type.GetType(instanceTypeName, true);
        var setupMethod = instanceType.GetMethods().First(m => m.CustomAttributes.Any(a => a.AttributeType == attributeType));
        var instance = Activator.CreateInstance(instanceType);
        setupMethod.Invoke(instance, new object[0]);
    }
</script>
