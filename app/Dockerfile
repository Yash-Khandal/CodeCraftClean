# Use .NET SDK for building the project
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

WORKDIR /src

# Copy and restore project dependencies
COPY TaskManagerAPI/TaskManagerAPI.csproj ./TaskManagerAPI/

RUN dotnet restore TaskManagerAPI.csproj

# Copy the full source and build
COPY . .
RUN dotnet build TaskManagerAPI.csproj -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish TaskManagerAPI.csproj -c Release -o /app/publish

# Final image using the ASP.NET runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final

WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["dotnet", "TaskManagerAPI.dll"]
