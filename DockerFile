FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WOKRDIR /app

COPY . .

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre

WOKRDIR /app

COPY  --from=builder /app/target/poc-2.jar /app/poc-2.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "poc-2.jar"]

