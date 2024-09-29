FROM ubuntu:latest
EXPOSE 25565

#Create a directory for the server
RUN mkdir /minecraft-init
RUN chmod 777 /minecraft-init

WORKDIR /minecraft-init

#Copy the server files
COPY ./docker-start.sh /minecraft-init/docker-start.sh

#Install Java and wget
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    wget

#Download the paper jar
RUN wget -O /minecraft-init/paper.jar  https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/110/downloads/paper-1.21.1-110.jar

#Run the server for the first time to generate the eula
RUN java -jar paper.jar

#Accept the eula
RUN echo "eula=true" > /minecraft-init/eula.txt

#Get Plugins
RUN wget -O /minecraft-init/plugins/Backer.jar https://hangarcdn.papermc.io/plugins/Collagen/Backuper/versions/3.1.0/PAPER/Backuper-3.1.0.jar

CMD ["./docker-start.sh"]