﻿namespace KrishiSancharCore.UserFeatures;

public class UserUpdateDto
{
    public int Id { get; set; }
    public string FullName { get; set; }
    public string Address { get; set; }
    public string PhoneNumber { get; set; }
    public string Email { get; set; }
}