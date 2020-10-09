namespace SitefinityWebApp.SfDev
{
    public class Settings
    {
        public void BasicAuthSet(string enabled)
        {
            UnrestrictedBackendServicesClient.SetBasicAuth(enabled.ToLower() == "true");
        }
    }
}