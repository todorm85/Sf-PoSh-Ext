<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Register Src="controls/IrisToggle.ascx" TagName="IrisToggle" TagPrefix="sfdev" %>
<%@ Register Src="controls/Localization.ascx" TagName="Localization" TagPrefix="sfdev" %>
<%@ Register Src="controls/SecondSite.ascx" TagName="SecondSite" TagPrefix="sfdev" %>
<%@ Register Src="controls/UiTestsArrangementExecutor.ascx" TagName="UiTestsArrangementExecutor" TagPrefix="sfdev" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <sfdev:Localization runat="server" />
            <br />
            <sfdev:SecondSite runat="server" />
            <br />
            <sfdev:IrisToggle runat="server" />

            <div style="padding: 15px 0px">
                <a href="../Sitefinity">Go to backend</a>
            </div>

            <sfdev:UiTestsArrangementExecutor runat="server" />
            
        </div>
    </form>
</body>
</html>
