#!/bin/bash

shopt -s nullglob
shopt -s globstar
shopt -s extglob

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

processedFilesCount=1
jpgArray=(*.@(jpg|JPG|jpeg|JPEG))
pngArray=(*.@(png|PNG))

jpgCount=${#jpgArray[@]}
pngCount=${#pngArray[@]}
photoCount=$((jpgCount+pngCount))

echo -e "FOUND ${GREEN} $photoCount ${ENDCOLOR} PHOTOS TO PROCESS"
 
read -n 1 -p "ENTER TO START..." "input"

for jpgPhoto in ${jpgArray[*]}; do

	echo "-------------PHOTO $processedFilesCount/$photoCount-------------------"
	jpegoptim "$jpgPhoto"
	
	processedFilesCount=$((processedFilesCount+1))
done

for pngPhoto in ${pngArray[*]}; do

	echo "-------------PHOTO $processedFilesCount/$photoCount-------------------"
	optipng "$pngPhoto"
	
	processedFilesCount=$((processedFilesCount+1))
done