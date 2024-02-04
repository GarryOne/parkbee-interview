# Use a base image that includes Node.js
FROM node:18-alpine

# Set the working directory in the Docker container
WORKDIR /app

# Optionally, if you have other dependencies to install
# COPY package*.json ./
# RUN npm install

# Install http-server globally
RUN npm install -g http-server

# Copy your static content
COPY ./public/index.html ./public/index.html

# Expose port 80 to the outside world
EXPOSE 80

# Run http-server on port 80 and serve content from the public directory
ENTRYPOINT ["http-server", "public", "-p 80"]
