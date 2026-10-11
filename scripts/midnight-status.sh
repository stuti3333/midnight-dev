#!/usr/bin/env bash

printf '\n'
printf '\033[38;5;141m━━━ MIDNIGHT SYSTEM STATUS ━━━\033[0m\n'

if command -v uptime >/dev/null 2>&1; then
    printf '\033[38;5;81mUptime:\033[0m '
    uptime -p
fi

if [[ -r /proc/loadavg ]]; then
    printf '\033[38;5;81mCPU load:\033[0m '
    awk '{print $1 " (1m), " $2 " (5m), " $3 " (15m)"}' /proc/loadavg
fi

if [[ -r /proc/meminfo ]]; then
    awk '
    /MemTotal:/ {total=$2}
    /MemAvailable:/ {available=$2}
    END {
        if (total > 0) {
            used=total-available
            printf "\033[38;5;81mRAM:\033[0m %.1f / %.1f GiB (%.0f%% used)\n", used/1048576, total/1048576, used/total*100
        }
    }' /proc/meminfo
fi

battery_found=0
for battery in /sys/class/power_supply/BAT*; do
    [[ -r "$battery/capacity" ]] || continue
    battery_found=1
    printf '\033[38;5;81mBattery:\033[0m %s%%' "$(cat "$battery/capacity")"
    if [[ -r "$battery/status" ]]; then
        printf ' (%s)' "$(cat "$battery/status")"
    fi
    printf '\n'
done

if (( battery_found == 0 )); then
    printf '\033[38;5;245mBattery: no battery detected\033[0m\n'
fi

printf '\033[38;5;141m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n\n'
