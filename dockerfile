# Here, we include the dotnet core SDK as the base to build our app
FROM mcr.microsoft.com/dotnet/core/sdk:7.0 AS build-env
# Setting the work directory for our app
WORKDIR /My_Site

# We copy the .csproj of our app to root and 
# restore the dependencies of the project.
COPY /My_Site.csproj .
RUN dotnet restore "My_Site.csproj"

# We proceed by copying all the contents in
# the main project folder to root and build it
COPY My_Site/* .
RUN dotnet build "My_Site.csproj" -c Release -o /build

# Once we're done building, we'll publish the project
# to the publish folder 
FROM build-env AS publish
RUN dotnet publish "My_Site.csproj" -c Release -o /publish

# We then get the base image for Nginx and set the 
# work directory 
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html

# We'll copy all the contents from wwwroot in the publish
# folder into nginx/html for nginx to serve. The destination
# should be the same as what you set in the nginx.conf.
COPY --from=publish /publish/wwwroot /usr/local/webapp/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf