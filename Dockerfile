# Use an official Node.js image as base
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app code
COPY . .

# Expose port 5000 (same as your app)
EXPOSE 5000

# Command to run the app
CMD ["npm", "start"]

