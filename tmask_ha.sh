#!/bin/bash

#################################################
# __author__ = "biuro@tmask.pl"                 #
# __copyright__ = "Copyright (C) 2023 TMask.pl" #
# __license__ = "MIT License"                   #
# __version__ = "1.0"                           #
#################################################

echo " "
echo " ███████████ ██████   ██████                   █████                   ████ "
echo "░█░░░███░░░█░░██████ ██████                   ░░███                   ░░███ "
echo "░   ░███  ░  ░███░█████░███   ██████    █████  ░███ █████    ████████  ░███ "
echo "    ░███     ░███░░███ ░███  ░░░░░███  ███░░   ░███░░███    ░░███░░███ ░███ "
echo "    ░███     ░███ ░░░  ░███   ███████ ░░█████  ░██████░      ░███ ░███ ░███ "
echo "    ░███     ░███      ░███  ███░░███  ░░░░███ ░███░░███     ░███ ░███ ░███ "
echo "    █████    █████     █████░░████████ ██████  ████ █████ ██ ░███████  █████"
echo "   ░░░░░    ░░░░░     ░░░░░  ░░░░░░░░ ░░░░░░  ░░░░ ░░░░░ ░░  ░███░░░  ░░░░░ "
echo "                                                             ░███           "
echo "                                                             █████          "
echo "                                                            ░░░░░           "
echo " "

cd /opt

now=$(date)

#HA

FIRMA="Nazwa Firmy"
SLACK="https://hooks.slack.com/services/SLACK"
TUNNEL=HA-$FIRMA
MAIL=biuro@tmask.pl
SEM=HA.sem
IP=pve02
SCRIPT="pvecm expected 1"
if ping -c 1 $IP  &> /dev/null; then
    echo "$now - $IP $TUNNEL - OK"       
    if test -f $SEM; then
        rm $SEM
        echo "Semafor $SEM usuniety"
        curl -X POST --data-urlencode "payload={\"channel\": \"#tmaskpl\", \"username\": \"$IP \", \"text\": \"OK $FIRMA HA - $IP \", \"icon_emoji\": \":white_check_mark:\"}" $SLACK
        echo "$now - $IP $TUNNEL - OK" >> /var/log/syslog
    fi
else
    if test -f $SEM; then
        echo "$now - $IP $TUNNEL - ERROR"
    else
        echo "$now - $IP $TUNNEL - ERROR"
        curl -X POST --data-urlencode "payload={\"channel\": \"#tmaskpl\", \"username\": \"$IP \", \"text\": \"ERROR $FIRMA HA - $IP \", \"icon_emoji\": \":red_circle:\"}" $SLACK
        echo "$now - $IP $TUNNEL - ERROR" >> /var/log/syslog
        sleep 120
        $SCRIPT
        echo "Dodanie semafora $SEM"
            touch $SEM
    fi
fi
