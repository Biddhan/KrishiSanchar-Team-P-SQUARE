using KrishiSancharCore.UserFeatures.UserEnums;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace KrishiSancharDataAccess.Converter;

public class UserStatusEnumConverter : ValueConverter<UserStatusEnum, string>
{
    public UserStatusEnumConverter()
        : base(
            userStatus => userStatus.Name,
            name => Enumeration.GetAll<UserStatusEnum>().FirstOrDefault(t => t.Name == name) 
        )
    {
    }
}