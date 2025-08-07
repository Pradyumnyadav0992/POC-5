# ----- Stage 1: Build -----
FROM maven:3.9-eclipse-temurin-17-alpine AS builder

# Set working directory
WORKDIR /app

# Copy source code
COPY . .

# Build the application and skip tests for speed
RUN mvn clean package -DskipTests

# ----- Stage 2: Runtime -----
FROM eclipse-temurin:17-jdk-alpine

# Create a non-root user
RUN adduser -D javauser

# Set working directory
WORKDIR /app

# Copy the JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Change ownership
RUN chown javauser:javauser app.jar
USER javauser

# Expose port (e.g., 8080 for Spring Boot)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
