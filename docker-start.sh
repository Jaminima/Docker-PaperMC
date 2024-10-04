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
cp ./server-icon.png /minecraft

# Start the server
cd /minecraft
java -Xms7G -Xmx7G -jar paper.jar --nogui