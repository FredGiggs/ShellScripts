#!/bin/bash
# Made by Frederico Goncalves
# $1 is the first argument supplied after calling the script

if [ -z "$1" ] # If VAR is unset or set to the empty string
then
        printf  "\nUsage:\n\tclearKey.sh <IP> or <HOSTNAME>\n\n"
        exit
fi

IPREGEX='[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
NAMEREGEX='.*[a-zA-Z]+\-[a-zA-Z]+.*'

if [[ $1 =~ $IPREGEX ]]
then
        IP=$1
        NAME=`nslookup $1 | tail -2 | head -1 | cut -d "=" -f2 | cut -d "." -f 1 | cut -d " " -f2`
        if [[ ! $NAME =~ $NAMEREGEX ]]
        then
                echo "Invalid IP..."
                printf  "\nUsage:\n\tclearKey.sh <IP> or <HOSTNAME>\n\n"
                exit
        fi
else
        NAME=$1
        IP=`nslookup $1 | tail -2 | head -1 | cut -d " " -f2`
        if [[ ! $IP =~ $IPREGEX ]]
        then
                echo "Invalid Name..."
                printf  "\nUsage:\n\tclearKey.sh <IP> or <HOSTNAME>\n\n"
                exit
        fi
fi
grep -v $IP ~/.ssh/known_hosts > ~/.ssh/known_hosts_tmp
grep -v -i $NAME ~/.ssh/known_hosts_tmp > ~/.ssh/known_hosts
rm ~/.ssh/known_hosts_tmp

echo "Deleted line $NAME and $IP from known_hosts file"
