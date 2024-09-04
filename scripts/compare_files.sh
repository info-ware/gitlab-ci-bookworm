#!/bin/bash

# Check if both files exist  
if ! [ -e "$1"  ];
then
    printf "%s doesn't exist\n" "$1"
    exit 2
elif ! [ -e "$2" ]
then
    printf "%s doesn't exist\n" "$2"
    exit 2
fi

# Get checksums of eithe file
file1_sha=$( sha256sum "$1" | awk '{print $1}')
file2_sha=$( sha256sum "$2" | awk '{print $1}')

# Compare the checksums
if [ "x$file1_sha" = "x$file2_sha" ]
then
    printf "Files %s and %s are the same\n" "$1" "$2"
    exit 0
else
    printf "Files %s and %s are different\n" "$1" "$2"
    exit 1
fi
