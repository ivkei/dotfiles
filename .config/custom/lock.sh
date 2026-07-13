#!/sbin/fish

set files (find $WALLPAPER_DIR -type f | shuf -n 2)

swaylock \
  --image DP-1:$files[1] \
  --image HDMI-A-1:$files[2] \
  -e --no-unlock-indicator &
