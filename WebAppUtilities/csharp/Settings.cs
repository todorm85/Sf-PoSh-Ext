using SitefinityWebApp.App_Code;

namespace SitefinityWebApp.SfDevExt
{
    public class Settings
    {
        public void BasicAuthSet(string enabled)
        {
            UnrestrictedBackendServicesClient.SetBasicAuth(enabled.ToLower() == "true");
        }
    }
}