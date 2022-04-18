FROM  openjdk
LABEL maintainer="DKL"
LABEL version="1"
LABEL description="Test task"
COPY ./demo-1.0.jar /app/demo.jar
WORKDIR /app
CMD   ["java", "-jar", "/app/demo.jar"]
EXPOSE 8080/tcp
