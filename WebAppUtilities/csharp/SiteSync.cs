using Telerik.Sitefinity.Configuration;
using Telerik.Sitefinity.Security;
using Telerik.Sitefinity.SiteSync.Configuration;
using Telerik.Sitefinity.TestIntegration.Helpers;
using Telerik.Sitefinity.TestIntegration.Modules.SiteSync;
using Telerik.Sitefinity.TestUtilities.CommonOperations;

namespace SitefinityWebApp.SfDevExt
{
    public class SiteSync
    {
        private const string UserName = "sync@test.test";
        private ConfigManager manager = ConfigManager.GetManager();
        private SiteSyncConfig config;

        public SiteSync()
        {
            this.config = this.manager.GetSection<SiteSyncConfig>();
        }

        public void SetupDestination()
        {
            SiteSyncIntegrationTestsHelper.EnsureSiteSyncModuleEnabled();
            if (UserManager.GetManager().GetUser(UserName) == null)
            {
                new CreateUserRegion(UserName, "Administrators");
            }

            ServerOperations.SiteSync().AllowPublishContentFromOtherSites(true);
        }

        public void SetupSrc(string url)
        {
            SiteSyncIntegrationTestsHelper.EnsureSiteSyncModuleEnabled();
            ServerOperations.SiteSync().AddSiteSyncReceivingServer(System.Web.HttpUtility.UrlDecode(url), UserName, CreateUserRegion.Password);
        }

        public void Sync(string types)
        {
            var parsedTypes = types.Split(',');
            ServerOperations.SiteSync().Sync(parsedTypes);
        }

        public string GetTargetUrl()
        {
            foreach (SiteSyncServerConfigElement item in this.config.ReceivingServers)
            {
                return item.ServerAddress;
            }

            return "";
        }

        public void Uninstall()
        {
            Config.UpdateSection<SiteSyncConfig>(config =>
            {
                var servers = config.ReceivingServers;
                servers.Clear();
            });
        }

        private void SaveChanges()
        {
            this.manager.SaveSection(this.config);
        }
    }
}