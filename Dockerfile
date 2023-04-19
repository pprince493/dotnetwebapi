FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["dotnet webapi.csproj", "."]
RUN dotnet restore "./dotnet webapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dotnet webapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnet webapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnet webapi.dll"]