using System.ComponentModel.DataAnnotations;

namespace APIdemo.DTOs
{
    // DTO for creating/updating a rental property
    public class PropertyDto
    {
        [Required]
        public string Title { get; set; } = null!;

        public string? Description { get; set; }

        public string? Address { get; set; }

        [Range(0, double.MaxValue)]
        public decimal PricePerMonth { get; set; }

        [Range(0, int.MaxValue)]
        public int Bedrooms { get; set; }

        [Range(0, int.MaxValue)]
        public int Bathrooms { get; set; }

        [Range(0, double.MaxValue)]
        public double? Area { get; set; }

        public bool IsAvailable { get; set; } = true;
    }
}
