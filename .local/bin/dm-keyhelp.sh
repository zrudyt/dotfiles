#!/bin/sh

# show key bindings for specific programs
# keybindings files should be named "key_XXXX.txt" where XXXX is the app name

XDG_DATA="$XDG_DATA_HOME/dm-keyhelp"

main () {

    [ -d "$XDG_DATA" ] || mkdir "$XDG_DATA" || exit 1

    files=$(find "$XDG_DATA" -type f -name "keys*\.txt" -print0 | xargs -0 -n1 \
	| sed -e "s|^$XDG_DATA/||")
    [ -z "$files" ] && exit 0

    choice=$(echo "$files" | dmenu -l 20 -p "Show keybindings for:")
    [ -z "$choice" ] && exit 0

    command -v xmessage \
        && xmessage -fn fixedsys -file "$XDG_DATA/$choice" \
	|| xmore "$XDG_DATA/$choice" 2> /dev/null

}

# ------------------------------------------------------------------------
#   P R O G R A M   E N T R Y   P O I N T
# ------------------------------------------------------------------------
main "$@"

