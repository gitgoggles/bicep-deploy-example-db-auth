using Microsoft.AspNetCore.Http.HttpResults;
using CoolWebApp.Components;
using CoolWebApp.Models;
using System.Globalization;
using Microsoft.AspNetCore.Localization;
using Microsoft.EntityFrameworkCore;
using CoolWebApp.Data;
using Microsoft.AspNetCore.Mvc;

var enGb = CultureInfo.GetCultureInfo("en-GB");

CultureInfo.DefaultThreadCurrentCulture = enGb;
CultureInfo.DefaultThreadCurrentUICulture = enGb;

var builder = WebApplication.CreateBuilder(args);

var connectionString =
	   builder.Configuration.GetConnectionString("DefaultConnection")
	   ?? throw new InvalidOperationException(
		   "Connection string 'DefaultConnection' was not configured.");

builder.Services.AddDbContext<AppDbContext>(options =>
		options.UseSqlServer(connectionString));

builder.Services.AddRazorComponents();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
	var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
	db.Database.Migrate();
}

if (!app.Environment.IsDevelopment())
{
	app.UseExceptionHandler("/Error");
}

app.UseRequestLocalization(new RequestLocalizationOptions
{
	DefaultRequestCulture = new RequestCulture(enGb),
	SupportedCultures = [enGb],
	SupportedUICultures = [enGb]
});

app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<App>();

app.MapGet("/api/products/table", async (AppDbContext db, CancellationToken ct) =>
{
	var products = await db.Products
	.AsNoTracking()
	.OrderBy(product => product.Id)
	.ToListAsync(ct);

	return new RazorComponentResult<ProductTable>(new { Products = products });
});

app.MapPost("/api/products", async (
			[FromForm] string name,
			[FromForm] string category,
			[FromForm] long price,
			[FromForm] int stock,
			AppDbContext db
			) =>
{
	var product = new Product { Name = name.Trim(), Category = category.Trim(), Price = price, Stock = stock };

	db.Products.Add(product);
	await db.SaveChangesAsync();

	return new RazorComponentResult<ProductRow>(new { Product = product });

});

app.Run();
