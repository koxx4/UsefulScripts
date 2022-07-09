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
read -n 1 -p "DELETE ORIGINAL FILES AFTER SUCCESSFUL COMPRESSION (y/n)? : " "deleteAfterComp"
echo ""
read -p "PREFIX OF COMPRESSED FILES : " "compPrefix"
read -n 1 -p "ENTER TO START..." "input"

if [[ -n "$compPrefix" ]]; then
	$compPrefix="$compPrefix"-
fi

for videoFile in ${filesArray[*]}; do

	echo '--------------------------------'
	originalFileSize=$(ls -sd "$videoFile" | awk '{print $1}')
	originalFileName="$(basename "$videoFile")"
	currentDir="$(dirname "$videoFile")"
	
		
	if [[ originalFileSize -eq 0 ]]; then
		echo -e "${RED} ORIGINAL FILE SIZE IS 0, ABORTING!"
		continue
	fi

	echo "PROGRESS: $processedFilesCount/$filesCount files"
	echo -e "PROCESSING FILE ${GREEN}'$originalFileName'${ENDCOLOR} - SIZE $originalFileSize BYTES"

	mkdir -p "$currentDir/compressedVideos"
	compressedFileName="$currentDir/$compPrefix-$originalFileName"
	compressedFilePath="./compressedVideos/$compressedFileName"

	echo -e "COMPRESSING TO ${GREEN}'$compressedFilePath'${ENDCOLOR}"
	
	#Actual compression done by ffmpeg
	ffmpeg -hide_banner -loglevel error -y -i "$videoFile" "$compressedFilePath"
	
	compressedFileSize=$(ls -sd "$compressedFilePath" | awk '{print $1}')
	reducedSize=$((originalFileSize-compressedFileSize))
	reducedPercentage=$((reducedSize*100/originalFileSize))
	
	echo -e "COMPRESSED TO ---> ${GREEN}'$compressedFilePath'${ENDCOLOR} - SIZE $compressedFileSize BYTES"
	echo -e "SAVED $reducedSize BYTES ($reducedPercentage%)"
	
	if [[ $compressedFileSize -ge $originalFileSize ]]; then
		echo -e "${RED}COMPRESSION MADE FILE BIGGER, ABORTING...${ENDCOLOR}"
		rm -f "$compressedFilePath"
	else
		if [[ "$deleteAfterComp" = "y" ]] || [[ "$deleteAfterComp" = "Y" ]]; then
			echo -e "DELETING ORIGINAL FILE ${GREEN}'$originalFileName'${ENDCOLOR}"
			rm -f "$videoFile"
		fi	
	fi
	
	processedFilesCount=$((processedFilesCount+1))
done