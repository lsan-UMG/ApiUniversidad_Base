# =====================================================
# Etapa 1: Build — compilar la aplicación
# =====================================================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /app

# Copiar los archivos de proyecto y restaurar dependencias
COPY src/*.csproj ./src/
RUN dotnet restore ./src/

# Copiar el resto del código fuente
COPY src/ ./src/

# Compilar y publicar en modo Release
RUN dotnet publish ./src/ -c Release -o /app/publish

# =====================================================
# Etapa 2: Runtime — imagen final ligera
# =====================================================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Copiar los archivos publicados desde la etapa de build
COPY --from=build /app/publish .

# Exponer el puerto en el que corre el API
EXPOSE 8080

# Configurar la URL de escucha
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Punto de entrada de la aplicación
ENTRYPOINT ["dotnet", "UniversityGrades.dll"]
