# -- Urls:
# DockerHub:                   https://hub.docker.com/r/microsoft/dotnet-sdk
# Microsoft Artifact Registry: https://mcr.microsoft.com/en-us/product/dotnet/sdk/about

# -- GIT clone
# git clone --branch helloworld --depth 1 https://github.com/lihnjo/uniqa-helloworld

# -- Build
# docker build --no-cache -t helloworld:latest .

# -- Run
# docker run --rm -p 127.0.0.1:8080:8080 helloworld

# -- Url
# -- http://127.0.0.1:8080


# Use the .NET SDK to build and run the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project file and restore dependencies
COPY SimpleDotNetWebApp/*.csproj ./
RUN dotnet restore

# Copy the rest of the application files
COPY SimpleDotNetWebApp/ ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the ASP.NET runtime to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Expose the port the app will run on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["dotnet", "SimpleDotNetWebApp.dll"]
