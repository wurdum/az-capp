FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5555
ENV ASPNETCORE_URLS=http://+:5555

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Directory.Build.props", ".editorconfig", "./"]
COPY ["src/AzCappHttp/AzCappHttp.csproj", "./src/AzCappHttp/"]
RUN dotnet restore "src/AzCappHttp/AzCappHttp.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "src/AzCappHttp/AzCappHttp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "src/AzCappHttp/AzCappHttp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN adduser wu
USER wu
ENTRYPOINT ["dotnet", "AzCappHttp.dll"]
