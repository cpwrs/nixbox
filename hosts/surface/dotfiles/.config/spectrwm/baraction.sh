#!/bin/sh
# This file echos a string that will be processed and displayed on the spectrwm bar.
# Any spectrwm bar_format character sequences will be expanded.

readonly BOLD="+@fn=1;+@fg=1;"
readonly REGULAR="+@fn=0;+@fg=0;"
readonly WIFI_INTERFACE="wlp1s0"
readonly BATTERY_DIR="/sys/class/power_supply"

# Echo the name(s) of connected bluetooth 
# device(s) via BlueZ (bluetoothctl).
bluetooth () {
  con=$(
    bluetoothctl devices \
    | cut -f2 -d' ' \
    | while read uuid; do bluetoothctl info $uuid; done \
    | grep -e "Name\|Connected: yes" \
    | grep -B1 "yes" \
    | head -n 1 \
    | cut -d\  -f2-
  )
  
  if ! [ -z "$con" ]; then
    con="󰂯 ${BOLD}${con}${REGULAR}"
  else
    con="󰂲"
  fi

  echo "$con"
}

# Echo the current battery capacity %
# Surface book 2 has two batteries, so we need our own percentage calculation
battery () {
  energy_full=0
  energy_now=0

  if [ -d "$BATTERY_DIR/BAT1" ]; then
    bat1_full=$(cat "$BATTERY_DIR/BAT1/energy_full") 
    bat1_now=$(cat "$BATTERY_DIR/BAT1/energy_now")
    energy_full=$((energy_full + bat1_full))
    energy_now=$((energy_now + bat1_now))
  fi

  if [ -d "$BATTERY_DIR/BAT2" ]; then
    bat2_full=$(cat "$BATTERY_DIR/BAT2/energy_full") 
    bat2_now=$(cat "$BATTERY_DIR/BAT2/energy_now")
    energy_full=$((energy_full + bat2_full))
    energy_now=$((energy_now + bat2_now))
  fi

  bat=$((energy_now*100 / energy_full))
  echo -e "Bat ${BOLD}${bat}%${REGULAR}"
}

# Echo an icon representing default sink volume from wireplumber. 
volume () {
  vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f%\n", $2*100}')
  echo -e "Vol ${BOLD}${vol}${REGULAR}"
}

# Echo a wifi signal strength icon and SSID
# For the RSSI -> quality percentage conversion:
# https://learn.microsoft.com/en-us/windows/win32/api/wlanapi/ns-wlanapi-wlan_association_attributes?redirectedfrom=MSDN
wifi () {
  link_info=$(iw dev "$WIFI_INTERFACE" link)

  if [[ "$link_info" =~ "Connected to" ]]; then
    # Connected, get ssid and dBm
    ssid=$(sed -n  's/.*SSID: *//p' <<< "$link_info")
    dBm=$(awk '/signal:/ {print $2}' <<< "$link_info")

    # dBm to quality percentage
    if (( dBm <= -100 )); then
      quality=0
    elif (( dBm >= -50 )); then
      quality=100
    else
      let "quality = 2 * ($dBm + 100)"
    fi

    # Match quality to icon
    if (( quality <= 20 )); then icon="󰣾"
    elif (( quality <= 40 )); then icon="󰣴"
    elif (( quality <= 60 )); then icon="󰣶"
    elif (( quality <= 80 )); then icon="󰣸"
    else icon="󰣺"
    fi
    
    echo "${icon} ${BOLD}${ssid}${REGULAR}"
  else
    # Not connected
    echo "󰣼"
  fi
}


# Echo the thermal_zone0 temp
temp () {
  tempraw=$(cat /sys/class/thermal/thermal_zone0/temp)
  tempcel=$(expr $tempraw / 1000)
  echo "Temp ${BOLD}${tempcel}C${REGULAR}"
}

# Echo the amount of memory currently being used.
memory () {
  mem=$(free -m | awk '/^Mem:/{print $3}')
  echo "Mem ${BOLD}${mem}MiB${REGULAR}"
}

# Update the bar utilities every five seconds.
while :; do
  # Display username and window manager workspace info on left.
  left="+|L ${BOLD}${USER}@$(hostname)${REGULAR}  Space ${BOLD}+L${REGULAR}  Hidden ${BOLD}+M${REGULAR}  Stack ${BOLD}+S${REGULAR}  $(date +"%H:%M")"

  # Display date and time in the center.
  center="+|C$(date +"%a %b %d %H:%M")"

  # Display utilities from this script on the right.
  right="+|R$(wifi)  $(bluetooth)  $(battery)  $(memory)  $(temp)  $(volume)"

  echo "${left}${right}"
  sleep 5
done
