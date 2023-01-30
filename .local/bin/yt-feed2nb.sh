#!/bin/sh

[ $# -ge 1 ] && yt_url="$1" || yt_url=$(xclip -o)
[ -z "$yt_url" ] && notify-send -u critical "yt-feed2nb.sh" "Input URL is blank"

urls="$HOME/.newsboat/urls"
[ -e "$urls" ] || urls="$XDG_CONFIG_HOME/newsboat/urls"
[ -e "$urls" ] || touch "$urls"

curl -s -S -o /tmp/rss.tmp "$yt_url" || exit 1

feedname="$(cat /tmp/rss.tmp \
  | grep -o '"originalUrl":"https://www.youtube.com/[^"]*' \
  | sed -e "s/\/featured//" \
  | sed -e "s/\/videos//" \
  | rev | cut -d'/' -f1 | rev \
  | sed -e "s/^@//")"

feed="$(cat /tmp/rss.tmp \
  | grep -o 'https://www.youtube.com/feeds/videos.xml?channel_id=[^"]*"' \
  | tr -d '"' | sort | uniq | sed -e "s/$/ \"~$feedname\"/")"

echo "$feed" >> "$urls"
notify-send "yt-feed2nb.sh - feed added" "$feedname"
