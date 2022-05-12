FROM  openjdk
LABEL maintainer="DKL"
LABEL version="0.1.2"
LABEL name="demo"
LABEL description="Test task"
COPY ./demo-0.1.2.jar /app/demo.jar
WORKDIR /app
CMD   ["java", "-jar", "/app/demo.jar"]
EXPOSE 8080/tcp
