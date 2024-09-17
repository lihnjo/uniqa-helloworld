using System.Net;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () =>
{
    // Get the hostname
    string hostname = Dns.GetHostName();
    return $"Hello, World! Running on host: {hostname}";
});

app.Run();

