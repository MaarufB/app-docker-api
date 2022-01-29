FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["app-docker-api.csproj", "./"]
RUN dotnet restore "app-docker-api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "app-docker-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "app-docker-api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "app-docker-api.dll"]
