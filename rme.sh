#!/bin/bash
#koxx4
if [ -z "$1" ]; then 
	echo "Provide first argument - files with this string will not be deleted."
	exit 1
fi

if [ -z "$2" ]; then
	echo "Provide second argument - files with this extension will get deleted. '*' to delete all."
	exit 1
fi

echo 'Making temp dir'
mkdir rme-temp
mv *"$1"* rme-temp
echo "Moved '$1' files to rme-temp"
echo "Deleting files not containing '$1' and that end with '$2'"
rm *."$2"
echo 'Restoring files from temp dir'
mv ./rme-temp/* ./
echo 'Deleting temp dir'
rm -d ./rme-temp
