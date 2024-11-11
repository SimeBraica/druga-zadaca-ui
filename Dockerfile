# Stage 1: Build the Blazor WebAssembly app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the Blazor project file and restore dependencies
COPY ./UI/UI.csproj ./UI/
RUN dotnet restore ./UI/UI.csproj

# Copy the rest of the Blazor project files
COPY ./UI/ ./UI/

# Build the Blazor WebAssembly app for production
RUN dotnet publish ./UI/UI.csproj -c Release -o /app/dist

# Stage 2: Use NGINX to serve the static files
FROM nginx:alpine AS runtime
WORKDIR /usr/share/nginx/html

# Copy the built Blazor app to the NGINX HTML directory
COPY --from=build /app/dist .

# Copy a custom NGINX configuration file if needed
# Uncomment the next two lines if you have a custom config (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for the NGINX server
EXPOSE 80

# Start the NGINX server
ENTRYPOINT ["nginx", "-g", "daemon off;"]
