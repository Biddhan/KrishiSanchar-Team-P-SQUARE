using KrishiSancharCore.UserFeatures.UserEnums;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace KrishiSancharDataAccess.Converter;

public class UserRoleEnumConverter : ValueConverter<UserRoleEnum, string>
{
    public UserRoleEnumConverter()
        : base(
            userStatus => userStatus.Name,
            name => Enumeration.GetAll<UserRoleEnum>().FirstOrDefault(t => t.Name == name)
        )
    {
    }
}