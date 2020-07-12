FROM adoptopenjdk/openjdk8:alpine-jre

COPY target/docker-k8s-demo.jar /opt/docker-k8s-demo/

WORKDIR /opt/

RUN mkdir appConfig

WORKDIR /opt/docker-k8s-demo/

RUN mkdir temp

ENTRYPOINT java $JAVA_OPTS -jar ./docker-k8s-demo.jar

EXPOSE 8080