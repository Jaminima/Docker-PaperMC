#!/bin/sh

cd /minecraft-init

# Copy server folders to the server directory
cp -r ./cache /minecraft
cp -r ./libraries /minecraft
cp -r ./plugins /minecraft
cp -r ./versions /minecraft

# Copy the server files
cp ./eula.txt /minecraft
cp ./paper.jar /minecraft

# Start the server
cd /minecraft
java -Xms4G -Xmx4G -jar paper.jar --nogui