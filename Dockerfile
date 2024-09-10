# Start with a Maven image to build the project
FROM maven:3.9.2-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file to the working directory
COPY pom.xml .

# Download all the dependencies without building the project
RUN mvn dependency:go-offline -B

# Copy the entire project to the container
COPY . .

# Build the Spring Boot application
RUN mvn clean package -DskipTests

# Use a lightweight OpenJDK image to run the application
FROM eclipse-temurin:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage to the run stage
COPY --from=build /app/target/treading-plateform-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port (optional, adjust based on your application)
EXPOSE 5454

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
