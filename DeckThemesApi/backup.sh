#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

cd /home/mudkip/docker/DeckThemesApi

echo Dumping db
sqlite3 sql/data.sqlite3 ".backup './data.bak.sqlite3'"

echo Backing up data
currentDate="$(date +"%m-%Y")"
currentTime="$(date +"%d %H:%M:%S")"
filename="$currentDate/$currentTime.tar.gz"
echo $filename
tar -czvf backup.tar.gz appsettings.json blob data.bak.sqlite3 *.sh docker-compose.yml

echo Uploading backup to Backblaze
./b2-linux upload_file deckthemes-backup backup.tar.gz "$filename"

echo Removing temp tarball
rm backup.tar.gz
rm data.bak.sqlite3
