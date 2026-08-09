#!/usr/bin/env bash

guis=$(ls /usr/share/applications/*.desktop | xargs -I {} basename {} .desktop | awk '{print "[G] " $0}')
clis=$(compgen -c | awk '{print "[C] " $0}')
windows=$(hyprctl clients | \
          grep -E '^[[:space:]]*title:' |\
          sed 's/^[[:space:]]*title:[[:space:]]*//'|\
          grep -v '^$' |\
          awk '{print "[W] " $0}')

choice=$(printf "%s\n%s\n%s" "$windows" "$guis" "$clis" | \
  fzf -i --border --tmux 80% --style minimal\
      --bind 'tab:up,shift-tab:down,change:first')

if [ -n "$choice" ]; then
  real_cmd="${choice:4}"

  if [[ "$choice" == "[G]"* ]]; then
    hyprctl dispatch "hl.dsp.exec_cmd('gtk-launch "$real_cmd"')" &> /dev/null
  elif [[ "$choice" == "[W]"* ]]; then
    hyprctl dispatch "hl.dsp.focus({ window = 'title:^${real_cmd}$' })" &> /dev/null
  else
    exec $real_cmd
  fi
fi
