# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

COPY TaskManagerAPI/TaskManagerAPI.csproj ./TaskManagerAPI/
RUN dotnet restore ./TaskManagerAPI/TaskManagerAPI.csproj

COPY . .
WORKDIR /src/TaskManagerAPI
RUN dotnet publish -c Release -o /app/publish

# Stage 2 - Runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "TaskManagerAPI.dll"]
