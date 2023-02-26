#!/bin/sh

# sysctl hw.disknames
# doas disklabel -A sd0
# doas disklabel sd0
# doas dkctl sd0
# doas dkctl sd0 listwedges

# ----------------------------------------------------------------------------
get_partitions () {
    for disk in $(sysctl -n hw.disknames); do
        part=$(mbrlabel "$disk" 2> /dev/null | grep "^Found ")
        [ -n "$part" ] && echo "$part" | sed \
            -e "s/^Found /${disk}: /" \
            -e "s/, .*$//" \
            -e "s/; size [^(]*(/ (/"
    done
}

# ----------------------------------------------------------------------------
# a:  38912000  78761984     4.2BSD      0     0     0  # (Cyl.  78136*- 116740*)
# b:  38912000      2048 Linux Ext2      0     0        # (Cyl.      2*-  38605*)
# e:  39845888  38914048     4.2BSD   1024  8192    16  # (Cyl.  38605*-  78134*)
# f:  38575333 117674667     4.2BSD   1024  8192    16  # (Cyl. 116740*- 155009*)
# ----------------------------------------------------------------------------
get_partitions_1 () {
    for disk in $(sysctl -n hw.disknames); do
        part=$(mbrlabel "$disk" 2> /dev/null | grep "^ [a-z]: " | grep -v "[0-9]  *unused ")
        [ -n "$part" ] && echo "$part"
    done
}

# ----------------------------------------------------------------------------
selection=$(get_partitions_1 | dmenu -c -l 10 -b)
echo "$selection"
