#!/bin/bash

get_ppid() {
    local pid=$1
    awk '{print $4}' "/proc/$pid/stat" 2>/dev/null
}

printf "%-8s %-8s %-6s %s\n" "PID" "PPID" "STATE" "COMMAND"
printf "%-8s %-8s %-6s %s\n" "-------" "-------" "-----" "----------------------------------------"

for pid_dir in /proc/[0-9]*/; do
    pid=$(basename "$pid_dir")
    if [[ -d "/proc/$pid" ]]; then
        ppid=$(get_ppid "$pid")
        state=$(awk '{print $3}' "/proc/$pid/stat" 2>/dev/null)
        cmd=$(cat "/proc/$pid/comm" 2>/dev/null )
        printf "%-8s %-8s %-6s %s\n" "$pid" "${ppid:-?}" "${state:-?}" "${cmd:-[unknown]}"
    fi
done 
