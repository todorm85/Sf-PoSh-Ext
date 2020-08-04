namespace SitefinityWebApp.SfDevExt
{
    public class Localization
    {
        public void Multi()
        {
            (new Telerik.Sitefinity.TestUI.Arrangements.SetupSitefinityForMultilingual()).EnableLocalization();
        }

        public void Mono()
        {
            (new Telerik.Sitefinity.TestUI.Arrangements.SetupSitefinityForMultilingual()).DisableLocalization();
        }
    }
}