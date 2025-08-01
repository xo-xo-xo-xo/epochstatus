#!/bin/bash

SOUND_FILE="/home/xo/sounds/alert.mp3"
DELAY=5

while true; do
    auth_status=$(nc -z -w 5 game.project-epoch.net 3724 >/dev/null 2>&1 && echo "alive" || echo "dead")
    game_status=$(nc -z -w 5 198.244.179.121 8085 >/dev/null 2>&1 && echo "alive" || echo "dead")
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$timestamp auth server $auth_status"
    echo "$timestamp kezan $game_status"
    [ "$auth_status" = "alive" ] && [ "$game_status" = "alive" ] && paplay "$SOUND_FILE" >/dev/null 2>&1
    sleep $DELAY
done
