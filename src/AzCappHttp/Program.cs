var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => $"[{DateTime.UtcNow}] Hello from HTTP Container App!");

app.Run();
