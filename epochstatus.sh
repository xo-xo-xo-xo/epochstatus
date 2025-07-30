#!/bin/bash

# ---------- config ----------
SERVER="game.project-epoch.net"
PORT=3724
DELAY_SECONDS=5
NOTIFICATION_ON_CHANGE=true
NOTIFICATION_WHEN_DOWN=false
SHOW_TEST_NOTIFICATION=true
SOUND_FILE="/home/xo/sounds/alert.mp3"

# ----------------------------

show_notification() {
    local title="$1"
    local message="$2"
    notify-send "$title" "$message" -t 5000
    if [ -f "$SOUND_FILE" ]; then
        paplay "$SOUND_FILE" > /dev/null 2>&1
    fi
}


if [ "$SHOW_TEST_NOTIFICATION" = true ]; then
    show_notification "Test Notification" "Notification test"
fi


last_status=""

while true; do

    nc -z -w 5 "$SERVER" "$PORT" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        status="alive"
    else
        status="fucked"
    fi

    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    line="$timestamp $status"


    echo "$line"
   state_changed=false
    if [ -n "$last_status" ] && [ "$status" != "$last_status" ]; then
        state_changed=true
    fi


    if [ "$NOTIFICATION_ON_CHANGE" = true ] && [ "$state_changed" = true ]; then
        show_notification "Epoch is $status" "Port $PORT on $SERVER @ $(date '+%H:%M:%S')"
    elif [ "$NOTIFICATION_WHEN_DOWN" = true ] && [ "$status" = "DOWN" ]; then
        show_notification "Epoch is $status" "Port $PORT on $SERVER @ $(date '+%H:%M:%S')"
    fi

    last_status="$status"
    sleep "$DELAY_SECONDS"
done
