FROM ubuntu:latest
EXPOSE 25565

RUN mkdir /minecraft-init
RUN chmod 777 /minecraft-init

WORKDIR /minecraft-init

COPY ./docker-start.sh /minecraft-init/docker-start.sh

RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    wget

RUN wget -O /minecraft-init/paper.jar  https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/110/downloads/paper-1.21.1-110.jar

RUN java -jar paper.jar

RUN echo "eula=true" > /minecraft-init/eula.txt

CMD ["./docker-start.sh"]