# Stage 1: Build the application
FROM maven:3.9.2-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the entire project to the container
COPY . .

# Build the Spring Boot application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage to the run stage
COPY --from=build /app/target/treading-plateform-0.0.1-SNAPSHOT.jar app.jar

# Copy the application.properties file
COPY src/main/resources/application.properties /app/application.properties

# Expose the port from the application.properties file (5454)
EXPOSE 5454

# Set environment variables for MySQL connection, email credentials, and payment gateway keys
ENV SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/treading
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=Pankaj@123
ENV SPRING_MAIL_USERNAME=your_email
ENV SPRING_MAIL_PASSWORD=your_app_password
ENV STRIPE_API_KEY=your_stripe_key
ENV RAZORPAY_API_KEY=rzp_test_73Y58ks8Q9Yq0z
ENV RAZORPAY_API_SECRET=sKn47jW05Xgv26VmgCZ8faDZ
ENV COINGECKO_API_KEY=your_coin_gecko_api_key
ENV GEMINI_API_KEY=your_gemini_api_key
ENV GOOGLE_CLIENT_ID=your_google_client_id
ENV GOOGLE_CLIENT_SECRET=your_google_client_secret
ENV SPRING_JPA_HIBERNATE_DIALECT=org.hibernate.dialect.MySQLDialect

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
