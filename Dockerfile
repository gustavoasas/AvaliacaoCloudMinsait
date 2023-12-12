FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM openjdk:17-alpine
WORKDIR /app
RUN apk update && \
    apk add iputils netcat-openbsd
COPY --from=build /app/target/minsait-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/app/app.jar" ]