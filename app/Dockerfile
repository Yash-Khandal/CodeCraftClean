# Build stage
WORKDIR /src
COPY TaskManagerAPI/TaskManagerAPI.csproj .
RUN dotnet restore TaskManagerAPI.csproj
COPY . .

RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "TaskManagerAPI.dll"]
