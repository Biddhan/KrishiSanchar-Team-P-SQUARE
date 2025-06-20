﻿namespace KrishiSancharCore.UserFeatures;

public class UserCreateDto
{
    public string FullName { get; set; }
    public string Username { get; set; }
    public string Password { get; set; }
    public string PasswordHash { get; set; }
    public string Email { get; set; }
    public string PhoneNumber { get; set; }
    public string Address { get; set; }
}