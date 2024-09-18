# Download source code, build and run application from docker image #

<br>

**GIT Clone**
```bash
git clone --branch helloworld --depth 1 https://github.com/lihnjo/uniqa-helloworld
```
<br>

**cd to directory**
```bash
cd helloworld
```
<br>

**Build**
```bash
docker build --no-cache -t helloworld:latest .
```

```
+] Building 9.2s (15/15) FINISHED                                                                                          docker:default
 => [internal] load build definition from Dockerfile                                                                                 0.0s
 => => transferring dockerfile: 1.15kB                                                                                               0.0s
 => [internal] load metadata for mcr.microsoft.com/dotnet/aspnet:8.0                                                                 0.5s
 => [internal] load metadata for mcr.microsoft.com/dotnet/sdk:8.0                                                                    0.0s
 => [internal] load .dockerignore                                                                                                    0.0s
 => => transferring context: 2B                                                                                                      0.0s
 => [build 1/6] FROM mcr.microsoft.com/dotnet/sdk:8.0                                                                                0.0s
 => [runtime 1/3] FROM mcr.microsoft.com/dotnet/aspnet:8.0@sha256:84a93198d134a82a8f41c88b96adc6bfc2caf1d91ad25d5f25d90279938e1c4d   0.0s
 => [internal] load build context                                                                                                    0.0s
 => => transferring context: 810B                                                                                                    0.0s
 => CACHED [runtime 2/3] WORKDIR /app                                                                                                0.0s
 => CACHED [build 2/6] WORKDIR /app                                                                                                  0.0s
 => [build 3/6] COPY SimpleDotNetWebApp/*.csproj ./                                                                                  0.1s
 => [build 4/6] RUN dotnet restore                                                                                                   2.1s
 => [build 5/6] COPY SimpleDotNetWebApp/ ./                                                                                          0.2s 
 => [build 6/6] RUN dotnet publish -c Release -o out                                                                                 5.5s 
 => [runtime 3/3] COPY --from=build /app/out .                                                                                       0.2s 
 => exporting to image                                                                                                               0.2s 
 => => exporting layers                                                                                                              0.1s 
 => => writing image sha256:f6d5d07b416aaf10ece85a2743db2850865c11b757265fec90d95d618311ab83                                         0.0s
 => => naming to docker.io/library/helloworld:latest                                                                                 0.0s
```
<br>

**Run**
```bash
docker run --rm -p 127.0.0.1:8080:8080 helloworld:latest
```

```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://[::]:8080
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /app
```
<br>

**Open in your Internet browser**
- http://127.0.0.1:8080
<br>

**List docker images**
```bash
docker image ls
# or
docker images
```
```
REPOSITORY                     TAG            IMAGE ID       CREATED             SIZE
helloworld                     latest         f6d5d07b416a   6 minutes ago       217MB
```
