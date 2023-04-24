#!/bin/bash

# @requires: amixer

SINK=$(amixer scontrols | grep -oP "'[^']*'" | sed "s/'//g" | head -n 1)

percentage () {
  local val=$(echo $1 | tr '%' ' ' | awk '{print $1}')
  local icon1=$2
  local icon2=$3
  local icon3=$4
  local icon4=$5
  if [ "$val" -le 15 ]; then
    echo $icon1
  elif [ "$val" -le 30 ]; then
    echo $icon2
  elif [ "$val" -le 60 ]; then
    echo $icon3
  else
    echo $icon4
  fi
}

is_muted () {
  amixer get Master | grep -o "\[off\]" | head -n 1
}

get_percentage () {
  local muted=$(is_muted)
  if [[ $muted == '[off]' ]]; then
    echo 0%
  else
    per=$(amixer get $SINK | grep -o '[0-9]*%' | head -n 1 | tr -d '%')
    echo "${per}%"
  fi
}

get_icon () {
  local vol=$(get_percentage)
  if [[ $vol == "0%" ]]; then
    echo "婢"
  else
    echo $(percentage "$vol" "" "" "墳" "")
  fi
}

get_class () {
  local vol=$(get_percentage)
  if [[ $vol == "0%" ]]; then
    echo "red"
  else
    echo $(percentage "$vol" "red" "magenta" "yellow" "blue")
  fi
}

get_vol () {
  local percent=$(get_percentage)
  echo $percent | tr -d '%'
}

if [[ $1 == "icon" ]]; then
  get_icon
fi

if [[ $1 == "class" ]]; then
  get_class
fi

if [[ $1 == "percentage" ]]; then
  get_percentage
fi

if [[ $1 == "vol" ]]; then
  get_vol
fi

if [[ $1 == "muted" ]]; then
  is_muted
fi

if [[ $1 == "toggle-muted" ]]; then
  amixer set Master toggle
fi

if [[ $1 == "set" ]]; then
  val=$(echo $2 | tr '.' ' ' | awk '{print $1}')
  if test $val -gt 100; then
    val=100
  fi
  amixer set $SINK $val%
fi
