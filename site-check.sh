#!/bin/bash

url=https://www.google.com/

while true; do
code=$(curl -s --head $url | grep HTTP | cut -d " " -f 2)
echo $code
  if [ $code != 301 ]
    then
    echo $code
    echo "Its up at $url" & while true; do echo -en "\a" > /dev/tty5; sleep 1; done
  fi;
sleep 1200;
done;
