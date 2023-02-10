# Here, we include the dotnet core SDK as the base to build our app
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["My_Site.csproj", "."]
RUN dotnet restore "My_Site.csproj"
COPY . .
RUN dotnet build "My_Site.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "My_Site.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "My_Site.dll"]