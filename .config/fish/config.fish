if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH $HOME/.ghcup/bin # ghcup-env

# Set default C and C++ compilers
export CC=$(which clang)
export CXX=$(which clang++)

function fish_greeting
  cat ~/plans/reminders.md
end

export WALLPAPER_DIR=$HOME/custom/wallpaper

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
  # Dont wrap into nvim because otherwise it opens even if esc was pressed
  ~/.config/custom/fff.sh
end

function ffd
  cd $(~/.config/custom/ffd.sh)
end

function ffg
  # Dont wrap into nvim because it cant handle line number that way
  ~/.config/custom/ffg.sh
end

function ffw
  ~/.config/custom/ffw.sh
end
