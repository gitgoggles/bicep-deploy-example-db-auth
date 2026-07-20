using CoolWebApp.Models;
using Microsoft.EntityFrameworkCore;

namespace CoolWebApp.Data;

public sealed class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
	public DbSet<Product> Products => Set<Product>();
}
