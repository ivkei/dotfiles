fzf -i --border --tmux 80% --style minimal --preview 'bat {} --color=always' \
  --bind 'tab:up,shift-tab:down,change:first' \
  --bind 'enter:become(nvim {})'
