FROM openjdk:17
WORKDIR /app
COPY target/student-survey-backend-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]



# FROM nginx:alpine
# COPY index.html /usr/share/nginx/html/
# EXPOSE 80