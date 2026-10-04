using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace APIdemo.Models
{
    public class User
    {
            [Key]
            [DatabaseGenerated(DatabaseGeneratedOption.Identity)] // Id tự tăng (1, 2, 3...)
            public int Id { get; set; }

            [Required]
            [MaxLength(50)] // Giới hạn độ dài chuỗi để tránh cột nvarchar(MAX)
            public string Username { get; set; } = string.Empty;

            [Required]
            [MaxLength(100)]
            [EmailAddress]
            public string Email { get; set; } = string.Empty;

            [Required]
            public byte[] PasswordHash { get; set; } = Array.Empty<byte>();

            [Required]
            public byte[] PasswordSalt { get; set; } = Array.Empty<byte>();

            [Required]
            [MaxLength(20)]
            public string Role { get; set; } = "User";

            [Required]
            public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        }
}
