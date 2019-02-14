#!/bin/bash

VIDEOS_DIR=~/Videos
USB_DIR=/media/$USER
PID_FILE=~/.vlc.pid

if [ ! -d $VIDEOS_DIR ];
then
    mkdir $VIDEOS_DIR
fi;
OIFS="$IFS"
IFS=$'\n'
for dir in $(ls $USB_DIR);
do
    SOURCE="$USB_DIR/$dir"
    echo "Syncing $SOURCE"
    rsync -av $SOURCE $VIDEOS_DIR 
done;
IFS="$OIFS"

if [ -f $PID_FILE ];
then
    VLC_PID=$(cat $PID_FILE)
    echo "VLC PID IS $VLC_PID"
    echo "PROCESS PROBING $(ps ax| grep $VLC_PID | grep vlc)"
    if [[ $VLC_PID == "" ]] || [[ $(ps ax| grep $VLC_PID | grep vlc) == "" ]];
    then
        echo "No PID or PID is not in the process list"
        vlc -L $VIDEOS_DIR --fullscreen &
        PID=$!
        echo $PID > $PID_FILE
    fi;
else
    vlc -L $VIDEOS_DIR --fullscreen &
    PID=$!
    echo $PID > $PID_FILE
fi;    

