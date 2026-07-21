namespace CoolWebApp.Models;

public sealed record Product(
	int Id,
	string Name,
	string Category,
	long Price,
	int Stock);
