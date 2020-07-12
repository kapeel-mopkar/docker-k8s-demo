FROM adoptopenjdk/openjdk8:alpine-jre

COPY target/docker-demo-1.0.jar /opt/docker-demo/

WORKDIR /opt/

RUN mkdir appConfig

WORKDIR /opt/docker-demo/

RUN mkdir temp

ENTRYPOINT java $JAVA_OPTS -jar ./docker-demo-1.0.jar

EXPOSE 8080