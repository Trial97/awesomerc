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
run /usr/bin/lxqt-policykit-agent &
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)
run xrdb $XDG_CONFIG_HOME/X11/xresources
run nm-applet
run blueman-applet

## run (only once) processes which spawn with different name
# if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
#     gnome-keyring-daemon --daemonize --login &
# fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
# run pa-applet

run thunar --daemon

run picom -b --dbus --config $XDG_CONFIG_HOME/picom/picom.conf
run lxqt-powermanagement
# run xidlehook --not-when-fullscreen --not-when-audio --timer 600 lock
# 'pulseeffects --gapplication-service',

sleep 5
run hexchat --minimize=2
