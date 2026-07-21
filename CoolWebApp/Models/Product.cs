namespace CoolWebApp.Models;

public sealed class Product
{
	public int Id { get; set; }
	public required string Name { get; set; }
	public required string Category { get; set; }
	public required long Price { get; set; }
	public required int Stock { get; set; }
};
