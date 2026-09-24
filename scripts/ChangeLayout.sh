#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly

notif="$HOME/.config/swaync/images/ja.png"

# Serialize rapid presses: queue behind any running instance so every
# press reads post-eval state (without this, two overlapping presses read
# the same layout and jump to the same target -> looks "stuck").
exec 9>/tmp/changelayout.lock
flock 9

LAYOUT=$(hyprctl -j getoption general:layout | jq '.str' | sed 's/"//g')

# Reverse layout value to reuse toggle logic. So layouts don't get swapped initially.
if [ "$1" = "init" ]; then
  if [ "$LAYOUT" = "master" ]; then
    LAYOUT="dwindle"
  else
    LAYOUT="master"
  fi
fi

# Cycles ALL built-in layouts: dwindle -> master -> scrolling -> dwindle.
# (hy3 joins the ring once its rebuild lands; unknown layouts fall to dwindle.)
case $LAYOUT in
"dwindle")
  hyprctl eval 'hl.config({ general = { layout = "master" } })'
  notify-send -e -u low -i "$notif" " Master Layout"
  ;;
"master")
  hyprctl eval 'hl.config({ general = { layout = "scrolling" } })'
  notify-send -e -u low -i "$notif" " Scrolling Layout"
  ;;
"scrolling")
  hyprctl eval 'hl.config({ general = { layout = "dwindle" } })'
  notify-send -e -u low -i "$notif" " Dwindle Layout"
  ;;
*)
  hyprctl eval 'hl.config({ general = { layout = "dwindle" } })'
  notify-send -e -u low -i "$notif" " Dwindle Layout"
  ;;
esac
