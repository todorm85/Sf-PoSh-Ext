using SitefinityWebApp.App_Code;

namespace SitefinityWebApp
{
    public class Settings
    {
        public void BasicAuthSet(string enabled)
        {
            UnrestrictedBackendServicesClient.SetBasicAuth(enabled.ToLower() == "true");
        }
    }
}