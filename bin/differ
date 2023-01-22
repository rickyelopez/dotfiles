#!/bin/bash

greenvid="\0033[32m"
resetvid="\0033[0m"

if [ $# -ne 3 ]
then
 echo "Usage: compare files in two directories including subdirectories"
 echo "         $0 <source-dir> <target-dir> <pattern>"
 echo "Example: $0  subdir-1     subdir-2     \"*.txt\""
 exit
fi

cmd='for pathname do
        greenvid="\0033[32m"
        resetvid="\0033[0m"
        echo -e "${greenvid}diff \"$pathname\" \"${pathname/'\"$1\"'/'\"$2\"'}\"${resetvid}"
        diff "$pathname" "${pathname/'\"$1\"'/'\"$2\"'}"
    done'
#echo "$cmd"

find "$1" -type f -name "$3" -exec bash -c "$cmd" bash {} +
