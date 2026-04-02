#!/bin/bash
# network.sh — realtime download/upload speed on default interface

INTERFACE=$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')
[ -z "$INTERFACE" ] && INTERFACE="en0"

get_bytes() {
  netstat -ib -I "$1" 2>/dev/null | awk 'NR>1 {down+=$7; up+=$10} END {print down+0, up+0}'
}

STATE_FILE="/tmp/sketchybar_net_${INTERFACE}"
read -r prev_down prev_up prev_time < "$STATE_FILE" 2>/dev/null \
  || { prev_down=0; prev_up=0; prev_time=0; }

curr_time=$(date +%s)
read -r curr_down curr_up <<< "$(get_bytes "$INTERFACE")"

dt=$(( curr_time - prev_time ))
[ "$dt" -le 0 ] && dt=1

raw_down=$(( curr_down - prev_down ))
raw_up=$(( curr_up - prev_up ))
[ "$raw_down" -lt 0 ] && raw_down=0
[ "$raw_up"   -lt 0 ] && raw_up=0

down_rate=$(( raw_down / dt ))
up_rate=$(( raw_up   / dt ))

echo "$curr_down $curr_up $curr_time" > "$STATE_FILE"

fmt() {
  local b=$1
  if   [ "$b" -ge 1048576 ]; then echo "$(( b / 1048576 ))M"
  elif [ "$b" -ge 1024 ];    then echo "$(( b / 1024 ))K"
  else                             echo "${b}B"
  fi
}

sketchybar --set network label="↓$(fmt $down_rate) ↑$(fmt $up_rate)"
