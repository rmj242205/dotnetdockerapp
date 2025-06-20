# Dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["DotnetDockerCICDApp.csproj", "./"]
RUN dotnet restore "./DotnetDockerCICDApp.csproj"
COPY . .
RUN dotnet build "DotnetDockerCICDApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotnetDockerCICDApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DotnetDockerCICDApp.dll"]