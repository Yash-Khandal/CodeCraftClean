# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY TaskManagerAPI/TaskManagerAPI.csproj TaskManagerAPI/
WORKDIR /src/TaskManagerAPI
RUN dotnet restore TaskManagerAPI.csproj

# Copy the entire source code
COPY TaskManagerAPI/. .

# Build the application
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Run
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Run the app
ENTRYPOINT ["dotnet", "TaskManagerAPI.dll"]
