FROM ubuntu:latest
EXPOSE 25565

RUN mkdir /minecraft
RUN chmod 777 /minecraft

WORKDIR /minecraft

RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    wget

RUN wget -O /minecraft/paper.jar  https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/110/downloads/paper-1.21.1-110.jar

RUN java -jar paper.jar

RUN echo "eula=true" > /minecraft/eula.txt

RUN ls /minecraft

CMD ["java", "-Xms4G", "-Xmx4G", "-jar", "paper.jar", "--nogui"]