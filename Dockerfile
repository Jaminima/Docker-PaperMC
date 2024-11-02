FROM ubuntu:latest

#Install Neccessary Packages
RUN apt-get update && apt-get install -y \
    openjdk-21-jdk \
    wget \
    dos2unix 

#Java Port
EXPOSE 25565

#Bedrock Port (UDP)
EXPOSE 19132/udp

#Plan Analytics Port
EXPOSE 8804

#BlueMap Port
EXPOSE 8100

#------Configure Minecraft Server------

#Create a directory for the server
RUN mkdir /minecraft-init
RUN chmod 777 /minecraft-init

WORKDIR /minecraft-init

#Download the paper jar
RUN wget -O /minecraft-init/paper.jar  https://api.papermc.io/v2/projects/paper/versions/1.21.3/builds/10/downloads/paper-1.21.3-10.jar

#Run the server for the first time to generate the eula
RUN java -jar paper.jar

#Accept the eula
RUN echo "eula=true" > /minecraft-init/eula.txt

#Copy Logo
COPY ./configs/server-icon.png /minecraft-init/server-icon.png

#Administration
RUN wget -O /minecraft-init/plugins/Backuper.jar https://hangarcdn.papermc.io/plugins/Collagen/Backuper/versions/3.1.1/PAPER/Backuper-3.1.1.jar
COPY ./configs/backuper-config.yml /minecraft-init/plugins/Backuper/config.yml

RUN wget -O /minecraft-init/plugins/Plan.jar https://github.com/plan-player-analytics/Plan/releases/download/5.6.2883/Plan-5.6-build-2883.jar

RUN wget -O /minecraft-init/plugins/Mini-Info.jar https://hangarcdn.papermc.io/plugins/bluelhf/mini-info/versions/1.0.0/PAPER/mini-info.jar
COPY ./configs/welcome-motd.txt /minecraft-init/plugins/mini-info/MOTD.txt
RUN dos2unix /minecraft-init/plugins/mini-info/MOTD.txt

RUN wget -O /minecraft-init/plugins/Mini-MOTD.jar https://hangarcdn.papermc.io/plugins/jmp/MiniMOTD/versions/2.1.3/PAPER/minimotd-bukkit-2.1.3.jar
COPY ./configs/mini-motd.conf /minecraft-init/plugins/MiniMOTD/main.conf

#Player
RUN wget -O /minecraft-init/plugins/BetterSleepPlus.jar https://mediafilez.forgecdn.net/files/5482/828/BetterSleepPlus-1.0.jar

#Permissions
RUN wget -O /minecraft-init/plugins/LuckyPerms.jar https://download.luckperms.net/1556/bukkit/loader/LuckPerms-Bukkit-5.4.141.jar
RUN wget -O /minecraft-init/plugins/VaultUnlocked.jar https://hangarcdn.papermc.io/plugins/TNE/VaultUnlocked/versions/2.0.0/PAPER/VaultUnlocked-2.1.0.jar

#Essentials
RUN wget -O /minecraft-init/plugins/EssentialsX.jar https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/jars/EssentialsX-2.21.0-dev+121-f7a8f86.jar
RUN wget -O /minecraft-init/plugins/EssentialsXChat.jar https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/jars/EssentialsXChat-2.21.0-dev+121-f7a8f86.jar

#BLueMap
RUN wget -O /minecraft-init/plugins/BlueMap.jar https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v5.4/bluemap-5.4-paper.jar
COPY ./configs/bluemap-core.conf /minecraft-init/plugins/BlueMap/core.conf

#WildStacker
RUN wget -O /minecraft-init/plugins/WildStacker.jar https://hub.bg-software.com/job/WildStacker%20-%20Stable%20Builds/5/artifact/target/WildStacker-2024.3.jar
COPY ./configs/wildstacker.yml /minecraft-init/plugins/WildStacker/config.yml

#FineHarvest
RUN wget -O /minecraft-init/plugins/FineHarvest.jar https://github.com/sammyt291/FineHarvest/releases/download/v1.4.7/FineHarvest-1.4.7.jar

#TreeFeller
RUN wget -O /minecraft-init/plugins/TreeFeller.jar https://cdn.modrinth.com/data/YrkmSvXh/versions/Va47sosG/TreeFeller-1.24.2.jar

#Multiverse
RUN wget -O /minecraft-init/plugins/multiverse-core.jar https://hangarcdn.papermc.io/plugins/Multiverse/Multiverse-Core/versions/4.3.13/PAPER/multiverse-core-4.3.13.jar
RUN wget -O /minecraft-init/plugins/multiverse-inventories.jar https://mediafilez.forgecdn.net/files/4721/185/multiverse-inventories-4.2.6.jar
RUN wget -O /minecraft-init/plugins/multiverse-portals.jar https://cdn.modrinth.com/data/8VMk6P0I/versions/R2j8xMnO/multiverse-portals-4.3.0-pre.jar

#Geyser
RUN wget -O /minecraft-init/plugins/Geyser.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot
RUN wget -O /minecraft-init/plugins/Floodgate.jar https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

#ViaVersion
RUN wget -O /minecraft-init/plugins/ViaVersion.jar https://hangarcdn.papermc.io/plugins/ViaVersion/ViaVersion/versions/5.1.1/PAPER/ViaVersion-5.1.1.jar

#Copy The Start Script
COPY docker-start.sh ./docker-start.sh
RUN dos2unix ./docker-start.sh
RUN chmod +x ./docker-start.sh

#------Start The Server------

CMD ["/bin/bash", "/minecraft-init/docker-start.sh"]