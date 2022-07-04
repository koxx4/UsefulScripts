#!/bin/bash

shopt -s nullglob
shopt -s globstar

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

if [ -z "$1" ]; then
	echo 'Please provide first arg - dir or pattern of dirs with videos to compress'
	exit 1
fi

if [ -z "$2" ]; then
	echo 'Please provide second arg - extension of the source video files'
	exit 1
fi

processedFilesCount=1
filesArray=("$1"**/*."$2")
filesCount=${#filesArray[@]}

echo -e "FOUND ${GREEN} $filesCount ${ENDCOLOR} videos to process"
read -n 1 -p "ENTER TO CONTINUE..." "input"
for videoFile in "$1"**/*."$2"; do
	echo '--------------------------------'
	originalFileSize=$(ls -sd "$videoFile" | awk '{print $1}')
	echo "PROGRESS: $processedFilesCount/$filesCount files"
	echo -e "PROCESSING FILE ${GREEN}'$(basename "$videoFile")'${ENDCOLOR} - SIZE $originalFileSize BYTES"
	echo -e "COMPRESSING TO ${GREEN}'$(dirname "$videoFile")/compressed-$(basename "$videoFile")'${ENDCOLOR}"
	ffmpeg -hide_banner -loglevel error -y -i "$videoFile" "$(dirname "$videoFile")/compressed-${videoFile##*/}"
	compressedFileSize=$(ls -sd "$(dirname "$videoFile")/compressed-$(basename "$videoFile")" | awk '{print $1}')
	reducedSize=$((originalFileSize-compressedFileSize))
	reducedPercentage=$((reducedSize*100/originalFileSize))
	echo -e "COMPRESSED TO ${GREEN}'$(dirname "$videoFile")/compressed-$(basename "$videoFile")'${ENDCOLOR} - SIZE $compressedFileSize BYTES"
	echo -e "SAVED $reducedSize BYTES ($reducedPercentage%)"
	processedFilesCount=$((processedFilesCount+1))
 done

