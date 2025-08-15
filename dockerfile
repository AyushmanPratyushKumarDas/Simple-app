# Use a small and secure base image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install ONLY production dependencies
RUN npm install --omit=dev

# Copy the rest of the application code
COPY . . 

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]