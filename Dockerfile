FROM mcr.microsoft.com/dotnet/core/runtime:2.2-stretch-slim AS base
WORKDIR /github/workspace

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY . .
RUN dotnet restore "source/Action.Releasemail/Action.Releasemail.csproj" 
COPY . .

RUN dotnet build "source/Action.Releasemail/Action.Releasemail.csproj" -c Release -o /app -nologo -clp:nosummary -v:m 

FROM build AS publish
RUN dotnet publish "source/Action.Releasemail/Action.Releasemail.csproj" -c Release -o /github/workspace

FROM base AS final

EXPOSE 16110
ENV TZ Europe/Amsterdam

WORKDIR /github/workspace 

COPY --from=publish /github/workspace  .

ENTRYPOINT ["dotnet", "actionreleasemail.dll"]