#FROM maven:3.8.2-jdk-11 AS build
#COPY ./ ./
#ENTRYPOINT ["mvn", "clean", "package", "-DskipTests"]
#
#FROM openjdk:19-jdk
#
#COPY --from=build target/demo-deloy-0.0.1-SNAPSHOT.jar demo-deploy.jar
##Using Dokerize to check whether db is up, if it is then start this service.
#COPY dockerize dockerize
#
#CMD ./dockerize -wait tcp://demo_db:1433 -timeout 15m java -Djava.security.egd=file:///dev/urandom -jar /demo-deploy.jar

#
# Build stage
#
FROM maven:3.8.2-openjdk-17 AS build
COPY . .
RUN mvn clean package -Pprod -DskipTests

#
# Package stage
#
FROM openjdk:17-jdk-slim
COPY --from=build /target/demo-deloy-0.0.1-SNAPSHOT.jar demo-deloy.jar
# ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["java","-jar","demo.jar"]