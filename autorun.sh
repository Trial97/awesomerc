#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run() {
    command -v $1 && ! (pgrep -u $USER -x $1 >/dev/null) && $@ &
}

FILE=/tmp/awesomewm/$USER/autostart
test -f "$FILE" && exit 0
mkdir -p /tmp/awesomewm/$USER
touch $FILE

dex --autostart --environment Awesome -w -s $XDG_CONFIG_HOME/autostart/
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)
run xrdb $XDG_CONFIG_HOME/X11/xresources

run thunar --daemon

run picom -b --dbus --config $XDG_CONFIG_HOME/picom/picom.conf

sleep 5
run hexchat --minimize=2
