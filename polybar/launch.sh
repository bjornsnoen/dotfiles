#!/usr/bin/env sh

killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

num_monitors=$(polybar --list-monitors | wc -l)

polybar --list-monitors | while read -r m; do
    case $num_monitors in
        1)
            TRAY="right"
            ;;
        *)
            MONITOR=$(echo $m | cut -d":" -f1)
            PRIMARY=$(echo $m | grep primary)
            if [ -z "$PRIMARY" ]; then
                TRAY="none"
            else
                TRAY="right"
            fi
            ;;
    esac

    TRAY=$TRAY MONITOR=$MONITOR polybar --reload arch &
done
