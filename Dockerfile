# Stage 1: Build the Blazor UI (Frontend)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS blazor-build
WORKDIR /app

# Copy the Blazor project file and restore dependencies
COPY ./UI/UI.csproj ./UI/
RUN dotnet restore ./UI/UI.csproj

# Copy the rest of the Blazor files
COPY ./UI/ ./UI/

# Build the Blazor WebAssembly app for production
RUN dotnet publish ./UI/UI.csproj -c Release -o /app/dist

# Stage 2: Serve Blazor app as static site using Nginx
FROM nginx:alpine AS runtime

# Copy the published Blazor UI from the build stage to the Nginx html folder
COPY --from=blazor-build /app/dist /usr/share/nginx/html

# Set up a custom nginx.conf to handle client-side routing for Blazor WebAssembly
COPY ./nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for the web app
EXPOSE 80

# Nginx will automatically serve the static files
CMD ["nginx", "-g", "daemon off;"]
