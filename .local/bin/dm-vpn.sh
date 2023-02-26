#!/bin/sh

# launch or kill VPN using DMEMU as a picker

set -o nounset

VPNDIR="$HOME/Downloads"
# ------------------------------------------------------------------------
get_openvpn_pid () {
    if command -v pidof > /dev/null; then
        pidof openvpn || echo "NULL"
    elif command -v pgrep > /dev/null; then
        pgrep openvpn || echo "NULL"
    else
        echo "NULL"
    fi
}

# ------------------------------------------------------------------------
#   main
# ------------------------------------------------------------------------
# Alternatives to notify-send:
#     xmessage "Hello world"
#     gtkdialog "Hello world"
command -v notify-send > /dev/null \
    || { echo "notify-send from pkg libnotify-bin not found"; exit 1; }  

ovpn=$(ls -1t "$VPNDIR/"*\.ovpn \
    | cut -d'/' -f4- \
    | dmenu -c -l 20 -p "Pick a VPN file or ESC to kill VPN")

pid=$(get_openvpn_pid)
if [ -n "$ovpn" -a "$pid" != "NULL" ]; then
    killall -q openvpn
    nohup openvpn --config "$VPNDIR/$ovpn" 2> /dev/null &
    notify-send -u normal -t 5000 "OpenVPN kill and run" "${ovpn%.*}"
    sleep 5
elif [ -n "$ovpn" -a "$pid" = "NULL" ]; then
    nohup openvpn --config "$VPNDIR/$ovpn" 2> /dev/null &
    notify-send -u normal -t 5000 "OpenVPN run" "${ovpn%.*}"
    sleep 5
elif [ -z "$ovpn" -a "$pid" != "NULL" ]; then
    killall -q openvpn
    notify-send -u normal -t 5000 "OpenVPN killed"
else
    notify-send -u normal -t 1000 "OpenVPN" "nothing to do"
fi

#  "country": "JP",
country=$(curl -s ipinfo.io/json \
    | tr -d '" ,' | grep "^country:" | cut -d':' -f2)

[ $(get_openvpn_pid) = "NULL" -o "$country" = "CA" ] \
    && { notify-send -u critical -t 0 "No VPN"; exit 0; }

# rename OVPN file to add country
echo "$ovpn" | grep "_${country}\.ovpn" > /dev/null 2>&1 || {
    ovpn_new="${ovpn%.*}_${country}.ovpn"
    mv -f "$VPNDIR/$ovpn" "$VPNDIR/$ovpn_new"
}

notify-send -u low -t 0 "VPN: $country"
