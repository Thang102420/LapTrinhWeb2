using System;
using System.ComponentModel.DataAnnotations;

namespace HouseRentalAPI.DTOs
{
    // Class chứa các DTO liên quan đến Users
    public class UsersDTO
    {
        // DTO dùng khi đăng ký tài khoản
        public class UserRegisterDto
        {
            // Email bắt buộc và phải đúng định dạng email
            [Required, EmailAddress]
            public string Email { get; set; } = string.Empty;

            // Username bắt buộc và tối thiểu 3 ký tự
            [Required, MinLength(3)]
            public string Username { get; set; } = string.Empty;

            // Password bắt buộc và tối thiểu 6 ký tự
            [Required, MinLength(6)]
            public string Password { get; set; } = string.Empty;
        }

        // DTO dùng khi đăng nhập
        public class UserLoginDto
        {
            // Username bắt buộc nhập
            [Required]
            public string Username { get; set; } = string.Empty;

            // Password bắt buộc nhập
            [Required]
            public string Password { get; set; } = string.Empty;
        }

        // DTO trả dữ liệu User về Front-end
        // Không chứa PasswordHash và PasswordSalt
        public class UserResponseDto
        {
            // ID của User
            public int Id { get; set; }

            // Họ và tên
            public string? FullName { get; set; }

            // Username
            public string Username { get; set; } = string.Empty;

            // Email
            public string Email { get; set; } = string.Empty;

            // Vai trò
            public string Role { get; set; } = string.Empty;

            // Thời gian tạo tài khoản
            public DateTime CreatedAt { get; set; }
        }
    }
}