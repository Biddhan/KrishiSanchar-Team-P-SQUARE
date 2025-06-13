using KrishiSancharDataAccess.Converter;

namespace KrishiSancharCore.UserFeatures.UserEnums;

public class UserStatusEnum : Enumeration
{
    public static readonly UserStatusEnum Active = new(1, nameof(Active));
    public static readonly UserStatusEnum InActive = new(2, nameof(InActive));

    private UserStatusEnum(int id, string name) : base(id, name)
    {
    }
}