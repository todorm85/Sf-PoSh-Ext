using System;
using Telerik.Sitefinity.TestIntegration.Helpers;

namespace SitefinityWebApp
{
    public class Users
    {
        public void Seed(string email, string roles)
        {
            var rolesCol = roles.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            new CreateUserRegion(email, rolesCol);
        }
    }
}