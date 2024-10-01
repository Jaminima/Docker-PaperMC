FROM ubuntu:latest

#MC Server Port
EXPOSE 25565

#Plan Analytics Port
EXPOSE 8804

#Create a directory for the server
RUN mkdir /minecraft-init
RUN chmod 777 /minecraft-init

WORKDIR /minecraft-init

#Copy the server files
COPY ./docker-start.sh /minecraft-init/docker-start.sh

#Install Java and wget
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    wget \
    dos2unix

#Download the paper jar
RUN wget -O /minecraft-init/paper.jar  https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/110/downloads/paper-1.21.1-110.jar

#Run the server for the first time to generate the eula
RUN java -jar paper.jar

#Accept the eula
RUN echo "eula=true" > /minecraft-init/eula.txt

#Copy Logo
COPY ./configs/server-icon.png /minecraft-init/server-icon.png

#Setup Plugins
RUN wget -O /minecraft-init/plugins/Backuper.jar https://hangarcdn.papermc.io/plugins/Collagen/Backuper/versions/3.1.0/PAPER/Backuper-3.1.0.jar
COPY ./configs/backuper-config.yml /minecraft-init/plugins/Backuper/config.yml

RUN wget -O /minecraft-init/plugins/Plan.jar https://github.com/plan-player-analytics/Plan/releases/download/5.6.2883/Plan-5.6-build-2883.jar

RUN wget -O /minecraft-init/plugins/HuskHomes.jar https://hangarcdn.papermc.io/plugins/William278/HuskHomes/versions/4.7/PAPER/HuskHomes-Paper-4.7.jar

RUN wget -O /minecraft-init/plugins/Mini-Info.jar https://hangarcdn.papermc.io/plugins/bluelhf/mini-info/versions/1.0.0/PAPER/mini-info.jar
COPY ./configs/welcome-motd.txt /minecraft-init/plugins/mini-info/MOTD.txt
RUN dos2unix /minecraft-init/plugins/mini-info/MOTD.txt

RUN wget -O /minecraft-init/plugins/Mini-MOTD.jar https://hangarcdn.papermc.io/plugins/jmp/MiniMOTD/versions/2.1.3/PAPER/minimotd-bukkit-2.1.3.jar
COPY ./configs/mini-motd.conf /minecraft-init/plugins/MiniMOTD/main.conf

RUN wget -O /minecraft-init/plugins/BetterSleepPlus.jar https://mediafilez.forgecdn.net/files/5482/828/BetterSleepPlus-1.0.jar

CMD ["./docker-start.sh"]