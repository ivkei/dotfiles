#!/sbin/fish

set files (find $WALLPAPER_DIR -type f | shuf -n 2)

swaybg -o HDMI-A-1 --image $files[1] -m fill &
swaybg -o DP-1 --image $files[2] -m fill &

set num (pgrep -c swaybg)

# Kill running swaybgs
sleep 2
if test $num -gt 2
  pkill -o swaybg
  pkill -o swaybg
end
