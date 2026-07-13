#!/bin/bash
find ~ -type d | fzf -i --border --tmux 80% --style minimal --bind 'tab:up,shift-tab:down,change:first'\
  --bind 'enter:become(nvim {})'
