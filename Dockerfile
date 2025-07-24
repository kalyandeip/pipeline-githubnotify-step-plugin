# Use an official Maven image with JDK 17
FROM maven:3.9.9-eclipse-temurin-17 AS builder

# Set environment variables
ENV MAVEN_OPTS="-Dmaven.javadoc.skip=true"

# Set working directory
WORKDIR /usr/src/app

# Copy Maven project files
COPY . .

# Download dependencies and build the plugin
RUN mvn clean install -Dmaven.javadoc.skip=true

# -----------------------------------------------------------------------------
# Runtime image (optional, if you want to keep just the HPI plugin artifact)
# -----------------------------------------------------------------------------
FROM debian:bullseye-slim AS runtime

# Install unzip in case you want to inspect plugin contents
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Copy the built plugin from the builder image
COPY --from=builder /usr/src/app/target/*.hpi /plugin/pipeline-githubnotify-step.hpi

# Default working directory
WORKDIR /plugin

CMD ["ls", "-l", "/plugin"]
