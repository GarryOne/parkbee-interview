# Use a base image that includes Node.js
FROM node:18-alpine

# Set the working directory in the Docker container
WORKDIR /app

# Install http-server globally
RUN npm install -g http-server

# Copy your static content and the script
COPY ./index.html ./public/index.html
COPY ./envsubst.sh ./envsubst.sh

# Make sure the script is executable
RUN chmod +x ./envsubst.sh

# Expose port 80 to the outside world
EXPOSE 80

# Set default environment variables (optional)
ENV API_HOST=localhost
ENV API_PORT=3000

# Use the script to start http-server
ENTRYPOINT ["./envsubst.sh", "http-server", "public", "-p 80"]
