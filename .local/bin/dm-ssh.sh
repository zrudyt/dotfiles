#!/bin/sh

hosts=$(cat <<- EOF
	rudy@starbase
	tc@zguide
EOF
)

choice=$(echo "$hosts" | dmenu -p "SSH:" -l 10 -b)

# if we quote $choice below, we get the following error when run from a shell
#     couldn't read from shell: Input/output error
[ -n "$choice" ] \
	&& st -g 100x48 -f "Liberation Mono:pixelsize=15" -e ssh $choice
