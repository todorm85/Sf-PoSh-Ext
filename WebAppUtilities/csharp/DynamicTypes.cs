using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Telerik.Sitefinity.Services;
using Telerik.Sitefinity.TestUtilities.CommonOperations;

namespace SitefinityWebApp.SfDevExt
{
    public class DynamicModule
    {
        private const string ModuleName = "ParentChildModule";
        private const string ModulePath = "Telerik.Sitefinity.TestIntegration.Data.ModuleBuilder.ParentChildModule.zip";
        private const string ChildTypeName = "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Childtype";
        private const string ParentTypeName = "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Parenttype";
        private const string FlatTypeName = "Telerik.Sitefinity.DynamicTypes.Model.ParentChildModule.Flat";

        public void Install()
        {
            ServerOperations.DynamicTypes().ActivateDynamicModule(ModuleName, ModulePath);
        }

        public void Seed(string parentsCountRaw, string childrenCountRaw)
        {
            this.Install();
            var parentsCount = int.Parse(parentsCountRaw);
            var childrenCount = int.Parse(childrenCountRaw);

            var culture = SystemManager.CurrentContext.AppSettings.CurrentCulture.Name;

            for (int i = 0; i < parentsCount; i++)
            {
                string firstParentUrlName = "parent_" + Guid.NewGuid().ToString().Split('-')[0];
                string flatParentUrlName = "flat_item_" + Guid.NewGuid().ToString().Split('-')[0];
                Guid firstParentId = ServerOperations.DynamicTypes().CreateParentType(firstParentUrlName, firstParentUrlName, culture);
                ServerOperations.DynamicTypes().CreateFlatItem(firstParentUrlName, firstParentUrlName, culture);
                for (int j = 0; j < childrenCount; j++)
                {
                    string childUrlName = "child_" + Guid.NewGuid().ToString().Split('-')[0];
                    Guid firstChildId = ServerOperations.DynamicTypes().CreateChildТype(childUrlName, childUrlName, culture, firstParentId);
                }
            }
        }

        public void Uninstall()
        {
            ServerOperations.DynamicTypes().UninstallDynamicModule(ModuleName);
        }
    }
}