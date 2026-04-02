#!/bin/bash
# memory.sh — RAM usage (used / total)

PAGE_SIZE=4096
STATS=$(vm_stat | awk '
  /Pages active:/     { active=$3 }
  /Pages wired down:/ { wired=$4 }
  /Pages compressed:/ { compressed=$3 }
  END {
    gsub(/\./, "", active)
    gsub(/\./, "", wired)
    gsub(/\./, "", compressed)
    print active+0, wired+0, compressed+0
  }')

read -r ACTIVE WIRED COMPRESSED <<< "$STATS"
TOTAL_BYTES=$(sysctl -n hw.memsize)
TOTAL_GB=$(( TOTAL_BYTES / 1024 / 1024 / 1024 ))
USED_GB=$(( (ACTIVE + WIRED + COMPRESSED) * PAGE_SIZE / 1024 / 1024 / 1024 ))

sketchybar --set memory label="${USED_GB}/${TOTAL_GB}G"
