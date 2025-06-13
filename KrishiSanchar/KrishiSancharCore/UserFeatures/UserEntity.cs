using KrishiSancharCore.UserFeatures.UserEnums;

namespace KrishiSancharCore.UserFeatures;

 public class UserEntity
    {
        protected UserEntity()
        {
        }

        public UserEntity(string fullname, string username, string passwordHash, string email, string phoneNumber,
            string address)
        {
            this.FullName = fullname;
            this.UserName = username;
            this.PasswordHash = passwordHash;
            this.Email = email;
            this.PhoneNumber = phoneNumber;
            this.Address = address;
            CreatedDate = DateOnly.FromDateTime(DateTime.Now);
            CreatedTime = TimeOnly.FromDateTime(DateTime.Now);
            Status = UserStatusEnum.InActive;
            Token = Guid.NewGuid().ToString();
        }

        public UserEntity(int id, string fullname, string username, string passwordHash, string email,
            string phoneNumber, string address) : this(fullname, username, passwordHash, email, phoneNumber, address)
        {
            this.Id = id;
        }

        public int Id { get; protected set; }
        public string FullName { get; set; }
        public string UserName { get; set; }
        public string PasswordHash { get; set; }
        public string? Email { get; set; }
        public string PhoneNumber { get; set; }
        public string Address { get; set; }

        public DateOnly CreatedDate { get; set; }
        public TimeOnly CreatedTime { get; set; }
        public DateOnly? UpdatedDate { get; set; } = null;
        public TimeOnly? UpdatedTime { get; set; } = null;
        public string Token { get; private set; }
        public bool IsVerified { get; set; } = false;

        public UserStatusEnum Status { get; set; }
        public UserRoleEnum Role { get; set; } = UserRoleEnum.General;

        public void Activate()
        {
            Status = UserStatusEnum.Active;
        }

        public void Deactivate()
        {
            Status = UserStatusEnum.InActive;
        }

        public bool IsActive()
        {
            return Status == UserStatusEnum.Active;
        }

        public void UpdateTimeStamp()
        {
            UpdatedDate = DateOnly.FromDateTime(DateTime.Now);
            UpdatedTime = TimeOnly.FromDateTime(DateTime.Now);
        }

        public void RegenerateToken()
        {
            IsVerified = false;
            Token = Guid.NewGuid().ToString();
        }

        public void VerifyUser()
        {
            if (IsVerified == true)
            {
                Token = String.Empty;
                Activate();
            }
        }
    }