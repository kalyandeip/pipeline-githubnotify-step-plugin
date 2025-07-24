# Stage 1: Build with Maven and JDK 8
FROM maven:3.9.6-eclipse-temurin-8 as builder

# Avoid interactive apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables to skip javadoc
ENV MAVEN_OPTS="-Dmaven.javadoc.skip=true"

# Set the working directory
WORKDIR /app

# Copy Maven project files
COPY . .

# Build the plugin and skip javadoc generation
RUN mvn clean install -Dmaven.javadoc.skip=true

# Stage 2: Slim runtime image to extract the .hpi
FROM debian:bullseye-slim

# Install minimal tools (optional)
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Create plugin directory
WORKDIR /plugin

# Copy the built plugin from the builder stage
COPY --from=builder /app/target/*.hpi /plugin/

# Default command just lists the plugin
CMD ["ls", "-lh", "/plugin"]
