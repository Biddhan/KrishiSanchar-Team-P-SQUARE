using KrishiSancharDataAccess.Converter;

namespace KrishiSancharCore.UserFeatures.UserEnums;

public class UserRoleEnum : Enumeration
{
    public static readonly UserRoleEnum Admin = new(1, nameof(Admin));
    public static readonly UserRoleEnum General = new(2, nameof(General));
    public static readonly UserRoleEnum Expert = new(2, nameof(Expert));

    private UserRoleEnum(int id, string name) : base(id, name)
    {
    }
}