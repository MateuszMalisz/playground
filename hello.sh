#!/bin/bash

countFile="count"
# Get count
runCount=`cat $countFile`
# Print
echo "Hello! You are running this $runCount. time!"
# Save updated count
runCount=$((runCount+1))
echo "$runCount" > "$countFile"

git add count
git commit -m "Bump #$runCount"
git push origin master
