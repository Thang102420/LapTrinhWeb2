using APIdemo.Data;
using APIdemo.DTOs;
using APIdemo.Models;
using HouseRentalAPI.DTOs;
using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;
using System.Text;

namespace APIdemo.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly AppDbContext _db;

        public UsersController(AppDbContext db)
        {
            _db = db;
        }

        // GET: api/Users
        [HttpGet]
        public IActionResult GetAll()
        {
            var users = _db.Users
                .Select(u => new UsersDTO.UserResponseDto
                {
                    Id = u.Id,
                    Username = u.Username,
                    Email = u.Email,
                    Role = u.Role,
                    CreatedAt = u.CreatedAt
                })
                .ToList();

            return Ok(users);
        }

        // GET: api/Users/1
        [HttpGet("{id:int}")]
        public IActionResult GetById(int id)
        {
            var user = _db.Users
                .Where(u => u.Id == id)
                .Select(u => new UsersDTO.UserResponseDto
                {
                    Id = u.Id,
                    Username = u.Username,
                    Email = u.Email,
                    Role = u.Role,
                    CreatedAt = u.CreatedAt
                })
                .FirstOrDefault();

            if (user == null)
                return NotFound(new { message = "Không tìm thấy User." });

            return Ok(user);
        }

        // POST: api/Users/register
        [HttpPost("register")]
        public IActionResult Register(UsersDTO.UserRegisterDto dto)
        {
            if (_db.Users.Any(u => u.Username == dto.Username))
                return BadRequest(new { message = "Username đã tồn tại." });

            if (_db.Users.Any(u => u.Email == dto.Email))
                return BadRequest(new { message = "Email đã tồn tại." });

            CreatePasswordHash(
                dto.Password,
                out byte[] hash,
                out byte[] salt);

            var user = new User
            {
                Username = dto.Username,
                Email = dto.Email,
                PasswordHash = hash,
                PasswordSalt = salt,
                Role = "Tenant",
                CreatedAt = DateTime.UtcNow
            };

            _db.Users.Add(user);
            _db.SaveChanges();

            return CreatedAtAction(
                nameof(GetById),
                new { id = user.Id },
                new UsersDTO.UserResponseDto
                {
                    Id = user.Id,
                    Username = user.Username,
                    Email = user.Email,
                    Role = user.Role,
                    CreatedAt = user.CreatedAt
                });
        }

        // POST: api/Users/login
        [HttpPost("login")]
        public IActionResult Login(UsersDTO.UserLoginDto dto)
        {
            var user = _db.Users
                .FirstOrDefault(u => u.Username == dto.Username);

            if (user == null ||
                !VerifyPasswordHash(
                    dto.Password,
                    user.PasswordHash,
                    user.PasswordSalt))
            {
                return Unauthorized(new
                {
                    message = "Username hoặc Password không chính xác."
                });
            }

            return Ok(new UsersDTO.UserResponseDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                Role = user.Role,
                CreatedAt = user.CreatedAt
            });
        }

        // PUT: api/Users/1
        [HttpPut("{id:int}")]
        public IActionResult Update(
            int id,
            [FromBody] UsersDTO.UserRegisterDto request)
        {
            var user = _db.Users.FirstOrDefault(u => u.Id == id);

            if (user == null)
                return NotFound(new
                {
                    message = $"Không tìm thấy người dùng có Id = {id}"
                });

            if (!string.IsNullOrEmpty(request.Username))
                user.Username = request.Username;

            if (!string.IsNullOrEmpty(request.Email))
                user.Email = request.Email;

            if (!string.IsNullOrEmpty(request.Password))
            {
                CreatePasswordHash(
                    request.Password,
                    out byte[] passwordHash,
                    out byte[] passwordSalt);

                user.PasswordHash = passwordHash;
                user.PasswordSalt = passwordSalt;
            }

            _db.SaveChanges();

            return Ok(new
            {
                message = $"Cập nhật thành công người dùng Id = {id}"
            });
        }

        // DELETE: api/Users/1
        [HttpDelete("{id:int}")]
        public IActionResult Delete(int id)
        {
            var user = _db.Users.FirstOrDefault(u => u.Id == id);

            if (user == null)
                return NotFound(new
                {
                    message = $"Không tìm thấy người dùng có Id = {id}"
                });

            _db.Users.Remove(user);
            _db.SaveChanges();

            return Ok(new
            {
                message = $"Đã xóa người dùng Id = {id}"
            });
        }

        private void CreatePasswordHash(
            string password,
            out byte[] hash,
            out byte[] salt)
        {
            using var hmac = new HMACSHA512();

            salt = hmac.Key;
            hash = hmac.ComputeHash(
                Encoding.UTF8.GetBytes(password));
        }

        private bool VerifyPasswordHash(
            string password,
            byte[] hash,
            byte[] salt)
        {
            using var hmac = new HMACSHA512(salt);

            return hmac.ComputeHash(
                Encoding.UTF8.GetBytes(password))
                .SequenceEqual(hash);
        }
    }
}