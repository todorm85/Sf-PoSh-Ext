using Telerik.Sitefinity.Configuration;
using Telerik.Sitefinity.LoadBalancing.Configuration;
using Telerik.Sitefinity.Services;

namespace SitefinityWebApp.App_Code
{
    public class NlbSetup
    {
        private ConfigManager manager = ConfigManager.GetManager();
        private SystemConfig config;

        public NlbSetup()
        {
            this.config = this.manager.GetSection<SystemConfig>();
        }

        public void AddNode(string port)
        {
            var address = "http://localhost:" + port;
            var urls = this.config.LoadBalancingConfig.URLS;
            if (urls.Contains(address))
            {
                return;
            }

            urls.Add(new InstanceUrlConfigElement(urls)
            {
                Value = address
            });

            this.SaveChanges();
        }

        public void SetSslOffload(string value)
        {
            this.config.SslOffloadingSettings.EnableSslOffloading = bool.Parse(value);
            this.SaveChanges();
        }

        private void SaveChanges()
        {
            this.manager.SaveSection(this.config, true);
        }
    }
}