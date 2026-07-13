if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/ivan/.ghcup/bin # ghcup-env

# Set default C and C++ compilers
export CC=$(which clang)
export CXX=$(which clang++)

function fish_greeting
  cat ~/plans/reminders.md
end

export WALLPAPER_DIR=/home/ivan/custom/wallpaper

function gimpmath
  gimp ~/gimpmath/*.xcf
end

function gimpfund
  gimp ~/gimpfundamentals/*.xcf
end

function reflect
  echo "
     _____  _____   _____ _      _____  _____  _____ 
    |  __ \| ____| |  ___| |    | ____|| ____||_   _|
    | |__) |  _|   | |_  | |    |  _|  | |      | |  
    |  _  /| |___  |  _| | |___ | |___ | |___   | |  
    |_| \_\|_____| |_|   |_____||_____||_____|  |_| 

    "
end

function fff
  ~/.config/custom/fff.sh
end

function ffd
  ~/.config/custom/ffd.sh
end

function ffg
  ~/.config/custom/ffg.sh
end
